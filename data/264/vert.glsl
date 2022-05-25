attribute vec4 texCoord;
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する

uniform mat4 transform;

// Varying values passed to our fragment shader
varying vec2 vTexCoord;

void main() {
	vTexCoord = texCoord.xy;

	vec4 positionVec4 = transform * position;
	// processing javaのpositionからp5.jsのaPositionへの
	// マッピングがいまいちわかってにゃい
	// ((transform * potition) + 1.0) / 2.0 ⇒ aPosition？？？
//	positionVec4.xy=positionVec4.xy*2.-1.;
	positionVec4.xy=positionVec4.xy;
	gl_Position=positionVec4;
}
