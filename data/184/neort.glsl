// 2022/04/29
// VMware(R) Workstation 16 Player 16.2.3 build-19376536
// にて"data/184/neort.glsl"のコンパイルがおかしい？！
// ⇒Vmware SVGA 3D 8.17.2.14
//   ray = camPos + dir * rLen;
//   に絡む処理の計算結果があやしい？
//   計算後？for()ループを戻ってきたときの
//   d = map(ray);
//   のrayの値がおかしく？なっているように見える
// 。。。ホストOS上の
// 　　　Intel(R) UHD Graphics 630 30.0.101.1660
// 　　　では現象が再現しない（期待通りにうごいている）

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

float N21(vec2 p) {
	p = fract(p * vec2(2.15, 8.3));
    p += dot(p, p + 2.5);
    return fract(p.x * p.y);
}

vec2 N22(vec2 p) {
	float n = N21(p);
    return vec2(n, N21(p + n));
}

vec3 hsv2rgb(float h, float s, float v)
{
    return ((clamp(abs(fract(h+vec3(0,2,1)/3.)*6.-3.)-1.,0.,1.)-1.)*s+1.)*v;
}

vec2 rotate(vec2 p, float a)
{
	return vec2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}

vec2 getPos(vec2 id, vec2 offset) {
	vec2 n = N22(id + offset);
    float x = cos(time * n.x);
    float y = sin(time * n.y);
    return vec2(x, y) * 0.3 + offset;
}

float distanceToLine(vec2 p, vec2 a, vec2 b) {
	vec2 pa = p - a;
    vec2 ba = b - a;
    float t = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    return length(pa - t * ba);
}

float getLine(vec2 p, vec2 a, vec2 b) {
	float distance = distanceToLine(p, a, b);
    float dx = 10./resolution.y;
    return smoothstep(dx, 0., distance) * smoothstep(0.85, 0.15, length(a - b));
}

