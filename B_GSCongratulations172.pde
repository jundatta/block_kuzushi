// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bnn9ip43p9f5erb53hn0?index=26&origin=user_like
//

class GameSceneCongratulations172 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  color[] pallete = {#ffbe0b, #fb5607, #ff006e, #8338ec, #3a86ff};
  int count;
  ArrayList<Particle> p = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    newForm();
    background(0);
  }
  @Override void draw() {
    push();
    rectMode(CENTER);
    background(0);
    for (int i=0; i<forms.size(); i++) {
      forms.get(i).run();
    }

    for (int i=0; i<p.size(); i++) {
      p.get(i).show();
      p.get(i).move();
    }

    if (frameCount%(60*20) == 0) {
      newForm();
    }
    pop();

    logoRightLower(#ff0000);
  }


  void newForm() {
    float w = width*0.75;
    //float h = w;
    float h = height*0.75;
    float x = (width-w)/2.0f;
    float y = (height-h)/2.0f;
    float min = (w+h)*0.04;

    count = 0;
    //forms.length = 0;
    forms.clear();
    //p.length = 0;
    p.clear();
    rectRec(x, y, w, h, min);
  }

  void rectRec(float x_, float y_, float w_, float h_, float min) {
    int c1 = int(random(2, 4));
    int c2 = int(random(2, 4));
    float w = w_/(float)c1;
    float h = h_/(float)c2;

    for (int i=0; i<c1; i++) {
      for (int j=0; j<c2; j++) {
        float x = x_+i*w;
        float y = y_+j*h;
        if (random(1) < 0.8 && w > min && h > min && 0 < min) {
          // オリジナルはminが指定されていない
          // これを見分けるために-1.0fを渡すように改造した
          rectRec(x, y, w, h, -1.0f);
        } else {
          forms.add(new Form(x + w/2.0f, y+h/2.0f, w, h));
          count ++;
        }
      }
    }
  }

  //----------------------------------------------------------------------

  class Form {
    float x, y, w, h, w0, h0;
    color col, fCol;
    int t, t0, t1, t2;
    Form(float x, float y, float w, float h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.w0 = w;
      this.h0 = h;
      this.col = color(P5JSrandom(pallete));
      this.fCol = this.col;
      this.t = -int(random(1000));
      this.t0 = 0;
      this.t1 = this.t0+30;
      this.t2 = this.t1+100;
      this.addPoints();
    }

    void show() {
      noStroke();
      fill(this.fCol);
      rect(this.x, this.y, this.w, this.h, (this.w+this.h)*0.05);
    }

    void move() {
      if (this.t0 < this.t && this.t < this.t1) {
        float amt = map(this.t, this.t0, this.t1-1, 0, 1);
        float ease = this.easeInQuart(amt);
        this.w = lerp(this.w0, 0, ease);
        this.h = lerp(this.h0, 0, ease);
      }
      this.t ++;
    }

    float easeInQuart(float t) {
      return t*t*t*t;
    }

    void addPoints() {
      int count = 20;
      for (int i=0; i<count; i++) {
        p.add(new Particle(this.x, this.y, this.fCol, this.t1, this.t2, this.t));
      }
    }

    void run() {
      this.show();
      this.move();
    }
  }

  //----------------------------------------------------------------------

  class Particle {
    PVector pos;
    color col;
    int t0, t1, t;
    float maxSize, size;
    float rnd;

    Particle(float x, float y, color col, int start, int end, int current) {
      this.pos = new PVector(x, y);
      this.col = col;
      this.t0 = start;
      this.t1 = end;
      this.t = current;
      this.maxSize = random(20);
      this.size = this.maxSize;
      this.rnd = random(10);
    }

    void show() {
      fill(this.col);
      noStroke();
      ellipse(this.pos.x, this.pos.y, this.size, this.size);
    }

    void move() {
      if (this.t0 < this.t && this.t < this.t1) {
        float  angle = noise(this.pos.x*0.01, this.pos.y*0.01, this.rnd)*20;
        this.pos.x += cos(angle)*0.7;
        this.pos.y += sin(angle)*0.7;
        this.size = map(this.t, this.t0, this.t1, this.maxSize, 0);
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
