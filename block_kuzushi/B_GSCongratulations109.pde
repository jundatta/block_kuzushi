// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Lunarhounddogさん
// 【作品名】Glow Graffiti
// https://openprocessing.org/sketch/909596
//

class GameSceneCongratulations109 extends GameSceneCongratulationsBase {
  final color[] palette = {#00ffff, #ff00ff, #ffff00, #ff0000, #0000ff};
  class Line {
    float x1;
    float y1;
    float x2;
    float y2;
    color c;
    Line(float x1, float y1, float x2, float y2, color c) {
      this.x1 = x1;
      this.y1 = y1;
      this.x2 = x2;
      this.y2 = y2;
      this.c = c;
    }
    void neonLine(PGraphics pg) {
      int cc = 30;
      float d = dist(x1, y1, x2, y2);
      pg.noFill();
      for (int j = 0; j < cc; j++) {
        float sw = map(j, 0, cc - 1, 1, 100);
        //      col.setAlpha(map(j, 0, cc - 1, 12, 1));
        float a = map(j, 0, cc - 1, 12, 1);
        color col = color(red(c), green(c), blue(c), a);
        pg.stroke(col);
        pg.strokeWeight(sw);
        pg.beginShape();
        for (int i = 0; i < d; i++) {
          float x = map(i, 0, d - 1, x1, x2);
          float y = map(i, 0, d - 1, y1, y2);
          pg.vertex(x, y);
        }
        pg.endShape();
      }
    }
  }
  ArrayList<Line> lines = new ArrayList();

  class Circle {
    float x;
    float y;
    float d;
    color c;
    Circle(float x, float y, float d, color c) {
      this.x = x;
      this.y = y;
      this.d = d;
      this.c = c;
    }
    void neonCircle(PGraphics pg) {
      int cc = 30;
      pg.noFill();
      for (int i = 0; i < cc; i++) {
        float sw = map(i, 0, cc - 1, 1, 100);
        //      col.setAlpha(map(i, 0, cc - 1, 12, 1));
        float a = map(i, 0, cc - 1, 12, 1);
        color col = color(red(c), green(c), blue(c), a);
        pg.stroke(col);
        pg.strokeWeight(sw);
        pg.circle(x, y, d);
      }
    }
  }
  ArrayList<Circle> circles = new ArrayList();

  class Rect {
    float x;
    float y;
    float w;
    float h;
    color c;
    Rect(float x, float y, float w, float h, color c) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.c = c;
    }
    void neonRect(PGraphics pg) {
      int cc = 30;
      pg.noFill();
      for (int i = 0; i < cc; i++) {
        float sw = map(i, 0, cc - 1, 1, 100);
        //      col.setAlpha(map(i, 0, cc - 1, 12, 1));
        float a = map(i, 0, cc - 1, 12, 1);
        color col = color(red(c), green(c), blue(c), a);
        pg.stroke(col);
        pg.strokeWeight(sw);
        pg.rect(x, y, w, h, 5);
      }
    }
  }
  ArrayList<Rect> rects = new ArrayList();

  PGraphics pg;
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    shapesSetup();

    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.rectMode(CENTER);
    pg.background(5);
    //  shapes();
    shapesDraw(pg);
    pg.noFill();
    pg.stroke(5);
    pg.strokeWeight(1);
    tile(pg);

    pg.stroke(255);
    pg.strokeWeight(3);
    for (Line line : lines) {
      pg.line(line.x1, line.y1, line.x2, line.y2);
    }
    for (Circle c : circles) {
      pg.circle(c.x, c.y, c.d);
    }
    for (Rect r : rects) {
      pg.rect(r.x, r.y, r.w, r.h, 5);
    }
    pg.endDraw();
  }
  @Override void draw() {
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  void tile(PGraphics pg) {
    int c = 20;
    int w = width / c;
    for (int i = 0; i <= c; i++) {
      for (int j = 0; j <= c; j++) {
        int x = j * w + w / 2;
        int y = i * w + w / 2;
        pg.rect(x, y, w, w / 2);
        pg.rect(x - w / 2, y - w / 2, w, w / 2);
      }
    }
  }

  color P5random(color[] args) {
    return args[int(random(args.length))];
  }
  void shapesSetup() {
    for (int i = 0; i < 20; i++) {
      float x = random(width);
      float y = random(height);
      float w = random(50, 300);
      float h = random(50, 300);
      float rnd = random(1);
      color col = P5random(palette);

      if (rnd < 0.3) {
        Circle c = new Circle(x, y, w, col);
        circles.add(c);
      } else if (rnd < 0.6) {
        Rect r = new Rect(x, y, w, h, col);
        rects.add(r);
      } else {
        if (random(1) < 0.5) {
          // 縦線にゃ
          Line line = new Line(x, y - h, x, y + h, col);
          lines.add(line);
        } else {
          // 横線にゃ
          Line line = new Line(x - w, y, x + w, y, col);
          lines.add(line);
        }
      }
    }
  }
  void shapesDraw(PGraphics pg) {
    for (Line line : lines) {
      line.neonLine(pg);
    }
    for (Circle c : circles) {
      c.neonCircle(pg);
    }
    for (Rect r : rects) {
      r.neonRect(pg);
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
