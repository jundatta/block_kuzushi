// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Circle Maze
// https://openprocessing.org/sketch/998934
//

class GameSceneCongratulations138 extends GameSceneCongratulationsBase {
  float angle=0;
  float av = 0;
  Player p;
  float py=-5;
  float pyv=0;
  ArrayList<Ring> rings = new ArrayList();
  ArrayList<Roller> rollers = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    textSize(18);
    p = new Player();
    makeMaze();
  }

  void makeMaze() {
    for (int r = 50; r<600; r+=50) {
      float a = 1.1*PI;
      if (r!=50) {
        a = random(TWO_PI);
      }
      rings.add( new Ring(r, a) );
      if (r>50) rollers.add( new Roller(r) );
    }
  }

  @Override void draw() {
    background(0);
    for (Ring r : rings) {
      if (r.touching()) {
        pyv=0;
        py-=0.02;
        break;
      } else {
        pyv+=0.02;
        if (py<-5 && py>-20) pyv*=0.95;
      }
    }
    py+=pyv;
    if (py>height) {
      py=-height;
      pyv=0;
      rings.get(0).a=1.1*PI;
    }
    angle+=av;
    av*=.98;
    p.roll();
    p.show();
    for (Roller r : rollers) {
      r.move();
      r.show();
      if (r.touching()) {
        py=0;
        pyv=0;
        rings.get(0).a=1.1*PI;
      }
    }
    for (Ring r : rings) {
      r.move();
      r.show();
    }
    checkKeys();

    logoRightLower(color(255, 0, 0));
  }

  void checkKeys() {
    if (keyCode == LEFT) {
      av-=.002;
    }
    if (keyCode == RIGHT) {
      av+=.002;
    }
    keyCode = 0;
  }

  class Player {
    float x;
    float y;
    float a;
    Player() {
      this.x=0;
      this.y=0;
      this.a=0;
    }
    void roll() {
      this.a+=av;
    }
    void show() {
      push();
      translate(width/2, height/2);
      fill(255, 0, 0);
      noStroke();
      ellipse(0, 0, 12, 12);
      rotate(this.a*py/5.0f);
      fill(255, 200);
      ellipse(0, 4, 3, 3);
      pop();
    }
  }

  class Ring {
    float r;
    float a;
    Ring(float r, float a) {
      this.r=r;
      this.a=a;
    }
    void show() {
      push();
      translate(width/2, height/2-py);
      rotate(HALF_PI);
      float da = 10*PI/this.r;
      stroke(255);
      noFill();
      strokeWeight(3);
      strokeCap(SQUARE);
      arc(0, 0, this.r, this.r, this.a, this.a+(2*PI)-da);
      pop();
    }
    void move() {
      this.a+=av * 2.0f;
      this.a%=TWO_PI;
    }
    boolean touching() {
      float da = (7.5*PI/this.r);
      return py+8>this.r/2.0f && py<=this.r/2.0f && abs(this.a-da)%TWO_PI>da/2.0f && py>=0;
    }
  }

  class Roller {
    float a;
    float r;
    float av;
    Roller(float r) {
      this.a = random(TWO_PI);
      this.r = r/2.0f-10;
      //    this.av = random(-2.5, 2.5)/100.0f;
      this.av = random(-1.0, 1.0) * 0.005f;
    }
    void move() {
      this.a+=this.av+av;
    }
    boolean touching() {
      float x = width/2.0f+this.r*cos(this.a);
      float y = height/2.0f-py+this.r*sin(this.a);
      float d = dist(x, y, width/2.0f, height/2.0f);
      return d<15;
    }
    void show() {
      float x = width/2.0f+this.r*cos(this.a);
      float y = height/2.0f-py+this.r*sin(this.a);
      fill(0, 0, 200);
      ellipse(x, y, 18, 18);
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();
  }
}
