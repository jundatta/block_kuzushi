//attribute vec3 aPosition;		// p5.js
//attribute vec4 aVertexColor;	// p5.js
attribute vec4 position;
attribute vec4 color;

//uniform mat4 uModelViewMatrix;	// p5.js
//uniform mat4 uProjectionMatrix;	// p5.js

uniform mat4 uViewMatrix;			// p5.js
uniform mat4 modelviewMatrix;
uniform mat4 projectionMatrix;

uniform mat4 uModelMatrix;

varying vec2 vTexCoord;

uniform mat4 transform;

void main(void) {
//  vec4 position = vec4(aPosition, 1.0);
  gl_Position = projectionMatrix * modelviewMatrix * position;

//  vec4 texPosition = uProjectionMatrix * uViewMatrix * uModelMatrix * position;
  vec4 texPosition = projectionMatrix * uViewMatrix * uModelMatrix * position;
  vTexCoord = texPosition.xy / texPosition.w * vec2(0.5, -0.5) + 0.5;    // ? : zで割るのかwで割るのか
}
