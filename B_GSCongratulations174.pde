// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】ctttc
// https://neort.io/art/bnhj08k3p9f5erb52u1g
//

class GameSceneCongratulations174 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  color[] pallete = {#390099, #9e0059, #ff0054, #ff5400, #ffbd00};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    newForm();
  }
  @Override void draw() {
    background(255);
    for (Form f : forms) {
      f.run();
    }

    if (frameCount % (60 * 6) == 0) {
      //forms.length = 0;
      forms.clear();
      newForm();
    }

    logoRightLower(#ff0000);
  }


  void newForm() {
    int c = 10;
    float w = height / (float)c;
    float[] gx = new float[20];
    float[] gy = new float[gx.length];
    float[] gs = new float[gx.length];
    color[] col = new color[gx.length];

    for (int i=0; i<gx.length; i++) {
      gx[i] = random(width);
      gy[i] = random(height);
      gs[i] = random(50, 400);
      col[i] = color(P5JSrandom(pallete));
    }

    for (int i = 0; i < c; i++) {
      for (int j = 0; j < c; j++) {
        float x = i * w;
        float y = j * w;
        PGraphics g = createGraphics((int)w, (int)w);
        g.beginDraw();
        g.noStroke();
        for (int k = 0; k<gx.length; k++) {
          //col[k].setAlpha(20);
          color clr = color(col[k], 20);
          g.fill(clr);
          for (int d=0; d<gs[k]; d++) {
            g.ellipse(gx[k]-x, gy[k]-y, d, d);
          }
        }
        g.endDraw();
        forms.add(new Form(x, y, w, g));
      }
    }
  }

  float myRandom() {
    float rnd = random(1);
    if (rnd < 0.5) {
      return -1;
    }
    return 1;
  }

  float easeInOutCirc(float t, float b, float c, float d) {
    if ((t/=d/2.0f) < 1) return -c/2.0f * (sqrt(1 - t*t) - 1) + b;
    return c/2.0f * (sqrt(1 - (t-=2)*t) + 1) + b;
  }

  class Form {
    int maxLen;
    float s;
    float offsetX, offsetY;
    float x0, y0, x, y, x1, y1;
    int sttt, t, t0, t1, t2, t3;
    PGraphics g;

    Form(float x, float y, float s, PGraphics g) {
      this.maxLen = 10;
      this.s = s;
      this.offsetX = s * int(random(1, this.maxLen)) * myRandom();
      this.offsetY = s * int(random(1, this.maxLen)) * myRandom();
      if (random(1) < 0.5) {
        this.x0 = x + this.offsetX;
        this.y0 = y;
      } else {
        this.x0 = x;
        this.y0 = y + this.offsetY;
      }
      this.x = this.x0;
      this.y = this.y0;
      this.x1 = x;
      this.y1 = y;
      this.sttt = 200;
      this.t = -int(random(this.sttt));
      this.t0 = 0;
      this.t1 = 100;
      this.t2 = this.t1 + 50 + (this.sttt + this.t);
      this.t3 = this.t2 + 50;
      this.g = g;
    }

    void show() {
      image(this.g, this.x, this.y);
    }

    void move() {
      if (this.t0 < this.t && this.t < this.t1) {
        float mp = map(this.t, this.t0, this.t1-1, 0, 1);
        float easing = easeInOutCirc(mp, 0, 1, 1);
        this.x = lerp(this.x0, this.x1, easing);
        this.y = lerp(this.y0, this.y1, easing);
      }
      this.t ++;
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
