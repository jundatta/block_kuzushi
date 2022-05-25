// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】動きたくない
// https://neort.io/art/c43lglk3p9ffolj04kdg
//

class GameSceneCongratulations150 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  //let es = new p5.Ease();
  color[] colors = {#fe4a49, #fed766, #009fb7, #f0f0f0};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    //  pixelDensity(2);
    strokeWeight(4);
    int seg = 10;
    int w = width / seg;
    int h = height / seg;
    for (int i = 0; i < seg; i++) {
      for (int j = 0; j < seg; j++) {
        int x = i * w + w/2;
        int y = j * h + h/2;
        int rnd = int(random(5)+1);
        int off = 0;
        color col = P5JSrandom(colors);
        if (rnd == 1) {
          forms.add(new Form01(x, y, w - off, col));
        } else if (rnd == 2) {
          forms.add(new Form02(x, y, w - off, col));
        } else if (rnd == 3) {
          forms.add(new Form03(x, y, w - off, col));
        } else if (rnd == 4) {
          forms.add(new Form04(x, y, w - off, col));
        } else if (rnd == 5) {
          forms.add(new Form05(x, y, w - off, col));
        }
        // rect(x, y, w, w);
      }
    }
  }
  @Override void draw() {
    background(#0d2c54);
    push();
    rectMode(CENTER);
    for (Form f : forms) {
      f.run();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  class Form {
    int x;
    int y;
    int w;
    float ang;
    int t;
    int t1;
    color col;
    float d;
    Form(int x, int y, int w, color col) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.ang = int(random(4)) * TAU/4.0f;
      this.t = -int(random(1500));
      this.t1 = 30;
      this.col = col;
      this.d = this.w * random(0.1, 0.5);
    }
    void show() {
    }
    void move() {
    }
    void run() {
      this.show();
      this.move();
      if (this.t1 < this.t) {
        this.t = -int(random(1500));
      }
    }
  }

  //●
  class Form01 extends Form {
    float off;
    Form01(int x, int y, int w, color col) {
      super(x, y, w, col);
      this.off = 0;
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      noFill();
      stroke(this.col);
      circle(this.off, 0, this.d);
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float t = map(this.t, 0, this.t1-1, 0, TAU*6);
        this.off = sin(t)*this.w*0.01;
      }
      this.t ++;
    }
  }

  //~
  class Form02 extends Form {
    float a0;
    float a;
    float amp;
    float mo;
    Form02(int x, int y, int w, color col) {
      super(x, y, w, col);
      this.a0 = random(10);
      this.a = this.a0;
      this.t1 = 60;
      this.amp = this.w * random(0.1, 0.4);
      this.mo = random(0.05, 0.1);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      // line(0, this.w/2, 0, 0);
      // line(this.w/2, this.w/2, -this.w/2, this.w/2);
      // line(this.w/2, -this.w/2, -this.w/2, -this.w/2);
      noFill();
      stroke(this.col);
      beginShape();
      for (int y=-this.w/2; y<this.w/2; y++) {
        vertex(sin((y*this.mo)+this.a) * this.amp, y);
      }
      endShape();
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1 - 1);
        // this.a += (1 / (this.t1-1))*TAU;
        //      this.a = lerp(0, TAU, es.quadraticInOut(nrm))+this.a0;
        this.a = lerp(0, TAU, easeInOutQuad(nrm))+this.a0;
      }

      this.t ++;
    }
  }

  //□
  class Form03 extends Form {
    float aa;
    int pn;
    float ww;
    Form03(int x, int y, int w, color col) {
      super(x, y, w, col);
      this.t1 = 40;
      this.aa = 0;
      this.pn = random(1)<0.5 ? -1 : 1;
      this.ww = this.w* random(0.1, 0.8);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang+this.aa);
      noFill();
      stroke(this.col);
      //    square(0, 0, this.ww, this.ww*0.05);
      rect(0, 0, this.ww, this.ww, this.ww*0.05);
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1 - 1);
        // this.aa = lerp(0, PI, (sin(nrm*PI*0.5)+1)/2)*this.pn;
        //      this.aa = lerp(0, PI*0.5, es.backInOut(nrm))*this.pn;
        this.aa = lerp(0, PI*0.5, easeInOutBack(nrm))*this.pn;
      }

      if (this.t1 < this.t) {
        this.pn = random(1) < 0.5 ? -1 : 1;
      }
      this.t ++;
    }
  }

  //×
  class Form04 extends Form {
    float ll0;
    float ll;
    Form04(int x, int y, int w, color col) {
      super(x, y, w, col);
      this.ll0 = this.w*random(0.1, 0.45);
      this.ll = this.ll0;
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      // fill(255);
      noFill();
      stroke(this.col);
      // line(-this.ll0/2, -this.ll0/2, -this.ll0/2 + this.ll, -this.ll0/2 + this.ll);
      // line(-this.ll0/2, this.ll0/2, -this.ll0/2 + this.ll, this.ll0/2 - this.ll);
      line(this.ll/2, this.ll/2, -this.ll/2, -this.ll/2);
      line(-this.ll0/2, this.ll0/2, this.ll0/2, -this.ll0/2);
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1 - 1);
        //      this.ll = lerp(this.ll0, 0, es.quadraticIn(sin((1-nrm)*PI)));
        this.ll = lerp(this.ll0, 0, easeInQuad(sin((1-nrm)*PI)));
      }

      this.t ++;
    }
  }

  //…
  class Form05 extends Form {
    int num;
    float d0;
    float aa;
    Form05(int x, int y, int w, color col) {
      super(x, y, w, col);
      this.num = int(random(5, 10));
      this.d *= 2;
      this.d0 = this.d;
      this.aa = 0;
      this.t1 = 50;
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang+this.aa);
      stroke(this.col);
      for (int i=0; i<this.num; i++) {
        float a = map(i, 0, this.num, 0, TAU);
        point(this.d * 0.5 * cos(a), this.d * 0.5 * sin(a));
      }
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1 - 1);
        //      this.d = lerp(this.d0, 0, es.quadraticIn(sin((1-nrm)*PI)));
        this.d = lerp(this.d0, 0, easeInQuad(sin((1-nrm)*PI)));
        this.aa = lerp(0, TAU, nrm);
      }

      this.t ++;
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
