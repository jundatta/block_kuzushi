precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define linearstep(edge0, edge1, x) min(1.0, max(0.0, (x - edge0) / (edge1 - edge0)))

mat2 rotate(float r) {
  float c = cos(r);
  float s = sin(r);
  return mat2(c, s, -s, c);
}

float circularOut(float t) {
  return sqrt((2.0 - t) * t);
}

float sdTorus(vec3 p, vec2 t) {
  vec2 q = vec2(length(p.xz) - t.x, p.y);
  return length(q) - t.y; 
}

float map(vec3 p) {
  p.xy *= rotate(time);
  p.yz *= rotate(0.3 * time);
  return sdTorus(p, vec2(1.0, 0.3));
}

vec3 calcNormal(vec3 p) {
  float d = 0.01;
  return normalize(vec3(
    map(p + vec3(d, 0.0, 0.0)) - map(p - vec3(d, 0.0, 0.0)),
    map(p + vec3(0.0, d, 0.0)) - map(p - vec3(0.0, d, 0.0)),
    map(p + vec3(0.0, 0.0, d)) - map(p - vec3(0.0, 0.0, d))
  ));
}

vec3 raymarch(vec3 ro, vec3 rd) {
  vec3 p = ro;
  for (int i = 0; i < 32; i++) {
    float d = map(p);
    p += d * rd;
    if (d < 0.01) {
      vec3 n = calcNormal(p);
      return n * 0.5 + 0.5;
    }
  }
  return vec3(0.0);
}

vec3 calcScene(vec2 st) {
  vec3 ro = vec3(0.0, 0.0, 2.5);
  ro.xz *= rotate(0.15 * time);
  vec3 ta = vec3(0.0);
  vec3 z = normalize(ta - ro);
  vec3 up = vec3(0.0, 1.0, 0.0);
  vec3 x = normalize(cross(z, up));
  vec3 y = normalize(cross(x, z));
  vec3 rd = normalize(x * st.x + y * st.y + z * 1.5);
  return raymarch(ro, rd);
}

void main(void) {
  vec2 st = (2.0 * gl_FragCoord.xy - resolution) / min(resolution.x, resolution.y);

  vec2 p = st;
  p.x += 0.25 * sin(5.0 * st.y + time);
  p.y += 0.1 * sin(3.0 * st.x + time);

  float t = mod(time, 10.0) / 10.0;

  float gridSize = 0.05;
  vec2 centerP = (floor(p / gridSize) + 0.5)  * gridSize;
  vec2 gridP = 2.0 * mod(p, gridSize) - gridSize;

  vec3 stC = calcScene(p);
  vec3 centerC = calcScene(centerP);
  vec3 circleC = mix(centerC, vec3(0.0), smoothstep(0.7 * gridSize, 0.8 * gridSize, length(gridP)));

  vec3 c = mix(stC, centerC, circularOut(linearstep(0.2, 0.23, t)));
  c = mix(c, circleC, circularOut(linearstep(0.5, 0.53, t)));
  c = mix(c, stC, circularOut(linearstep(0.9, 0.93, t)));

  vec2 uv = st;
  for (int i = 0; i < 7; i++) {
    float d = (abs(uv.x) + abs(uv.y));
    c = mix(c, 1.0 - c, smoothstep(0.61, 0.62, d));
    uv *= 0.92;
  }

  gl_FragColor = vec4(c, 1.0);
}