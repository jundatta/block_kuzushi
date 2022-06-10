// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】cccddd
// https://neort.io/art/bnig0ek3p9f5erb53180
//

class GameSceneCongratulations173 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  int num;
  int formLen;
  color[] pallete = {#540d6e, #ee4266, #ffd23f, #2f92fc, #232323};
  color col;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    newForm();
  }
  @Override void draw() {
    push();
    rectMode(CENTER);
    background(255);
    for (int i = 0; i < forms.size(); i++) {
      forms.get(i).run();
    }
    if (frameCount % (60 * 10) == 0) {
      newForm();
    }
    pop();

    logoRightLower(#ff0000);
  }


  void newForm() {
    float s = 600;
    float hs = s / 2;
    //forms.length = 0;
    forms.clear();
    num = 0;
    col = P5JSrandom(pallete);
    divideRect((width / 2.0f) - hs, (height / 2.0f) - hs, s, s, s * 0.4);
    formLen = forms.size();
  }

  void divideRect(float x, float y, float w, float h, float min) {
    if (w + h > min) {
      if (w >= h) {
        float rndw = random(0.05, 0.95) * w;
        divideRect(x, y, rndw, h, min);
        divideRect(x + rndw, y, w - rndw, h, min);
      }
      if (w < h) {
        float rndh = random(0.05, 0.95) * h;
        divideRect(x, y, w, rndh, min);
        divideRect(x, y + rndh, w, h - rndh, min);
      }
    } else {
      forms.add(new Form(x + (w / 2.0f), y + (h / 2.0f), w, h, num));
      num++;
    }
  }

  float easeInOutExpo(float t, float b, float c, float d) {
    if (t == 0) return b;
    if (t == d) return b + c;
    if ((t /= d / 2.0f) < 1) return c / 2.0f * pow(2, 10 * (t - 1)) + b;
    return c / 2.0f * (-pow(2, -10 * --t) + 2) + b;
  }

  class Form {
    float x, y, tgtw, w, tgth, h;
    int num, t;
    float rnd;
    float angle;
    boolean toggle;
    float circleS;

    Form(float x, float y, float w, float h, int n) {
      this.x = x;
      this.y = y;
      this.tgtw = w;
      this.w = 0;
      this.tgth = h;
      this.h = 0;
      this.num = n;
      this.t = -this.num;
      this.rnd = random(1);
      this.angle = HALF_PI;
      this.toggle = true;
      this.circleS = 0;
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.angle);
      fill(col);
      stroke(col);
      if (this.t > 0) {
        ellipse(0, 0, this.circleS, this.circleS);
        rect(0, 0, this.w, this.h);
      }
      pop();
    }

    void move() {
      int t0 = 0;
      int t1 = 70 + t0;
      int t2 = 60 + t1;
      int t3 = 70 + t2;
      int t4 = 40 + t3;
      int end = t4 + 20 + (int)((formLen - this.num) / 2.0f);

      if (t0 <= this.t && this.t < t1) {
        this.circleS = lerp(0, (this.tgtw + this.tgth) * 0.1, this.easing(t0, t1 - 1));
      }
      if (t1 <= this.t && this.t < t2) {
        if (this.rnd < 0.5) {
          this.w = 0;
          this.h = lerp(1, this.tgth, this.easing(t1, t2 - 1));
        } else {
          this.h = 0;
          this.w = lerp(1, this.tgtw, this.easing(t1, t2 - 1));
        }
      }
      if (t2 <= this.t && this.t < t3) {
        if (this.rnd < 0.5) {
          this.w = lerp(0, this.tgtw, this.easing(t2, t3 - 1));
        } else {
          this.h = lerp(0, this.tgth, this.easing(t2, t3 - 1));
        }
        this.circleS = lerp((this.tgtw + this.tgth) * 0.1, 0, this.easing(t2, t3 - 1));
      }
      if (t3 <= this.t && this.t < t4) {
        this.angle = lerp(HALF_PI, 0, this.easing(t3, t4 - 1));
      }

      if (this.t > end) {
        this.toggle = false;
      }
      if (this.toggle) {
        this.t++;
      } else {
        this.t--;
      }
    }

    float easing(int start, int end) {
      float amt1 = map(this.t, start, end, 0, 1);
      float amt2 = easeInOutExpo(amt1, 0, 1, 1);
      return amt2;
    }

    void run() {
      this.show();
      this.move();
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
