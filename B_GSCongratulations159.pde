// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Viscous Fingering - webGL2 smplfさん
// 【作品名】FabriceNeyret2
// https://www.shadertoy.com/view/ttjXzR
// 【移植】サンタさん
//
import java.util.*;
import java.util.stream.*;

class GameSceneCongratulations159 extends GameSceneCongratulationsBase {
  static final float _K0 = -20./6.;
  static final float _K1 =   4./6.;
  static final float _K2 =   1./6.;
  static final float cs =  .25;
  static final float ls =  .24;
  static final float ps = .06;
  static final float ds = -.08;
  static final float pwr =  .2;
  static final float amp = 1.;
  static final float sq2 =  .7;
  static final int WIDTH = 250;
  static final int HEIGHT = 400;
  static final int ITERATION = 2;
  PGraphics off;
  long buff[];
  float heightMap[];
  int map[];

  long toLong(float r, float g, float b) {
    int i = Float.floatToIntBits(r);
    long R = ((i >> 11) & 0x100000) | ((i >> 10) & 0xfe000) | ((i >> 10) & 0x1fff);
    i = Float.floatToIntBits(g);
    long G = ((i >> 11) & 0x100000) | ((i >> 10) & 0xfe000) | ((i >> 10) & 0x1fff);
    i = Float.floatToIntBits(b);
    long B = ((i >> 11) & 0x100000) | ((i >> 10) & 0xfe000) | ((i >> 10) & 0x1fff);
    return (R << 42) | (G << 21) | B;
  }

  float toX(long rgb) {
    int i = (int)(rgb >>> 42);
    return Float.intBitsToFloat(((i & 0x100000) << 11) | ((i & 0xfe000) << 10) | ((i & 0x1fff) << 10));
  }

  float toY(long rgb) {
    int i = (int)(rgb >>> 21);
    return Float.intBitsToFloat(((i & 0x100000) << 11) | ((i & 0xfe000) << 10) | ((i & 0x1fff) << 10));
  }

  float toZ(long rgb) {
    int i = (int)rgb;
    return Float.intBitsToFloat(((i & 0x100000) << 11) | ((i & 0xfe000) << 10) | ((i & 0x1fff) << 10));
  }

  float fastInverseSquareRoot(float x) {
    var bits = Float.floatToRawIntBits(x);
    bits = 0x5f3759df - (bits >> 1);
    var newton = Float.intBitsToFloat(bits);
    newton *= 1.5 - .5 * x * newton * newton;
    return newton;
  }

  float clamp(float v, float minv, float maxv) {
    return v < minv ? minv : v > maxv ? maxv : v;
  }

