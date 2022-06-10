precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

float sphere( vec3 p, float s )
{
  return length(p)-s;
}

float box( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

vec3 hash3( vec3 p ){
	//vec3 q = vec3( dot(p,vec3(127.1,311.7, 114.5)), dot(p,vec3(269.5,183.3, 191,9)), dot(p,vec3(419.2,371.9, 514.1)));
    vec3 q = vec3(dot(p,vec3(127.1,311.7, 114.5)), dot(p,vec3(269.5,183.3, 191.9)), dot(p,vec3(419.2,371.9, 514.1)));
	return fract(sin(q)*43758.5453);
}

float pingPong(float t, float len, float smth)
{
    float tt = mod(t, len);
    tt = min(1.0, tt * smth);
    float cond = step(mod(t, len*2.0), len);
    return mix(1.0 - tt, tt, cond);
}

float map(vec3 p)
{
    float pl = sdPlane(p, vec4(0.0, 1.0, 0.0, 4.0));
    vec2 cell2 = floor(p.xz * 6.0);
    pl += hash(cell2) * 1.5;
    
    vec2 cell = floor(p.xz / 18.0);
    
    p.xz = mod(p.xz, 18.0) - 9.0;
    vec3 hh = hash3(vec3(cell, 0.0));
 	float t = -time * 8.0 * (hh.y + 0.2) + hh.x * 15.0;
    vec3 h = hash3(floor(p * 2.0) / 2.0) * 2.0 - 1.0;
    h = sign(h) * h * h * h * h;

    float sw = pingPong(t + p.y, 8.0, 1.0);
    float ss = mod(t + p.y, 8.0);
    ss = 1.0 - smoothstep(0.0, 4.0, ss);
    
    p = p + h * 4.0 * ss;
    
    float s = sphere(p - vec3(0.0, 0.0, 0.0), 5.0 + hh.x * 2.0);
    float b = box(p + vec3(0.0, 0.0, 0.0), vec3(4.0 + hh.x * 2.0));
    
    float hhh = hash(cell);
    
    if (step(0.35, hhh) < 0.5) {
    	 return min(pl, mix(s, b, sw));
    } else {
    	return pl;
    }

    return min(pl, mix(s, b, sw));
}

vec2 intersect(vec3 ro, vec3 ray)
{
    float t = 0.0;
    for (int i = 0; i < 300; i++) {
        float res = map(ro+ray*t);
        if( res < 0.01 ) return vec2(t, res);
        t += res * 0.25;
		//if( t>9.0 ) break;
    }

    return vec2(-9999.0);
}

vec3 normal(vec3 pos, float e )
{
    vec3 eps = vec3(e,0.0,0.0);

	return normalize( vec3(
           map(pos+eps.xyy) - map(pos-eps.xyy),
           map(pos+eps.yxy) - map(pos-eps.yxy),
           map(pos+eps.yyx) - map(pos-eps.yyx) ) );
}

mat3 createCamera(vec3 ro, vec3 ta, float cr )
{
	vec3 cw = normalize(ta - ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

float softshadow( in vec3 ro, in vec3 rd, in float mint, in float maxt, in float k)
{
    float res = 1.0;
    float t = mint;
    for( int i=0; i<128; i++ )
    {
        float h = map( ro + rd*t);
        res = min( res, k*h/t );
        t += clamp( h, 0.05, 0.2 );
        if( res<0.01 || t>maxt ) break;
    }
    return clamp( res, 0.0, 1.0 );
}

float calcAo(in vec3 p, in vec3 n){
    float k = 1.0, occ = 0.0;
    for(int i = 0; i < 5; i++){
        float len = 0.15 + float(i) * 0.15;
        float distance = map(n * len + p);
        occ += (len - distance) * k;
        k *= 0.5;
    }
    return clamp(0.0, 1.0, 1.0 - occ);
}

void mainImage( out vec4 fragColor, in vec2 p )
{
    // fragment position
    //vec2 p = (fragCoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);

    // camera
    vec3 ro = vec3(20.0 * sin(time * 0.15), 5.0 + sin(time * 0.075) * 2.0, 20.0 * cos(time * 0.15)) * 2.0;
    vec3 ta = vec3(0.0);
    mat3 cm = createCamera(ro, ta, sin(time * 2.0) * 0.025);
    vec3 ray = cm * normalize(vec3(p, 2.0));
    
    // marching loop
    vec2 res = intersect(ro, ray);
    
    // hit check
    if(res.y > -9990.5) {
        vec3 pos = ro + ray * res.x;
        vec3 nor = normal(pos, 0.0001);
        vec3 ldir = normalize(vec3(1.0, 1.0, 1.0));
        float sha = softshadow(pos, ldir, 0.1, 500.0, 3.5);
        float ao = calcAo(pos, nor);
        vec3 light = (nor * 0.5 + 0.5) * ((sha + 0.1) / 1.1) * ao;
        fragColor = vec4(pow(vec3(light), vec3(1.0 / 2.2)) + res.x * vec3(0.0015, 0.002, 0.001), 1.0);
    }else{
        fragColor = vec4(vec3(0.9, 1.0, 0.8), 1.0);
    }
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

    vec4 col;
    mainImage(col, uv);
    
    gl_FragColor = col;
}
