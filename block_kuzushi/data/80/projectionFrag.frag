precision highp float;

uniform sampler2D uTexture;

varying vec2 vTexCoord;

void main(void) {
  if (min(vTexCoord.x, vTexCoord.y) > 0.0 && max(vTexCoord.x, vTexCoord.y) < 1.0) {
    gl_FragColor = texture2D(uTexture, vTexCoord);
  } else {
//    gl_FragColor = uMaterialColor;
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);	// 原作者様の想定から外れると赤がでる感じですにゃ
  }
}
