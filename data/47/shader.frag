// shader.frag

#define TRAIL_MAX_COUNT 30
#define PARTICLE_MAX_COUNT 70

uniform vec2 resolution;
uniform int trailCount;
uniform vec3 trailColor;
uniform vec2 trail[TRAIL_MAX_COUNT];
uniform int particleCount;
uniform vec3 particles[PARTICLE_MAX_COUNT];
uniform vec3 colors[PARTICLE_MAX_COUNT];

void main() {
  vec2 st = gl_FragCoord.xy / resolution.xy;  // Warning! This is causing non-uniform scaling.

  float r = 0.0;
  float g = 0.0;
  float b = 0.0;

  for (int i = 0; i < TRAIL_MAX_COUNT; i++) {
    if (i < trailCount) {
      vec2 trailPos = trail[i];

      float value = float(i) / distance(st, trailPos.xy) * 0.00018;  // Multiplier may need to be adjusted if max trail count is tweaked.

      r += trailColor.r * value;
      g += trailColor.g * value;
      b += trailColor.b * value;
    }
  }

  float mult = 0.00005;

  for (int i = 0; i < PARTICLE_MAX_COUNT; i++) {
    if (i < particleCount) {
      vec3 particle = particles[i];
      vec2 pos = particle.xy;
      float mass = particle.z;
      vec3 color = colors[i];

      r += color.r / distance(st, pos) * mult * mass;
      g += color.g / distance(st, pos) * mult * mass;
      b += color.b / distance(st, pos) * mult * mass;
    }
  }

  gl_FragColor = vec4(r, g, b, 1.0);
}