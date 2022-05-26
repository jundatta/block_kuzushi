// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】lplllpl
// https://neort.io/art/bpefcu43p9f4nmb8bq00
//

class GameSceneCongratulations168 extends GameSceneCongratulationsBase {
  final int C = 30;
  Form[] forms = new Form[C * C];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    addForms();
  }
  @Override void draw() {
    push();
    rectMode(CENTER);
    translate(width * 0.5 - height * 0.5, 0);
    background(0);
    fill(#f1f1f1);
    rect(height * 0.5, height/2, height, height);
    for (int i=0; i<forms.length; i++) {
      forms[i].show();
      forms[i].move();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }


  void addForms() {
    float w = height / C;
    float t = 0;
    for (int i=0; i<C; i++) {
      for (int j=0; j<C; j++) {
        float x = i * w + w / 2;
        float y = j * w + w / 2;
        float d = map(dist(height/2, height/2, x, y), 0, sqrt(sq(height/2)+sq(height/2)), 0.2, 1);
        forms[i*C+j] = new Form(x, y, w, w, d);
        t ++;
      }
    }
  }

  class Form {
    float x, y, w, h;
    float w1, h1;
    float x1, y1, x2, y2;
    float cx, cy, cw, ch;
    float t;
    Form(float x, float y, float w, float h, float t) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;

      this.w1 = w * 0.5;
      this.h1 = h * 0.5;
      this.x1 = this.x + (this.w - this.w1) / 2;
      this.y1 = this.y + (this.h - this.h1) / 2;
      this.x2 = this.x - (this.w - this.w1) / 2;
      this.y2 = this.y - (this.h - this.h1) / 2;

      this.cx = this.x1;
      this.cy = this.y1;
      this.cw = this.w1;
      this.ch = this.h1;

      this.t = t;
    }

    void show() {
      noStroke();
      fill(0);
      rect(this.x1, this.y1, this.w1, this.h1);
      fill(#f1f1f1);
      rect(this.cx, this.cy, this.cw, this.ch);
    }

    void move() {
      this.cx = map(sin(frameCount * this.t * 0.2), -1, 1, this.x1, this.x2);
      this.cy = map(sin(frameCount * this.t * 0.2), -1, 1, this.y1, this.y2);
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
