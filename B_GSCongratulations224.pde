// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1034456
//

class GameSceneCongratulations224 extends GameSceneCongratulationsBase {
  // source code: https://github.com/moPsych/ferris-wheel

  // number of the background rectangles
  int n = 200;
  // initializing background rectangles the colors
  class Rec {
    float x, y, w, h;
    color col;

    Rec(float x, float y, float w, float h, color col) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.col = col;
    }
  }
  ArrayList<Rec> recs = new ArrayList();

  // image for the background
  PImage img;
  // optional color for the background
  color bg;

  Wheel w;

  PGraphics pg;

  void preload() {
    img = loadImage("data/224/bg.jpg");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();

    bg = color(20, 20, 20);
    background(bg);
    // the wheel object
    w = new Wheel(width / 3.0f, height * 2 / 3.0f, 700);

    pg = createGraphics(width, height);
    pg.rectMode(CENTER);
  }
  @Override void draw() {
    pg.beginDraw();
    //  background(img);
    pg.image(img, 0, 0, width, height);
    // the background rectangles
    drawRecs(pg);
    // updating and drawing the wheel
    w.update();
    w.render(pg);
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(#ff0000);
  }

  void drawRecs(PGraphics pg) {
    if (frameCount % 4 == 0) {
      recs = new ArrayList();
      for (int i = 0; i < n; i++) {
        Rec rec = new Rec(random(width), random(height / 4.0f, height),
          random(7, 15), random(7, 15) / 2.0f, colorizeRnd());
        recs.add(rec);
      }
    }
    for (Rec rec : recs) {
      pg.fill(rec.col);
      pg.rect(rec.x, rec.y, rec.w, rec.h, rec.h / 3.0f);
    }
  }

  color colorize(int i) {
    // a function to give color for the cabins according to the cabin's index
    float v = 220;
    color[] c = {
      color(v, 0, 0),
      color(0, v, 0),
      color(0, 0, v),
      color(v, v, 0),
      color(v, 0, v),
      color(0, v, v),
    };
    int index = i % 6;
    return c[index];
  }

  color colorizeRnd() {
    // a function to generate a random color from a list of colors
    int v = 80;
    color[] c = {
      color(v, 0, 0),
      color(0, v, 0),
      color(0, 0, v),
      color(v, v, 0),
      color(v, 0, v),
      color(0, v, v),
    };
    int index = floor(random(6));
    return c[index];
  }

  class Cabin {
    // x, y: coordinates | r: radius | c: color
    float x, y;
    float r;
    float cl, cr;
    color c;
    float a;

    Cabin(float x, float y, float r, color c) {
      this.x = x;
      this.y = y;
      this.r = r;
      // the end point of the line that the cabin is attached to
      this.cl = this.r / 30.0f;
      // the radius of the cabin
      this.cr = this.r / 8.75;
      // the color of the cabin
      this.c = c;
      // the angle of the cabin
      this.a = 0;
    }

    void update(float da) {
      // updates the angle of the cabin to stay vertical
      this.a = -da;
    }

    void render(PGraphics pg) {
      pg.push();
      pg.translate(this.x, this.y);
      pg.rotate(this.a);
      // the line that the cabin is attached to;
      pg.noStroke();
      pg.fill(this.c);
      pg.circle(0, 0, this.r / 65.0f);
      pg.stroke(this.c);
      pg.strokeWeight(this.r / 250.0f);
      pg.line(0, 0, 0, this.cl);
      pg.fill(bg);
      pg.noStroke();
      // base cabin circle
      pg.circle(0, this.cr / 2.0f + this.cl, this.cr);
      pg.noFill();

      // inner lines
      pg.stroke(this.c);
      pg.strokeWeight(this.r / 300.0f);
      float cx1 = this.cr / 6.0f;
      float cx2 = -cx1;
      float cy1 = this.cl + 0.0277 * this.cr;
      float cy2 = this.cl + this.cr - 0.0277 * this.cr;
      pg.line(cx1, cy1, cx1, cy2);
      pg.line(cx2, cy1, cx2, cy2);
      cx1 = (-this.cr * 0.99) / 2.0f;
      cx2 = (this.cr * 0.99) / 2.0f;
      cy1 = this.cl + this.cr * 0.4;
      cy2 = cy1 + this.cr * 0.05;
      pg.line(cx1, cy1, cx2, cy1);
      pg.line(cx1, cy2, cx2, cy2);

      // inner circles
      pg.fill(this.c);
      pg.noStroke();
      cx1 = -this.cr * 0.3;
      cx2 = -cx1;
      cy1 = this.cr * 0.57;
      pg.circle(cx1, cy1, this.cr * 0.15);
      pg.circle(cx2, cy1, this.cr * 0.15);

      // rectangles
      float w = this.cr / 10.0f;
      float h = this.cr / 4.0f;
      pg.rect(-this.cr / 14.0f, this.cr / 1.95, w, h, this.cr / 30.0f);
      pg.rect(this.cr / 14.0f, this.cr / 1.95, w, h, this.cr / 30.0f);
      w = this.cr / 5.0f;
      h = this.cr / 3.0f;
      pg.rect(0, this.cr * 1.01, w, h, this.cr / 20.0f);

      // outer circle
      pg.noFill();
      pg.stroke(this.c);
      pg.strokeWeight(this.r / 200.0f);
      pg.circle(0, this.cr / 2.0f + this.cl, this.cr);
      pg.pop();
    }
  }

  class Wheel {
    // x, r: coordinates || r: radius of the wheel
    float x, y;
    float r;
    float ang, da;
    float r1, r2, r3, r4;
    color circleCol, trussCol, legsCol;
    float trussAng;
    ArrayList<Cabin> cabins;
    Wheel(float x, float y, float r) {
      this.x = x;
      this.y = y;
      this.r = r;
      // angle of rotation
      this.ang = TWO_PI / 12.0f;
      this.da = 0;
      // radii of different circles
      this.r1 = r * 0.12;
      this.r2 = r * 0.4;
      this.r3 = r * 0.6;
      this.r4 = r * 0.69;
      // colors
      this.circleCol = color(70, 110, 140);
      this.trussCol = color(40, 80, 110);
      this.legsCol = color(20, 60, 90);
      this.trussAng = this.ang * 0.3;
      // the cabins list
      this.cabins = new ArrayList();
      int i = 0;
      //contructing cabins around the wheel
      for (float a = 0; a < TWO_PI; a += this.ang) {
        this.cabins.add(
          new Cabin(
          (r * cos(a + this.ang / 2.0f)) / 2.0f,
          (r * sin(a + this.ang / 2.0f)) / 2.0f,
          this.r,
          colorize(i)
          )
          );
        i++;
      }
    }

    void update() {
      // updating the angles of the cabins to stay vertical
      this.da += 0.002;
      for (Cabin c : this.cabins) {
        c.update(this.da);
      }
    }

    void render(PGraphics pg) {
      //legs
      pg.push();
      pg.stroke(this.legsCol);
      pg.strokeWeight(this.r / 30.0f);
      pg.line(this.x, this.y, this.x + this.r * 0.75, this.y + this.r * 1.5);
      pg.line(this.x, this.y, this.x - this.r * 0.75, this.y + this.r * 1.5);
      pg.pop();

      pg.push();
      // for the center and the rotation of the wheel
      pg.translate(this.x, this.y);
      pg.rotate(this.da);

      //cabins
      for (Cabin cab : this.cabins) {
        cab.render(pg);
      }
      pg.noFill();
      pg.stroke(this.trussCol);
      for (float a = 0; a < TWO_PI; a += this.ang) {
        //main structure
        pg.strokeWeight(this.r / 150);
        pg.line(0, 0, (this.r * cos(a)) / 2.0f, (this.r * sin(a)) / 2.0f);
        //first truss
        pg.strokeWeight(this.r / 250.0f);
        pg.line(
          (this.r2 * cos(a)) / 2.0f,
          (this.r2 * sin(a)) / 2.0f,
          (this.r3 * cos(a + this.trussAng)) / 2.0f,
          (this.r3 * sin(a + this.trussAng)) / 2.0f
          );
        pg.line(
          (this.r2 * cos(a)) / 2.0f,
          (this.r2 * sin(a)) / 2.0f,
          (this.r3 * cos(a - this.trussAng)) / 2.0f,
          (this.r3 * sin(a - this.trussAng)) / 2.0f
          );
        pg.line(
          (this.r3 * cos(a + this.trussAng)) / 2.0f,
          (this.r3 * sin(a + this.trussAng)) / 2.0f,
          (this.r4 * cos(a)) / 2.0f,
          (this.r4 * sin(a)) / 2.0f
          );
        pg.line(
          (this.r3 * cos(a - this.trussAng)) / 2.0f,
          (this.r3 * sin(a - this.trussAng)) / 2.0f,
          (this.r4 * cos(a)) / 2.0f,
          (this.r4 * sin(a)) / 2.0f
          );
        //second truss
        pg.line(
          (this.r4 * cos(a)) / 2.0f,
          (this.r4 * sin(a)) / 2.0f,
          (this.r * cos(a + this.trussAng)) / 2.0f,
          (this.r * sin(a + this.trussAng)) / 2.0f
          );
        pg.line(
          (this.r4 * cos(a)) / 2.0f,
          (this.r4 * sin(a)) / 2.0f,
          (this.r * cos(a - this.trussAng)) / 2.0f,
          (this.r * sin(a - this.trussAng)) / 2.0f
          );
      }
      // circle structures
      pg.noStroke();
      pg.fill(this.trussCol);
      pg.circle(0, 0, this.r1);
      pg.fill(this.circleCol);
      pg.circle(0, 0, this.r1 / 2.0f);
      pg.strokeWeight(this.r / 150.0f);
      pg.noFill();
      pg.stroke(this.circleCol);
      pg.circle(0, 0, this.r2);
      pg.circle(0, 0, this.r3);
      pg.circle(0, 0, this.r4);
      pg.circle(0, 0, this.r);
      pg.pop();
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
