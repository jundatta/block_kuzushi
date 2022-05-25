
varying vec4 vertColor;
varying vec4 vertTexCoord;

const int N_balls = 20;
uniform vec3 metaballs[N_balls];

uniform float WIDTH;
uniform float HEIGHT;

void main() {
   float x = vertTexCoord.x * WIDTH;
   float y = vertTexCoord.y * HEIGHT;
   float v = 0.0;

   for (int i = 0; i < N_balls; i++) {
      vec3 ball = metaballs[i];
      float dx = ball.x - x;
      float dy = ball.y - y;
      float r = ball.z;
      v += r * r / (dx * dx + dy * dy);
   }

   if (v > 1.0) gl_FragColor = vec4(x / WIDTH, y / HEIGHT, 0.0, 1.0);
   else gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
