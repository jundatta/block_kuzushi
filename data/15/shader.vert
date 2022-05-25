
uniform mat4 transform;

attribute vec4 position;
attribute vec4 color;
attribute vec4 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * position;
  vertColor = color;
  vertTexCoord = texCoord;
}