precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define saturate(x) max(min(x, 1.0), 0.0)

vec3 palette(vec3 a, vec3 b, vec3 c, vec3 d, float t) {
  return a + b * cos(6.28318530718 * (c * t + d));
}

float random(float x){
  return fract(sin(x * 12.9898) * 43758.5453);
}

float srandom(float x) {
  return 2.0 * random(x) - 1.0;
}

float map(vec3 p) {
  float s = 1.0;
  for (float i = 1.0; i <= 5.0; i += 1.0) { 
    p.x += s * 0.15 * sin(4.0 / s * p.y + 5.0 * srandom(i + 0.19) * time);
    p.y += s * 0.15 * sin(4.0 / s * p.z + 5.0 * srandom(i + 0.32) * time);
    p.z += s * 0.15 * sin(4.0 / s * p.x + 5.0 * srandom(i + 0.07) * time);
    s *= 0.57;
  }
  return length(p) - 3.0;
}

vec3 calcNormal(vec3 p) {
  float d = 0.005;
  return normalize(vec3(
    map(p + vec3(d, 0.0, 0.0)) - map(p - vec3(d, 0.0, 0.0)),
    map(p + vec3(0.0, d, 0.0)) - map(p - vec3(0.0, d, 0.0)),
    map(p + vec3(0.0, 0.0, d)) - map(p - vec3(0.0, 0.0, d))
  ));
}

vec3 lightDir = normalize(vec3(0.0, 1.0, 0.0));

vec3 raymarch(vec3 ro, vec3 rd) {
  vec3 p = ro;
  for (int i = 0; i < 128; i++) {
    float d = map(p);
    p += d * rd;
    if (d < 0.001) {
      vec3 n = calcNormal(p);
      float dotNL = saturate(dot(n, lightDir));
      float dotNV = saturate(dot(n, -rd));
      vec3 rainbow = palette(vec3(0.5), vec3(0.5), vec3(1.0), vec3(0.0, 0.81, 0.67), 3.0 * dotNV);
      return dotNL * mix(vec3(0.013, 0.015, 0.022), rainbow, pow(1.0 - dotNV, 3.0));
    }
  }
  return mix(vec3(0.8), vec3(0.2), abs(rd.y));
}

void main(void) {
  vec2 st = (2.0 * gl_FragCoord.xy - resolution) / min(resolution.x, resolution.y);

  vec3 ro = vec3(3.5 * cos(0.3 * time), 3.0 * sin(0.71 * time), 6.0 * sin(0.3 * time));
  vec3 ta = vec3(0.0);
  vec3 z = normalize(ta - ro);
  vec3 up = vec3(0.0, 1.0, 0.0);
  vec3 x = normalize(cross(z, up));
  vec3 y = normalize(cross(x, z));
  vec3 rd = normalize(x * st.x + y * st.y + z * 1.5);

  vec3 c = raymarch(ro, rd);

  c = pow(c, vec3(0.4545));

  gl_FragColor = vec4(c, 1.0);
}