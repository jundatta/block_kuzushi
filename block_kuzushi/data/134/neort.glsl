precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const float PI = 3.1415926;
const float TWO_PI = 6.283185;

vec3 hsv(float h, float s, float v){
    vec4 t = vec4(1.0, 0.5 / 3.0, 0.5 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}
// matrixes------------------------------------
// rotate matrix
mat2 rotate2d(float angle){
    return mat2(
        cos(angle), -sin(angle),
        sin(angle),  cos(angle));
}

// scale matrix
mat2 scale(vec2 scale){
    return mat2( scale.x,  0.0,
                 0.0,      scale.y );
}
// --------------------------------------------

// shape func ---------------------------------
float circle(vec2 p){
    return length(p);
}

float square(vec2 p){
    return abs(p.x) + abs(p.y);
}

// ???
float lPolygon(vec2 p,int n){
  float a = atan(p.x, p.y) + PI;
  float r = TWO_PI / float(n);
  return cos(floor(0.5 + a / r) * r - a) * length(p);
}
// --------------------------------------------


void main(){
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y;
    
    float threshold = sin(time * 5.0) * 0.5 + 0.5;
    float wave = (mod(p.x + p.y + time * 6.0, 3.0));
    
    float tri = lPolygon(p, 3);
    
    // Remap
    p *= 3.0;
    p = fract(p);
    p = p * 1.0 - 0.5;
    p += rotate2d(sin(time) * PI) * p;
    p += scale(vec2(sin(time) + 1.0)) * p;


    float d = mix(square(p), tri, threshold * wave + wave * 2.0);
    vec3 color = hsv(smoothstep(0.1, 0.5, d)* smoothstep(0.8, 0.7, d), 1.0, 1.0);
    
    gl_FragColor = vec4(color, 1.0);
}
