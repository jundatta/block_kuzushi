precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const float PI = 3.1415926;
const float E = 0.003;

mat2 rotate2D(float r)
{
    return mat2(cos(r), -sin(r), sin(r), cos(r));
}

vec2 de(vec3 p)
{
    vec2 o = vec2(100.0, 0.0);

    vec3 p_ = p;
    
//    p.y -= 0.5;
    p.yz *= rotate2D(-0.1);
    p.xz *= rotate2D(time * 0.5);

    p.y += atan(p.z, p.x) * 0.5 * 4.0;
    p.y = mod(p.y, PI) - PI * 0.5;

    vec2 paramTorus = vec2(3.0, 0.06);
    float u = atan(length(p.xz) - paramTorus.x, p.y);
    float v = atan(p.x, p.z);
    
    float r = v * 4.0;
    const int ite = 22;
    for (int i = 0; i < ite; i++)
    {
        float rOffset = float(i) / float(ite) * PI * 2.0;
        float t = 0.5 + sin(float(i) * 1.618 * PI * 2.0) * 0.2;
        
        float tm = time + float(i);
        float m = sin(tm) + cos(tm * 2.2) * 0.5 + sin(tm * 7.1) * 0.2;
        m *= sin(p_.y * 2.0 + time * 2.5) * 0.2;
        t += m;

        vec2 q = vec2(length(p.xz) + cos(r + rOffset) * t - paramTorus.x, p.y + sin(r + rOffset) * t);
        float d = length(q) - paramTorus.y;
        
        if (d < o.x)
        {
            o.x = d;
            o.y = float(i);
        }
//      o.x = min(o.x, d);
    }

    return o;
}

// iquilezles.org/www/articles/normalsSDF/normalsSDF.htm
vec3 normal(vec3 p)
{
    float h = E;
    vec2 k = vec2(1.0, -1.0);
    return normalize(
            k.xyy * de(p + k.xyy * h).x + 
            k.yyx * de(p + k.yyx * h).x + 
            k.yxy * de(p + k.yxy * h).x + 
            k.xxx * de(p + k.xxx * h).x
        );
}

void trace(vec3 ro, vec3 rd, inout vec3 color)
{
    float ad = 0.0;
    for (int i = 0; i < 128; i++)
    {
        vec2 res = de(ro) * 0.5;
        ro += rd * res.x;
        ad += res.x;
        
        if (res.x < E)
        {
            // normal
            vec3 n = normal(ro);
            
            // albedo
            color = mix(vec3(1.0, 0.5, 0.2), vec3(0.2, 0.6, 1.0) * 2.5, fract(res.y * 1.618));
            color = mix(color, vec3(10.0, 0.0, 0.0), pow(fract((res.y + 10.5) * 1.618), 10.0));
            
            // diffuse
            color *= pow(dot(n, normalize(vec3(1.0, 1.0, 0.5))) * 0.5 + 0.5, 2.0);
            
            // ao
            float rim = float(i) / (128.0 - 1.0);
            color *= exp(-rim * rim * 30.0) * 0.5;

            return;
        }
        else if (ad > 20.0)
        {
            break;
        }
    }
    
    // background
    color = vec3(rd.y * rd.y * 0.2);
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec3 color = vec3(0.0);
    
    // ray
    vec3 ro = vec3(0.0, 0.0, 10.0);
    vec3 rd = normalize(vec3(p, -2.0));
    
    // ray marching
    trace(ro, rd, color);
    
    color = pow(color, vec3(0.454545));
    gl_FragColor = vec4(color, 1.0);
}
