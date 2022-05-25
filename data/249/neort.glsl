precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

vec2 rotate(vec2 p, float a){
    float c = cos(a),s = sin(a);
    return mat2(c,s,-s,c) * p;
}

float sdEgg(vec2 p, float ra, float rb){
    const float k = sqrt(3.0);
    p.x = abs(p.x);
    float r = ra - rb;
    float a = k * (p.x + r) < p.y ? length(vec2(p.x, p.y - k * r)) : length(vec2(p.x + r,p.y)) - 2.0 * r;
    return ((p.y < 0.0) ? length(p) - r : a) - rb;
}

float sdIsoscaleTriangle(vec2 p, vec2 q){
    p.x = abs(p.x);
    vec2 a = p - q * clamp(dot(p,q)/dot(q,q),0.0,1.0);
    vec2 b = p - q * vec2(clamp(p.x/q.x,0.0,1.0),1.0);
    float s = -sign(q.y);
    vec2 d = min(vec2(dot(a,a), s * (p.x * q.y - p.y * q.x)),vec2(dot(b,b),s * (p.y - q.y)));
    return -sqrt(d.x) * sign(d.y);
}

float sdFish(vec2 uv){
    vec2 p0 = uv;
    
    p0.x *= 1.75;
    
    p0 = rotate(p0,sin(time * 0.1) * 0.1);
    
    float body = sdEgg(p0,0.1,0.05);
    
    vec2 p1 = uv;
    
    p1.y -= 0.03;
    
    p1 = rotate(p1,sin(time+0.5)*0.2);
    p1.x = abs(p1.x);
    p1 = rotate(p1,0.8);
    
    p1.x -=0.05;
    
    float fin0 = sdIsoscaleTriangle(p1,vec2(0.04,0.12));
    
    body = min(body,fin0);
    
    vec2 p2 = uv;
    
    p2.y -= 0.125;
    
    p2 = rotate(p2,sin(time)*0.3);
    
    float fin1 = sdIsoscaleTriangle(p2,vec2(0.03,0.16));
    
    body = min(body,fin1);
    
    p2 = rotate(p2, + sin(time) * 0.1);
    
    p2.x = abs(p2.x);
    
    p2 = rotate(p2,0.7);
    
    float fin2 = sdIsoscaleTriangle(p2,vec2(0.015,0.13));
    
    body = min(body,fin2);
    
    return body;
}

float hash(vec2 uv){
    return fract(46641.5396 * sin(dot(uv,vec2(12.8989,78.531))));
}

vec2 hash2(vec2 uv){
    return vec2(hash(uv),hash(uv + vec2(12.6314)));
}

float noise(vec2 uv){
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a0 = hash(i);
    float a1 = hash(i + vec2(1,0));
    float a2 = hash(i + vec2(0,1));
    float a3 = hash(i + vec2(1,1));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a0,a1,u.x),mix(a2,a3,u.x),u.y);
}

vec2 noise2(vec2 uv){
    return vec2(noise(uv),noise(uv + vec2(12.6214)));
}

vec4 goldFish(vec2 uv, float hash){
    
    // float n = noise(uv * 16. + hash);
    // vec3 color = n > 0.3 ? (n > 0.6 ? vec3(1) : vec3(1,0,0)) : vec3(0.1);
    vec3 color = hash > 0.75 ? vec3(1.0,0.0,0.0) : vec3(0.0);
    float c = smoothstep(0.04,0.0,sdFish(uv));
    float s = smoothstep(0.05,0.0,sdFish(uv - vec2(0.1)));
    
    return vec4(c * color,c + s * 0.1 * (1.-c));
}

float vnoise(vec2 uv){
    vec2 i =  floor(uv);
    vec2 f = fract(uv);
    
    vec2 res = vec2(8.0);
    
    for(int x = -1; x <= 1; x++){
        for(int y = -1; y <= 1; y++){
            vec2 n = vec2(x,y);
            vec2 p = noise2(i + n + time * 0.1);
            vec2 pos = n + p - f;
            float l = length(pos);
            if(l < res.x){
                res.y = res.x;
                res.x = l;
            } else if(l < res.y){
                res.y = l;
            }
        }
    }
    res = sqrt(res);
    return res.y -res.x;
}

#define PI acos(-1.)

float wave(vec2 uv, float d){
    vec2 i = floor(uv * 3.0);
    vec2 f = fract(uv * 3.0);
    float r = length(f- 0.5);
    float t= time * 10.;
    float ph = mod(t/10. + hash(i) * d,d);
    float w = smoothstep(0.9,1.0,sin(r * 30.0 - t + hash(i) * 10.0) * 0.5 + 0.5) * smoothstep(0.5,0.0,r) * smoothstep(1.,0.,ph);
    return w;
}

vec3 tex(vec2 uv){
    float t = time * 0.4;
    
    vec2 p = uv;
    
    vec4 o = vec4(0);
    
    for(int i = 0; i < 6; i++){
        float dir = hash(vec2(i)) - 0.5;
        vec2 pos = uv  + hash2(vec2(i));
        float z = hash(vec2(i + 100)) * 0.5 + 0.5;
        pos = rotate(pos,dir*PI);
        pos.y += dir > 0.? t * dir : - t * dir ;
        pos = mod(pos,2.0) - 1.0;
        o += goldFish(pos/z, z) * z;
    }
    
    float v = vnoise(uv * 2. + time * 0.1);
    float v2 = vnoise(uv * 4. + time*0.05);
    v = smoothstep(0.1,0.,v) * 0.1;
    v2 = smoothstep(0.1,0.,v2) * 0.05;
    
    
    float w = wave(uv,16.0) + wave(uv * 0.5 + 0.2,32.0);
    
    return v + v2 + o.rgb + vec3(0.1,0.4,0.7) * (1.- o.a) + w;
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    gl_FragColor = vec4(tex(uv), 1.0);
}