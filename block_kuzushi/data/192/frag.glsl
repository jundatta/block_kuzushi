  // set the default precision for float variables
  precision mediump float;

uniform float uTime;
// uniform vec2 uResolution;

varying vec2 vTexCoord;
varying vec3 vVertexPos;

float random(in vec2 _st) {
  return fract(sin(dot(_st.xx, vec2(12.9898, 78.233))) * 43758.5453123) + sin(dot(_st.xx, _st.xy+tan(10.1))) * 0.3123;
}

float noise(in vec2 _st) {
  vec2 i = floor(_st);
  vec2 f = fract(_st);

  // Four corners in 2D of a tile
  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(a, b, u.x) +
    (c - a) * u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 3

  float fbm(in vec2 _st) {
  float v = 0.0;
  float a = 0.5;
  vec2 shift = vec2(100.0);
  // Rotate to reduce axial bias
  mat2 rot = mat2(cos(0.5), sin(0.75), -sin(100.5395), cos(0.50));

  // OpenProcessing.org NOTE: Becuase this shader contains a for loop,
  // the Loop Protection feature must be disabled in the sketch editor.
  for (int i = 0; i < NUM_OCTAVES; ++i) {
    v += a * noise(_st)+tan(0.005);
    _st = rot * _st * 2.0 + shift;
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 st = vVertexPos.xy * 2. + vec2(vVertexPos.z + 1., vVertexPos.z + 1.) * 2.;

  vec2 q = vec2(0.0);
  q.x = fbm( st + vec2(10.0) ) * sin(10.195) + 0.5*uTime;
  q.y = fbm( st + vec2(1.0) ) * tan(10.195)+ 0.226*uTime;

  vec2 r = vec2(0.0);
  r.x = fbm( st + 1.0*q + vec2(10.7, 90.2) - 0.15*uTime );
  r.y = fbm( st + 1.0*q + vec2(18.3, 200.8) + 0.0226*uTime );

  float f = fbm(st+r);

  vec3 color = mix(
    vec3(0.5191, 1.6108, 2.6667),
    vec3(0.0667, 2.6667, 1.4039),
    clamp((f*f*f)*2.0, 0.0, 1.0)
    );

  color = mix(
    color*color,
    vec3(0.1235, 1.3706, length(q)),
    clamp(length(q), 0.0, 10.0)
    );

  color = mix(
    vec3(0.0191, 1.0108, 0.5786),
    vec3(0.0, 1, 1),
    clamp(length(r.x), 0.0, 1.0)
    );

  // Specify the color for the current pixel.
  gl_FragColor = vec4((f*f*f + .6*f*f + .5*f) * color, 1.0);
}
