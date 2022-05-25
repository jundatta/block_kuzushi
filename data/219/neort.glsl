// Distance Function by iq https://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm

precision highp float;
uniform vec2  resolution;
uniform float time;

const float PI = 3.14159265359;
const float PI2 = 6.28318530718;

float rand(vec2 st){
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453);
}
vec2 rand2(vec2 st){
    st = vec2(dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    //return -1.0 + 2.0*fract(sin(st)*43758.5453123);
    return fract(sin(st)*43758.5453123);
}
float perlinNoise(vec2 st) {
    vec2 p = floor(st);
    vec2 f = fract(st);
    vec2 u = f*f*(3.0-2.0*f);

    float v00 = rand(p+vec2(0.0,0.0))*2.0-1.0;
    float v10 = rand(p+vec2(1.0,0.0))*2.0-1.0;
    float v01 = rand(p+vec2(0.0,1.0))*2.0-1.0;
    float v11 = rand(p+vec2(1.0,1.0))*2.0-1.0;

    return mix( mix(dot(vec2(v00), f-vec2(0,0)), dot(vec2(v10), f-vec2(1.0,0.0)), u.x),
                mix(dot(vec2(v01), f-vec2(0,1)), dot(vec2(v11), f-vec2(1.0,1.0)), u.x), 
                u.y)+0.5;
}

vec2 rotate(vec2 st, float angle){
    mat2 mat = mat2(cos(angle), -sin(angle),
                            sin(angle), cos(angle));
    return mat*st;
}
float sdCircle(vec2 st, float radius){
    return length(st) - radius;
}
float sdBox(vec2 st, vec2 size){
    vec2 d = abs(st) - size;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}
float sdLine(vec2 p, vec2 a, vec2 b){
    vec2 pa = p-a;
    vec2 ba = b-a;
    vec2 h = vec2(clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0));
    return length( pa - ba*h );
}
float sdVesica(vec2 st, float r, float d){
    st = abs(st);
    float b = sqrt(r*r-d*d);
    return ((st.y-b)*d>st.x*b) ? length(st-vec2(0.0,b))
                               : length(st-vec2(-d,0.0))-r;
}
float sdTrapezoid(vec2 p, float r1, float r2, float he){
    p.y *= -1.0;
    vec2 k1 = vec2(r2,he);
    vec2 k2 = vec2(r2-r1,2.0*he);
    p.x = abs(p.x);
    vec2 ca = vec2(p.x-min(p.x,(p.y<0.0)?r1:r2), abs(p.y)-he);
    vec2 cb = p - k1 + k2*clamp( dot(k1-p,k2)/dot(k2, k2), 0.0, 1.0 );
    float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
    return s*sqrt( min(dot(ca, ca),dot(cb, cb)) );
}

