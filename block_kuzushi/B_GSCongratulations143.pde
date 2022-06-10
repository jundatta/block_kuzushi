// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】スピード
// https://neort.io/art/c4kblfc3p9ffolj06p00
//

import java.util.LinkedList;

class GameSceneCongratulations143 extends GameSceneCongratulationsBase {
  color[] colors = {#533d8d, #024a96, #0277ba, #199ed7, #48c7eb, #f2f2f0, #f8d252};
  final int seg = 6;
  Form[] forms = new Form[seg * seg];
  PGraphics[] circleGrfx = new PGraphics[seg * seg];
  int wdt;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);

    imageMode(CENTER);

    if (width < height) {
      wdt = int(height * 1.0);
    } else {
      wdt = int(width * 1.0);
    }
    int w = wdt / seg;
    for (int i = 0; i < circleGrfx.length; i++) {
      circleGrfx[i] = createGrfx(w*3, 0);
      if (i == 0) {
        PGraphics pg = circleGrfx[i];
      }
    }
    for (int i = 0; i < seg; i++) {
      for (int j = 0; j < seg; j++) {
        int x = i * w + w / 2;
        int y = j * w + w / 2;
        forms[i*seg+j] = new Form(x, y, w);
      }
    }
    //  shuffle(forms, true);
    LinkedList<Form> formList = new LinkedList();
    for (Form f : forms) {
      formList.add(f);
    }
    java.util.Collections.shuffle(formList);
    for (int i = 0; i < formList.size(); i++) {
      forms[i] = formList.get(i);
    }
  }
  @Override void draw() {
    translate((width - wdt) / 2, (height - wdt) / 2);
    background(28);
    for (Form f : forms) {
      f.run((width - wdt) / 2, (height - wdt) / 2);
    }

    logoRightLower(color(255, 0, 0));
  }

  PGraphics createGrfx(int w, int t) {
    // よくはわかりゃんが奇数になるとふち？の線がでるので偶数にした
    if (w % 2 != 0) {
      w++;
    }
    PGraphics pg = createGraphics(w, w);
    float hw = w / 2.0f;
    int rnd = int(random(3));
    pg.beginDraw();
    pg.rectMode(CENTER);

    //  pg.shuffle(colors, true);
    LinkedList<Integer> colorList = new LinkedList();
    for (color c : colors) {
      colorList.add(c);
    }
    java.util.Collections.shuffle(colorList);
    for (int i = 0; i < colorList.size(); i++) {
      colors[i] = colorList.get(i);
    }

    pg.background(colors[0]);
    pg.push();
    pg.translate(hw, hw);
    pg.noStroke();

    if (rnd == 0) {
      for (int i = 0; i < 4; i++) {
        pg.rotate(PI * 0.5);
        pg.fill(colors[1 + i]);
        pg.triangle(0, 0, w * 0.25, w * 0.5, -w * 0.25, w * 0.5);
      }
    } else if (rnd == 1) {
      int c = int(random(10, 15));
      int ww = w / c;
      for (int i = 0; i < c; i++) {
        for (int j = 0; j < c; j++) {
          int xx = i * ww - w / 2;
          int yy = j * ww - w / 2;
          if ((i + j) % 2 == 0) {
            pg.fill(colors[1]);
            pg.circle(xx + ww / 2, yy + ww / 2, ww);
          }
        }
      }
    } else if (rnd == 2) {
      int c = int(random(2, 7));
      int ww = w / c;
      for (int i = 0; i < c; i++) {
        for (int j = 0; j < c; j++) {
          int xx = i * ww - w / 2;
          int yy = j * ww - w / 2;
          if ((i + j) % 2 == 0) {
            pg.fill(colors[1]);
            pg.square(xx + ww / 2, yy + ww / 2, ww);
          }
        }
      }
    }
    pg.stroke(0);
    if (t == 0) {
      float r = hw;
      //    pg.erase();
      PGraphics mask = createGraphics(w, w);
      mask.beginDraw();
      mask.background(255);
      mask.translate(w/2, w/2);
      mask.noStroke();
      mask.fill(0);
      mask.beginShape();
      mask.vertex(-hw, -hw);
      mask.vertex(-hw, hw);
      mask.vertex(hw, hw);
      mask.vertex(hw, -hw);
      mask.beginContour();
      for (float a = 0; a < TAU; a += TAU / 360.0f) {
        mask.vertex(r * cos(a), r * sin(a));
      }
      mask.endContour();
      mask.endShape();
      mask.endDraw();
      pg.mask(mask);
    }
    pg.pop();
    pg.endDraw();
    return pg;
  }

  float easeInOutCubic(float t) {
    if ((t /= 1 / 2.0f) < 1) return 1 / 2.0f * t * t * t;
    return 1 / 2.0f * ((t -= 2) * t * t + 2);
  }

  class Form {
    int x;
    int y;
    PGraphics grfx2;
    float a;
    float w0;
    float w;
    int t;
    int t1;
    int nsk;
    int pom;
    int rnd;
    float w1;
    float w2;
    Form(int x, int y, int w) {
      this.x = x;
      this.y = y;
      this.grfx2 = P5JSrandom(circleGrfx);
      this.a = 0;
      this.w0 = w;
      this.w = this.w0 * 0.5 * int(random(4) + 1);
      this.init();
    }
    void show(int originX, int originY) {
      push();
      translate(this.x + originX, this.y + originY);
      rotate(this.a);
      //    image(this.grfx2, originX, originY, this.w, this.w);
      image(this.grfx2, 0, 0, this.w, this.w);
      pop();
    }

    void move() {
      if (0 <= this.t && this.t < this.t1) {
        float nrm = norm(this.t, 0, this.t1 - 1);
        if (this.rnd == 0) this.a = lerp(0, TAU * this.nsk * this.pom, easeInOutCubic(nrm));
        if (this.rnd == 1) this.w = lerp(this.w1, this.w2, easeInOutCubic(nrm));
      }
      if (this.t1 < this.t) {
        this.init();
      }
      this.t++;
    }

    void init() {
      this.t = -int(random(0));
      this.t1 = int(random(60, 200));
      this.nsk = int(random(1, 4));
      this.pom = random(1) < 0.5 ? -1 : 1;
      this.rnd = int(random(2));
      this.w1 = this.w;
      this.w2 = this.w0 * 0.5 * int(random(4) + 1);
    }

    void run(int originX, int originY) {
      this.show(originX, originY);
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
