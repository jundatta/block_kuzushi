precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define PI acos(-1.)

mat2 rot(float a){
    float c = cos(a),s= sin(a);
    return mat2(c,s,-s,c);
}

vec2 rotate(vec2 p, float a){
    return rot(a)*p;
}

vec2 pmod(vec2 p, float n){
    float a = atan(p.y,p.x) + PI/n;
    float r = 2.0 * PI /n;
    a = floor(a/r)*r;
    return rotate(p,-a);
}

float rect(vec2 p, vec2 s){
    vec2 d = abs(p) - s;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float circle(vec2 p, float r){
    return length(p) - r;
}

float hash(vec2 p){
    return fract(44615.6314 * sin(dot(p,vec2(12.8989,72.599))));
}

vec2 rpos(vec2 p){
    return vec2(hash(p),hash(p + vec2(45.6314,124.531)));
}

vec3 voronoi(vec2 p, float a){
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    vec2 pt = vec2(0.0);
    vec2 res = vec2(8.0);
    for(int x = -1;x <=1;x++){
        for(int y = -1; y <=1;y++){
            vec2 n = vec2(x,y);
            vec2 np = rpos(n + i) * abs(a);
            vec2 p = np + n - f;
            float l = length(p);
            if(l < res.x){
                res.y = res.x;
                res.x = l;
                pt = n + i;
            } else if(l < res.y){
                res.y = l;
            }
        }
    }
    res = sqrt(res);
    return vec3(res.y -res.x,pt);
}

float tex(vec2 p){
    float o = 1.0;
    vec2 p0 = p;
    
    p = rotate(p,PI/3. + time * 0.1);
    vec2 q0 = p;
    q0 = rotate(q0,PI/12. - time*0.25);
    for(int i = 0; i < 12; i++){
        q0 = rotate(q0,PI/6.);
        float b0 = rect(rotate(q0 - vec2(0.65,0.),PI * 0.25),vec2(.0625));
        float s2 = circle(rotate(q0,PI/12.) - vec2(0.5,0),0.12);
        o = min(o,b0);
        o = min(o,s2);
    }
        
    vec2 q1 = pmod(rotate(p,time*0.1),8.);
    float s0 = circle(q1 - vec2(0.29,0.),0.075);
    vec2 q2 = pmod(p,12.);
    float s1 = circle(q2 - vec2(1.0,0.0),0.25);
        
    o = min(o,s0);
    o = min(o,s1);
        
    
    float s2 = circle(p0,0.2);
    o = min(o,s2);
    
    float s = circle(p0,1.0);
    

    // o = min(o,s1);
    o = max(o,s);
    // o = smoothstep(0.001,0.0,o);
    return o;
}

vec3 hsv2rgb(vec3 hsv){
    return ((clamp(abs(fract(hsv.r+vec3(0,2,1)/3.)*6.-3.)-1.,0.,1.)-1.)*hsv.g+1.)*hsv.b;
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    
    float c = tex(uv);
    vec3 v = voronoi(rotate(uv,time * 0.01) * 10.,0.75);
    c = smoothstep(0.001,0.0,c);
    c *= smoothstep(0.0,0.05,v.r);
    vec3 color = hsv2rgb(vec3(atan(v.g,v.b),0.45,1.)) * c;
    gl_FragColor = vec4(color,1.0);
}