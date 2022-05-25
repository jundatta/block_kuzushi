// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】Ballllll
// https://neort.io/art/c3098bc3p9f8s59bd78g
//

class GameSceneCongratulations152 extends GameSceneCongratulationsBase {
  Ball[] balls = new Ball[300];
  color[] colors = {#072ac8, #1e96fc, #a2d6f9, #fcf300, #ffc600};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i=0; i<balls.length; i++) {
      color c = color(P5JSrandom(colors));
      int alpha = (int)random(200, 250);
      c = color(red(c), green(c), blue(c), alpha);
      balls[i] = new Ball(random(0.1, 0.9)*width, random(0.1, 0.9)*height, c);
    }
  }
  @Override void draw() {
    background(25);
    for (Ball b : balls) {
      b.show();
      b.move();
    }

    logoRightLower(color(255, 0, 0));
  }

  class Ball {
    float x;
    float y;
    float d;
    float stepX;
    float stepY;
    color col;
    Ball(float x, float y, color col) {
      this.x = x;
      this.y = y;
      this.d = 0;
      this.stepX = random(-1, 1)*2;
      this.stepY = random(-1, 1)*2;
      this.col = col;
    }
    void show() {
      noStroke();
      fill(this.col);
      circle(this.x, this.y, this.d);
    }
    void move() {
      this.x += this.stepX;
      this.y += this.stepY;
      if (this.x > width - this.d/2 || this.x < 0 + this.d/2) {
        this.stepX *= -1;
      }
      if (this.y > height - this.d/2 || this.y < 0 + this.d/2) {
        this.stepY *= -1;
      }
      float nScl = 0.02;
      this.d =  (cos(this.x * nScl - (frameCount * 0.01))+1) * (sin(this.y * nScl - (frameCount * 0.05))+1) * 30 + 3;
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
