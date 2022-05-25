precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

#define TAU 6.28318530718
#define Octaves 4
#define PI2 6.28318530718

const float PI = 3.1415926535897932384626433832795;

float opUnion(float d1, float d2) { return min(d1, d2); }
float opIntersection(float d1, float d2) { return max(d1, d2); }
float opSubtraction(float d1, float d2) { return max(d1, -d2); }
float opOnion(float d, float thikness) { return abs(d) - thikness; }

float noise(vec2 pixuv, float t, vec2 p){
    vec2 p2 = mod(pixuv*TAU, TAU)-250.0;
	vec2 s = vec2(p2);
	float c = 1.0;
	float inten = 0.005;
    
    for (int n = 0; n < Octaves; n++) 
	    {
		    float ti = t * (1.0 - (3.0 / float(n+1)));
		    s = p + vec2(cos(ti - s.x) + sin(ti + s.y), sin(ti - s.y) + cos(ti + s.x));
		    c += 1.0/length(vec2(p2.x / (sin(s.x+t)/inten),p2.y / (cos(s.y+t)/inten)));
	    }
	    c /= float(Octaves);
	    c = 1.17-pow(c, 1.4);
    return c;
}

float moon(vec2 st){
    float s = smoothstep(1.21, 1.2, length(st-vec2(0.15, .15)));
    s *= smoothstep(.80, .81, length(st-vec2(.40, 0.75)));
    return s;
}

float sdCircle(vec2 p, float r)
{
    return length(p) - r;
}

float sdRect(vec2 p, vec2 r)
{
    vec2 d = abs(p) - r;
    return length(max(d, 0.0))
        + min(max(d.x, d.y), 0.0);
}

float sdHook(vec2 p, float s)
{
    float base = opUnion(sdCircle(p, s * 0.7), sdRect(p - vec2(0, -1.5) * s, vec2(0.3, 1.0) * s));
    float hookCircle = opOnion(sdCircle(p - vec2(0, -3.3) * s, s), 0.25 * s);
    float mask = sdRect(p - vec2(-1.2, -3) * s, vec2(1, 1.1) * s);
    float hook = opSubtraction(hookCircle, mask);
    return opUnion(base, hook);
}

float sdline(vec2 p)
{
    float line = sdRect(p - vec2(0.13, 0.1), vec2(0.002, 0.55));
    
    return line;
}

float rand(int seed, float ray) {
	return mod(sin(float(seed)*363.5346+ray*674.2454)*6743.4365, 1.0);
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);    
    uv.x += 0.0035 * cos(uv.y * 100.0 + time * PI2);
    uv.x += 0.0015 * cos(uv.y * 250.0 + time * PI2);
    
    vec2 uvn = gl_FragCoord.xy/resolution.y;
    
    vec2 uv2 = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
	uv2.x *=  resolution.x / resolution.y;
    
    vec2 p = gl_FragCoord.xy / resolution.xy-0.5;
	p.x *= resolution.x/resolution.y;
	p*= 10.0;
    vec2 pixuv = vec2((gl_FragCoord.xy / resolution.xy-0.5).x * 1.0, (gl_FragCoord.xy / resolution.xy-0.5).y * 1.0);
    
    float n = noise(pixuv, time * 0.25, p);
    vec3 back = vec3(n) * vec3(0.0,0.3,1.0);
    back = pow(back,vec3(1.0,0.8,0.85));
    back *= 2.0;

    // bubbles by inigo quilez https://www.shadertoy.com/view/4dl3zn
    vec3 bcol = vec3(0.0);
	for( int i=0; i<64; i++ )
	{
		float pha =      sin(float(i)*546.13+1.0)*0.5 + 0.5;
		float siz = pow( sin(float(i)*651.74+5.0)*0.5 + 0.5, 4.0 );
		float pox =      sin(float(i)*321.55+4.1) * resolution.x / resolution.y;

		float rad = 0.025 + 0.025*siz+sin(time/6.+pha*500.0+siz)/30.0;
		vec2  pos = vec2( pox+sin(time/10.+pha+siz), -1.0-rad + (2.0+2.0*rad)
						 *mod(pha+0.1*(time/5.0)*(0.2+0.8*siz),1.0));
		float dis = length( uv2 - pos );
		vec3  col = mix( vec3(0.15,0.15,0.25*sin(time/6.0)), 
						vec3(0.25,0.4,0.85*sin(time/9.0)), 
						0.5+0.5*sin(float(i)*1.2+1.9));
        
		float f = length(uv2-pos)/rad;
		f = sqrt(clamp(1.0+(sin((time/7.0)+pha*500.0+siz)*0.5)-f*f,0.0,1.0));
		bcol += col.zyx *(1.0-smoothstep( rad*0.85, rad, dis )) * f;
	}

    vec3 col = vec3(0.0, .35 + uv.y * .55, .95 + uv.y * .25);
    
    vec3 moon = vec3(moon(uv+vec2(0.1,0.6)));
    moon *= back;
    
    col += moon;
    col += bcol;
    
    vec2 lPos = vec2(1.2,0.6);
    
    if (sdline(uvn - lPos) < 0.0)
    {
        col = vec3(1.0);
    }
    
    if (sdHook(uvn - lPos - vec2(0.13, -0.45), 0.01) < 0.0)
    {
        col = vec3(0.1);
    }
    
    vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.1, 1.5);
	position.y *= resolution.y/resolution.x;
	float ang = atan(position.y, position.x);
	float dist = length(position);
	vec3 Light = vec3(0.15, 0.5, 0.8) * (pow(dist, -1.0) * 0.2) + dist * vec3(0.02, 0.1, 0.35);
	for (float ray = 0.0; ray < 100.0; ray += 1.0) {
		float rayang = rand(5234, ray)*10.0+time*0.15*(rand(2500, ray)-rand(4000, ray));
		rayang = mod(rayang, PI*2.0) + PI * 0.5;
		if (rayang < ang - PI) {rayang += PI*2.0;}
		if (rayang > ang + PI) {rayang -= PI*2.0;}
		float brite = .20 - abs(ang - rayang);
		brite -= dist * 0.05;
		if (brite > 0.0) {
			Light += vec3(0.0, 0.25+0.4*rand(4567, ray), 0.25+0.4*rand(5000, ray)) * brite;
		}
	}
    
    col *= Light;
    
    col *= uvn.y * 1.5;
    
    gl_FragColor = vec4(col, 1.0);
}