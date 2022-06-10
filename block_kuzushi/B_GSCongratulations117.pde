// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】ikeryouさん
// 【作品名】sketch_21_12_15
// https://neort.io/art/c6so9vc3p9f3hsje6sjg
//

class GameSceneCongratulations117 extends GameSceneCongratulationsBase {
  float sw;
  float sh = sw * 1.5;
  float weight = 0;
  float speed;
  float interval = 0;
  color[] colors = new color[200*3];
  Item[] items = new Item[25];

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    sw = height;
    sh = sw * 1.5;

    speed = random(1.5, 3);
    interval = random(10, 30);

    final color colA = color(random(255), random(255), random(255));
    final color colB = color(random(255), random(255), random(255));
    final color colC = color(random(255), random(255), random(255));
    for (int i = 0; i < colors.length/3; i++) {
      colors[i*3+0] = lerpColor(colA, colB, random(1));
      colors[i*3+1] = lerpColor(colB, colC, random(1));
      colors[i*3+2] = lerpColor(colC, colA, random(1));
    }

    pg = createGraphics(width, height);

    final int num = items.length;
    weight = (sh / num) * 0.9;

    for (int i = 0; i < num; i++) {
      items[i] = new Item(i, 0, (sh / (float)(num - 1)) * i);
    }
  }
  @Override void draw() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    pg.background(0);

    pg.noFill();
    pg.strokeCap(ROUND);
    pg.strokeJoin(ROUND);
    pg.stroke(255);

    pg.clear();
    pg.background(colors[0]);

    pg.translate(sh * 0.5, sw * 0.4);
    pg.rotate(radians(65));

    for (Item i : items) {
      i.update(pg);
    }
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  class Item {
    int id;
    float x;
    float y;
    float ang;
    float noise;
    color col;
    color col2;

    Item(int id, float x, float y) {
      this.id = id;
      this.x = x - sw * 0.5;
      this.y = y - sw * 0.5;
      this.ang = this.id * interval;
      this.noise = random(0, 1);
      this.col = P5JSrandom(colors);
      this.col2 = P5JSrandom(colors);
    }

    void update(PGraphics pg) {
      float w = map(sin(radians(this.ang)), -1, 1, 0, sw);
      float cx = (sw * 0.5) + sin(radians(this.ang)) * w * 0.4;
      float offset = 3;

      pg.noFill();
      pg.strokeWeight(weight);
      pg.stroke(0);
      pg.line(this.x + cx - offset, this.y + offset, this.x + w - offset, this.y + offset);
      pg.stroke(this.col);
      pg.line(this.x + cx, this.y, this.x + w, this.y);
      this.ang -= speed;

      pg.noStroke();
      pg.fill(0);
      offset *= 0.5;
      pg.circle(this.x + cx - offset, this.y + offset, weight * 0.5);
      pg.fill(this.col2);
      pg.circle(this.x + cx, this.y, weight * 0.5);

      pg.noStroke();
      pg.fill(0);
      offset *= 0.5;
      pg.circle(this.x + cx - offset, this.y + offset, weight * 0.15);
      pg.fill(this.col);
      pg.circle(this.x + cx, this.y, weight * 0.15);
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
