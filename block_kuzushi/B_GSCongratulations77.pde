// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】Star in the Bottle
// https://openprocessing.org/sketch/912174
//

class GameSceneCongratulations77 extends GameSceneCongratulationsBase {
  Mover[] mover = new Mover[30];
  Water liquid;
  PGraphics tx;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    float waterX = width / 2 + 10 - 90;
    float waterY = height / 2 - 80;
    liquid = new Water(waterX, waterY, 160, 315, 0.5);
    for (int i = 0; i < mover.length; i++) {
      //    mover[i] = new Mover(random(1, 5), random(230, 360), random(160, 170), 45, 70, 6);
      mover[i] = new Mover(waterX, waterY,
        random(1, 5), random(0, 120), random(0, 10), 45, 70, 6);
    }

    tx = createGraphics(width, height);
    tx.beginDraw();
    tx.noStroke();
    for (int i = 0; i < width * height * 1 / 10.0f; i++) {
      float x = random(width);
      float y = random(height);
      tx.fill(0, 3);
      tx.ellipse(x, y, random(5), random(5));
    }
    tx.endDraw();
  }
  @Override void draw() {
    background(#212331);
    PVector wind = new PVector(0, 0);
    if (mousePressed) {
      wind = new PVector(0, -1);
    }
    bottle();

    for (int i = 0; i < mover.length; i++) {
      if (liquid.contains(mover[i])) {
        PVector dragForce = liquid.calculateDrag(mover[i]);
        mover[i].applyForce(dragForce);
      }

      float m = mover[i].mass;
      PVector gravity = new PVector(0, 0.1 * m); //重力をスケーリング
      mover[i].applyForce(wind);
      mover[i].applyForce(gravity);
      mover[i].update();
      mover[i].show();
      mover[i].checkEdges();
      liquid.show();
    }
    image(tx, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  void bottle() {
    push();
    //drawingContext.shadowOffsetX = 0;
    //drawingContext.shadowOffsetY = 0;
    //drawingContext.shadowBlur = 10;
    //drawingContext.shadowColor = "#f4f1de";
    fill(220);
    noStroke();
    push();

    rectMode(CENTER);
    rect(width / 2, 80, 40, 30, 20);
    rect(width / 2, 100, 130, 20, 10);
    rect(width / 2, 130, 100, 50, 10);
    rect(width / 2, height / 2 + 50, 180, 400, 50);
    rect(width / 2, height / 2 + 150, 180, 200, 20);
    pop();
    pop();
  }

  class Mover {
    float sx;      // 左上隅x座標
    float sy;      // 左上隅y座標
    float mass;
    float radius1;
    float radius2;
    float npoints;
    float angle;
    float halfAngle;
    PVector pos;
    PVector vel;
    PVector acc;
    float d;
    float yama;
    float tani;

    Mover(float sx, float sy,
      float m, float x, float y, float radius1, float radius2, float npoints) {
      this.sx = sx + 20;
      this.sy = sy - 20;
      this.radius1 = radius1;
      this.radius2 = radius2;
      this.npoints = npoints;
      this.angle = TWO_PI / this.npoints;
      this.halfAngle = this.angle / 2.0;

      this.mass = m;
      this.pos = new PVector(this.sx + x, this.sy + y);
      this.vel = new PVector(0, 0);
      this.acc = new PVector(0, 0);
      this.d = this.mass * 8;
      //this.topspeed = 4;
      this.yama = this.radius1 * this.mass / 15.0f;
      this.tani = this.radius2 * this.mass / 15.0f;
    }
    void applyForce(PVector force) {
      PVector f = PVector.div(force, this.mass);
      this.acc.add(f);
    }
    void update() {
      this.vel.add(this.acc);
      this.pos.add(this.vel);
      this.acc.mult(0);
    }
    void show() {
      push();
      //drawingContext.shadowOffsetX = 0;
      //drawingContext.shadowOffsetY = 0;
      //drawingContext.shadowBlur = 30;
      //drawingContext.shadowColor = "#f4f1de";
      stroke(255);
      color c = color(#f4f1de);
      fill(c);
      beginShape();
      for (float a = 0; a < TWO_PI; a += this.angle) {
        float sx = this.pos.x + cos(a) * this.yama;
        float sy = this.pos.y + sin(a) * this.yama;
        vertex(sx, sy);
        sx = this.pos.x + cos(a + this.halfAngle) * this.tani;
        sy = this.pos.y + sin(a + this.halfAngle) * this.tani;
        vertex(sx, sy);
      }
      endShape(CLOSE);

      noStroke();
      c = color(0xf4, 0xf1, 0xde, 64);
      fill(c);
      float scale = 1.5f;
      beginShape();
      for (float a = 0; a < TWO_PI; a += this.angle) {
        float sx = this.pos.x + cos(a) * this.yama * scale;
        float sy = this.pos.y + sin(a) * this.yama * scale;
        vertex(sx, sy);
        sx = this.pos.x + cos(a + this.halfAngle) * this.tani * scale;
        sy = this.pos.y + sin(a + this.halfAngle) * this.tani * scale;
        vertex(sx, sy);
      }
      endShape(CLOSE);

      pop();
    }

    void checkEdges() {
      float sY = this.sy;
      float eY = sY + 348;
      if (eY - this.d < this.pos.y) {
        this.vel.y *= -1;
        this.pos.y = eY - this.d;
      } else if (this.pos.y < sY) {
        this.vel.y *= -1;
        this.pos.y = sY;
      }
    }
  }

  class Water {
    float x;
    float y;
    float w;
    float h;
    float c;

    Water(float x, float y, float w, float h, float c) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.c = c;
    }

    boolean contains(Mover mover) {
      PVector l = mover.pos;
      return l.x > this.x && l.x < this.x + this.w &&
        l.y > this.y && l.y < this.y + this.h;
    }
    PVector calculateDrag(Mover mover) {
      float speed = mover.vel.mag();
      float dragMagnitude = this.c * speed * speed;

      PVector dragForce = mover.vel.copy();
      dragForce.mult(-1);
      dragForce.normalize();
      dragForce.mult(dragMagnitude);
      return dragForce;
    }

    void show() {
      noStroke();
      color cw = color(#91ADC2);
      //    cw.setAlpha(10);
      cw = color(red(cw), green(cw), blue(cw), 10);
      fill(cw); //water color
      rect(this.x, this.y, this.w, this.h);
    }
  }

  @Override void mousePressed() {
    //    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
