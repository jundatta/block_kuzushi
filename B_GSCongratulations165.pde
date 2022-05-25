// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bvitdek3p9f30ks55fl0?index=32&origin=user_like
//

class GameSceneCongratulations165 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  color[] colors = {#ef233c, #d5f2e3, #73ba9b, #003e1f, #d90429, #ffda33};
  PVector[] stars = new PVector[60];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    int w = 25;
    int n = 20;
    for (int i=0; i<n; i++) {
      int nn = int(map(i, 0, n, 0, 20));
      for (int j=0; j<nn; j++) {
        float x = (width * 0.5) - ((nn * w)/2.0f) + j * w;
        float y = (i * w * 1.25) + height * 0.05;
        forms.add(new Form(x, y));
      }
    }
    for (int i=0; i<stars.length; i++) {
      stars[i] = new PVector(random(width), random(height), random(1, 10));
    }
  }
  @Override void draw() {
    background(10);

    push();
    rectMode(CENTER);
    strokeWeight(1);
    for (PVector s : stars) {
      float alph = noise(frameCount * 0.01 * s.z, s.z, s.y)*255;
      stroke(255, alph);
      line(s.x + (s.z * 0.5), s.y, s.x - (s.z * 0.5), s.y);
      line(s.x, s.y + (s.z * 0.5), s.x, s.y - (s.z * 0.5));
    }

    for (Form f : forms) {
      f.run();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  class Form {
    float x;
    float y;
    color col;
    Okazz ss;
    Form(float x, float y) {
      this.x = x;
      this.y = y;
      this.setValues();
    }

    void run() {
      noFill();
      stroke(this.col);
      this.ss.run();
      if (this.ss.isDead()) {
        this.setValues();
      }
    }

    void setValues() {
      this.col = color(P5JSrandom(colors));
      int rnd = int(random(3));
      float s = random(10, 30);

      if (rnd == 0) {
        this.ss = new Circle(this.x, this.y, s);
      }
      if (rnd == 1) {
        this.ss = new Square(this.x, this.y, s);
      }
      if (rnd == 2) {
        this.ss = new Cross(this.x, this.y, s);
      }
    }
  }

  class Okazz {
    float x;
    float y;
    float s;
    float s0;
    float s1;
    float sw1;
    float sw;
    int t;
    int t1;
    int t2;
    float ang;
    Okazz(float x, float y, float s) {
      this.x = x;
      this.y = y;
      this.s = 0;
      this.s0 = s*0.5;
      this.s1 = s;
      this.sw1 = s * 0.5;
      this.sw = 1;
      this.t = int(random(-200));
      this.t1 = 80;
      this.t2 = 80 + this.t1;
      this.ang = int(random(2)) * PI * 0.25;
    }

    void move() {
      if (0 <= this.t && this.t < this.t2) {
        float  nrm = norm(this.t, 0, this.t1-1);
        this.s = lerp(0, this.s0, nrm);
        this.sw = lerp(1, this.sw1, nrm);
      }
      if (this.t1 <= this.t && this.t < this.t2) {
        float nrm = norm(this.t, this.t1, this.t2-1);
        this.s = lerp(this.s0, this.s1, nrm);
        this.sw = lerp(this.sw1, 0, nrm);
      }
      this.t ++;
    }

    boolean isDead() {
      return this.t > this.t2;
    }

    void run() {
      if (0 < this.t) {
        this.show();
      }
      this.move();
    }

    void show() {
    }
  }

  class Circle extends Okazz {
    Circle(float x, float y, float s) {
      super(x, y, s);
    }

    void show() {
      strokeWeight(this.sw);
      circle(this.x, this.y, this.s);
    }
  }

  class Square extends Okazz {
    Square(float x, float y, float s) {
      super(x, y, s);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      strokeWeight(this.sw);
      square(0, 0, this.s);
      pop();
    }
  }

  class Cross extends Okazz {
    Cross(float x, float y, float s) {
      super(x, y, s);
    }

    void show() {
      push();
      translate(this.x, this.y);
      rotate(this.ang);
      strokeWeight(this.sw);
      line(0 + this.s*0.5, 0, 0 - this.s*0.5, 0);
      line(0, 0 + this.s*0.5, 0, 0 - this.s*0.5);
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
