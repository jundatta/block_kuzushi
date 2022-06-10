uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iMouse;
uniform int iFrame;

// ====== V3.0 ======

vec2 rotate(vec2 c, float a) {
  return vec2(c.x*cos(a)-c.y*sin(a),c.x*sin(a)+c.y*cos(a));
}

bool firework(vec2 xy, float time){
    float t=time;
    float r=length(xy);
    float rad=atan(xy.y,xy.x);
    float deg=degrees(rad);
    xy=rotate(xy,deg);
    r=length(xy);
    rad=atan(xy.y,xy.x);
    deg=degrees(rad);
    float X=xy.x+sin(deg+t)*(deg+mod(t,100.0));
    float Y=xy.y+cos(deg+t)*(deg+mod(t,100.0));
    return (sqrt(X*X+Y*Y)<30.0&&r<150.0*(sin(t)));
}

void mainImage( out vec4 rgba, in vec2 xy ){
    
    // fireworks
//    rgba=vec4(0.0);
    rgba=vec4(0.0,0.0,0.0,1.0);
    if(xy.y>55.0){
        float time=mod(iTime,3.1415);
        if(firework(xy-iResolution.xy/vec2(1.75,3.0),time-0.25))
            rgba+=vec4(0,1,0,1.0)*(sin((time-0.25)*2.0));//green
        if(firework(xy-iResolution.xy/vec2(2.0,1.7),time-0.5))
            rgba+=vec4(1,1,0,1.0)*(sin((time-0.5)*2.0));//yellow
        if(firework(xy-iResolution.xy/vec2(2.25,3.5),time-0.75))
            rgba+=vec4(1,0,1,1.0)*(sin((time-0.75)*2.0));//violet
        if(firework(xy-iResolution.xy/vec2(3.0,3.0),time-1.0))
            rgba+=vec4(1,0,0,1.0)*(sin((time-1.25)*2.0));//red
        if(firework(xy-iResolution.xy/vec2(2.5,1.7),time-1.25))
            rgba+=vec4(0,1,0.75,1.0)*(sin((time-1.25)*2.0));//turquoise
        if(firework(xy-iResolution.xy/vec2(1.5,2.0),time-1.5))
            rgba+=vec4(0,0.75,1,1.0)*(sin((time-1.5)*2.0));//blue
    } rgba=clamp(rgba,0.0,1.0);
    
    // fractal city
    float line=120.0;
    vec2 oxy=vec2(xy.y,xy.x);
    oxy=iResolution.y*2.5-oxy;
    if(iResolution.y>1000.0) {
        // fullscreen fix
        xy/=2.0;oxy=vec2(xy.y,xy.x);
        oxy=iResolution.y*2.5-oxy;
        oxy/=2.0;oxy.x-=135.0;
        oxy.x+=1000.0;line*=2.0;
        if(iResolution.y>2000.0)
            oxy.x+=212.0;
    }if(xy.y<line){
        // others resolutions
        oxy.y+=400.0;oxy-=130.0/2.0;
        if(iResolution.y==281.0)oxy-=82.0;
        if(iResolution.y==236.0)oxy+=30.0;
        if(iResolution.y==288.0)oxy+=40.0;
        if(iResolution.y==360.0)oxy-=2.0;
        if(iResolution.y==773.0)oxy+=78.0;
        oxy*=49.91/2.50;//zoom
        // fractal city lines 
        rgba+=vec4((int(oxy.x)&int(oxy.y))
        >>(int(mod(floor(oxy.x),5.)*4.0))
        +(4-int(mod(floor(oxy.y),5.)))&1);
    }
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
