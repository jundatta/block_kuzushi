// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Takashi Tanakaさん
// 【作品名】Loop Trails
// https://openprocessing.org/sketch/1226295
//

class GameSceneCongratulations39 extends GameSceneCongratulationsBase {
  DrawCircle drawCircle;

  @Override void setup() {
    imageMode(CORNER);

    colorMode(HSB, 255);
    //  angleMode(DEGREES);
    background(0);
    drawCircle = new DrawCircle();
  }
  @Override void draw() {
    //  background(0, 12);
    fill(0, 12);
    noStroke();
    rect(0, 0, width, height);
    drawCircle.display(340, 1);

    logo(color(255, 0, 0));
  }

  class DrawCircle {
    float fc;
    PVector basePoint;
    int firstDeg;
    int lastDeg;
    ArrayList<PVector> points;
    float count;

    DrawCircle() {
      this.fc = frameCount;
      this.basePoint = new PVector(width / 2, height / 2);
      this.firstDeg = -90;
      this.lastDeg = 361;
      this.points = new ArrayList();
      for (int i = 0; i < this.lastDeg; i++) {
        PVector p = new PVector(0, 0);
        this.points.add(p);
      }
      this.count = 0;
    }
    float COS(float a) {
      return cos(radians(a));
    }
    float SIN(float a) {
      return sin(radians(a));
    }
    void createBasePoint(float radius, int deg) {
      for (int i = 0; i * deg < this.lastDeg; i++) {
        PVector p = this.points.get(i);
        p.x = this.basePoint.x + radius * COS(this.firstDeg + i * deg) * (COS(i / (180 + 180 * COS(this.fc)) + this.fc));
        p.y = this.basePoint.y + radius * SIN(this.firstDeg + i * deg);
      }
    }
    void drawBasePoint() {
      noFill();
      strokeWeight(5);
      beginShape();
      for (int i = 0; i < this.points.size(); i++) {
        stroke(frameCount%255, 200, 255);
        vertex(
          this.points.get(i).x,
          this.points.get(i).y
          );
      }
      endShape(CLOSE);
    }
    void update() {
      this.fc = frameCount;
    }
    void display(float radius, int deg) {
      this.createBasePoint(radius, deg);
      this.drawBasePoint();
      this.update();
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
