precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const float PI = 3.1415926;
const float E = 0.01;

vec3 hsv(float h, float s, float v)
{
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}

// https://www.iquilezles.org/www/articles/smin/smin.htm
float smin(float a, float b, float k)
{
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}
vec2 smin(vec2 a, vec2 b, float k)
{
    vec2 h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}
vec3 smin(vec3 a, vec3 b, float k)
{
    vec3 h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

// https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdVerticalCapsule(vec3 p, float h, float r)
{
    p.y -= clamp(p.y, 0.0, h);
    return length(p) - r;
}

float de(vec3 p)
{
    vec3 p_ = p;
    
    float r = time + p.y * 1.5;
    p *= 1.0;
    p.xz *= mat2(cos(r), -sin(r), sin(r), cos(r));
    p.y += 5.0;
    p.xz = p.xz - 2.0 * smin(vec2(0.0), p.xz, 0.225) - 0.5;
    p.xz = p.xz - 2.0 * smin(vec2(0.0), p.xz, 0.225) - 0.25;
    float d = sdVerticalCapsule(p, 10.0, (0.05 + 0.125 * (sin(p.y * 7.5) * 0.5 + 0.5)));
    
    p = p_;
    p.y += 5.0;
    for (int i = -1; i < 2; i++)
    {
        float r_ = float(i) * 0.6 - 2.3;
        float x_ = cos(r_) * 8.0;
        float y_ = sin(r_) * 8.0;
        float d_ = abs(sdVerticalCapsule(p - vec3(x_, 0.0, y_), 10.0, 0.75)) - 0.075;
        d_ = max(d_, length(p - vec3(x_, 0.0, y_)) - 6.0);
        d = min(d, d_);
    }
    
    p = p_;
    d = smin(d, dot(p, vec3(0.0, 1.0, 0.0)) + 1.0, 0.75);
    
    return d;
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

// 雰囲気SSS(subsurface scattering)
// 衝突点から任意の方向に固定長で複数回サンプリングして、厚みと通過後の遮蔽具合を同時に推定するイメージです
// o .. レイの開始位置
// dir .. レイの方向
// ed .. 推定する距離
// la .. 光の減衰率
// li .. 光の強さ
float sss(vec3 o, vec3 dir, float ed, float la, float li)
{
    // サンプリング回数
    // 回数を増やすことで推定精度が上がります
    // AOのアプローチに近いかも
    const int ei = 5;
    
    float accum = 0.0;
    float st = ed / float(ei);
    float d = st;
    for (int i = 0; i < ei; i++)
    {
        accum += max(de(o + dir * d) / d, 0.0);
        d += st;
    }
    accum = clamp(accum / float(ei), 0.0, 1.0);
    return exp(-(1.0 - accum) * la) * li;
}

void trace(vec3 ro, vec3 rd, inout vec3 color)
{
    float ad = 0.0;
    for (int i = 0; i < 128; i++)
	{
	    float d = de(ro) * 0.75;
	    ro += rd * d;
	    ad += d;
	    
	    if (d < E)
        {
            // normal
            vec3 n = normal(ro);

            for (int j = 0; j < 5; j++)
	        {
	            float st = step(0.0, float(j) - 1.9);
	            
	            // point lights
	            float r = float(j) * PI * 2.0 / 2.0 + time * 0.5;
	            vec3 lp = vec3(0.0, cos(r), 0.0) * 1.5;
	            {
    	            float r_ = float(j - 3) * 0.6 + -2.3;
                    float x_ = cos(r_) * 8.0;
                    float y_ = sin(r_) * 8.0;
    	            vec3 lp2 = vec3(x_, 0.0, y_);
    	            lp = mix(lp, lp2, st);
	            }
	            vec3 li = hsv(float(j) * 1.618, 0.9, 1.0) * 40.0;
	            {
	                vec3 li2 = vec3(1.0, 0.6, 0.25) * (30.0 + sin(sin((time + float(j)) * 5.0) * 6.0) * 2.0);
	                li = mix(li, li2, st);
	            }
	            float ll = length(lp - ro);
                float atte = exp(-ll * 2.5);
	            
	            // diffuse
	            color += pow(dot(normalize(lp - ro), n) * 0.5 + 0.5, 2.0) * li * atte * 0.2;
	            
                // sss
                color += sss(ro, normalize(lp - ro), 1.0, 3.0, 1.0) * li * atte;
                
//                color = n * 0.5 + 0.5;
	        }
	        
	        return;
        }
        else if(ad > 20.0)
        {
            // background
            color += vec3(max(rd.y + 0.2, 0.0) * 0.1);
            break;
        }
	}
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y;
    vec3 color = vec3(0.0);
    
    {
        // ray
        vec3 ro = vec3(-1.8, 3.0, 5.0);
        vec3 rd = normalize(vec3(p, -2.0));
        
        float r = -0.5;
        rd.yz *= mat2(cos(r), -sin(r), sin(r), cos(r));
        
        // ray marching
        trace(ro, rd, color);
  
        // composition
/*
        p.x *= resolution.y / resolution.x;
        p.xy = abs(p.xy) - 0.33333;
        color.x += smoothstep(0.005, 0.0025, abs(dot(p, vec2(1.0, 0.0))));
        color.x += smoothstep(0.005, 0.0025, abs(dot(p, vec2(0.0, 1.0))));
*/
    }
    
    color = pow(color, vec3(0.454545));
    gl_FragColor = vec4(color, 1.0);
}
