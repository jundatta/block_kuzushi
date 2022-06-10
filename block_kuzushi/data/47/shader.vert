// shader.vert

uniform mat4 transform;

attribute vec4 position;

void main() {
  vec4 positionVec4 = transform * position;
  positionVec4.xy = positionVec4.xy * 20.0 - 1.0;
  gl_Position = positionVec4;
}