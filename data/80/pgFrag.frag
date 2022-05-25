precision highp float;

#define PI 3.141592653589793

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uStroke;

uniform float uSeed;
uniform float uTime;

float rand2D(vec2 _p) {
  return fract(sin(dot(_p.xy, vec2(12.9898, 78.233))) * uSeed);
}

float grad(vec2 _p1, vec2 _p2) {
  float theta = 2.0 * PI * rand2D(_p1);
  vec2 v1 = vec2(cos(theta), sin(theta)) / sqrt(2.0);
  vec2 v2 = _p2 - _p1;
  return dot(v1, v2);
}

// パーリンノイズ
float perlin(vec2 _p, float _size) {
  vec2 uv = _p / _size;
  float xf = smoothstep(0.0, 1.0, fract(uv.x));
  float yf = smoothstep(0.0, 1.0, fract(uv.y));
  float x0 = floor(uv.x);
  float x1 = floor(uv.x) + 1.0;
  float y0 = floor(uv.y);
  float y1 = floor(uv.y) + 1.0;

  float n1 = mix(grad(vec2(x0, y0), uv), grad(vec2(x1, y0), uv), xf);
  float n2 = mix(grad(vec2(x0, y1), uv), grad(vec2(x1, y1), uv), xf);

  return (mix(n1, n2, yf) + 1.0) / 2.0;
}

float octavePerlin(vec2 _p, float _size, float persistence) {
  float total = 0.0;
  float max = 0.0;
  float size = _size;
  float amplitude = 1.0;
  const int octaves = 10;

  for (int i=0; i<octaves; i++) {
    total += amplitude * perlin(_p, size);
    max += amplitude;
    size /= 2.0;
    amplitude *= persistence;
  }

  return total / max;
}

void main(void) {
  float amp = octavePerlin(gl_FragCoord.xy + vec2(0.0, uTime), 100.0, 0.2);

  if (amp > 0.535) {
    gl_FragColor = vec4(uColor1, 1.0);
  } else if (amp > 0.53) {
    gl_FragColor = vec4(uStroke, 1.0);
  } else if (amp > 0.47) {
    gl_FragColor = vec4(uColor2, 1.0);
    if (mod(floor((gl_FragCoord.x+gl_FragCoord.y+uTime) / 2.0), 8.0) == 0.0) gl_FragColor = vec4(uStroke, 1.0);
  } else if (amp > 0.465) {
    gl_FragColor = vec4(uStroke, 1.0);
  } else {
    gl_FragColor = vec4(uColor3, 1.0);
    if (mod(floor((gl_FragCoord.x+gl_FragCoord.y+uTime) / 2.0), 8.0) == 0.0 || mod(floor((gl_FragCoord.x+gl_FragCoord.y+uTime) / 2.0), 8.0) == 4.0) gl_FragColor = vec4(uStroke, 1.0);
  }
}