vec4 SUN(vec2 uv, vec2 offs, float radius){
    float c1 = sdCircle(uv-offs, radius);

    //pmod
    float r = 24.0;
    vec2 ruv = uv-offs;
    float a = atan(ruv.x, ruv.y) + PI / r;
    float n = PI2 / r;
    a = floor(a / n) * n;
    ruv = rotate(ruv ,-a);
    float c2 = sdCircle(ruv, radius*4.0);
    float id = floor(a/n) + floor(time);

    float c3 = sdCircle(uv-offs, radius*2.0);
    c2 = max(c2, -c3);

    c1 = float(0.0 > c1);
    c2 = mod(id,3.0)==0.0 ? float(0.0 > c2) : 0.0;

    vec4 suncol = vec4(1.0, 1.0, 0.0, 1.0);
    return vec4(c1+c2)*suncol;
}
vec4 CLOUD(vec2 uv, vec2 offs, float scale){
    vec2 ruv = uv - offs;
    float id = floor(ruv.x -time*0.05);
    ruv.x = fract(ruv.x -time*0.05)-0.5;
    ruv.x *= 0.42;

    vec2 r2 = rand2(vec2(id+3.5))-0.5;
    float d = sdCircle(ruv+r2*0.175, scale);
    float a = atan(ruv.x, ruv.y);
    float f = (abs(cos(a*4.0)*cos(a*1.8)+cos(a*2.1))*0.04-0.3)*0.2;
    vec4 col = vec4(step(d, f));
    
    //OutLine?
    //float x = 1.0/resolution.x;
    //vec4 ocol = vec4(step(d, f-x*2.0));
    //col.rgb = mix(ocol.rgb, col.rgb, ocol.a);

    return col;
}
vec4 MOUNTAIN(vec2 uv){
    float id = floor(uv.x);
    float n = fract(sin(id*234.12)*5463.0)*2.0-1.0;

    float x = n*0.3;
    float y = sin(uv.x*0.423) + sin(uv.x)*0.3;

    float mt = smoothstep(0.025, -0.025, uv.y+y); // Ground
    vec4 col = vec4(0.0, 1.0, 0.0, 1.0);

    return col*mt;
}
vec4 CAR(vec2 uv, vec2 offs, float size){
    //Tire
    uv -= offs;
    vec2 tuv = uv;
    tuv.x = abs(uv.x);
    float tsize = 0.02;
    float d1 = sdCircle(tuv-vec2(0.045, -.0275), tsize);

    //Body
    float d2 = sdBox(uv+vec2(0.0, 0.005), vec2(0.08, 0.02));

    //Upper
    float d3 = sdBox(uv+vec2(0.035,-0.04), vec2(0.03, 0.03));
    float d4 = sdTrapezoid(uv+vec2(0.05,-0.04), 0.015, 0.03, 0.03);

    //Door
    float dl = sdLine(uv, vec2(-0.035, 0.012), vec2(-0.02, 0.012));

    float db = min(d3, d4);
    float dd = min(db, d2);
    float d = min(min(d1,dd), dl);

    vec3 Tcol = vec3(0.3);
    vec3 Bcol = vec3(1.0);
    vec3 Wcol = vec3(0.0, 0.8, 1.0);
    vec3 Dcol = vec3(0.0);
    vec3 col = mix(Tcol, Bcol, step(dd, d1));
    float ss = step(db, -0.01);
    col = mix(col, Wcol, ss);
    float ds = step(0.002, dl);
    col = mix(Dcol, col, ds);

    return vec4(col, float(0.0 > d));
}
vec4 FIRLD(vec2 uv, vec2 id){
    vec4 col = vec4(0.0);
    float d,d1,d2;
    float r = 0.75;
    float s = 0.7;

    vec2 st = uv;
    st.x *= 1.75;
    st.x = st.x + (st.y+0.5)*sin(id.x + time*2.0)*0.2;
    st.y = (st.y-0.5)*0.5;

    vec2 st1 = st + vec2(pow(-st.y, 0.2) - 0.75, 0.0);
    d1 = sdVesica(st1, r, s);

    vec2 st2 = st + vec2(pow(-st.y, 0.05) - 0.9, 0.0);
    st2.y /= 1.5;
    d2 = sdVesica(st2, r, s);

    d = min(d1, d2); 
    col = vec4(0.0, 0.8, 0.0, 1.0)*smoothstep(0.01, -0.01, d);

    return clamp(col, 0.0, 1.0);
}

void main(){
    //vec2 uv = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution) / resolution;
    vec4 col = vec4(0.0);

    vec4 sky = mix(vec4(0.0,0.7,1.0,1.0), vec4(1.0), pow(clamp(1.5-((uv.x-uv.y)*0.3+1.4), 0.0, 0.5), 0.9) );
    col = sky;

    vec2 offs = vec2(-0.75, 0.8);
    float radius = 0.06;
    vec4 sun = SUN(uv, offs, radius);
    col = mix(col, sun, sun.a);

    float height = -0.1;

    //Cloud
    float scale = 0.125;
    offs = vec2(0.5, 0.55);
    vec2 cuv = uv.y>height ? vec2(uv.x, uv.y) : vec2(uv.x - 0.1, -uv.y);
    vec4 cloud = CLOUD(cuv, offs, scale);

    //Mountain
    scale = 10.0;
    vec2 tv = uv.y>height ? vec2(time*0.75, 4.0) : vec2(time*0.75 + 1.0, 4.0);
    vec4 mt = MOUNTAIN(vec2(uv.x, abs(uv.y))*scale-tv);
    mt.g *= clamp(uv.y+0.6, 0.5, 1.0);

    cloud = mix(cloud, mt, mt.a);
    
    col = uv.y>height ? mix(col, cloud, cloud.a) : mix(col, cloud, cloud.a*0.5);
    
    float size = 0.05;
    float h = floor(mod(time*10.0,2.0))*0.005;
    offs = vec2(0.8, height+size+h);
    vec4 car = CAR(uv, offs, size);
    col = mix(col, car, car.a);

    if(uv.y<height){
        uv.y -= height;
        col.g *= 1.25;
        vec2 uv2 = uv;
        uv2.x += uv2.x*uv2.y*0.25;

        uv2 = fract(uv2 * vec2(1.2, 1.8) - vec2(time*0.1, 0.0)); //*2.0-1.0;

        vec4 ridge = vec4(0.45, 0.30, 0.20, 1.0);
        vec4 grass = vec4(0.0, 1.0, 0.0, 1.0);
        if(abs(uv2.x)>0.925 || abs(uv2.y)>0.925) {
            col = mix(col, mix(ridge, grass, perlinNoise(uv2*2.0)), ridge.a);
        }else{
            vec2 grid = vec2(12.0, 12.0);
            vec2 gv = fract(uv2*grid)-0.5;
            vec2 id = floor(uv2*grid)+grid;
            
            vec4 rice = FIRLD(gv, id);
            col = mix(col, rice, rice.a);
        }
    }

    gl_FragColor = col;
}