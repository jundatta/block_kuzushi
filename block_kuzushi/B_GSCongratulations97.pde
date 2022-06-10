// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】PCD2021_DCC04
// https://openprocessing.org/sketch/1104536
//

class GameSceneCongratulations97 extends GameSceneCongratulationsBase {
  //2021-02-17 @senbaku
  // ##PCD2021_DailyCoding1weekChalenge05"Desert"
  //PCD2021_DCC04

  float start = 0.0;
  float xoff = 0.0;
  float inc = 0.002;
  float t = 0.0;
  float vel = 0.02;
  PGraphics pg;
  PGraphics bg;
  PGraphics tx;
  float w, h;
  ArrayList<Particle> particles = new ArrayList();
  final color[] col = {#ffcdb2, #ffb4a2, #e5989b, #b5838d, #6d6875};

  final int W = 600;
  final int H = 600;
  int TopX;
  int TopY;
  PGraphics maskImg;
  PGraphics humanImg;
  PGraphics particleImg;
  PGraphics highlightImg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    TopX = (width - W) / 2;
    TopY = (height - H) / 2;

    background(color(#f4f1de));
    //  angleMode(DEGREES);

    bg = createGraphics(W, H);
    bg.beginDraw();
    xoff = start;
    bg.fill(color(#3d405b));
    bg.rect(0, 0, W, H);
    bg.translate(0, 100);
    for (int x = 0; x < W; x++) {
      float y = noise(xoff) * 200;
      float y2 = noise(xoff + 1) * 300;
      float y3 = noise(xoff + 10) * 400;
      float y4 = noise(xoff + 20) * 500;
      float y5 = noise(xoff + 30) * 600;
      bg.stroke(col[0]);
      bg.line(x, y, x, H);
      bg.stroke(col[1]);
      bg.line(x, y2, x, H);
      bg.stroke(col[2]);
      bg.line(x, y3, x, H);
      bg.stroke(col[3]);
      bg.line(x, y4, x, H);
      bg.stroke(col[4]);
      bg.line(x, y5, x, H);
      xoff += inc;
      start += inc / 100.0f;
    }
    bg.endDraw();

    noStroke();
    push();
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.translate(width / 2, height / 2);
    pg.background(color(#f4f1de));
    pg.fill(51);
    pg.noStroke();
    w = W / 2.5;
    h = H / 6.0f;
    float yy = -H / 10.0f;

    pg.ellipse(0, yy + H / 3 + 20, w * 0.9, h * 0.8); //台座下
    pg.ellipse(0, yy + H / 3 - 5, w * 0.8, h * 1); //台座中
    pg.fill(80);
    pg.ellipse(0, yy + H / 4, w * 0.6, h - 20); //台座中

    //  pg.erase();
    //  pg.ellipse(0, -H / 13.0f, H / 2.5, H / 1.8); //ドーム
    //  pg.noErase();
    pg.endDraw();
    pop();
    maskImg = createGraphics(width, height);
    maskImg.beginDraw();
    maskImg.translate(width / 2, height / 2);
    maskImg.background(255);
    maskImg.noStroke();
    maskImg.fill(0);
    maskImg.ellipse(0, -H / 13.0f, H / 2.5, H / 1.8); //ドーム
    maskImg.endDraw();
    tx = createGraphics(W, H);
    tx.beginDraw();
    tx.noStroke();
    tx.fill(255, 30);
    for (int i = 0; i < 300000; i++) {
      float x = random(W);
      float y = random(H);
      float n = noise(x * 0.01, y * 0.01) * W * 0.002;
      tx.rect(x, y, n, n);
    }
    tx.endDraw();

    humanImg = createGraphics(W, H);
    particleImg = createGraphics(W, H);
    highlightImg = createGraphics(W, H);
  }
  @Override void draw() {
    noStroke();
    image(bg, TopX, TopY);
    image(tx, TopX, TopY);
    push();
    humanImg.beginDraw();
    humanImg.clear();
    humanImg.noStroke();
    humanImg.translate(W / 2, H / 2);
    //human----------
    humanImg.push();
    humanImg.fill(255);
    float osci = 4 * sin(radians(t * 100));
    humanImg.translate(0, osci);
    humanImg.ellipse(0, 0, 10, 10);
    humanImg.rectMode(CENTER);
    humanImg.rect(0, 13, 10, 18, 3, 3, 0, 0); //body
    humanImg.rect(-2.5, 13 + 13 - osci, 4, 17, 2);
    humanImg.rect(2.5, 13 + 13, 4, 17, 2);
    t += vel;
    humanImg.pop();
    humanImg.fill(220);
    for (int i = 0; i < 150; i += 20) {
      humanImg.rect(-2.5, 60 + i, 4, 4, 2);
      humanImg.rect(2.5, 68 + i, 4, 4, 2);
    }
    //----------

    humanImg.endDraw();
    image(humanImg, TopX, TopY);
    pop();

    push();
    particleImg.beginDraw();
    particleImg.clear();
    translate(W / 4, H / 4);
    //particle----------
    particles.add(new Particle(new PVector(random(W), random(0, 500))));
    // Looping through backwards to delete
    for (var i = particles.size() - 1; i >= 0; i--) {
      var p = particles.get(i);
      p.run(particleImg);
      if (p.isDead() || particles.size() > 100) {
        //remove the particle
        particles.remove(0);
      }
    }
    particleImg.endDraw();
    image(particleImg, TopX, TopY);
    pop();

    push();
    highlightImg.beginDraw();
    highlightImg.clear();
    highlightImg.translate(W / 2, H / 2);
    //highlight---
    highlightImg.stroke(255);
    highlightImg.noFill();
    highlightImg.strokeCap(ROUND);
    highlightImg.strokeWeight(5);
    highlightImg.arc(0, -H / 13.0f, H / 2.5 - 15, H / 1.8 - 15, radians(180 + 180 / 5.), radians(270));
    highlightImg.arc(0, -H / 13.0f, H / 2.5 - 15, H / 1.8 - 15, radians(180 + 180 / 8.0f), radians(180 + 180 / 6.0f));
    highlightImg.stroke(255, 30);
    highlightImg.strokeWeight(30);
    highlightImg.arc(0, -H / 13.0f, H / 2.5 - 25, H / 1.8 - 25, radians(0), radians(90));
    highlightImg.endDraw();
    image(highlightImg, TopX, TopY);
    pop();

    //text----
    pg.mask(maskImg);
    image(pg, 0, 0);
    fill(color(#3d405b));
    textSize(25);
    textAlign(CENTER, CENTER);
    text("D e s e r t", TopX + (W / 2), TopY + 550);

    logoRightLower(color(255, 0, 0));
  }

  class Particle {
    PVector acceleration;
    PVector velocity;
    PVector position;
    float lifespan;
    float d;

    Particle(PVector position) {
      this.acceleration = new PVector(0.02, 0.005);
      this.velocity = new PVector(random(-1, 1), random(1, 0));
      this.position = position.copy();
      this.lifespan = 255.0;
      this.d = random(1, 4);
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
      p.stroke(255, 205, 178, this.lifespan);
      p.strokeWeight(0.5);
      p.noFill();
      p.ellipse(this.position.x, this.position.y, this.d, this.d);
    }

    boolean isDead() {
      return this.lifespan < 0.0;
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
