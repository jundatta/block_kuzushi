// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】osmosm
// https://neort.io/art/bnh05sc3p9f5erb52t00
//

class GameSceneCongratulations137 extends GameSceneCongratulationsBase {
  Form[] forms;
  final int num = 80;
  color[] pallete = {#8465d3, #00c3e5, #fff200, #ff7716, #ff3f3f};
  PGraphics bg;

  PGraphics offScreen;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    offScreen = createGraphics(width, height);
    bg = createGraphics(width, height);
    bg.beginDraw();
    bg.noStroke();
    for (int i = 0; i < 400000; i++) {
      float x = random(width);
      float y = random(height);
      float s = random(1);
      bg.fill(185, 50);
      bg.rect(x, y, s, s);
    }
    bg.endDraw();
    forms = new Form[num];
    for (int i = 0; i < num; i++) {
      forms[i] = new Form();
    }
  }
  @Override void draw() {
    offScreen.beginDraw();
    offScreen.background(255);
    offScreen.rectMode(CENTER);
    for (int i = 0; i < forms.length; i++) {
      forms[i].run(offScreen);
    }
    offScreen.image(bg, 0, 0);
    offScreen.endDraw();
    image(offScreen, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  float easeOutElastic(float t, float b, float c, float d) {
    float s = 1.70158;
    float p = 0;
    float a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    //  if (!p) p = d * 0.3;
    if (p == 0.0) p = d * 0.3;
    if (a < abs(c)) {
      a = c;
      //    let s = p / 4.0f;
      s = p / 4.0f;
    } else s = p / (2 * PI) * asin(c / a);
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b;
  }

  float easeInOutExpo(float t, float b, float c, float d) {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2.0f) < 1) return c/2.0f * pow(2, 10 * (t - 1)) + b;
    return c/2.0f * (-pow(2, -10 * --t) + 2) + b;
  }

  class Form {
    float sttx;
    float stty;
    float x;
    float y;
    float tgtx;
    float tgty;
    float maxS;
    float sttw;
    float stth;
    float w;
    float h;
    float tgtw;
    float tgth;
    float sttt;
    float t0;
    float t1;
    float t;
    float stta;
    float angle;
    float tgta;
    color col;
    float offset;
    Form() {
      this.sttx = random(width);
      this.stty = random(height);
      this.x = this.sttx;
      this.y = this.stty;
      this.tgtx = random(width);
      this.tgty = random(height);
      this.maxS = width*0.15;
      this.sttw = random(0.1, 1) * this.maxS;
      this.stth = random(0.1, 1) * this.maxS;
      this.w = this.sttw;
      this.h = this.stth;
      this.tgtw = random(0.1, 1) * this.maxS;
      this.tgth = random(0.1, 1) * this.maxS;
      this.sttt = -20;
      this.t0 = 0;
      this.t1 = this.t0 + 150;
      this.t = this.sttt;
      this.stta = TAU * int(random(-1, 1) * 2);
      this.angle = this.stta;
      this.tgta = TAU * int(random(-1, 1) * 2);
      this.col = color(P5JSrandom(pallete));
      this.offset = 10;
    }

    void show(PGraphics p) {
      p.push();
      p.noStroke();
      p.fill(0, 100);
      p.translate(this.x + this.offset, this.y + this.offset);
      p.rotate(this.angle);
      p.rect(0, 0, this.w, this.h);
      p.pop();

      p.stroke(0);
      p.strokeWeight(0.5);
      p.fill(this.col);
      p.push();
      p.translate(this.x, this.y);
      p.rotate(this.angle);
      p.rect(0, 0, this.w, this.h);
      p.pop();
    }

    void move() {
      if (this.t0 < this.t && this.t < this.t1) {
        float mp = map(this.t, this.t0, this.t1 - 1, 0, 1);
        float easing1 = easeOutElastic(mp, 0, 1, 1);
        float easing2 = easeInOutExpo(mp, 0, 1, 1);

        this.x = lerp(this.sttx, this.tgtx, easing1);
        this.y = lerp(this.stty, this.tgty, easing1);
        this.w = lerp(this.sttw, this.tgtw, easing2);
        this.h = lerp(this.stth, this.tgth, easing2);
        this.angle = lerp(this.stta, this.tgta, easing2);
      }
      if (this.t > this.t1) {
        this.t = this.sttt;
        this.sttx = this.x;
        this.stty = this.y;
        this.sttw = this.w;
        this.stth = this.h;
        this.tgtx = random(width);
        this.tgty = random(height);
        this.tgtw = random(0.1, 1) * this.maxS;
        this.tgth = random(0.1, 1) * this.maxS;
      }
      this.t++;
    }

    void run(PGraphics p) {
      this.show(p);
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
