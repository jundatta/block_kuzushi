// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bvca2as3p9f7gigeesbg?index=31&origin=user_like
//

class GameSceneCongratulations166 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  color[] colors = {#f881ac, #ffe655, #ffd900, #0a50a1, #008737};
  ArrayList<PVector> shapes = new ArrayList();

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    float seg = 8;
    float segH = height / seg;
    float wid = width / seg;

    for (int i = 0; i <= seg; i += 2) {
      for (int j = 0; j <= segH; j += 2) {
        float x = i * wid;
        float y = j * wid;
        shapes.add(new PVector(x, y, wid));
        shapes.add(new PVector(x + wid, y + wid, wid));
        forms.add(new Form(x, y, wid));
        forms.add(new Form(x + wid, y + wid, wid));
      }
    }

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.background(255);
    for (PVector s : shapes) {
      pg.noFill();
      pg.stroke(0, 150);
      pg.strokeWeight(1);
      pg.rect(s.x, s.y, s.z, s.z);
    }
    for (Form f : forms) {
      f.run(pg);
    }
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  class Form {
    float x;
    float y;
    float d0;
    float d;
    float sw;
    int t;
    int t1;
    color col;
    Form(float x, float y, float d) {
      this.x = x;
      this.y = y;
      this.d0 = d;
      this.d = d * 0.5;
      this.sw = this.d;
      this.t = int(random(-1, 1) * 100);
      this.t1 = int(random(50, 200));
      this.col = color(P5JSrandom(colors));
    }

    void show(PGraphics pg) {
      pg.fill(this.col);
      pg.noStroke();
      pg.circle(this.x, this.y, this.d0 * 0.5);
      if (0 <= this.t && this.t < this.t1) {
        pg.noFill();
        pg.strokeWeight(this.sw);
        pg.stroke(this.col);
        pg.circle(this.x, this.y, this.d - this.sw);
      }
    }

    void move() {
      if (0 <= this.t && this.t < this.t1) {
        float nor = norm(this.t, 0, this.t1 - 1);
        this.sw = lerp(this.d0 * 0.2, 0, nor);
        this.d = lerp(this.d0 * 0.5, this.d0 * 1.5, nor);
      } else if (this.t1 < this.t) {
        this.t = -int(random(50, 100));
        this.t1 = int(random(50, 100));
      }
      this.t++;
    }

    void run(PGraphics pg) {
      this.show(pg);
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
