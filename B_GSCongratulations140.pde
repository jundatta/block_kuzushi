// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】ケオティックフューザー
// https://neort.io/art/c6adqc43p9fe3sqpua50
//

class GameSceneCongratulations140 extends GameSceneCongratulationsBase {
  PGraphics pg;

  ArrayList<Mover> movers = new ArrayList();
  color[] colors = {#ee2642, #eda037, #388da4, #000000};
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
  }
  ArrayList<Circle> circles = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    int seg = 5;
    int w = int(width / (float)seg);
    int h = int(height / (float)seg);
    for (int i = 0; i < seg; i++) {
      for (int j = 0; j < seg; j++) {
        float x = i * w + w / 2.0f;
        //      float y = j * w + w / 2.0f;
        float y = j * h + h / 2.0f;
        float d = random(0.5, 1)*w;
        int num = int(random(1, 4));
        color col = P5JSrandom(colors);
        for (int k=0; k<num; k++) {
          circles.add(new Circle(x, y, d*0.7, col));
          movers.add(new Mover(x, y, d*0.5));
        }
      }
    }

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.translate(width / 2, height / 2);
    pg.scale(0.8);
    pg.translate(-width / 2, -height / 2);

    pg.background(255);

    for (Circle c : circles) {
      pg.fill(c.c);
      pg.circle(c.x, c.y, c.d);
    }

    for (Mover mv : movers) {
      mv.show(pg);
      mv.move();
    }
    pg.noStroke();
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }


  class Mover {
    float x;
    float y;
    float r;
    float cs;
    float cs0;
    float t;
    float off;
    float tStep;
    float ang;
    float aStep;
    color col1;
    color col2;

    Mover(float x, float y, float r) {
      this.x = x;
      this.y = y;
      this.r = r;
      this.cs = this.r * 0.4;
      this.cs0 = this.r * 0.4;
      this.t = random(100);
      this.off = 0;
      this.tStep = random(0.01, 0.05);
      this.ang = random(TAU);
      this.aStep = random(-1, 1)*0.01;
      this.col1 = P5JSrandom(colors);
      this.col2 = P5JSrandom(colors);
      while (this.col1 == this.col2) {
        this.col1 = P5JSrandom(colors);
      }
    }

    void show(PGraphics pg) {
      pg.push();
      pg.translate(this.x, this.y);
      pg.rotate(this.ang);
      pg.stroke(255);
      pg.fill(this.col1);
      if (this.cs0*0.15 < this.cs) {
        pg.fill(this.col2);
        pg.circle(this.off, 0, this.cs);
      }
      pg.pop();
    }

    void move() {
      this.off = map(sin(this.t), -1, 1, -1, 1)*this.r;
      this.cs = map(cos(this.t), -1, 1, this.cs0, 0);
      this.t += this.tStep;
      this.ang += this.aStep;
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
