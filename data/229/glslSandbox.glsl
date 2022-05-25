// extra changes by aidene

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

     vec3 normalized_dot = normalize(vec3((gl_FragCoord.xy - resolution.xy * .5) / resolution.x, .5));
    vec3 sized=vec3(0);
    vec3 c=vec3(0);
    vec3 fracted_normalized_dot=vec3(0);
    vec3 outp=normalized_dot;
    vec3 camera=vec3(0); 
    vec3 y=vec3(1.0,3.0,0.0);
    camera.y = 1.2*cos((camera.x=0.3)*(camera.z=time * 5.0));
    camera.x -= sin(time) + 3.0;

    for( float i=.0; i<11.; i+=.05 ) {
        fracted_normalized_dot = fract(c = camera += normalized_dot*i*.05); 
    sized = floor( c )*.4;
        if( cos(sized.z) + sin(sized.x) > ++sized.y ) {
            outp = (fracted_normalized_dot.y-.04*cos((c.x+c.z)*10.)>.7?y:fracted_normalized_dot.x*y.yxz) / i;
            break;
        }
    }
    gl_FragColor = vec4(outp,1.1);


}