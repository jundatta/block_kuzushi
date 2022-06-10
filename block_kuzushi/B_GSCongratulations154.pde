// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】stjbb
// https://neort.io/art/c2oneac3p9f8s59bbv8g
//

class GameSceneCongratulations154 extends GameSceneCongratulationsBase {
  color[] colors = {#cf2b34, #f08f46, #f0c129, #196e94, #232323};
  ArrayList<Form> forms = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);


    int seg = 8;
    int w = height / seg;
    for (int i = 0; i < int(seg * 1.5); i++) {
      for (int j = 0; j < seg; j++) {
        int x = i * w + w/2;
        int y = j * w + w/2;
        color col = P5JSrandom(colors);
        forms.add(new Form(x, y, w - 10, col));
      }
    }
  }
  @Override void draw() {
    push();
    colorMode(HSB, 360, 100, 100, 100);
    rectMode(CENTER);
    background(0);
    for (Form f : forms) {
      stroke(0);
      // HSBなのにRGB？。。。謎
      //    fill(255);
      fill(0, 0, 100);
      rect(f.tx, f.ty, f.tw, f.tw);
      f.run();
      // (*•ω•*)
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  //-------------------------------------------

  class Form {
    int tx;
    int ty;
    int tw;
    float nScl;
    int t0;
    int t1;
    int t2;
    int t3;
    int dt;
    int t;

    int inRnd;
    int outRnd;
    color col;
    int alph;
    int x;
    int y;
    int w;
    int sx;
    int sy;
    int sw;
    Form(int x, int y, int w, color col) {
      this.tx = x;
      this.ty = y;
      this.tw = w+1;

      this.nScl = 0.003;

      this.rrr();

      this.t0 = 0;
      this.t1 = 40;
      this.t2 = this.t1 + 100;
      this.t3 = this.t2 + 40;
      this.dt = int(random(200));
      this.t = -this.dt;

      this.col = col;
    }

    void show() {
      // this.colを書き換えているように見えるが。。。謎
      //    this.col.setAlpha(this.alph);
      color c = color(this.col, this.alph);
      noStroke();
      fill(c);
      rect(this.x, this.y, this.w, this.w);
    }

    void move() {
      if (this.t0 <= this.t && this.t < this.t1) {
        float nrm = norm(this.t, this.t0, this.t1-1);
        if (this.inRnd == 0) {
          this.w = (int)lerp(0, this.tw, sqrt(nrm));
        } else if (this.inRnd == 1) {
          this.alph = (int)lerp(0, 100, sqrt(nrm));
        } else if (this.inRnd == 2) {
          this.w = (int)lerp(0, this.tw, sqrt(nrm));
          this.x = (int)lerp(this.sx, this.tx, sqrt(nrm));
          this.y = (int)lerp(this.sy, this.ty, sqrt(nrm));
        }
      } else if (this.t2 <= this.t && this.t < this.t3) {
        float nrm = norm(this.t, this.t2, this.t3-1);
        if (this.outRnd == 0) {
          this.w = (int)lerp(this.tw, 0, sqrt(nrm));
        } else if (this.outRnd == 1) {
          this.alph = (int)lerp(100, 0, sqrt(nrm));
        } else if (this.outRnd == 2) {
          this.w = (int)lerp(this.tw, 0, sqrt(nrm));
          this.x = (int)lerp(this.tx, this.sx, sqrt(nrm));
          this.y = (int)lerp(this.ty, this.sy, sqrt(nrm));
        }
      }
      if (this.t3 < this.t) {

        this.rrr();
        this.t = -this.dt;
      }
      this.t ++;
    }

    void rrr() {
      this.inRnd = int(random(3));
      this.outRnd = int(random(3));

      this.alph = 100;
      if (this.inRnd == 0) {
        this.x = this.tx;
        this.y = this.ty;
        this.w = 0;
      }
      if (this.inRnd == 1) {
        this.x = this.tx;
        this.y = this.ty;
        this.w = this.tw;
        this.alph = 0;
      }
      if (this.inRnd == 2) {
        this.sx = this.tx+(this.tw/2) * ((int(random(2))*2)-1);
        this.sy = this.ty+(this.tw/2) * ((int(random(2))*2)-1);
        this.sw = 0;
        this.x = this.sx;
        this.y = this.sy;
        this.w = this.sw;
        // this.alph = 0;
      }
      if (this.outRnd == 2) {
        this.sx = this.tx+(this.tw/2) * ((int(random(2))*2)-1);
        this.sy = this.ty+(this.tw/2) * ((int(random(2))*2)-1);
      }
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
