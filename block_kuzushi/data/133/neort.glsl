// BEGIN: shadertoy porting template
precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

#define iResolution resolution
#define iTime time
#define iMouse mouse

void mainImage(out vec4 fragColor, in vec2 fragCoord);

void main(void) {
    vec4 col;
    mainImage(col, gl_FragCoord.xy);
    gl_FragColor = col;
}
// END: shadertoy porting template

#define NUM_OCTAVES 5

float hash(float n) { return fract(sin(n) * 1e4); }

float hash21(vec2 p) {
  p = fract(p * vec2(233.34, 851.74));
  p += dot(p, p + 23.45);
  return fract(p.x * p.y);
}

// This one has non-ideal tiling properties that I'm still tuning
float noise(vec3 x) {
	const vec3 step = vec3(110, 241, 171);

	vec3 i = floor(x);
	vec3 f = fract(x);
 
	// For performance, compute the base input to a 1D hash from the integer part of the argument and the 
	// incremental change to the 1D based on the 3D -> 1D wrapping
    float n = dot(i, step);

	vec3 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(mix( hash(n + dot(step, vec3(0, 0, 0))), hash(n + dot(step, vec3(1, 0, 0))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 0))), hash(n + dot(step, vec3(1, 1, 0))), u.x), u.y),
               mix(mix( hash(n + dot(step, vec3(0, 0, 1))), hash(n + dot(step, vec3(1, 0, 1))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 1))), hash(n + dot(step, vec3(1, 1, 1))), u.x), u.y), u.z);
}

const mat3 m = mat3( 0.00,  0.80,  0.60,
                    -0.80,  0.36, -0.48,
                    -0.60, -0.48,  0.64 );

float fbm( vec3 p )
{
	p += vec3(1.0,0.0,0.8);
	
    float f;
    f  = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p ); 
	
	float n = noise( p*3.5 );
    f += 0.03*n*n;
	
    return f;
}

float sdRect( vec2 p, vec2 b )
{
    vec2 d = abs(p) - b;
    return min(max(d.x, d.y),0.0) + length(max(d,0.0));
}

const float pi = acos(-1.);
const float pi2 = pi * 2.0;

mat2 rot( float th ){ vec2 a = sin(vec2(pi*.5, 0) + th); return mat2(a, -a.y, a.x); }

vec2 pMod(in vec2 p, in float s) {
    float a = pi / s - atan(p.x, p.y);
    float n = pi2 / s;
    a = floor(a / n) * n;
    p *= rot(a);
    return p;
}

float gear(vec2 p, float size, float width, float num, float height, vec2 toothWidth)
{
    float ring = abs(length(p) - (size - width)) - width;
    p = pMod(p, num);
    float rect = sdRect(p - vec2(0.0, size + height), vec2(mix(toothWidth.x, toothWidth.y, smoothstep(size, size + height * 2.0, p.y)), height));
    float d = min(ring, rect);
    return d;
}

float gear2(vec2 p, float size, float width, float num, float height, vec2 toothWidth)
{
    float ring = abs(length(p) - (size - width)) - width;
    p = pMod(p, num);
    float rect = sdRect(p - vec2(0.0, size + height - 0.25), vec2(mix(toothWidth.x, toothWidth.y, smoothstep(size, size + height * 2.0, p.y)), height));
    float d = max(-rect, ring);
    return d;
}

float luminance(vec3 col)
{
    return dot(vec3(0.298912, 0.586611, 0.114478), col);
}


float spark(vec2 p)
{
    vec2 id = floor(p / 0.2);
    float rnd = hash21(id);
    if (rnd < 0.91) {
    	return 0.0;
    }
    vec2 cell = mod(p, 0.2) - 0.5 * 0.2;
    float s = length(cell + vec2(0.03 * sin(iTime * (hash21(id + 100.0) * 4.0)))) - 0.001;
    return exp(-s * 200.) * (sin(iTime * (hash21(id + 20.0) * 10.0)) * 0.5 + 0.5);
}

vec3 sparkLayer(vec2 p)
{
    float spa = spark(p - vec2(-iTime * 0.3, iTime * 0.3) + 123.);
    vec3 col = spa * vec3(0.1, 0.08, 0.07) * 10.0 * clamp((p.x - p.y)*0.5 + 0.25, 0.0, 1.0);
   
	spa = spark(p - vec2(-iTime * 0.4, iTime * 0.2) * 1.5 + 77.0);
    col += spa * vec3(0.1, 0.08, 0.07) * 15.0 * clamp((p.x - p.y)*0.5 + 0.5, 0.0, 1.0);
    
	spa = spark(p - vec2(-iTime * 0.1, iTime * 0.3) * 2.0 + 33.0);
    col += spa * vec3(0.1, 0.08, 0.07) * 20.0 * clamp((p.x - p.y)*0.5 + 0.75, 0.0, 1.0);
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);
    
    vec3 col = vec3(fbm(vec3(p * vec2(3.0, 8.0) + vec2(iTime * 0.6, 0.0), iTime * 0.5))) * 0.5 + 0.5;// * smoothstep(0.5, -2.0, p.y) * 0.5;
    vec3 light1 = vec3(1.0, 0.85, 0.6) * 0.8 * exp(-length(p * vec2(1.0, 1.6) - vec2(0.0, 2.)) * 1.25);
    vec3 light2 = vec3(0.8, 0.8, 0.75) * .8 * exp(-length(p - vec2(0.8, -1.6)) * 1.5);
    vec3 light3 = vec3(0.8, 0.8, 0.75) * .8 * exp(-length(p - vec2(-0.8, -1.6)) * 1.5);
    vec3 light4 = vec3(0.9, 1.0, 0.9) * 1. * exp(-length(p - vec2(-0.0, -1.7)) * 3.0);
    col += vec3(0.1, 0.08, 0.05) * 14.0;
    col *= light1 + light2 + light3 + light4;

	col += sparkLayer(p);
    
    vec2 pp = p;
    pp.x -= 1.55;
    pp.y += 0.75;
    pp.x *= 1.1;
    pp.x -= pp.y * 0.3;
    pp *= 4.0;
    // Time varying pixel color
    
    p = (pp) * rot(iTime * 2.0);
    float g2 = gear(p, 0.5, 0.01, 32., 0.015, vec2(0.03, 0.02));
    
    p = (pp - vec2(-0.05, 0.025)) * rot(-iTime * 2.0);
    float g1 = gear(p * 1.3, 0.5, 0.02, 32., 0.05, vec2(0.01, 0.001)) / 1.3;

    p = pp * rot(iTime * 1.5);
    float g3 = gear2(p * 1.7, 0.5, 0.05, 6., 0.1, vec2(0.1, 0.1)) / 1.7;
    
    vec3 col3 = mix(col, vec3(1.75), smoothstep(.02, .0, g3));
    col = mix(col3, vec3(1.0, 0.33, 0.2), smoothstep(0.2, -0.2, g3));
    
 	vec3 col2 = mix(col, vec3(1.75), smoothstep(.02, .0, g1));
    col = mix(col2, vec3(1.0, 0.33, 0.2), smoothstep(0.2, -0.2, g1));
    
    vec3 col1 = mix(col, vec3(1.7), smoothstep(.02, .0, g2));
    col = mix(col1, vec3(1.0, 0.33, 0.2), smoothstep(0.2, -0.2, g2));
    
    //col = pow(col, vec3(1.0/2.2));
    
    // Output to screen
    fragColor = vec4(col,1.0);
}