float layer(vec2 st) {
    float m = 0.;
    vec2 gv = fract(st) - 0.5;
    vec2 id = floor(st);
    vec2 pointPos = getPos(id, vec2(0., 0.));
    m += smoothstep(0.05, 0.01, length(gv - pointPos));
    
    float dx=15./resolution.y;
    
    vec2 p[9];
    p[0] = getPos(id, vec2(-1., -1.));
    p[1] = getPos(id, vec2(-1.,  0.));
    p[2] = getPos(id, vec2(-1.,  1.));
    p[3] = getPos(id, vec2( 0., -1.));
    p[4] = getPos(id, vec2( 0.,  0.));
    p[5] = getPos(id, vec2( 0.,  1.));
    p[6] = getPos(id, vec2( 1., -1.));
    p[7] = getPos(id, vec2( 1.,  0.));
    p[8] = getPos(id, vec2( 1.,  1.));
    
    for (int j = 0; j <=8 ; j++) {
    	m += getLine(gv, p[4], p[j]);
        vec2 temp = (gv - p[j]) * 50.;
        m += 1./dot(temp, temp) * (sin(10. * time + fract(p[j].x) * 20.) * 0.5 + 0.5);
        
    }
    
    m += getLine(gv, p[1], p[3]);
    m += getLine(gv, p[1], p[5]);
    m += getLine(gv, p[3], p[7]);
    m += getLine(gv, p[5], p[7]);

    return m;
}

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
  { 
  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

  vec3 i  = floor(v + dot(v, C.yyy) );
  vec3 x0 =   v - i + dot(i, C.xxx) ;

  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; 
  vec3 x3 = x0 - D.yyy;      

  i = mod289(i); 
  vec4 p = permute( permute( permute( 
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

  float n_ = 0.142857142857; // 1.0/7.0
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                dot(p2,x2), dot(p3,x3) ) );
  }

float normnoise(float noise) {
	return 0.5*(noise+1.0);
}

float clouds(vec2 uv) {
    uv += vec2(time*0.02, + time*0.02);
    
    vec2 off1 = vec2(50.0,33.0);
    vec2 off2 = vec2(0.0, 0.0);
    vec2 off3 = vec2(-300.0, 50.0);
    vec2 off4 = vec2(-100.0, 200.0);
    vec2 off5 = vec2(400.0, -200.0);
    vec2 off6 = vec2(100.0, -1000.0);
	float scale1 = 3.0;
    float scale2 = 6.0;
    float scale3 = 12.0;
    float scale4 = 24.0;
    float scale5 = 48.0;
    float scale6 = 96.0;
    return normnoise(snoise(vec3((uv+off1)*scale1,time*0.5))*0.8 + 
                     snoise(vec3((uv+off2)*scale2,time*0.4))*0.4 +
                     snoise(vec3((uv+off3)*scale3,time*0.1))*0.2 +
                     snoise(vec3((uv+off4)*scale4,time*0.7))*0.1 +
                     snoise(vec3((uv+off5)*scale5,time*0.2))*0.05 +
                     snoise(vec3((uv+off6)*scale6,time*0.3))*0.025);
}

vec3 opRep(vec3 p, vec3 c) {
    return mod(p,c)-0.5*c;
}

float opU( float d1, float d2 ) {
    return min(d1,d2);
}

float sdBox( vec3 p, vec3 b ) {
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float map(vec3 p) {
    float res = sdBox(opRep(p, vec3(11.0, 0.0, 11.0)), vec3(3.0, 8.0, 2.5));
    res = opU(res, sdBox(opRep(p + vec3(0.0, -4.0, 5.0), vec3(0.0, 0.0, 10.0)), vec3(1.0, 0.3, 5.0)));
	return res;
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    uv *= 2.5;
    uv *= 0.1 + sin(time * 0.12) * 0.05;
	uv = rotate(uv, sin(time * 0.15) * 1.0);
    
    vec2 st = gl_FragCoord.xy / resolution;
    
    vec2 rayuv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    
    //star
    float m = 0.;
    for (float i = 0.; i < 1.0 ; i += 0.25) {
    	float depth = fract(i + time * 0.1);
        m += layer(uv * mix(10., 0.5, depth) + i * 20.) * smoothstep(0., 0.5, depth) * smoothstep(1., 0.7, depth);
    }
    m *= 1.0-fract(time*0.15);
    m *= 2.0;
    
    vec3 hsv = hsv2rgb(0.65,0.7,1.0);
    vec3 star = m * hsv;
    
    //Ray
    vec3 camPos = vec3(0.0,4.8,1.0-time);
    vec3 camDir = normalize(vec3(0.0, 0.0, -1.0));
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float fov = 1.8;

    vec3 dir = normalize(camSide*rayuv.x + camUp*rayuv.y + camDir*fov);	    
    vec3 ray = camPos;
    int march = 0;
    float d = 0.0;
    float rLen = 0.0;

    float total_d = 0.0;
    const int MAX_MARCH = 128;
    const float MAX_DIST = 100.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        march = i;
        total_d += d;
        if(d<0.001) {
            break;
        }
        if(total_d>MAX_DIST) {
            total_d = MAX_DIST;
            march = MAX_MARCH-1;
            break;
        }
    
        rLen += min(min(min((step(0.0,dir.x)-fract(ray.x))/dir.x,
                            (step(0.0,dir.y)-fract(ray.y))/dir.y)+0.01,
                        (step(0.0,dir.z)-fract(ray.z))/dir.z)+0.01, d);

        ray = camPos + dir * rLen;
    }
	
    float fog = min(1.0, (1.0 / float(MAX_MARCH)) * float(march));
    vec3  fog2 = vec3(1.0, 1.0, 1.0) * total_d * 0.002;
    vec3 raycol = vec3(0.1, 0.1, 0.3)*fog + fog2*0.5;

    //composite
    float cloud = clouds(st)*0.6;
    raycol += star;
    raycol *= cloud;
   
    //vignette
    st *=  1.0 - st.yx;
    float vig = st.x*st.y * 30.0;
    vig = pow(vig, 2.5);
    raycol *= vig;

    gl_FragColor = vec4(raycol, 1.0);
}