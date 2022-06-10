// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】hanabi
// https://neort.io/art/c46haa43p9ffolj050tg
//

class GameSceneCongratulations148 extends GameSceneCongratulationsBase {
  ArrayList<Pachi> pc = new ArrayList();
  ArrayList<Shun> sn = new ArrayList();
  color[] colors = {#34bcd1, #ffe042, #ff6397, #f48158, #ffffff, #5fefc9};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i=0; i<30; i++) {
      int num = int(random(1, 4));
      float x = P5JS.randomGaussian(0.5, 0.2)*width;
      float y = P5JS.randomGaussian(0.5, 0.2)*height;
      for (int j=0; j<num; j++) {
        pc.add(new Pachi(x, y, random(50, 300), P5JSrandom(colors)));
      }
      if (random(1)<0.5) {
        sn.add(new Shun(P5JSrandom(colors)));
      }
    }
  }
  @Override void draw() {
    background(#09194c);

    for (Shun s : sn) {
      s.run();
    }

    for (Pachi p : pc) {
      p.run();
    }

    logoRightLower(color(255, 0, 0));
  }

  class Okazz {
    color col;

    int tSpn;
    int t;
    int t1;
    Okazz(color col) {
      this.col = col;
      this.tSpn = int(random(100));
      this.t = -this.tSpn;
      this.t1 = int(random(40, 90));
    }
    void show() {
    }
    void move() {
    }
    void run() {
      if (0<this.t && this.t < this.t1) {
        this.show();
      }
      this.move();
    }
  }

  class Pachi extends Okazz {
    float cx;
    float cy;
    float r1;
    float r;
    int num;
    float ps;
    float ps0;
    color col;
    int ang;
    Pachi(float x, float y, float s, color col) {
      super(col);
      this.cx = x;
      this.cy = y;
      this.r1 = s/2.0f;
      this.r = 0;
      this.num = int(random(5, 21));
      this.ps = s * random(0.05, 0.1);
      this.ps0 = this.ps;
      this.col = col;
      // this.t1 = 60;
      this.ang = int(random(2021));
    }

    void show() {
      push();
      translate(this.cx, this.cy);
      rotate(this.ang);
      fill(this.col);
      noStroke();
      for (int i=0; i<this.num; i++) {
        float theta = map(i, 0, this.num, 0, TAU);
        float x = this.r * cos(theta);
        float y = this.r * sin(theta);
        // circle(x, y, this.ps);
        push();
        translate(x, y);
        rotate(theta);
        ellipse(0, 0, this.ps, this.ps*0.5);
        pop();
      }
      pop();
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1-1);
        this.r = lerp(0, this.r1, pow(nrm, 0.3));
        this.ps = lerp(this.ps0, 0, nrm);
      }
      this.t ++;
      if (this.t > 70) {
        this.t = - this.tSpn - ((50 - this.tSpn));
      }
    }
  }

  class Shun extends Okazz {
    float sx;
    float sy;
    float ex;
    float ey;
    float x1;
    float y1;
    float x2;
    float y2;
    float sw;
    Shun(color col) {
      //    super();
      super(col);
      this.sx = random(-0.1, 1.1)*width;
      this.sy = random(-0.1, 1.1)*width;
      this.ex = random(-0.1, 1.1)*width;
      this.ey = random(-0.1, 1.1)*width;
      this.x1 = this.sx;
      this.y1 = this.sy;
      this.x2 = this.sx;
      this.y2 = this.sy;
      this.sw = random(1, 5);
      this.t1 *= 0.5;
    }

    void show() {
      strokeWeight(this.sw);
      stroke(this.col);
      line(this.x1, this.y1, this.x2, this.y2);
    }

    void move() {
      if (0 < this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1-1);
        this.x1 = lerp(this.sx, this.ex, pow(nrm, 2));
        this.x2 = lerp(this.sx, this.ex, pow(nrm, 0.5));
        this.y1 = lerp(this.sy, this.ey, pow(nrm, 2));
        this.y2 = lerp(this.sy, this.ey, pow(nrm, 0.5));
      }
      this.t ++;
      if (this.t > 70) {
        this.t = - this.tSpn - ((50 - this.tSpn));
      }
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
