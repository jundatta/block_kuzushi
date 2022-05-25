// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】reona396さん
// 【作品名】Ghosts Heart
// https://openprocessing.org/sketch/1175793
//

class GameSceneCongratulations8 extends GameSceneCongratulationsBase {
  final int segNum = 15,
    segLength = 10;

  final int ghostsNum = 30;
  Ghost[] ghosts = new Ghost[ghostsNum];

  int MIN;

  // const palette = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#00FFFF", "#FF00FF"];
  final int[] palette = {0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF};

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);
    background(0);

    MIN = min(width, height);

    for (int i = 0; i < ghostsNum; i++) {
      //    ghosts.push(new Ghost(i));
      ghosts[i] = new Ghost(i);
    }
    pg = createGraphics(width, height);
  }
  // 背景消去
  void clearBackground(int alpha) {
    pg.noStroke();
    pg.fill(0, 0, 0, alpha);
    pg.rect(0, 0, width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.blendMode(BLEND);
    //  background("#0000002A");
    clearBackground(0x2A * 2);

    pg.blendMode(SCREEN);
    //  blendMode(ADD);
    for (int i = 0; i < ghosts.length; i++) {
      ghosts[i].move();
      ghosts[i].draw();
    }
    pg.endDraw();
    image(pg, 0, 0, width, height);

    logoRightUpper(color(255, 0, 0));
  }

  class Ghost {
    float nx, ny;
    float[] x;
    float[] y;
    float ox, oy;
    color c;
    float max;
    float NX, NY;
    float nn;
    float t, tStep;
    float R;
    Ghost(int index) {
      this.nx = random(100);
      this.ny = random(100);

      this.x = new float[segNum];
      this.y = new float[segNum];

      this.ox = random(width);
      this.oy = random(height);
      for (int i = 0; i < segNum; i++) {
        this.x[i] = this.oy;
        this.y[i] = this.oy;
      }

      //    this.c = color(palette[index % palette.length]);
      int paletteColor = palette[index % palette.length];
      this.c = color(red(paletteColor), green(paletteColor), blue(paletteColor));

      this.max = random(30, 60);

      this.NX = random(100);
      this.nx = 0;
      this.NY = random(100);
      this.ny = 0;

      this.nn = random(100);

      this.t = random(360);
      this.tStep = random(0.1, 0.5) * 3;
      this.tStep *= 2.5;
      this.tStep *= random(1) >= 0.5 ? -1 : 1;

      this.R = MIN * 0.025; //random(MIN * 0.5, MIN);
    }

    float SIN(float degreeAngle) {
      return (sin(radians(degreeAngle)));
    }
    float COS(float degreeAngle) {
      return (cos(radians(degreeAngle)));
    }
    void move() {
      this.ox = (map(noise(this.NX, this.nx), 0, 1, -15, 15) + this.R) *
        (16 * SIN(this.t) * SIN(this.t) * SIN(this.t)) + width / 2;
      this.oy = -(map(noise(this.NY, this.ny), 0, 1, -15, 15) + this.R) *
        ((13 * COS(this.t) - 5 * COS(2 * this.t) -
        2 * COS(3 * this.t) - COS(4 * this.t))) + height * 0.45;

      this.nx += (0.0031 + this.nn * 0.00005);
      this.ny += (0.0037 + this.nn * 0.00005);

      this.t += this.tStep;
    }

    void draw() {
      this.calcSegment(0, this.ox, this.oy);
      pg.stroke(this.c);
      for (int i = 0; i < this.x.length - 1; i++) {
        pg.strokeWeight(map(i, 0, this.x.length - 2, this.max, 20));
        this.calcSegment(i + 1, this.x[i], this.y[i]);
      }
    }

    void calcSegment(int i, float xin, float yin) {
      final float dx = xin - this.x[i];
      final float dy = yin - this.y[i];
      final float angle = atan2(dy, dx);
      this.x[i] = xin - cos(angle) * segLength;
      this.y[i] = yin - sin(angle) * segLength;
      this.segment(this.x[i], this.y[i], angle);
    }

    void segment(float x, float y, float a) {
      pg.push();
      pg.translate(x, y);
      pg.rotate(a);
      pg.line(0, 0, segLength, 0);
      pg.pop();
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
