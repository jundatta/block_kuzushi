//attribute vec3 aPosition;
//attribute vec2 aTexCoord;
//attribute vec3 aNormal;
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する
attribute vec4 texCoord;

//uniform mat4 uProjectionMatrix;
//uniform mat4 uModelViewMatrix;
uniform mat4 transform;

varying vec2 vTexCoord;

void main() {
  vTexCoord = texCoord.xy;
  gl_Position = transform * position;
}