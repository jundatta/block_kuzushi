precision highp float;
precision highp int;

// vvv 移植用に追加した vvv
uniform mat4 transform;
attribute vec4 position;
attribute vec4 texCoord;
// ^^^ 移植用に追加した ^^^

// attribute vec3 aPosition;
// attribute vec2 aTexCoord;

varying vec2 vTexCoord;

// uniform mat4 uProjectionMatrix;
// uniform mat4 uModelViewMatrix;

void main() {
//  vec4 positionVec4 = vec4(aPosition, 1.0);
//  vTexCoord = aTexCoord;
//  gl_Position = uProjectionMatrix * uModelViewMatrix * positionVec4;

  vTexCoord = vec2(texCoord.x, texCoord.y);
  gl_Position = transform * position;
}
