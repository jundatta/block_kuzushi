// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bvm480k3p9f30ks5625g?index=34&origin=user_like
//

class GameSceneCongratulations163 extends GameSceneCongratulationsBase {
  Bomb[] bombs = new Bomb[20];
  color[] colors = {#f20c0c, #ffaa00, #f2f20c, #0cf259, #0ca6f2, #590cf2, #f20ca6};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    strokeWeight(2);
    for (int i = 0; i < bombs.length; i++) {
      bombs[i] = new Bomb();
    }
  }
  @Override void draw() {
    //  background(0, 100);
    fill(0, 0, 0, 50);
    rect(0, 0, width, height);
    push();
    rectMode(CENTER);
    for (Bomb b : bombs) {
      b.run();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  float easeInQuint(float t) {
    return t * t * t * t * t;
  }

  float easeOutQuint(float t) {
    return 1 + (--t) * t * t * t * t;
  }

  float easeInCubic(float t) {
    return t * t * t;
  }

  float easeOutCubic(float t) {
    return (--t) * t * t + 1;
  }

  class Bomb {
    ArrayList<Okazz> forms;
    Bomb() {
      this.forms = new ArrayList();
      this.setValues();
    }

    void run() {
      for (Okazz f : this.forms) {
        stroke(255);
        f.run();
      }
      if (this.forms.get(0).isDead()) {
        //      this.forms.length = 0;
        this.forms.clear();
        this.setValues();
      }
    }

    void setValues() {
      float x = random(-0.1, 1.1) * width;
      float y = random(-0.1, 1.1) * height;
      float s = random(10, 100);
      int t = -int(random(100));
      int t1 = int(random(60, 150));
      int num = int(random(6, 23));
      float aa = random(10);
      int rnd = int(random(4));
      color col = color(P5JSrandom(colors));
      for (float a = 0; a < TAU; a += (TAU / num)) {
        if (rnd == 0) this.forms.add(new Form01(x, y, s, a + aa, t, t1, col));
        if (rnd == 3) this.forms.add(new Form04(x, y, s, a + aa, t, t1, col));
      }
      if (rnd == 1) this.forms.add(new Form02(x, y, s, aa, t, t1, col));
      if (rnd == 2) this.forms.add(new Form03(x, y, s, aa, t, t1, col));
    }
  }

  class Okazz {
    float x;
    float y;
    float len;
    float l1;
    float l2;
    float t;
    float t1;
    float ang;
    color col;
    Okazz(float x, float y, float l, float a, float t, float t1, color col) {
      this.x = x;
      this.y = y;
      this.len = l;
      this.l1 = 0;
      this.l2 = 0;
      this.t = t;
      this.t1 = t1;
      this.ang = a;
      this.col = col;
    }
    void move() {
      if (0 < this.t) {
        float nrm = norm(this.t, 0, this.t1);
        this.l1 = lerp(0, this.len, easeOutCubic(nrm));
        this.l2 = lerp(0, this.len, easeInCubic(nrm));
      }
      this.t++;
    }
    void show() {
    }
    void run() {
      if (0 < this.t) this.show();
      this.move();
    }
    boolean isDead() {
      if (this.t > this.t1) return true;
      return false;
    }
  }

  class Form01 extends Okazz {
    Form01(float x, float y, float l, float a, float t, float t1, color col) {
      super(x, y, l, a, t, t1, col);
    }
    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      stroke(this.col);

      line(this.l1, 0, this.l2, 0);
      pop();
    }
  }

  class Form02 extends Okazz {
    Form02(float x, float y, float l, float a, float t, float t1, color col) {
      super(x, y, l, a, t, t1, col);
    }

    void show() {
      push();
      translate(this.x, this.y);

      noFill();
      stroke(this.col);

      circle(0, 0, this.l1 * 2);
      circle(0, 0, this.l2 * 2);

      pop();
    }
  }

  class Form03 extends Okazz {
    Form03(float x, float y, float l, float a, float t, float t1, color col) {
      super(x, y, l, a, t, t1, col);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      noFill();
      stroke(this.col);
      square(0, 0, this.l1 * 2);
      square(0, 0, this.l2 * 2);
      pop();
    }
  }

  class Form04 extends Okazz {
    Form04(float x, float y, float l, float a, float t, float t1, color col) {
      super(x, y, l, a, t, t1, col);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      noStroke();
      fill(this.col);
      circle(this.l1, 0, 5);
      circle(this.l2, 0, 5);
      pop();
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
