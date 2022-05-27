// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Kaneshige Hirokazuさん
// 【作品名】particle in capsule_3
// https://neort.io/art/c816l743p9f3k6tgusug
//

class GameSceneCongratulations258 extends GameSceneCongratulationsBase {
  PGraphics pg;
  final int OrgW = 800;

  class Obj {
    void update() {
    }
    void render(PGraphics pg) {
      pg.text("呼ばれちゃったよ～ん", 0, 0);
    }
  }
  ArrayList<Obj> objects = new ArrayList();

  class Line extends Obj {
    float x, y;
    float h;

    Line(float x, float y, float h) {
      this.x = x;
      this.y = y;
      this.h = h;
    }
    @Override void render(PGraphics pg) {
      pg.strokeWeight(20);
      pg.stroke(#0000ff);  // blue
      pg.noFill();
      pg.line(x, y, x, y+h);
    }
  }

  class Circle extends Obj {
    float x, y;
    float r;

    Circle(float x, float y, float r) {
      this.x = x;
      this.y = y;
      this.r = r;
    }
    @Override void render(PGraphics pg) {
      pg.strokeWeight(5);
      pg.stroke(#0000ff);  // blue
      pg.noFill();
      pg.circle(x, y, r*2);
    }
  }

  class Circle_2 extends Obj {
    float x, y;
    float r;
    color col;

    Circle_2(float x, float y, float r, color col) {
      this.x = x;
      this.y = y;
      this.r = r;
      this.col = col;
    }
    @Override void render(PGraphics pg) {
      pg.noStroke();
      pg.fill(col);
      pg.circle(x, y, r*2);

      pg.noStroke();
      pg.fill(#ffff00);  // yellow
      pg.circle(x, y, (r-35)*2);

      pg.strokeWeight(5);
      pg.stroke(0, 255, 255);
      pg.noFill();
      pg.circle(x, y, (r-5)*2);
    }
  }

  float distance(PVector obj1, PVector obj2) {
    float dist2 = pow(obj1.x - obj2.x, 2) + pow(obj1.y - obj2.y, 2);
    float dist = pow(dist2, 0.5);
    return dist;
  }

  class Particle_2 extends Obj {
    float x, y;
    float vx, vy;
    color col;
    float cx, cy;
    float r;

    Particle_2(float x, float y, float vx, float vy, color col, float cx, float cy, float r) {
      this.x = x;
      this.y = y;
      this.vx = vx;
      this.vy = vy;
      this.col = col;
      this.cx = cx;
      this.cy = cy;
      this.r = r;
    }

    void update() {
      PVector self = new PVector(x, y);
      PVector center = new PVector(cx, cy);

      //領域circleにおける速度の振舞い方
      if (distance(self, center) > this.r) {
        float nx = cos(atan2(this.y-center.y, this.x-center.x));
        float ny = sin(atan2(this.y-center.y, this.x-center.x));
        PVector normal = new PVector(nx, ny);

        float inner_product = (normal.x)*(this.vx) + (normal.y)*(this.vy);
        PVector normal_vel = new PVector(inner_product*normal.x, inner_product*normal.y);

        PVector new_vel = new PVector(-2*normal_vel.x + this.vx, -2*normal_vel.y + this.vy);

        this.vx = new_vel.x;
        this.vy = new_vel.y;
      }

      this.x += this.vx;
      this.y += this.vy;
    }

    @Override void render(PGraphics pg) {
      pg.noStroke();
      pg.fill(col);
      pg.circle(x, y, 2*2);
    }
  }

  class CircleParam {
    float x, y;
    float r;
    color c;

    CircleParam(float x, float y, float r, color c) {
      this.x = x;
      this.y = y;
      this.r = r;
      this.c = c;
    }
  }

  @Override void setup() {
    for (int i=1; i<4; i++) {
      objects.add(new Line(200, 200*i-40, 80));
    }

    for (int i=1; i<4; i++) {
      objects.add(new Line(600, 200*i-40, 80));
    }

    for (int i=0; i<3; i++) {
      objects.add(new Line(300, 200+200*i-40, 80));
    }
    for (int i=0; i<3; i++) {
      objects.add(new Line(500, 200+200*i-40, 80));
    }

    for (int i=1; i<8; i++) {
      for (int j=1; j<8; j++) {
        if (i%2 == 0 || j%2 == 0) {
          CircleParam circle = new CircleParam(100*i, 100*j, 40, color(255, 0, 0));
          for (int k=0; k<50; k++) {
            objects.add(
              new Particle_2(circle.x+(circle.r/2)*random(1), circle.y+(circle.r/2)*random(1),
              random(1), random(1), circle.c, circle.x, circle.y, circle.r));
          }
          objects.add(new Circle(circle.x, circle.y, circle.r));
        }

        if (i%2 == 1 && j%2 == 1) {
          CircleParam circle = new CircleParam(100*i, 100*j, 57, color(255, 255, 0));
          objects.add(new Circle_2(circle.x, circle.y, circle.r, #008000));  // green
          for (int k=0; k<100; k++) {
            objects.add(
              new Particle_2(circle.x+(circle.r/2)*random(1), circle.y+(circle.r/2)*random(1),
              random(1), random(1), circle.c, circle.x, circle.y, circle.r));
          }
        }
      }
    }
    for (int i=0; i<4; i++) {
      objects.add(new Line(200, 100+200*i-40, 80));
    }

    for (int i=0; i<4; i++) {
      objects.add(new Line(600, 100+200*i-40, 80));
    }

    pg = createGraphics(OrgW, height, P2D);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.strokeCap(SQUARE);//角の端を直角

    // 前の描画を消す。
    pg.background(0);

    // 各オブジェクトの状態を更新する。
    for (Obj obj : objects) {
      obj.update();
    }

    // 各オブジェクトを描画する。
    for (Obj obj : objects) {
      obj.render(pg);
    }
    pg.endDraw();
    int offsetX = (OrgW-width) / 2;
    image(pg, -offsetX, 0);

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
