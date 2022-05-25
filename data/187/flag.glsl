precision highp float;
varying vec2 vTexCoord;
uniform float WIDTH;
uniform float HEIGHT;
//uniform vec3 balls[50];
uniform float balls[50 * 3];

void main() {
	float x=vTexCoord.x*WIDTH;
	float y=HEIGHT-vTexCoord.y*HEIGHT;
	float r=0.;
 	for (int i=0; i<50; i++) {
//		vec3 b=balls[i];
		vec3 b = vec3(balls[i*3+0], balls[i*3+1], balls[i*3+2]);
		r+=b.z*b.z/((b.x-x)*(b.x-x)+(b.y-y)*(b.y-y));
	}
	//r=pow(r,3./4.);
	float g=(r-.5)*2.;
	float b=(r-5./6.)*6.;
	gl_FragColor = vec4(r, g, b, 1.);
}
