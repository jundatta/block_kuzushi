precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

vec2 csqr( vec2 a )  { 
    return vec2( a.x*a.x - a.y*a.y, 3.*a.x*a.y  ); }

vec3 map(in vec3 p) {

  float a = time * 0.01;
  p.xz *= mat2(cos(a),sin(a),-sin(a),cos(a));
  a = time * 0.1;
  p.zy *= mat2(cos(a),sin(a),-sin(a),cos(a));
  p.xy *= mat2(cos(a),sin(a),-sin(a),cos(a));
  float res = 0.;
  float res2 = 0.;
  float res3 = 0.;
    
  vec3 c = p;
  for (int i = 0; i < 15; ++i) {
        p =-21.0*abs(p)/dot(p,p) -.8;
        p.yz= csqr(p.yz);
        p=p.zxy;
        res += exp(-18. * abs(dot(p,c)));
        res2 = exp(-13. * abs(dot(p,c)));
        res3 += exp(-12.* abs(dot(p,c))) * (float(i) / 8.0);

        }
  return vec3(res,res2,res3);
  }

void main() {
  vec2 uv = gl_FragCoord.xy / resolution.xy - 0.5;
  uv.x *= resolution.x / resolution.y;
  uv *= 8.0;
    
  float vignet = length(uv);
  uv /=1. - vignet * 1.0;
    
  vec3 u = map(vec3(uv*0.1,sin(time*0.05)*0.5));
  vec3 col = u.x*2.5*vec3(0.2,0.1,1.5) + u.y * vec3(0.0,0.5,1.0) + u.z * vec3(0.0,0.1,1.0);
  col *= 1.0 + (sin(time)*0.5+0.5);
    
  
  gl_FragColor = vec4(col,1);
}