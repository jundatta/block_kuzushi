uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iMouse;
uniform int iFrame;





// Origin: https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
// Using this since it was easy to differentiate, same technique would work for any curve 
vec3 s_curve(vec3 x)
{
    float a = 2.51f;
    float b = 0.03f;
    float c = 2.43f;
    float d = 0.59f;
    float e = 0.14f;
    x = max(x, 0.0);
    return clamp((x*(a*x+b))/(x*(c*x+d)+e),0.0,1.0);
}

// derivative of s-curve
vec3 d_s_curve(vec3 x)
{
    float a = 2.51f;
    float b = 0.03f;
    float c = 2.43f;
    float d = 0.59f;
    float e = 0.14f;
    
    x = max(x, 0.0);
    vec3 r = (x*(c*x + d) + e);
    return (a*x*(d*x + 2.0*e) + b*(e - c*x*x))/(r*r);
}

vec3 tonemap_per_channel(vec3 c)
{
    return s_curve(c);
}

vec3 tonemap_hue_preserving(vec3 c)
{
    mat3 toLms = mat3(
        0.4122214708, 0.5363325363, 0.0514459929,
        0.2119034982, 0.6806995451, 0.1073969566,
        0.0883024619, 0.2817188376, 0.6299787005);
        

     mat3 fromLms = mat3(
        +4.0767416621f , -3.3077115913, +0.2309699292,
        -1.2684380046f , +2.6097574011, -0.3413193965,
        -0.0041960863f , -0.7034186147, +1.7076147010);
        
    vec3 lms_ = c*toLms;
    vec3 lms = sign(lms_)*pow(abs(lms_), vec3(1.0/3.0));
    
    float maxLms = max(lms.r,max(lms.g,lms.b));
    
    vec3 lmsNormalized = lms/maxLms;

    maxLms = maxLms*maxLms*maxLms;
    
    float maxLmsPost = s_curve(vec3(maxLms)).x;
    
    lmsNormalized = 1.0f + (maxLms*lmsNormalized - maxLms)*d_s_curve(vec3(maxLms))/maxLmsPost; 
    
    maxLms = pow(maxLmsPost, 1.0/3.0);
    
    lms = lmsNormalized*maxLms;
 
    vec3 rgb = lms*lms*lms*fromLms;

    return rgb;
}


vec3 softClip(vec3 x)
{
    float a = 0.04;
    return 0.5*(1.0+sqrt(x*x+a*a)-sqrt((x-1.0)*(x-1.0) + a*a));
}

float softClipInv(float x)
{
    float a = 0.04;
    return 0.5 + (x - 0.5)*sqrt(x*(x - 1.0)*(x*x - x - a*a))/(x-x*x);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2.0*(fragCoord-0.5*iResolution.xy)/min(iResolution.x, iResolution.y);
// 0クリアした
    vec3 color = vec3(0.0,0.0,0.0);
    
    const int N = 8;
    
    float time = 0.125*iTime;
    
    for (int i = 0; i <= N; i++)
    {
        for (int j = 0; j <= i; j++)
        {
            float fi = float(i)/float(N);
            float fj = float(j)/float(N);
        
            float x = 1.5*(fi-0.5*fj-0.5);
            float y = 1.5*sqrt(3.0)/2.0*(fj-0.5);            
            vec2 xyd = vec2(x,y)-uv;
            
            float d = min(0.001/dot(xyd,xyd),1.0);
            
            vec3 c = vec3(fi-fj, fj, 1.0-fi);
            
            mat3 rec2020toSrgb = mat3(
                1.6603034854, -0.5875701425, -0.0728900602,
                -0.1243755953,  1.1328344814, -0.0083597372,
                -0.0181122800, -0.1005836085,  1.1187703262);
            
            mat3 displayP3toSrgb = mat3(
                1.2248021163, -0.2249112615, -0.0000475721,
                -0.0419281049,  1.0420298967, -0.0000026429,
                -0.0196088092, -0.0786321233,  1.0983153702);
            
            // uncomment for a triangle in other color spaces
            // (output will still be sRGB)
            //c = c*displayP3toSrgb;
            //c = c*rec2020toSrgb;
            
            color += pow(2.0,-3.0*cos(2.0*3.14159*time))*d*c;
        }
    }
    
    color = tonemap_hue_preserving(color);
    
    //color = tonemap_per_channel(color);
    
    // simple soft clip of rgb values to remove some artifacts of hard clipping
    // does cause some excessive desaturation of dark colors which isn't great
    color = softClip(color);
    float x = dot(color, vec3(1.0/3.0));
    color = (color - x) + softClipInv(x);
    
    
    /*
    // uncomment to highlight colors that clip
    
    float diff = length(color - clamp(color, 0., 1.));
    
    if(diff != 0.)
        color = vec3(0.5,0.5,0.5);    
    */
    
    // Output to screen
    fragColor = vec4(pow(color,vec3(1.0/2.2)),1.0);
}


void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
