// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1362294
//

class GameSceneCongratulations189 extends GameSceneCongratulationsBase {
  Flake[] flakes = new Flake[200];
  PGraphics forest;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    forest = createGraphics(width, height);
    noiseDetail(8, 0.25);
    forest.beginDraw();
    drawForest();
    forest.endDraw();
    for (int i = 0; i < flakes.length; i++) {
      PVector pos = new PVector(random(width), random(-height, 0));
      PVector vel = new PVector(random(-1, 1), 0);
      flakes[i] = new Flake(pos, vel, random(2, 5));
    }
  }

  void drawForest() {
    noiseSeed(0);
    drawSky();
    forest.noFill();

    float theta0 = random(TWO_PI);
    for (int j = 0; j < 5; j++) {
      //forest.background(200, 25);
      forest.fill(200, 25);
      forest.rect(0, 0, width, height);
      forest.noFill();

      for (int i = 0; i < 50; i++) {
        // random height, bigger for foreground
        float h = random(map(j, 0, 5, 20, 50), map(j, 0, 5, 50, 350));
        float x = random(width);

        float y0 = 0.67 * height + 10 * j; // reference y pos, lower for foreground
        float s = sin(theta0 + 0.01 * x); // sin for a curve
        float n = noise(0.01 * x, j); // noise for some randomness
        float a = map(j, 0, 5, 70, 30); // amplitude, smaller for foreground
        float y = y0 + a * s * n;

        pine(x, y, h / 2.0f, h);
      }
    }
  }

  void pine(float x, float y, float w, float h) {
    float y0 = y - h;

    forest.stroke(0, 10, 0);
    forest.noFill();

    forest.strokeWeight(2);
    forest.line(x, y, x, y - h);

    forest.strokeWeight(0.5);
    float di = random(3, 7);
    for (float i = y0; i < y; i += di) {
      float l = map(i, y0, y, 0, w);
      branch(x, i, l);
    }
  }

  void branch(float x, float y, float l) {
    for (int i = 0; i < 10; i++) {
      float dy = random(-1, 5);
      float dl = random(1);
      forest.bezier(x - dl * 0.50 * l, y + dy,
        x - dl * 0.25 * l, y,
        x + dl * 0.25 * l, y,
        x + dl * 0.50 * l, y + dy);
    }
  }

  void drawSky() {
    color start = color(0, 0, 50);
    color finish = color(147, 231, 251);
    color c = start;
    for (int y = 0; y < height; y += 2) {
      c = lerpColor(c, finish, 4 / (float)height);
      forest.stroke(c);
      forest.strokeWeight(2);
      forest.noFill();
      forest.line(0, y, width, y);
    }
  }

  @Override void draw() {
    clear();
    image(forest, 0, 0);
    for (Flake f : flakes) {
      f.move();
      f.show();
      f.wrap();
    }
    //  if (frameCount % 20 == 0) forest.background(0, 2);
    if (frameCount % 20 == 0) {
      forest.beginDraw();
      forest.fill(0, 2);
      forest.rect(0, 0, width, height);
      forest.endDraw();
    }

    logoRightLower(#ff0000);
  }

  class Flake {
    PVector pos, vel;
    float size;
    Flake(PVector pos, PVector vel, float size) {
      this.pos = pos;
      this.vel = vel;
      this.size = size;
    }
    void show() {
      push();
      translate(this.pos.x, this.pos.y);
      rotate(-this.pos.x / 300);
      fill(200, 200, 251, 155);
      noStroke();
      ellipse(-50, 0, this.size, this.size);
      ellipse(50, 0, this.size, this.size);
      ellipse(0, -50, this.size, this.size);
      ellipse(0, 50, this.size, this.size);

      ellipse(-150, 0, this.size, this.size);
      ellipse(150, 0, this.size, this.size);
      ellipse(0, -150, this.size, this.size);
      ellipse(0, 150, this.size, this.size);

      pop();
    }
    void move() {
      this.pos.add(this.vel);
      this.vel.y += this.size * 0.001;
      this.vel.x -= this.size *this.size* ((width / 2) - mouseX) / 1000000.0f;
    }
    void wrap() {
      if (this.pos.y > height+50) {
        this.pos.x = random(width);
        this.pos.y = random(-height / 2.0f, 0);
        this.vel.mult(0.5);
      }
      if (this.pos.x < 0) this.pos.x = width;
      if (this.pos.x > width) this.pos.x = 0;
      this.vel.x -= this.size * ((width / 2) - mouseX) / 100000.0f;
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
