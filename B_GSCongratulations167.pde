// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bvarqsc3p9f7gigeefs0?index=30&origin=user_like
//

class GameSceneCongratulations167 extends GameSceneCongratulationsBase {
  color[] colors = {#471284, #ca1128, #f54397, #18205e, #094f94};
  ArrayList<Form> forms = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    //  smooth(8);
    noStroke();
    addFomrs();
  }
  @Override void draw() {
    background(255);
    for (int i = 0; i < forms.size(); i++) {
      forms.get(i).run();
    }
    if (frameCount % (60 * 5) == 0) {
      //forms.length = 0;
      forms.clear();
      addFomrs();
    }

    logoRightLower(color(255, 0, 0));
  }

  void addFomrs() {
    float cx = width / 2;
    float cy = height / 2;
    ArrayList<PVector> points = new ArrayList();
    float count = 10000;
    for (int i = 0; i < count; i++) {
      float a = random(TAU);
      float d = random(width * 0.7);
      float x = cx + cos(a) * d;
      float y = cy + sin(a) * d;
      float s = random(10, 400);
      boolean add = true;
      for (int j = 0; j < points.size(); j++) {
        PVector p = points.get(j);
        if (dist(x, y, p.x, p.y) < (s + p.z) * 0.5) {
          add = false;
          break;
        }
      }
      if (add) {
        points.add(new PVector(x, y, s));
      }
    }
    for (int i = 0; i < points.size(); i++) {
      PVector p = points.get(i);
      forms.add(new Form(p.x, p.y, p.z));
    }
  }

  float easeOutElastic(float t) {
    float s = 1.70158;
    //  float p = 0;
    float p = 0.3;
    float a = 1;
    if (t == 0) return 0;
    if ((t /= 1) == 1) return 1;
    //  if (!p) p = 0.3;
    if (a < abs(1)) {
      a = 1;
      s = p / 4.0f;
    } else s = p / (2 * PI) * asin(1 / a);
    return a * pow(2, -10 * t) * sin((t * 1 - s) * (2 * PI) / p) + 1;
  }

  class Form {
    float x0;
    float y0;
    float d0;
    float x;
    float y;
    float d;
    float x1;
    float y1;
    float d1;
    color col;
    float alph;
    float len1;
    float len2;
    int t;
    int t1;
    int t2;
    int t3;
    int t4;
    Form(float x, float y, float d) {
      this.x0 = width / 2;
      this.y0 = height / 2;
      this.d0 = 0;
      this.x = this.x0;
      this.y = this.y0;
      this.d = this.d0;
      this.x1 = x;
      this.y1 = y;
      this.d1 = d;
      this.col = color(P5JSrandom(colors));
      this.alph = random(150, 255);
      //    this.col.setAlpha(this.alph);
      this.col = color(red(this.col), green(this.col), blue(this.col), this.alph);
      this.len1 = d / 2.0f;
      this.len2 = 0;
      int tst = int(random(20, 80));
      this.t = -tst;
      this.t1 = 200;
      this.t2 = this.t1 + 10;
      this.t3 = this.t2 + 5;
      this.t4 = this.t3 + 5;
    }

    void show() {
      fill(this.col);
      noStroke();
      circle(this.x, this.y, this.d);
      if (this.t3 <= this.t && this.t < this.t4) {
        stroke(this.col);
        line(this.x + this.len1, this.y, this.x + this.len2, this.y);
        line(this.x - this.len1, this.y, this.x - this.len2, this.y);
        line(this.x, this.y + this.len1, this.x, this.y + this.len2);
        line(this.x, this.y - this.len1, this.x, this.y - this.len2);
      }
    }

    void move() {
      if ((0 <= this.t) && (this.t < this.t1)) {
        float nor = norm(this.t, 0, this.t1 - 1);
        float ease = easeOutElastic(nor);
        this.x = lerp(this.x0, this.x1, ease);
        this.y = lerp(this.y0, this.y1, ease);
        this.d = lerp(this.d0, this.d1, ease);
      } else if (this.t2 <= this.t && this.t < this.t3) {
        float nor = norm(this.t, this.t2, this.t3 - 1);
        this.d = lerp(this.d1, 0, nor);
      }
      if (this.t3 <= this.t && this.t < this.t4) {
        float nor = norm(this.t, this.t3, this.t4 - 1);
        this.len2 = lerp(0, this.len1, nor);
      }
      this.t++;
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
