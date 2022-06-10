// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Okazzさん
// 【作品名】Abstraction
// https://openprocessing.org/sketch/798278
//

class GameSceneCongratulations75 extends GameSceneCongratulationsBase {
  color[] pallete = { #b80c09, #0b4f6c, #01baef, #fbfbff, #040f16 };
  PGraphics bg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    bg = createGraphics(width, height);
    bg.beginDraw();
    bg.noStroke();
    for (int i = 0; i < 400000; i++) {
      float x = random(width);
      float y = random(height);
      float s = random(1);
      bg.fill(185, 50);
      bg.rect(x, y, s, s);
    }
    bg.endDraw();
  }
  @Override void draw() {
    randomSeed(0);
    ArrayList<PVector> points = new ArrayList();
    float maxd = 300;

    background(#EDEFFF);

    while (points.size() < 20) {
      float d = random(60, 500);
      float x = random(width);
      float y = random(height);
      PVector v = new PVector(x, y, d);

      int i;
      for (i = 0; i < points.size(); i++) {
        PVector p = points.get(i);
        if (dist(v.x, v.y, p.x, p.y) < (v.z + p.z / 2.0f)) {
          break;
        }
      }
      if (i == points.size()) {
        points.add(v);
      }
    }

    for (int i = 0; i < points.size(); i++) {
      PVector p1 = points.get(i);
      for (int j = 0; j < points.size(); j++) {
        PVector p2 = points.get(j);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        if (p1 != p2 && d <= maxd) {
          stroke(0, 230);
          strokeWeight(0.5);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }

    for (int i = 0; i < points.size(); i++) {
      PVector p = points.get(i);
      form(p.x, p.y, p.z);
    }

    image(bg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }
  void form(float x, float y, float s) {
    for (int j = 0; j < 10; j++) {
      float l = random(s / 2.0f);
      float d = s * random(0.01, 0.10);
      int c = int(random(100, 1000));
      color col = P5JSrandom(pallete);

      push();
      translate(x, y);
      rotate(random(TAU));
      noStroke();
      fill(col);
      for (int i = 0; i < c; i++) {
        float dd = map(i, 0, c, 0, d);
        rotate(radians(0.5));
        ellipse(l, 0, dd, dd);
      }
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
