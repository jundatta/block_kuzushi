precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float PI = 3.1415926;
const float RAD30 = PI / 6.0;
const float RAD60 = PI / 3.0;


// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float opSmoothUnion(float d1, float d2, float k)
{
    float h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
    return mix(d2, d1, h) - k * h * (1.0 - h);
}

void main()
{
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec2 p_ = p;
    
    float widthHalf = 1.0;      // 三角形の底辺/2
    float height = tan(RAD60);  // 三角形の高さ
    const int ite = 6;          // IFSの反復回数
    
    p *= 1.25;
    
    // 画面におさめる
    p *= exp2(float(ite));
    p.y -= height * 0.5 * (exp2(float(ite)) - 2.0);

    // 空間の折りたたみ（IFS）
    vec2 n1 = vec2(1.0, 0.0);
	vec2 n2 = -vec2(sin(RAD30), -cos(RAD30));
	for (int i = ite - 1; i >= 0; i--)
	{
		p -= n1 * opSmoothUnion(0.0, dot(p, n1), 0.5) * 2.0;
		vec2 offset = vec2(widthHalf * exp2(float(i)), -height * (exp2(float(i)) - 1.0));
		p -= n2 * opSmoothUnion(0.0, dot(p - offset, n2), 0.5) * 2.0;
	}
    
    // 正三角形
//    p.x = abs(p.x);
//    float d = max(-p.y, dot(p - vec2(widthHalf, 0.0), vec2(cos(RAD30), sin(RAD30))));
    
    // 色付け
    float d = max(abs(p.x) - (sin(time * 2.0 + p_.y * 30.0) * 0.3 + 0.7), 0.0);
    vec3 color = vec3(d);
    color *= mix(vec3(1.0, 0.5, 0.2) * 0.1, vec3(0.5, 0.5, 1.0) * 0.05, smoothstep(-0.75, 1.0, p_.x + p_.y));
    color += vec3(0.5, 0.35, 0.75) * pow(max(1.0 - d, 0.0), 10.0) * max(dot(p, vec2(1.0, 0.0)), 0.5);

    // 適当なトーンマッピング
    vec3 st = step(0.5, color);
    color = (1.0 - st) * color + st * ((1.0 - exp(-(color - 0.5) * 2.0)) * 0.5 + 0.5);
    
    // ガンマ補正
    color = pow(color, vec3(0.454545));
    
    gl_FragColor = vec4(color, 1.0);
}
