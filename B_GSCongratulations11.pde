// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】reona396さん
// 【作品名】arc ring
// https://openprocessing.org/sketch/963284
//

class GameSceneCongratulations11 extends GameSceneCongratulationsBase {
  ArrayList<Ring> rings = new ArrayList();
  int ringsNum = 10;
  int arcNum = 20;
  // let e = new p5.Ease();
  int targetIndex = 1;
  int count = 0;
  color[] palette = {#F15BB5, #FEE43F, #06BBFA};

  PGraphics pg;

  @Override void setup() {
    imageMode(CENTER);

    colorMode(RGB, 255);
    background(0);

    for (int i = 0; i < ringsNum; i++) {
      rings.add(new Ring(i));
    }

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    push();
    translate(width / 2, height / 2);

    pg.beginDraw();
    pg.strokeCap(SQUARE);
    pg.blendMode(BLEND);
    pg.background(0);

    pg.blendMode(DIFFERENCE);
    for (int i = 0; i < rings.size(); i++) {
      rings.get(i).display();
    }
    pg.endDraw();
    image(pg, 0, 0);

    rings.get(targetIndex).move();
    if (rings.get(targetIndex).checkLife()) {
      targetIndex++;
      if (targetIndex > rings.size() - 1) {
        targetIndex = rings.size() - 1;
        count++;

        if (count > 60 * 3) {
          rings.clear();
          for (int i = 0; i < ringsNum; i++) {
            rings.add(new Ring(i));
          }
          targetIndex = 1;
          count = 0;
        }
      }
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  class Ring {
    int index;
    color c;
    int stw;
    float theta;
    float rDelta;
    float r;
    float eX;
    boolean isFinished;
    float rot;

    Ring(int tmpIndex) {
      this.index = tmpIndex;
      this.c = palette[this.index % palette.length];
      this.stw = 30;
      this.theta = this.index % 2 * 90;
      this.rDelta = 0;
      this.r = this.index * this.stw * this.rDelta + 150;
      this.eX = 0;
      this.isFinished = false;
      this.rot = 0;
    }

    void move() {
      //    this.rDelta = 2 * e.circularInOut(this.eX);
      this.rDelta = 2 * easeInOutCirc(this.eX);
      this.r = this.index * this.stw * this.rDelta + 150;

      //    this.rot = 360 / ringsNum * e.circularInOut(this.eX);
      this.rot = 360 / ringsNum * easeInOutCirc(this.eX);

      this.eX += 1 / 100.0;
      if (this.eX > 1) {
        this.eX = 1;
        this.isFinished = true;
      }
    }

    boolean checkLife() {
      return this.isFinished;
    }

    void display() {
      pg.noFill();
      pg.strokeWeight(this.stw);
      pg.push();
      pg.translate(width / 2, height / 2);
      pg.rotate(radians(this.theta + this.rot));
      for (int i = 0; i < arcNum; i++) {
        if (i % 2 == 0) {
          pg.stroke(this.c);
        } else {
          pg.noStroke();
        }
        pg.arc(0, 0, this.r, this.r, radians(360 * i / arcNum), radians(360 * (i + 1) / arcNum));
      }
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
