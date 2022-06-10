  // geometry vertex position provided by p5js.
  attribute vec3 aPosition;
// vertex texture coordinate provided by p5js.
//attribute vec2 aTexCoord;
attribute vec4 texCoord;
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する

// Built in p5.js uniforms
//uniform mat4 uModelViewMatrix;
//uniform mat4 uProjectionMatrix;
// [processing java]
//uniform mat4 modelviewMatrix;
//uniform mat4 projectionMatrix;

uniform mat4 transform;

// Varying values passed to our fragment shader
varying vec2 vTexCoord;
varying vec3 vVertexPos;

void main() {
//  vTexCoord = aTexCoord;
	vTexCoord = texCoord.xy;

  vec4 aPosition4 = transform * position;
  aPosition4 /= aPosition4.w;
  vec3 aPosition = aPosition4.xyz;
  vVertexPos = aPosition;
  
//  vec4 pos = aPosition4;

  // Apply the ModelView and Projection matricies
//  gl_Position = uProjectionMatrix * uModelViewMatrix * pos;
  gl_Position = aPosition4;
}
