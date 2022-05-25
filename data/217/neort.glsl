precision highp float;
precision highp int;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const float PI = 3.141592;
const int   oct  = 8;
const float per  = 0.5;

vec3 hex2color(int hex) {
    float r = float(hex / 256 / 256);
    float g = float(hex / 256 - int(r * 256.0));
    float b = float(hex - int(r * 256.0 * 256.0) - int(g * 256.0));
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

// 乱数生成
float random(vec2 p){
    return fract(sin(dot(p ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

    vec3 color1 = hex2color(0xd81159);
    vec3 color2 = hex2color(0x8f2d56);
    vec3 color3 = hex2color(0x218380);
    vec3 color4 = hex2color(0xfbb13c);
    vec3 color5 = hex2color(0x73d2de);
    
    vec3 color;
    float mesh, val;
    float freq = 5.0;
    float amp = 1.0;
    
    uv.x += sin(uv.y + time * 1.2);
    uv.y += sin(uv.x + time * 1.2);
    color += vec3(sin(atan(uv.x, uv.y) * 2.0)) * color2;
    uv.x += sin(uv.y + time * 1.4);
    uv.y += sin(uv.x + time * 1.4);
    color += vec3(sin(atan(uv.x, uv.y) * 3.0)) * color3;
    uv.x += sin(uv.y + time * 1.6);
    uv.y += sin(uv.x + time * 1.6);
    color += vec3(sin(atan(uv.x, uv.y) * 4.0)) * color4;
    uv.x += sin(uv.y + time * 1.8);
    uv.y += sin(uv.x + time * 1.8);
    color += vec3(sin(atan(uv.x, uv.y) * 5.0)) * color5;
    
    gl_FragColor = vec4(color / 2.0 + 0.5, 1.0);
}