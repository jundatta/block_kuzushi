//attribute vec3 aPosition;
attribute vec4 position;

//uniform mat4 uModelViewMatrix;
//uniform mat4 uProjectionMatrix;
uniform mat4 modelviewMatrix;
uniform mat4 projectionMatrix;

uniform mat4 transform;

void main(void) {
  vec4 aPosition4 = transform * position;
  aPosition4 /= aPosition4.w;
  vec3 aPosition = aPosition4.xyz;

  vec4 positionVec4 = vec4(aPosition, 1.0);
//  gl_Position = projectionMatrix * modelviewMatrix * positionVec4;
  gl_Position = positionVec4;
}
