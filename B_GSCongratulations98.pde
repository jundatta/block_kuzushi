// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】Water (Magic) Circle
// https://openprocessing.org/sketch/989004
//

class GameSceneCongratulations98 extends GameSceneCongratulationsBase {
  //2020-10-16@senbaku
  Ude[] ude= new Ude[360];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i = 0; i < ude.length; i += 1) {
      float radius = 200; //半径
      float ex = radius * sin(radians(i));
      float ey = radius-90 * cos(radians(i));

      ude[i] = new Ude(ex, ey);
    }
  }
  @Override void draw() {
    stroke(color(#f4f1de));
    background(51);

    push();
    translate(width/2, height/2);

    for (int i = 0, len = ude.length; i < len; i += 1) {
      ude[i].update();
      ude[i].show();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  class Ude {
    PVector pos;
    PVector acc;
    PVector vel;
    float topspeed;
    float ellipsesize;

    Ude(float ex, float ey) {
      this.pos = new PVector(ex, ey);
      this.acc = new PVector(0, -0.01);
      this.vel = new PVector(0, 0);
      this.topspeed = 1;
      this.ellipsesize = random(1, 6);
    }
    void update() {
      this.acc.mult(random(2));
      this.vel.add(this.acc);
      this.vel.limit(this.topspeed);
      this.pos.add(this.vel);
    }
    void show() {
      ellipse(this.pos.x, this.pos.y, this.ellipsesize, this.ellipsesize);
      noStroke();
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
