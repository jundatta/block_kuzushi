uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform sampler2D iChannel0;

//// [2TC 15] Mystery Mountains.
// David Hoskins.

// Add texture layers of differing frequencies and magnitudes...
#define F +texture(iChannel0,.3+p.xz*s/3e3)/(s+=s) 

void mainImage( out vec4 c, vec2 w )
{
    vec4 p=vec4(w/iResolution.xy,1,1)-.5,d=p,t;
    p.z += iTime*20.;d.y-=.4;
    
    for(float i=1.5;i>0.;i-=.002)
    {
        float s=.5;
        t = F F F F F F;
        c =1.+d.x-t*i; c.z-=.1;
        if(t.x>p.y*.007+1.3)break;
        p += d;
    }
    c = vec4(c.xyz, 1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
