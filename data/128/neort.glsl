precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float PI = 3.1415926;

// https://www.shadertoy.com/view/4djSRW
float hash12(vec2 p, float s)
{
    p = mod(p, s * 2.0);    // 周期化
    
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}
vec2 hash22(vec2 p, float s)
{
    p = mod(p, s * 2.0);    // 周期化
    
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz)*p3.zy);
}

float interpolation(float f)
{
    return f * f * f * (f * (6.0 * f - 15.0) + 10.0);
}

float animation(float f, float speed)
{
	return sin(f * PI * 2.0 + time * speed) * 0.5 + 0.5;
}

float sNoiseValue2D(vec2 p, float s, float speed)
{
    p *= s;
    vec2 i = floor(p);
    vec2 f = fract(p);
    float r1 = animation(hash12(i + vec2(0.0, 0.0), s), speed);
    float r2 = animation(hash12(i + vec2(1.0, 0.0), s), speed);
    float r3 = animation(hash12(i + vec2(0.0, 1.0), s), speed);
    float r4 = animation(hash12(i + vec2(1.0, 1.0), s), speed);
    return mix(mix(r1, r2, interpolation(f.x)), mix(r3, r4, interpolation(f.x)), interpolation(f.y));
}

float sNoiseValueFbm2D(vec2 p, float s, float speed, int octaves, float amplitude)
{
    float o = 0.0;
    float fbm_max = 0.0;
    for(int i = 0; i >= 0; i++)
    {
		if(i >= octaves)    break;
        float a = pow(amplitude, float(i));
        o += a * sNoiseValue2D(p, s * pow(2.0, float(i)), speed);
        fbm_max += a;
    }
    return o / fbm_max;
}

float sNoiseCellular2D(vec2 p, float s, float speed)
{
    float o = 1.0;
    p *= s;
    vec2 i = floor(p);
    vec2 f = fract(p);
    for(int y = -1; y <= 1; y++)
    {
        for(int x = -1; x <= 1; x++)
        {
            vec2 neightbor = vec2(float(x), float(y));
            vec2 r = hash22((i + neightbor), s);
            r.x += animation(r.x, 2.0) * 0.1;
            r.y += animation(r.y, 2.0) * 0.1;
            r = clamp(r, 0.0, 1.0);
            o = min(length(f - (neightbor + r)), o);
        }
    }
    return o;
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec2 p_ = p;
    vec3 color = vec3(0.0);
  
    p = vec2(atan(p.y, p.x) / PI, log2(length(p))); // -1.0～1.0に正規化した極座標へ変換
    p.x *= float(1);    // リピート数
    p.y *= 0.6;         // 
    p.x += p.y * 0.3;  // スパイラル
    p.y -= time * 0.5;  // 奥から手前へ

    // ドメインワーピング（バリューノイズFBM ＆ バリューノイズFBM ＆ セルラーノイズ）
    float qx = sNoiseValueFbm2D(p, 5.0, 2.0, 5, 0.5);
    float qy = sNoiseValueFbm2D(p + vec2(0.5, 0.5), 5.0, 2.0, 5, 0.5);
    float n = sNoiseValueFbm2D(p + vec2(qx, qy) * 0.5, 3.0, 2.0, 5, 0.5);
    n = sNoiseCellular2D(p + n * 1.0, 2.0, 2.0);
    n = pow(n, 1.5);

    color += mix(vec3(0.0), vec3(0.1, 0.25, 1.0), n);
    color += mix(vec3(0.0), vec3(2.0, 3.0, 2.0), n * n * n * n * n);
    color += mix(vec3(0.0), vec3(0.1, 1.0, 1.0), qx * qy) * exp(-length(p_) * 1.0) * 1.25;
    color = pow(color, vec3(0.6));
    gl_FragColor = vec4(color, 1.0);
}