  color cleanColor(float h, float s, float b) {
    float x = (1 + (clamp(Math.abs(1.5 - 3 * h) - .5, 0, 1) - 1) * s) * b;
    float y = (1 + (clamp(1 - Math.abs(3 * h - 1), 0, 1) - 1) * s) * b;
    float z = (1 + (clamp(1 - Math.abs(3 * h - 2), 0, 1) - 1) * s) * b;
    return 0xff000000 | ((int)(x * 255) << 16) | ((int)(y * 255) << 8) | (int)(z * 255);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    //frameRate(60);
    off = createGraphics(WIDTH, HEIGHT, P3D);
    buff = new long[WIDTH * HEIGHT];
    for (int i = buff.length; i-- > 0; ) {
      buff[i] = toLong(random(-.5, .5), random(-.5, .5), random(-.5, .5));
    }
    heightMap = new float[WIDTH * HEIGHT];
    map = new int[WIDTH * HEIGHT];
    for (int i = 0; i < WIDTH * HEIGHT; ++i)map[i] = i;
    var r = new Random();
    for (int i = 0; i < WIDTH * HEIGHT; ++i) {
      int j = r.nextInt(WIDTH * HEIGHT - i) + i;
      int tmp = map[i];
      map[i] = map[j];
      map[j] = tmp;
    }
  }
  @Override void draw() {
    // booooom!
    if (mousePressed) {
      IntStream.range(0, 256)
        .parallel()
        .forEach(i -> {
        int x = (i & 7) - 4;
        int y = (i >> 3) - 4;
        if (x * x + y * y <= 64) {
          x += mouseX * WIDTH / width + WIDTH;
          y += mouseY * HEIGHT / height + HEIGHT;
          buff[x % WIDTH + (y % HEIGHT) * WIDTH] = toLong(random(-1, 1) * .015625, random(-1, 1) * .015625, random(-1, 1) * .015625);
        }
      }
      );
    }

    // simulation
    IntStream.range(0, WIDTH * HEIGHT * ITERATION)
      .parallel()
      .forEach(i -> {
      i = map[i % (WIDTH * HEIGHT)];
      final var buf = buff;
      final int x = i % WIDTH;
      final int y = i / WIDTH;

      final int t = y < HEIGHT - 1 ? y + 1 : 0;
      final int r = x < WIDTH - 1 ? x + 1 : 0;
      final int b = y > 0 ? y - 1 : HEIGHT - 1;
      final int l = x > 0 ? x - 1 : WIDTH - 1;
      final var uv = buf[i];
      final var n = buf[x + t * WIDTH];
      final var e = buf[r + y * WIDTH];
      final var s = buf[x + b * WIDTH];
      final var w = buf[l + y * WIDTH];
      final var nw = buf[l + t * WIDTH];
      final var sw = buf[l + b * WIDTH];
      final var ne = buf[r + t * WIDTH];
      final var se = buf[r + b * WIDTH];
      final float lapx = _K0 * toX(uv) + _K1 * (toX(n) + toX(e) + toX(s) + toX(w)) + _K2 * (toX(nw) + toX(sw) + toX(ne) + toX(se));
      final float lapy = _K0 * toY(uv) + _K1 * (toY(n) + toY(e) + toY(s) + toY(w)) + _K2 * (toY(nw) + toY(sw) + toY(ne) + toY(se));
      final float lapz = _K0 * toZ(uv) + _K1 * (toZ(n) + toZ(e) + toZ(s) + toZ(w)) + _K2 * (toZ(nw) + toZ(sw) + toZ(ne) + toZ(se));

      final float sp = ps * lapz;
      final float curl = toX(n) - toX(s) - toY(e) + toY(w)
        + sq2 * (toX(nw) + toY(nw) + toX(ne) - toY(ne) + toY(sw) - toX(sw) - toY(se) - toX(se));
      final float a = cs * (curl < 0 ? -1 : 1) * pow(curl < 0 ? -curl : curl, pwr);
      final float div  = toY(s) - toY(n) - toX(e) + toX(w)
        + sq2 * (toX(nw) - toY(nw) - toX(ne) - toY(ne) + toX(sw) + toY(sw) + toY(se) - toX(se));
      final float sd = ds * div;

      final float u = toX(uv);
      final float v = toY(uv);
      final float norm = fastInverseSquareRoot(u * u + v * v);
      final float normx = u * norm;
      final float normy = v * norm;

      final float tx = (amp + sd) * u + ls * lapx + normx * sp;
      final float ty = (amp + sd) * v + ls * lapy + normy * sp;
      final float co = cos(a);
      final float si = sin(a);

      final float X = clamp(tx * co + ty * si, -1., 1.);
      final float Y = clamp(tx * -si + ty * co, -1., 1.);
      final float Z = clamp(div, -1., 1.);
      buf[i] = toLong(X, Y, Z);
      final float coeff = fastInverseSquareRoot(X * X + Y * Y + Z * Z);
      heightMap[i] = Z * coeff * 100;
    }
    );

    // light
    final float theta = frameCount * PI / 180.;
    final float lx = cos(theta) * 0.7071067811865475;
    final float ly = sin(theta) * 0.7071067811865475;
    final float lz = 0.7071067811865475;

    // lighting
    off.loadPixels();
    IntStream.range(0, WIDTH * HEIGHT)
      .parallel()
      .forEach(i -> {
      final var buf = heightMap;
      final int x = i % WIDTH;
      final int y = i / WIDTH;

      final int t = y < HEIGHT - 1 ? y + 1 : 0;
      final int r = x < WIDTH - 1 ? x + 1 : 0;
      final int b = y > 0 ? y - 1 : HEIGHT - 1;
      final int l = x > 0 ? x - 1 : WIDTH - 1;
      final var uv = buf[i];
      final var n = buf[x + t * WIDTH] - uv;
      final var e = buf[r + y * WIDTH] - uv;
      final var s = buf[x + b * WIDTH] - uv;
      final var w = buf[l + y * WIDTH] - uv;
      final var nw = buf[l + t * WIDTH] - uv;
      final var sw = buf[l + b * WIDTH] - uv;
      final var ne = buf[r + t * WIDTH] - uv;
      final var se = buf[r + b * WIDTH] - uv;

      float nx, ny, nz;
      nx = w - e + (nw + sw - ne - se) * 0.7071067811865475;
      ny = s - n + (sw + se - nw - ne) * 0.7071067811865475;
      nz = 4 + 4 * 1.414213562373095;
      final float d = fastInverseSquareRoot(nx * nx + ny * ny + nz * nz);
      nx *= d;
      ny *= d;
      nz *= d;

      final float L = nx * lx + ny * ly + nz * lz;

      off.pixels[i] = cleanColor(clamp(uv * -0.005 + 1. / 3, 0, 1), clamp(1 - L * L * 0.7, 0, 1), .3 + clamp(L, 0, 1) * .6);
    }
    );
    off.updatePixels();
    image(off, 0, 0, width, height);

    logoRightLower(color(255));
  }
  @Override void mousePressed() {
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
