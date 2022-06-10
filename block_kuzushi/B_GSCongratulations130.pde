// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】巨躯なる怪異の却られた悲哀が軈ては天空
// https://neort.io/art/c71j43s3p9f3hsje8tl0
//
import java.util.LinkedList;

class GameSceneCongratulations130 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms;
  LinkedList<Integer> colors = new LinkedList();
  color bgCol;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    init();
  }
  @Override void draw() {
    background(bgCol);
    //  background(255, 50);
    fill(255, 50);
    rect(0, 0, width, height);

    for (Form f : forms) {
      f.run();
    }

    if (frameCount % 180 == 0) {
      init();
    }

    logoRightLower(color(255, 0, 0));
  }

  void init() {
    //  colors = ['#ed3441', '#ffb03b', '#ffd630', '#0d941d', '#36acf5', '#ff70a5', '#783508', '#E349E6', '#f2f2f2'];
    color[] colorSource = {#ed3441, #ffb03b, #ffd630, #0d941d, #36acf5, #ff70a5, #783508, #E349E6, #f2f2f2};

    for (color c : colorSource) {
      colors.add(c);
    }
    //  shuffle(colors, true);
    java.util.Collections.shuffle(colors);

    bgCol = colors.get(0);
    //  colors.splice(0, 1);
    colors.remove(0);

    forms = new ArrayList();
    ArrayList<PVector> pos = new ArrayList();
    for (int i = 0; i < 1000; i++) {
      float a = random(TAU);
      float d = random(15, 200);
      //      float r = random(width * 0.35);
      float r = random(height * 0.35);
      float x = width / 2.0f + r * cos(a);
      float y = height / 2.0f + r * sin(a);
      boolean add = true;
      for (int j = 0; j < pos.size(); j++) {
        PVector p = pos.get(j);
        if (dist(x, y, p.x, p.y) < (d + p.z) * 0.5) {
          add = false;
          break;
        }
      }
      if (add) {
        pos.add(new PVector(x, y, d));
      }
    }
    for (PVector p : pos) {
      forms.add(new Form(p.x, p.y, p.z));
    }
  }

  class Form {
    float x;
    float y;
    float w;
    float w1;
    float t;
    float tStep;
    color col1;
    color col2;
    float a;
    float a1;
    Form(float x, float y, float w) {
      this.x = x;
      this.y = y;
      this.w = 0;
      this.w1 = w;
      this.t = -random(0.5);
      this.tStep = 1 / 120.0f;
      //    this.col1 = random(colors);
      this.col1 = colors.get((int)random(colors.size()));
      //    this.col2 = random(colors);
      this.col2 = colors.get((int)random(colors.size()));
      while (this.col1 == this.col2) {
        //      this.col2 = random(colors);
        this.col2 = colors.get((int)random(colors.size()));
      }
      this.a = 0;
      this.a1 = random(-1, 1) * 2;
    }

    void show() {
      if (this.t >= 0) flower(this.x, this.y, this.w, this.a, this.col1, this.col2);
    }

    void move() {
      if (this.t >= 0) {
        this.w = lerp(0, this.w1, easeOutElastic(this.t));
        //      this.a = lerp(0, this.a1, this.t ** 0.1);
        this.a = lerp(0, this.a1, pow(this.t, 0.1));
      }
      if (this.t < 1) {
        this.t += this.tStep;
      }
    }

    void run() {
      this.show();
      this.move();
    }
  }

  float easeOutElastic(float x) {
    final float c4 = (2 * PI) / 3.0f;
    //return x === 0 ?
    //  0 :
    //  x === 1 ?
    //  1 :
    //  pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
    if (x == 0.0f) {
      return 0.0f;
    }
    if (x == 1.0f) {
      return 1.0f;
    }
    return pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
  }

  void flower(float x, float y, float w, float a, color c1, color c2) {
    push();
    translate(x, y);
    rotate(a);
    int num = 12;
    fill(c1);
    for (int i = 0; i < num; i++) {
      rotate(TAU / (float)num);
      ellipse(w * 0.32, 0, w * 0.35, (w / (float)num) * 1.8);
    }
    fill(c2);
    circle(0, 0, w * 0.4);
    pop();
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
