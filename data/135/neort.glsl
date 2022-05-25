precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float PI = 3.1415926;
const float TAU = PI * 2.0;
const float E = 0.005;

struct Ray
{
    vec3 pos;
    vec3 dir;
};

// https://www.shadertoy.com/view/4djSRW
float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

mat2 rotate2D(float r)
{
    float s = sin(r);
    float c = cos(r);
    return mat2(c, -s, s, c);
}

float de(vec3 p)
{
    p.xy *= rotate2D(time);
    p.yz *= rotate2D(time * 1.5);
    vec2 q = vec2(length(p.xz) - 2.0, p.y);
    return length(q) - 0.75;
}

vec3 background(vec3 dir)
{
    return vec3(0.0, 0.0, 0.0);
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

float trace(Ray ray, inout vec3 color, float md)
{
    float ad = 0.0;
    for (float i = 1.0; i > 0.0; i -= 1.0 / 64.0)
    {
        float d = de(ray.pos);
        if (d < E)
        {
//            vec3 n = normal(ray.pos);
//            color += n * 0.5 + 0.5;

            return ad;
        }

        d *= 1.0;
        ray.pos += ray.dir * d;
        ad = ad + d;
        if (ad > md)
        {
            break;
        }
    }

    // background
    color += background(ray.dir);

    return md;
}

float traceV(Ray ray, float md)
{
    float ad = 0.0;
    for (float i = 1.0; i > 0.0; i -= 1.0 / 32.0)
    {
        float d = de(ray.pos);
        if (d < E)
        {
            return 0.0;
        }

        d *= 1.0;
        ray.pos += ray.dir * d;
        ad = ad + d;
        if (ad > md)
        {
            break;
        }
    }

    return 1.0;
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec3 color = vec3(0.0);
    
    // view
    vec3 view = vec3(0.0, 0.0, 10.0);
    vec3 at = normalize(vec3(0.0, 0.0, 0.0) - view);
    vec3 right = normalize(cross(at, vec3(0.0, 1.0, 0.0)));
    vec3 up = cross(right, at);
    float focallength = 2.0;

    // ray
    Ray ray;
    ray.pos = view;
    ray.dir = normalize(right * p.x + up * p.y + at * focallength);

    // ray marching
    {
        // light
        vec3 lp = vec3(2.5, 5.0, -3.0);
        vec3 li = vec3(0.1, 0.25, 1.0) * 5.0;
        
        float ad = trace(ray, color, 20.0);
        
        float vl = 0.0;
        float offset = hash12(p.xy * 1000.0) * 0.025;
        for (float i = 0.0; i < 1.0; i += 0.025)
        {
            Ray rayV;
            rayV.pos = view + ray.dir * (float(i) + offset) * ad;
            rayV.dir = normalize(lp - rayV.pos);
            float l = length(lp - rayV.pos);
            float d = traceV(rayV, l);
            vl += d * exp(-l * 0.8) * exp(-float(i) * ad * 0.1);
        }
        color += vl * li;
    }

    // cheap tonemapping
    float k = 0.75;
    color = mix(color, (1.0 - exp(-(color - k) / (1.0 - k))) * (1.0 - k) + k, step(k, color));

    // gamma correction
    color = pow(color, vec3(0.454545));

    gl_FragColor = vec4(color, 1.0);
}
