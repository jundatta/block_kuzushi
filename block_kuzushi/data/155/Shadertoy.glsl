uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iMouse;
uniform int iFrame;

// Copyright (c) 2021 Felix Westin
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// -------------------------------------
// Defines
#define EPS                 1e-6
#define PI                  3.14159265359
#define INFINITY            1.0 / 0.0
#define PLANET_RADIUS       6371000.0
#define PLANET_CENTER       vec3(0, -PLANET_RADIUS, 0)
#define ATMOSPHERE_HEIGHT   100000.0
#define RAYLEIGH_HEIGHT     (ATMOSPHERE_HEIGHT * 0.08)
#define MIE_HEIGHT          (ATMOSPHERE_HEIGHT * 0.012)

// -------------------------------------
// Coefficients
#define C_RAYLEIGH          (vec3(5.802, 13.558, 33.100) * 1e-6)
#define C_MIE               (vec3(3.996,  3.996,  3.996) * 1e-6)
#define C_OZONE             (vec3(0.650,  1.881,  0.085) * 1e-6)

#define ATMOSPHERE_DENSITY  1.0
#define EXPOSURE            20.0

// -------------------------------------
// Math
vec2 SphereIntersection(vec3 rayStart, vec3 rayDir, vec3 sphereCenter, float sphereRadius)
{
	rayStart -= sphereCenter;
	float a = dot(rayDir, rayDir);
	float b = 2.0 * dot(rayStart, rayDir);
	float c = dot(rayStart, rayStart) - (sphereRadius * sphereRadius);
	float d = b * b - 4.0 * a * c;
	if (d < 0.0)
	{
		return vec2(-1);
	}
	else
	{
		d = sqrt(d);
		return vec2(-b - d, -b + d) / (2.0 * a);
	}
}
vec2 PlanetIntersection(vec3 rayStart, vec3 rayDir)
{
	return SphereIntersection(rayStart, rayDir, PLANET_CENTER, PLANET_RADIUS);
}
vec2 AtmosphereIntersection(vec3 rayStart, vec3 rayDir)
{
	return SphereIntersection(rayStart, rayDir, PLANET_CENTER, PLANET_RADIUS + ATMOSPHERE_HEIGHT);
}

// -------------------------------------
// Phase functions
float PhaseRayleigh(float costh)
{
	return 3.0 * (1.0 + costh*costh) / (16.0 * PI);
}

float PhaseMie(float costh, float g)
{
	g = min(g, 0.9381);
	float k = 1.55*g - 0.55*g*g*g;
	float kcosth = k*costh;
	return (1.0 - k*k) / ((4.0 * PI) * (1.0-kcosth) * (1.0-kcosth));
}

// -------------------------------------
// Atmosphere
float AtmosphereHeight(vec3 positionWS)
{
	return distance(positionWS, PLANET_CENTER) - PLANET_RADIUS;
}
float DensityRayleigh(float h)
{
	return exp(-max(0.0, h / RAYLEIGH_HEIGHT));
}
float DensityMie(float h)
{
	return exp(-max(0.0, h / MIE_HEIGHT));
}
float DensityOzone(float h)
{
	// The ozone layer is represented as a tent function with a width of 30km, centered around an altitude of 25km.
	return max(0.0, 1.0 - abs(h - 25000.0) / 15000.0);
}
vec3 AtmosphereDensity(float h)
{
	return vec3(DensityRayleigh(h), DensityMie(h), DensityOzone(h));
}

// Optical depth is a unitless measurement of the amount of absorption of a participating medium (such as the atmosphere).
// This function calculates just that for our three atmospheric elements:
// R: Rayleigh
// G: Mie
// B: Ozone
// If you find the term "optical depth" confusing, you can think of it as "how much density was found along the ray in total".
vec3 IntegrateOpticalDepth(vec3 rayStart, vec3 rayDir)
{
	vec2 intersection = AtmosphereIntersection(rayStart, rayDir);
	float  rayLength    = intersection.y;

	int    sampleCount  = 8;
	float  stepSize     = rayLength / float(sampleCount);
	
	vec3 opticalDepth = vec3(0);

	for (int i = 0; i < sampleCount; i++)
	{
		vec3 localPosition = rayStart + rayDir * (float(i) + 0.5) * stepSize;
		float  localHeight   = AtmosphereHeight(localPosition);
		vec3 localDensity  = AtmosphereDensity(localHeight);

		opticalDepth += localDensity * stepSize;
	}

	return opticalDepth;
}

