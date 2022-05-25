uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iMouse;
uniform int iFrame;


vec3 neon(float val, vec3 color) {
	float r = clamp(val, 0.0, 1.0);
    float r2 = r * r;
    float r4 = r2 * r2;
    float r16 = r4 * r4;
    vec3 c = color;
    vec3 c2 = pow(color, vec3(4.0)); // A darker, more saturated version of color
    
	vec3 outp = vec3(0.0);
	outp += c2 * r2; // Darker color falloff
	outp += c * r4; // Specified Color main part
	outp += vec3(1.0) * r16; // White core
	return outp;
}

const float octaves = 15.0;


// This hash function taken from https://www.shadertoy.com/view/4djSRW
vec4 hash44(vec4 p4)
{
	p4 = fract(p4  * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy+33.33);
    return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}



vec4 noiseElement(vec2 coord, vec2 delta, float seed, float octave) {
    vec4 noise = hash44(vec4(coord, octave, seed));
    float midpoint = max(noise.a - length(delta) * noise.a, 0.0);
    
    vec3 color = noise.rgb;
    float brightness = (cos(-octave * 0.5 + iTime * 3.0) + 1.0) * 0.3 + 0.7;
    return vec4(neon(midpoint * brightness * 1.2, color), 1.0);
}






void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float seed = 1.0;//round(iTime * 0.5);
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv.x *= iResolution.x / iResolution.y;
    
    
    vec4 noise_out = vec4(0);
    for (float octave=1.0; octave<octaves; octave+=1.0) {
    
        float angle = cos(iTime) * 0.2;
        float displacement = (iTime + sin(iTime)* 0.5) * 1.0 / octave;
        vec2 nuv = mat2(cos(angle), sin(angle), -sin(angle), cos(angle)) * uv;
        nuv += displacement;
        nuv *= float(octave);
        
        vec2 coord = round(nuv);
        vec2 delta = (nuv - coord) * 2.0;
        
        
        vec4 new = noiseElement(coord, delta, seed, octave);
        
        
        noise_out = noise_out + new / (octave * 0.5 + 1.0);
    }
    


    // Output to screen
    fragColor = noise_out;
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
