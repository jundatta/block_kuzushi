precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

#define folds 3

vec2 fold(vec2 p)
{
    p.x=abs(p.x);
    vec2 v=vec2(0,1);
    for(int i=0;i<folds;i++)
    {
        p-=2.0*min(0.0,dot(p,v))*v;
        v=normalize(vec2(v.x-1.0,v.y));
    }
    return p;    
}

vec2 csqr( vec2 a )  { 
    return vec2( a.x*a.x - a.y*a.y, 3.*a.x*a.y  ); }

vec3 map(in vec3 p) {

    float a = time * 0.1;
    p.xz *= mat2(cos(a),sin(a),-sin(a),cos(a));
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
    uv /=1. - vignet * 0.85;
    
    float t = time *0.2;
    float s = sin(t);
    float c = cos(t);
    mat2 rot = mat2(c, -s, s, c); 
    uv *= rot;
    
    uv = fold(uv);
    
    
    vec3 u = map(vec3(uv*1.5,sin(time*0.05)*1.0));
    vec3 col = u.x*2.5*vec3(0.1,0.2,1.5) + u.y * vec3(0.0,0.5,1.0) + u.z * vec3(0.0,0.1,1.0);
    col *= 2.0;
    //col *= 1.0 + (sin(time)*0.5+0.5);
    
  
  gl_FragColor = vec4(col,1);
}