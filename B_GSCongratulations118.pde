// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】mao tadaさん
// 【作品名】water_200308
// https://neort.io/art/bpie0vc3p9fbkbq82qn0
// 【移植】サンタさん
//

class GameSceneCongratulations118 extends GameSceneCongratulationsBase {
  float t = 0;
  float noiseScale = 0.02;
  final float BLUR = 14 / 3.0;
  Blur blur;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    pg = createGraphics(width, height);

    blur = new Blur(180, 180, BLUR);
    final var g = blur.target();
    g.beginDraw();
    g.noStroke();
    g.fill(g.color(0, 0, 0, 255));
    g.circle(90, 90, 170);
    g.endDraw();
    blur.Exec(0, 0, 180, 180, 0.75, 0x998787);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.colorMode(HSB, 360, 100, 100, 1.0);
    pg.noStroke();
    pg.blendMode(BLEND);
    pg.background(3, 20, 90);
    pg.blendMode(DIFFERENCE);
    final var g = blur.target();

    for (float x = 150; x <= width - 150; x = x + 90) {
      for (float y = 150; y <= height - 150; y = y + 90) {

        float xAngle = map(constrain(mouseX, 0, width), 0, width, -4 * PI, 2 * PI);
        float yAngle = map(constrain(mouseY, 0, height), 0, height, -7 * PI, 2 * PI);
        float angle = xAngle * (x / width) + yAngle * (y / height);

        float myX = x + 40 * -cos(0.2 * PI * t + angle);
        float myY = y + 20 * -sin(0.5 * PI * t + angle);

        pg.image(g, myX - 90 + 58 / 3.0, myY - 90 + 50 / 3.0);

        pg.fill(360);
        pg.circle(myX, myY, 170);
      }
    }
    pg.endDraw();
    image(pg, 0, 0);
    t = t + 0.03;

    logoRightLower(color(255, 0, 0));
  }

  class Blur {
    int w;
    int h;
    PGraphics blur;
    float[] buffer;
    float[] kernel;

    public Blur(int _width, int _height, float blurSize) {
      w = _width;
      h = _height;
      blur = createGraphics(w, h);
      final float R = round(blurSize);
      final float variance = R * R * -0.5 / log(0.04);
      kernel = new float[1 + (int)R];
      float total = 0.0;
      for (int i = 0; i < kernel.length; i++) {
        kernel[i] = exp(i * i * -0.5 / variance);
        total += (i == 0 ? 1 : 2) * kernel[i];
      }
      for (int i = 0; i < kernel.length; i++) {
        kernel[i] /= total;
      }
      buffer = new float[w * h];
    }

    PGraphics target() {
      return blur;
    }

    void Exec(int sx, int sy, int ex, int ey, float alpha, int col) {
      blur.loadPixels();
      final color[] p = blur.pixels;
      final float[] d = buffer;
      final int w = this.w;
      final int h = this.h;
      final int n = kernel.length;
      for (int y = sy; y < ey; y++) {
        for (int x = sx; x < ex; x++) {
          final int i = x + y * w;
          float a = 0.0;
          for (int j = Math.max(1 - n, sx - x), end = Math.min(n - 1, ex - x); j < end; j++) {
            a += (p[i + j] >>> 24) * kernel[j < 0 ? -j : j];
          }
          d[y + x * h] = a;
        }
      }
      for (int x = sx; x < ex; x++) {
        for (int y = sy; y < ey; y++) {
          final int i = y + x * h;
          float a = 0.0;
          for (int j = Math.max(1 - n, sy - y), end = Math.min(n - 1, ey - y); j < end; j++) {
            a += d[i + j] * kernel[j < 0 ? -j : j];
          }
          p[x + y * w] = (int(a * alpha) << 24) | col;
        }
      }
      blur.updatePixels();
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
