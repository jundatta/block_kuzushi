//The idea and technique is based on the "buildings + train"　https://www.shadertoy.com/view/MdlfRj

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define PI2 6.28318530718

#define C(x) clamp(x, 0., 1.)
#define S(a, b, x) smoothstep(a, b, x)
#define F(x, f) (floor(x * f) / f)
#define round(x, f) (floor((x)/(f) + 0.5) * (f))

float posT = 256.0/15.0;
float ptime = (floor(mod(time*1.0, 7200.0) * posT) / posT);

float random(float p)
{
    return fract(52.043*sin(p*205.429));
}
float random2(float p)
{
    return random(p)*2.0-1.0;
}

vec3 star(vec2 uv, float gtime, float delay)
{
    float seed = round(gtime, delay);
    
    float startTime = (delay - 1.5) * random(seed);
    float time = max(0.0, min(1.0, gtime-seed - startTime));
    
    vec2 start = vec2(
        random2(seed),
        0.7 + 0.3 * random(seed+0.1)
    );
    
    vec2 end = start * 0.2;
    
    uv = uv - mix(start, end, time);
    
    end = normalize(end - start);
    uv = uv * mat2(end.x, end.y, -end.y, end.x);
    uv.x *= 0.1;
    
    float alpha = 12.0 * pow(time, 2.0) * pow(time - 1.0, 2.0);
    return vec3(max(0.0, alpha - resolution.y * length(uv)));
}

vec3 starfall(vec2 uv)
{
    return
        star(uv, time, 6.85) +
        star(uv, time + 18.3, 8.63) +
        star(uv, time + 84.0, 10.8);
}

vec3  posterize(vec3 color, float power){
    float div= 256.0 / power;
    vec3 pos = ( floor( color * div ) / div );
    return pos;
    }

vec3 city(vec2 pos){
	vec3 col = vec3(0.0);
    
    float roof = 0.15;
    float bx = pos.x * 20.0;
    float x = 0.05 * floor(bx - 4.0);
    bx = mod(bx,1.0);
  
    roof += 0.04 * cos(x * 20.0);
	roof += 0.06 * cos(x * 23.0);
	roof += 0.02 * cos(x * 720.0 );
	roof += 0.02 * cos(x * 1200.0 );
	
    roof += 0.06;
    
    if(pos.y < roof && pos.y > 0.0 && bx > 0.1 * cos(20.0 * pos.x)){
    	col.b += 0.2;
        
        float window = abs(sin(200.0 * pos.y));
        window *= abs(sin(10.0 * bx));
        
        if(mod(2023.0 * x,2.0) < 0.5){
          	window = floor(1.15 * window);
        	col.rgb += 1.5 * window * vec3(0.9,0.9,0.9);
        }

        else if(mod(2983.0 * x,2.0) < 0.85){
        	col.rb += window;
        }
        else {
            if(window > 0.7){
            	col.rg += 0.8;
           	}
        }
    }

    return col;
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float s = 180.0;
    uv = floor(uv * s) / s;
    
    uv.y += .15;
        
    float reflection = 0.;
    
    if (uv.y < 0.)
    {
        reflection = 1.0;
        uv.x += 0.004 * cos(uv.y * 100.0 + ptime * PI2);
        uv.x += 0.0025 * cos(uv.y * 450.0 + ptime * PI2);
        uv.x += 0.0015 * cos(uv.y * 4000.0 + ptime * PI2);
    }
    vec2 st = vec2(uv.x, abs(uv.y));
    
    float mountain = sin(1.69 * st.x * 1.3 * cos(2.7 * st.x) + 4.87 * sin(1.17 * st.x)) * .1 - .18 + st.y;
    mountain = C(S(-.005, .005, mountain));
    
    vec3 city = city(st);
    
    float moon = smoothstep(.3, .27, length(st-vec2(0.8, .90)));
    moon *= smoothstep(.3, .45, length(st-vec2(.65, 1.0)));
    
    vec3 star = vec3(max(80.* fract(dot(sin(gl_FragCoord),gl_FragCoord))-89.5, 0.0));
    star += vec3(max(75.* fract(dot(cos(gl_FragCoord),gl_FragCoord))-74.4, 0.0));
    float flicker = sin((st.x + ptime*0.1 + cos(st.y * 50. + ptime*0.1)) * 25.);
    flicker *= cos((st.y * .187 - (ptime*.1) * 4.16 + sin(st.x * 11.8 + (ptime*.1) * .347)) * 6.57);
    flicker = flicker * .5 + .5;
    star *= flicker;
    star *= 2.0;
    
    vec3 starfall = starfall(st);
	
    vec3 col = vec3(0.0, 0.0, 0.0);
    col += vec3(.5 - st.y * .5, .20 - st.y * .5, .15 + st.y * .08);
    col = posterize(col,8.0);
    
    col = col * mountain + vec3(.15 - st.y * .1, .1 - st.y * .1, .08) * (1. - mountain);
    
    col += city;
    
    col += starfall;

    col += star * mountain;
    
    col += posterize(moon * vec3(1.0, 1.0, 0.5),28.0)*(abs(sin(ptime*0.25))*1.0+0.5);
    
    col.r -= reflection * .1;
    col.gb += reflection * .05;

    gl_FragColor = vec4(col, 1.0);
}