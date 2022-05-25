// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】reona396さん
// 【作品名】Lines
// https://openprocessing.org/sketch/918484
//

class GameSceneCongratulations95 extends GameSceneCongratulationsBase {
  final color[] palette = {#3B3247, #006D8E, #EEDCC4, #B53021, #421717};
  MyLine[] lines = new MyLine[60];

  final float DIST = 10;
  float MAX;
  final float GEN = 30;

  color stColor;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    MAX = width > height ? width : height;
    stColor = P5JSrandom(palette);

    for (int i = 0; i < lines.length; i++) {
      lines[i] = new MyLine();
    }
  }
  @Override void draw() {
    background(235);

    noStroke();
    for (int i = 0; i < lines.length; i++) {
      push();
      translate(width / 2, height / 2);
      rotate(radians(360 * i / (float)lines.length));
      lines[i].display();
      pop();
    }

    fill(235);
    stroke(stColor);
    strokeWeight(10);
    circle(width / 2, height / 2, MAX * 0.2);

    logoRightLower(color(255, 0, 0));
  }

  class MyLine {
    ArrayList<Obj> objs;
    float speed;
    float h;

    MyLine() {
      this.objs = new ArrayList();
      this.speed = random(3, 6);
      this.h = random(2, 10);
    }

    void display() {
      if (random(100) < GEN) {
        if ((this.objs.size() == 0) ||
          (this.objs.size() > 0 && this.objs.get(this.objs.size() - 1).hasDistance())) {
          this.objs.add((new Obj(this.speed, this.h)));
        }
      }

      for (int i = 0; i < this.objs.size(); i++) {
        this.objs.get(i).move();
        this.objs.get(i).display();
      }

      if (this.objs.size() > 0) {
        for (int j = this.objs.size() - 1; j >= 0; j--) {
          if (this.objs.get(j).isFinished()) {
            this.objs.remove(j);
          }
        }
      }
    }
  }

  class Obj {
    float x;
    float y;
    float speed;
    float w;
    float h;
    color c;

    Obj(float tmpSpeed, float tmpH) {
      this.x = 0;
      this.y = 0;
      this.speed = tmpSpeed;
      this.w = random(10, 100);
      this.h = tmpH;
      this.c = color(P5JSrandom(palette));
    }

    void move() {
      this.x -= this.speed;
    }

    boolean isFinished() {
      return this.x < -MAX * 0.6 - this.w;
    }

    boolean hasDistance() {
      return this.x < -(this.w + DIST);
    }

    void display() {
      fill(this.c);
      rect(this.x, this.y, this.w, this.h, this.h / 2.0f);
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
