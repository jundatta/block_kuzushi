// (https://glslfan.com/)
precision highp float;
uniform float time;
void main(){
	// vec3 q,p=(gl_FragCoord.xyz)/1e3-.5;
	vec3 q=vec3(0.0,0.0,0.0);
	vec3 p=(gl_FragCoord.xyz)/1e3-0.5;
	for(int i=0;i<9;++i) {
		float a = time*0.1;
		p.xz=mat2(cos(a),sin(a),-sin(a),cos(a))*p.xz;
		p=abs(p)/dot(p,p)*0.7-0.7;
		p.xz=p.zx;
		q=q+exp(-dot(p,p)*32.0);
	}
	gl_FragColor=vec4(q*abs(p),1.0);
}
