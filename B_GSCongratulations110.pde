// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】PCD2021_DCC03
// https://openprocessing.org/sketch/1102630
//

class GameSceneCongratulations110 extends GameSceneCongratulationsBase {
  //2021-02-14 @senbaku
  // ##PCD2021_DailyCoding1weekChalenge03"sky"

  float t = 0.0;
  float t2 = 0.0;
  float vel = 0.02;
  PGraphics pg;
  PGraphics mask;
  float w, h;
  final color[] col = {#f94144, #f3722c, #f8961e, #f9c74f, #90be6d, #43aa8b, #7d6f86};
  ArrayList<Particle> particles = new ArrayList();

  final int kOrgW = 600;
  final int kOrgH = 600;
  int TopX, TopY;
  PGraphics screen;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    TopX = (width - kOrgW) / 2;
    TopY = (height - kOrgH) / 2;

    pg = createGraphics(kOrgW, kOrgH);
    pg.beginDraw();
    pg.translate(kOrgW / 2, kOrgH / 2);
    pg.background(#f4f1de);
    pg.fill(51);
    pg.noStroke();
    //  w = kOrgW / 2.5;
    w = kOrgW / 2.5;
    h = kOrgH / 6.0f;
    float yy = -kOrgH / 10.0f;

    pg.ellipse(0, yy + kOrgH / 3.0f, w, h * 1); //台座下
    pg.ellipse(0, yy + kOrgH / 3.0f - 10, w - 10, h * 1 - 20); //台座下
    pg.beginShape();
    pg.curveVertex(-(w * 0.51) / 2.0f, kOrgH / 12.0f);
    pg.curveVertex(-(w * 0.51) / 2.0f, kOrgH / 12.0f);
    pg.curveVertex(-(w * 0.51) / 2.0f + 5, kOrgH / 12.0f + 20);
    pg.curveVertex(-(w * 0.51) / 2.0f - 50, kOrgH / 12.0f + 60);
    pg.curveVertex(-w / 2.0f + 10, yy + kOrgH / 3.0f);
    pg.curveVertex(-w / 2.0f + 50, yy + kOrgH / 3.0f);
    pg.curveVertex(w / 2.0f - 50, yy + kOrgH / 3.0f);
    pg.curveVertex(w / 2.0f - 10, yy + kOrgH / 3.0f);
    pg.curveVertex((w * 0.51) / 2.0f + 50, kOrgH / 12.0f + 60);
    pg.curveVertex((w * 0.51) / 2.0f - 5, kOrgH / 12.0f + 20);
    pg.curveVertex((w * 0.51) / 2.0f - 5, kOrgH / 12.0f);
    pg.curveVertex(0, kOrgH / 12.0f);
    pg.curveVertex(0, kOrgH / 12.0f);
    pg.endShape(CLOSE);

    pg.ellipse(0, kOrgH / 12.0f, w * 0.51, h / 2.5); //台座2
    pg.quad(-(w * 0.51) / 2.0f, kOrgH / 12.0f, (w * 0.51) / 2.0f, kOrgH / 12.0f, (w * 0.5) / 2.0f, kOrgH / 14.0f, -(w * 0.5) / 2.0f, kOrgH / 14.0f);
    pg.fill(100);
    pg.ellipse(0, kOrgH / 14.0f, w * 0.5, h / 2.7); //台座1
    pg.endDraw();

    //  pg.erase();
    mask = createGraphics(kOrgW, kOrgH);
    mask.beginDraw();
    mask.translate(kOrgW / 2, kOrgH / 2);
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.ellipse(0, -kOrgH / 7.3, kOrgH / 2.3, kOrgH / 2.3); //ドーム
    mask.endDraw();
    pg.mask(mask);
    //  pg.noErase();

    screen = createGraphics(kOrgW, kOrgH);
  }
  @Override void draw() {
    background(#f4f1de);

    screen.beginDraw();

    screen.background(#76bed0);
    screen.noStroke();
    screen.push();
    screen.translate(kOrgW / 2, kOrgH / 2);
    screen.push();
    for (int i = 0; i < col.length; i++) {
      screen.stroke(col[i]);
      screen.strokeWeight(1);
      screen.noFill();
      screen.arc(-15, 15, kOrgH / 2.8 - i * 8, kOrgH / 2.8 - i * 8, radians(-180), radians(30));
    }
    color skycol = color(#76bed0, 70);
    //  skycol.setAlpha(70);
    screen.fill(skycol);
    screen.noStroke();
    screen.ellipse(0, -kOrgH / 7.3, kOrgH / 2.3, kOrgH / 2.3); //ドーム
    //wood-----
    float x = -15;
    float ty = 10;
    screen.fill(#6c464e);
    screen.noStroke();
    screen.triangle(x - 5, ty, x, ty - 35, x + 5, ty);
    float movex = -30;
    float movey = 20;
    screen.triangle(x - 5 + movex, ty + movey, x + movex, ty - 35 + movey, x + 5 + movex, ty + movey);
    screen.fill(#C1D7D7);
    screen.noStroke();
    screen.ellipse(0, -kOrgH / 10.0f + kOrgH / 5.0f, w, h);
    screen.fill(#6c464e);
    screen.triangle(x - 5 - movex * 2, ty + movey, x - movex * 2, ty - 35 + movey, x + 5 - movex * 2, ty + movey);
    //---------

    screen.push();
    color suncol = color(#f4f1bb, 80);
    //  suncol.setAlpha(80);
    //  drawingContext.shadowBlur = 30;
    //  drawingContext.shadowColor = #f4f1bb;
    screen.fill(suncol);
    // 嫁はんのリクエストでちょっとだけ右にずらしました
    //  screen.ellipse(0, -150, 30, 30);
    screen.ellipse(40, -150, 30, 30);
    screen.pop();

    screen.pop();

    screen.push();
    screen.scale(0.5);
    screen.translate(-kOrgW / 2, -kOrgH);
    particles.add(new Particle(new PVector(random(kOrgW), random(100, 600))));
    // Looping through backwards to delete
    for (int i = particles.size() - 1; i >= 0; i--) {
      var p = particles.get(i);
      p.run(screen);
      if (p.isDead() || particles.size() > 100) {
        //remove the particle
        particles.remove(0);
      }
    }
    screen.pop();

    screen.push();
    //pop();
    //highlight---
    screen.stroke(255);
    screen.noFill();
    screen.strokeCap(ROUND);
    screen.strokeWeight(5);
    screen.arc(0, -kOrgH / 7.3, kOrgH / 2.3 - 15, kOrgH / 2.3 - 15, radians(180 + 180 / 5), radians(270));
    screen.arc(0, -kOrgH / 7.3, kOrgH / 2.3 - 15, kOrgH / 2.3 - 15, radians(180 + 180 / 8), radians(180 + 180 / 6));
    screen.stroke(255, 30);
    screen.strokeWeight(30);
    //line(100, 120, 100, -60);
    screen.arc(0, -kOrgH / 7.3, kOrgH / 2.3 - 35, kOrgH / 2.3 - 35, radians(0), radians(90));
    screen.ellipse(0, -kOrgH / 7.3, kOrgH / 2.3, kOrgH / 2.3); //ドーム
    screen.pop();
    screen.pop();
    //text----
    screen.image(pg, 0, 0);
    screen.fill(#e07a5f);
    screen.textSize(25);
    screen.textAlign(CENTER, CENTER);
    screen.text("S k y", kOrgW / 2, 550);

    screen.endDraw();
    image(screen, TopX, TopY);

    logoRightLower(color(255, 0, 0, 32));
  }
  class Particle {
    PVector acceleration;
    PVector velocity;
    PVector position;
    float lifespan;
    float d;
    Particle(PVector position) {
      this.acceleration = new PVector(0, -0.005);
      this.velocity = new PVector(random(-1, 1), random(-1, 0));
      this.position = position.copy();
      this.lifespan = 255.0;
      this.d = random(2, 5);
    }

    void run(PGraphics p) {
      this.update();
      this.display(p);
    }

    void update() {
      this.velocity.add(this.acceleration);
      this.position.add(this.velocity);
      this.lifespan -= 2.0;
    }

    void display(PGraphics p) {
      p.push();
      p.stroke(255, this.lifespan);
      p.strokeWeight(0.8);
      p.noFill();
      p.translate(this.position.x, this.position.y);
      p.rotate(radians(45));
      p.rect(0, 0, this.d, this.d);
      p.pop();
    }

    boolean isDead() {
      if (this.lifespan < 0.0) {
        return true;
      } else {
        return false;
      }
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
