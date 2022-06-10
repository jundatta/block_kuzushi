precision highp float;
//attribute vec3 aPosition;
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する
//attribute vec2 aTexCoord;
attribute vec4 texCoord;
varying vec2 vTexCoord;

uniform mat4 transform;

void main() {
//	vTexCoord = aTexCoord;
	vTexCoord = texCoord.xy;
//	vec4 positionVec4=vec4(aPosition, 1.);
	vec4 positionVec4 = transform * position;
	positionVec4.xy=positionVec4.xy*2.-1.;
	gl_Position = positionVec4;
}
