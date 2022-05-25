precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float PI = 3.1415926;
const float E = 0.005;

struct Ray
{
    vec3 pos;
    vec3 dir;
};

mat2 rotate2D(float rad)
{
    float c = cos(rad);
    float s = sin(rad);
    return mat2(c, s, -s, c);
}

// https://www.shadertoy.com/view/4djSRW
float hash13(vec3 p3)
{
	p3 = fract(p3 * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float noiseValue3D(vec3 p, float div)
{
    p *= div;
    vec3 i = floor(p);
    vec3 f = fract(p);
    float r1 = hash13((i + vec3(0.0, 0.0, 0.0)));
    float r2 = hash13((i + vec3(1.0, 0.0, 0.0)));
    float r3 = hash13((i + vec3(0.0, 1.0, 0.0)));
    float r4 = hash13((i + vec3(1.0, 1.0, 0.0)));
    float r5 = hash13((i + vec3(0.0, 0.0, 1.0)));
    float r6 = hash13((i + vec3(1.0, 0.0, 1.0)));
    float r7 = hash13((i + vec3(0.0, 1.0, 1.0)));
    float r8 = hash13((i + vec3(1.0, 1.0, 1.0)));
    return mix(
            mix(mix(r1, r2, smoothstep(0.0, 1.0, f.x)), mix(r3, r4, smoothstep(0.0, 1.0, f.x)), smoothstep(0.0, 1.0, f.y)),
            mix(mix(r5, r6, smoothstep(0.0, 1.0, f.x)), mix(r7, r8, smoothstep(0.0, 1.0, f.x)), smoothstep(0.0, 1.0, f.y)),
            smoothstep(0.0, 1.0, f.z)
        );
}

float noiseValueFbm3D(vec3 p, float div, int octaves, float amplitude)
{
    float o = 0.0;
    float fbm_max = 0.0;
    for(int i = 0; i >= 0; i++)
    {
        if(i >= octaves)    break;
        float a = pow(amplitude, float(i));
        o += a * noiseValue3D(p, div * pow(2.0, float(i)));
        fbm_max += a;
    }
    return o / fbm_max;
}

float deBox(vec3 p, vec3 b)
{
  vec3 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float dePers(vec3 p, float r)
{
    p = abs(p) - r;
    float l = 0.01;
    float d = length(p.xy) - l;
    d = min(d, length(p.xz) - l);
    d = min(d, length(p.yz) - l);
    return d;
}

float de(vec3 p)
{
    vec3 p_ = p;
    float d = deBox(p, vec3(1.0));
    
    p = p_;
    p -= 0.5;
    d = max(d, -deBox(p, vec3(1.0)));
    
    p = p_;
    d = min(d, deBox(p, vec3(0.6)));
    
    p = p_;
    p.y -= 0.4;
    d = min(d, deBox(p, vec3(0.7, 0.1, 0.7)));
    
    p = p_;
    p.y += 0.2;
    d = max(d, -deBox(p, vec3(0.8, 0.3, 0.15)));
    d = max(d, -deBox(p, vec3(0.15, 0.3, 0.8)));
    
    if (d < 0.06)
    {
        p = p_;
        d += noiseValueFbm3D(p, 8.0, 4, 0.5) * 0.06;
    }
    
//    p = p_;
//    d = min(d, dePers(p, 1.0));
    
    return d * 0.85;
}

// iquilezles.org/www/articles/normalsSDF/normalsSDF.htm
vec3 normal(vec3 p)
{
    float h = E;
    vec2 k = vec2(1.0, -1.0);
    return normalize(
            k.xyy * de(p + k.xyy * h) + 
            k.yyx * de(p + k.yyx * h) + 
            k.yxy * de(p + k.yxy * h) + 
            k.xxx * de(p + k.xxx * h)
        );
}

float ao(Ray ray, float l)
{
    float d = 0.0;
    d += de(ray.pos + ray.dir * l * 1.0 / 5.0);
    d += de(ray.pos + ray.dir * l * 2.0 / 5.0);
    d += de(ray.pos + ray.dir * l * 3.0 / 5.0);
    d += de(ray.pos + ray.dir * l * 4.0 / 5.0);
    d += de(ray.pos + ray.dir * l * 5.0 / 5.0);
    return pow(d / (15.0 / 5.0 * l), 2.0);
}

float shadow(Ray ray)
{
    float o = 1.0;
    for(int i = 0; i < 32; i++){
        float d = de(ray.pos);
		ray.pos += d * ray.dir;
		if(d < E)
		{
		    return 0.0;
		}
		o = min(o, 32.0 * d / float(i));
    }
    return o;
}

void trace(Ray ray, inout vec3 color, float md)
{
    float ad = 0.0;
    for (float i = 1.0; i > 0.0; i -= 1.0 / 64.0)
    {
        float d = de(ray.pos);
        if (d < E)
        {
            // light
            vec3 l = normalize(vec3(cos(time * 0.5), 1.0, sin(time * 0.5)));
            
            // normal
            vec3 n = normal(ray.pos);
            
            // material
            Ray materialRay;
            materialRay.pos = ray.pos + vec3(0.0, 1.0, 0.0) * E * 5.0;
            materialRay.dir = vec3(0.0, 1.0, 0.0);
            vec3 mat = mix(vec3(0.6, 0.3, 0.2), vec3(2.5, 2.5, 2.5), shadow(materialRay));
            
            // ambient occlusion
            Ray aoRay;
            aoRay.pos = ray.pos;
            aoRay.dir = n;
            float a = ao(aoRay, 0.3) * 0.9 + 0.1;
            
            // shadow
            Ray shadowRay;
            shadowRay.pos = ray.pos + l * E * 5.0;
            shadowRay.dir = l;
            float sh = shadow(shadowRay);

            // color
            color += a * vec3(0.1, 0.1, 0.2) * mat;
            color += max(dot(n, l), 0.0) * sh * vec3(1.0, 0.7, 0.5) * mat;

            return;
        }

        ray.pos += ray.dir * d;
        ad = ad + d;
        if (ad > md)
        {
            break;
        }
    }

    // background
}

void grid(vec2 p, inout vec3 color)
{
    vec3 c = vec3(0.0);
    float l = 0.005;
    p = mod(p, 0.5);
    float d = step(min(abs(p.x) - l, abs(p.y) - l), 0.0);
    c.yz += d;
    p = mod(p, 0.25);
    d = step(min(abs(p.x) - l, abs(p.y) - l), 0.0);
    c.x += d;
    color = mix(color, c, c.x);
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec3 color = vec3(0.0);

    // view
    vec3 view = vec3(3.0, 1.5, 1.5);
    vec3 at = normalize(vec3(0.0, 0.0, 0.0) - view);
    vec3 right = normalize(cross(at, vec3(0.0, 1.0, 0.0)));
    vec3 up = cross(right, at);
    float focallength = 2.0;
    
    // ray
    Ray ray;
    ray.pos = view;
    ray.dir = normalize(right * p.x + up * p.y + at * focallength);

    // ray marching
    trace(ray, color, 100.0);
    
    // grid
//    grid(p.xy, color);

    // cheap tonemapping
    // https://www.desmos.com/calculator/adupt0spl8
    float k = 0.75;
    color = mix(color, 1.0 - exp(-(color - k) / (1.0 - k)) * (1.0 - k), step(k, color));

    // gamma correction
    color = pow(color, vec3(0.454545));

    gl_FragColor = vec4(color, 1.0);
}
