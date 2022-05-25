attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する

uniform mat4 transform;

void main() {
  vec4 aPosition4 = transform * position;
  aPosition4 /= aPosition4.w;
  
//  gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
  gl_Position = aPosition4;
}
