// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】dcc#28 "Blizzard"
// https://openprocessing.org/sketch/883224
//

class GameSceneCongratulations107 extends GameSceneCongratulationsBase {
  //2020-04-28　dcc#28 "Blizzard" @senbaku
  final color c1 = #98c1d9; //background
  final color c2 = #ee6c4d; //text
  final color c3 = #e0fbfc; //ground;
  final color c4 = #3d5a80; //man
  PGraphics pg;
  ArrayList<Particle> particles = new ArrayList();
  float t = 0.0;
  float deg = 0;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);
  }
  @Override void draw() {
    background(c1);

    //blizzard-------------
    //how many particles do I want to add each frame
    for (float i = 0; i < 1; i += 0.5) {
      Particle p = new Particle();
      particles.add(p);
    }
    for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).update();
      particles.get(i).show();
      if (particles.get(i).finished()) {
        //remove this particle.
        particles.remove(i);
      }
    }
    //ground-----------------------
    float groundH = height * 0.625f;
    fill(c3);
    rect(0, groundH, width, height);
    //man--------------
    float manH = height * 0.55f;
    push();
    scale(0.5);
    translate(250, manH);

    man();
    pop();
    //text--------
    fill(c2);
    //fill("#FF1654");
    noStroke();
    textSize(20);
    //  textFont("helvetica");
    textAlign(CENTER);
    text("B l i z z a r d ", width / 2, height * 0.75f);

    logoRightLower(color(255, 0, 0));
  }

  class Particle {
    float x;
    float y;
    float vx;
    float vy;
    int alpha;
    color col1;
    Particle() {
      this.x = -180;
      this.y = 0;
      this.vx = random(-1, 50);
      this.vy = random(-1, 50);
      this.alpha = 255;
      //this.col1 = color(255, 255, 255);
    }

    boolean finished() {
      return this.alpha < 0;
    }
    void update() {
      this.x += this.vx;
      this.y += this.vy;
      this.alpha -= 10;
    }

    void show() {
      noStroke();
      //this.col1.setAlpha(50 + this.alpha);
      //fill(this.col1, this.alpha);
      color c = color(255, 255, 255, 50 + this.alpha);
      fill(c);
      ellipse(this.x, this.y, 14, 10);
    }
  }

  void man() {
    translate(width / 2, height * 0.75f);
    fill(c4);
    noStroke();
    push();
    translate(0, -30);
    for (float i = 0; i < HALF_PI; i += 0.05) {
      float sx = -sin(i + t) * 30;
      float sy = i * 50;
      float cx = sin(i + t) * 30;
      float cy = i * 50;

      ellipse(sx, sy, 10, 10);
      ellipse(cx, cy, 10, 10);
    }
    t += 0.1;
    pop();
    strokeWeight(2);

    float mw = 150;
    float mh = 200;
    float radian = radians(deg);
    float a = sin(radian);


    beginShape();
    curveVertex(-mw / 3.0f, 10 + a);
    curveVertex(mw / 2.0f, -20 + a);

    curveVertex(mw / 3.0f, -mh / 3.0f + a);
    curveVertex(mw / 7.0f, -mh / 2.0f - mw / 3.0f + a);
    curveVertex(-mw / 3.0f, -mh + a);
    curveVertex(-mw / 2.0f, -mh + 10 + a);
    curveVertex(-mw / 3.0f, -mh / 2.0f - 10 + a);
    curveVertex(-mw / 3.0f, -mh / 2.0f + mw / 4.0f + a);

    curveVertex(-mw / 3.0f, 10 + a);
    curveVertex(mw / 2.0f, -20 + a);
    curveVertex(mw / 3.0f, -mh / 2.0f + a);
    endShape();

    ellipse(-mw / 2.0f, -mh, 70 + a, 70 + a);
    fill(255);
    ellipse(-mw / 2.0f - 10, -mh, 15, 6 + a * 2);
    deg += 15; //動き
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
