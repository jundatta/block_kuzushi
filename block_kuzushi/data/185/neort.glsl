precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

mat2 rot(float a){return mat2(cos(a),sin(a),-sin(a),cos(a));}
float bo(vec2 p , vec2 s){p = p - s;return max(p.x,p.y);}

vec2 map(vec3 p)
{
    vec3 op = p;
	vec2 o = vec2(10.);
    vec3 l = vec3(.5);
    float s = 3.;
    p.x += sin(p.x * 20.)/30.;
    p.xy = sin(p.xy/s)*s;
    
    p.x = abs(p.x)-1.2;
    

    p.xy *= rot( sin(p.z/10.)+time/32. );
    p.x += 3.;
    p.xy = abs(p.xy)-(2. + sin(time/10.)/10.);
    
    p.xy *= rot(p.z/2. + time/3.);
    
    p.yz = sin(p.yz*.8)/.8;
    p.xy -= clamp(p.xy , -l.xy,l.xy);
    
    
    o.x = length(p.xy)-0.01;
    //o.x = bo(p.xy , vec2(.4));
    o.x -= sin(p.z*30.)/100.;
    vec3 b = op;
	
    
    return o;
}

vec2 march(vec3 cp , vec3 rd)
{
	float depth = 0.;
    for(int i = 0; i < 59 ; i++)
    {
        vec3 rp = cp + rd * depth;
        vec2 d = map(rp);
        if(abs(d.x) < 0.1)
        {
            return vec2(depth,d.y);
        }
        if(depth > 30.)break;
        depth += d.x;
        
    }
    return vec2(-depth);
    
}


void main(void) {
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    vec3 cp = vec3(21.1,0.,-19.);
    //cp.y += sin(time/) * 6.;
    //cp.z += cos(time/3.);
    
    vec3 target = vec3(0.);
    vec3 cd = normalize(target - cp);
    
    vec3 cs = normalize(cross(vec3(0.,1.,0.) ,cd));
    vec3 cu = normalize(cross(cd , cs));
    
    float fov = 2.5;
    vec3 rd = normalize(p.x * cs + p.y * cu + fov * cd);
    
    vec2 d = march(cp , rd);
    vec3 col = vec3(1.);
    //col = sin(rd ) * vec3(1.,.0,1.);
    col = vec3(0.,1.,.7)/5.;
    //col = vec3(0.);
    vec3 scol = col;
    if(d.x > 0.)
    {
        vec2 e = vec2(0,0.001);
        vec3 pos = d.x * rd + cp;
        
        vec3 N = normalize(map(pos).x - vec3(map(pos + e.xyy).x , map(pos + e.yxy).x , map(pos + e.yyx).x ));
        col = pos;
        col =  N;
        vec3 sun = normalize(vec3(2.,4.,8.));
        sun = normalize(vec3(0.,1.,0.));
        //sun.xz *= rot(time);
        float diff = max(0.,dot(sun,N));
        diff = mix(1.,diff , .8);
        float sp = max(0.,dot(reflect(sun,N),rd));
        sp = pow(sp,10.);
        float rim = 1. - abs(dot(N,rd));
        rim = pow(rim , 30.);
        vec3 mat = vec3(1.);
        col = diff * mat + sp + rim * vec3(1.);//fuck yeah!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         //col = N;
        float t = exp(-0.0003  * d.x * d.x * d.x );
       // float t2 = exp(-0.03  * d.x * d.x * d.x );
        scol = mix(vec3(0.,1.,.7) /5.,vec3(0.,1.,.7) , t);
        col = mix(scol , col , t);
        
    }

    gl_FragColor = vec4(col, 1.0);
}