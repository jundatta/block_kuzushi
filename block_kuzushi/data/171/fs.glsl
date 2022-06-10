precision mediump float;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_count;
// 定数
const float pi = 3.14159;
const float TAU = atan(1.0) * 8.0;
const float eps = 0.00001;
const vec3 ex = vec3(1.0, 0.0, 0.0);
const vec3 ey = vec3(0.0, 1.0, 0.0);
const vec3 ez = vec3(0.0, 0.0, 1.0);
// 色
const vec3 black = vec3(0.2);
const vec3 red = vec3(0.95, 0.3, 0.35);
const vec3 orange = vec3(0.98, 0.49, 0.13);
const vec3 yellow = vec3(0.95, 0.98, 0.2);
const vec3 green = vec3(0.3, 0.9, 0.4);
const vec3 lightgreen = vec3(0.7, 0.9, 0.1);
const vec3 purple = vec3(0.6, 0.3, 0.98);
const vec3 blue = vec3(0.2, 0.25, 0.98);
const vec3 skyblue = vec3(0.1, 0.65, 0.9);
const vec3 white = vec3(1.0);
const vec3 aquamarine = vec3(0.47, 0.98, 0.78);
const vec3 turquoise = vec3(0.25, 0.88, 0.81);
const vec3 coral = vec3(1.0, 0.5, 0.31);
const vec3 limegreen = vec3(0.19, 0.87, 0.19);
const vec3 khaki = vec3(0.94, 0.90, 0.55);
const vec3 navy = vec3(0.0, 0.0, 0.5);
const vec3 silver = vec3(0.5);
const vec3 gold = vec3(0.85, 0.67, 0.14);
const vec3 bronze = vec3(0.8, 0.4, 0.3);
// ベクトル取得関数
vec2 fromAngle(float t){ return vec2(cos(t), sin(t)); }
// 正二面体群
// 基本領域の中心が0にくるように調整してある
vec2 dihedral_center(vec2 p, float n){
  float k = pi * 0.5 / n;
  vec2 e1 = vec2(sin(k), cos(k));
  vec2 e2 = vec2(sin(k), -cos(k));
  for(float i = 0.0; i < 99.0; i += 1.0){
    if(i == n){ break; }
    p -= 2.0 * min(dot(p, e1), 0.0) * e1;
    p -= 2.0 * min(dot(p, e2), 0.0) * e2;
  }
  return p;
}
// 基本領域のはじっこに0がくるやつ（0～pi/n）
vec2 dihedral_bound(vec2 p, float n){
  float k = pi / n;
  vec2 e1 = vec2(0.0, 1.0);
  vec2 e2 = vec2(sin(k), -cos(k));
  for(float i = 0.0; i < 99.0; i += 1.0){
    if(i == n){ break; }
    p -= 2.0 * min(dot(p, e1), 0.0) * e1;
    p -= 2.0 * min(dot(p, e2), 0.0) * e2;
  }
  return p;
}
// 円(中心c半径r)
float circle(vec2 p, vec2 c, float r){
  return length(p - c) - r;
}
// 長方形(中心c,横q.xで縦q.y)
float rect(vec2 p, vec2 c, vec2 q){
  return max(abs(p.x - c.x) - q.x * 0.5, abs(p.y - c.y) - q.y * 0.5);
}
// 正方形(中心c,横も縦もr)
float square(vec2 p, vec2 c, float r, float t){
  p = (p - c) * mat2(cos(t), -sin(t), sin(t), cos(t));
  return max(abs(p.x) - r * 0.5, abs(p.y) - r * 0.5);
}
// 三角形
float triangle(vec2 p, vec2 c, float r, float t){
  p -= c;
  p *= mat2(cos(t), -sin(t), sin(t), cos(t));
  vec2 e1 = vec2(0.0, 1.0);
  vec2 e2 = vec2(0.5 * sqrt(3.0), -0.5);
  for(int i = 0; i < 3; i++){
    p -= 2.0 * min(dot(p, e1), 0.0) * e1;
    p -= 2.0 * min(dot(p, e2), 0.0) * e2;
  }
  return p.x - r;
}
// 星型
float star(vec2 p, vec2 c, float r, float t){
  p -= c;
  p *= mat2(cos(t), -sin(t), sin(t), cos(t));
  p = dihedral_bound(p, 5.0);
  vec2 e = fromAngle(0.4 * pi);
  return dot(p - vec2(r, 0.0), e);
}
// 月型
float moon(vec2 p, vec2 c, float r, float t){
  p = (p - c) * mat2(cos(t), -sin(t), sin(t), cos(t));
  return max(length(p) - r, r * 0.65 - length(p - vec2(r * 0.5, 0.0)));
}
// getRGB,参上！
vec3 getRGB(float h, float s, float b){
  vec3 c = vec3(h, s, b);
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
  rgb = rgb * rgb * (3.0 - 2.0 * rgb);
  return c.z * mix(vec3(1.0), rgb, c.y);
}
float getDist(vec2 p){
  float d1 = star(p, vec2(0.4, 0.5), 0.18, u_count * TAU / 180.0);
  float d2 = triangle(p, vec2(-0.5, -0.6), 0.1, u_count * TAU / 210.0);
  float d3 = circle(p, vec2(-0.7, 0.5), 0.2);
  float d4 = rect(p, vec2(0.4, -0.4), vec2(0.3, 0.2));
  float d5 = square(p, vec2(0.6, 0.0), 0.35, -u_count * TAU / 270.0);
  float d6 = moon(p, vec2(-0.2, 0.1), 0.25, -u_count * TAU / 240.0);
  float result = min(min(min(d1, d2), min(d3, d4)), min(d5, d6));
  return result;
}
void main(){
  vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
  vec3 col = vec3(0.0);
  float d1 = getDist(p);
  if(d1 < 0.0){
    col = (1.0 + d1 * 5.0) * skyblue - 5.0 * d1 * vec3(1.0);
  }
// dが0.0でない場合はそこは図形の外だから0.0から見える以下略
  float threshold = 0.001;
  vec2 m = (u_mouse * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
  m.y = -m.y;
  vec2 cur = m;
  vec2 direction = p - cur;
  float l = length(p - cur);
  float d = 0.0;
  if(l > 0.0){
    direction = direction / l;
    for(float i = 0.0; i < 32.0; i += 1.0){
      d = getDist(cur);
      if(d < threshold){ break; }
      cur += direction * d;
    }
    if(length(cur - m) > length(p - m)){
      l = length(p - m);
      float blt = (l < 0.5 ? 1.0 : 0.7);
      col = getRGB(0.15, 1.0, blt);
    }
  }
  gl_FragColor = vec4(col, 1.0);
}