// Calculate a luminance transmittance value from optical depth.
vec3 Absorb(vec3 opticalDepth)
{
	// Note that Mie results in slightly more light absorption than scattering, about 10%
	return exp(-(opticalDepth.x * C_RAYLEIGH + opticalDepth.y * C_MIE * 1.1 + opticalDepth.z * C_OZONE) * ATMOSPHERE_DENSITY);
}

// Integrate scattering over a ray for a single directional light source.
// Also return the transmittance for the same ray as we are already calculating the optical depth anyway.
vec3 IntegrateScattering(vec3 rayStart, vec3 rayDir, float rayLength, vec3 lightDir, vec3 lightColor, out vec3 transmittance)
{
	// We can reduce the number of atmospheric samples required to converge by spacing them exponentially closer to the camera.
	// This breaks space view however, so let's compensate for that with an exponent that "fades" to 1 as we leave the atmosphere.
	float  rayHeight = AtmosphereHeight(rayStart);
	float  sampleDistributionExponent = 1.0 + clamp(1.0 - rayHeight / ATMOSPHERE_HEIGHT, 0.0, 1.0) * 8.0; // Slightly arbitrary max exponent of 9

	vec2 intersection = AtmosphereIntersection(rayStart, rayDir);
	rayLength = min(rayLength, intersection.y);
	if (intersection.x > 0.0)
	{
		// Advance ray to the atmosphere entry point
		rayStart += rayDir * intersection.x;
		rayLength -= intersection.x;
	}

	float  costh    = dot(rayDir, lightDir);
	float  phaseR   = PhaseRayleigh(costh);
	float  phaseM   = PhaseMie(costh, 0.85 /* Default */);

	int    sampleCount  = 64;

	vec3 opticalDepth = vec3(0);
	vec3 rayleigh     = vec3(0);
	vec3 mie          = vec3(0);

	float  prevRayTime  = 0.0;

	for (int i = 0; i < sampleCount; i++)
	{
		float  rayTime = pow(float(i) / float(sampleCount), sampleDistributionExponent) * rayLength;
		// Because we are distributing the samples exponentially, we have to calculate the step size per sample.
		float  stepSize = (rayTime - prevRayTime);

		vec3 localPosition = rayStart + rayDir * rayTime;
		float  localHeight   = AtmosphereHeight(localPosition);
		vec3 localDensity  = AtmosphereDensity(localHeight);

		opticalDepth += localDensity * stepSize;

		// The atmospheric transmittance from rayStart to localPosition
		vec3 viewTransmittance = Absorb(opticalDepth);

		vec3 opticalDepthlight  = IntegrateOpticalDepth(localPosition, lightDir);
		// The atmospheric transmittance of light reaching localPosition
		vec3 lightTransmittance = Absorb(opticalDepthlight);

		rayleigh += viewTransmittance * lightTransmittance * phaseR * localDensity.x * stepSize;
		mie      += viewTransmittance * lightTransmittance * phaseM * localDensity.y * stepSize;

		prevRayTime = rayTime;
	}

	transmittance = Absorb(opticalDepth);

	return (rayleigh * C_RAYLEIGH + mie * C_MIE) * lightColor * EXPOSURE;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{    
    //camera position
    vec3 ray_start = vec3(0,0,0);
    
    vec2 mouse_vec = iMouse.xy/iResolution.xy;
    
    vec3 cam_dir = normalize(vec3(mouse_vec, 1.0));
    vec3 u = normalize(cross(cam_dir, vec3(0., 1., 0.)));
    vec3 v = cross(u, cam_dir);
    float fdist = 0.3;
    vec3 ray_dir = normalize(cam_dir*fdist+(fragCoord.x/iResolution.x-0.5)*u+(fragCoord.y-iResolution.y/2.0)/iResolution.x*v);
    
    const float ray_length = 1000000000.0f;
    vec3 light_dir = vec3(0.25,1,0);
    vec3 light_color = vec3(1,1,1);
    vec3 transmittance;
    vec3 sky_color = IntegrateScattering(ray_start, ray_dir, ray_length, light_dir, light_color, transmittance);
    
    fragColor = vec4(sky_color,1);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
