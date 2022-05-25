precision mediump float;

varying vec2 vTexCoord;
uniform vec3 uColor;

void main() {
  vec2 uv = vTexCoord;
  float d = 0.02 / length(uv - vec2(0.5));
  d = pow(d, 2.5);
  gl_FragColor = vec4(uColor, d);
//  gl_FragColor = vec4(uColor * d, 1.0);
}