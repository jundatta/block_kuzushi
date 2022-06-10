// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Bowling in Space
// https://openprocessing.org/sketch/976330
//

class GameSceneCongratulations144 extends GameSceneCongratulationsBase {
  PShape obj;
  ArrayList<Pin> pins = new ArrayList();
  Ball ball;
  Floor floor;
  PImage img;
  PImage img3;

  PShape shapeBall;
  PShape shapeSpace;

  void preload() {
    img = loadImage("data/144/marble.jpg");
    shapeBall = createShape(SPHERE, 60);
    shapeBall.setTexture(img);
    shapeBall.setStrokeWeight(0);
    img3 = loadImage("data/144/space.jpg");
    shapeSpace = createShape(BOX, 12000, 6000, 1);
    shapeSpace.setTexture(img3);
    obj = loadShape("data/144/pin.obj");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();
    //  angleMode(DEGREES);
    ball = new Ball();
    floor = new Floor();
    for (int row=0; row<4; row+=1) {
      int z = -250-100*row;
      for (int p=0; p<row+1; p+=1) {
        int x = -row*60+p*120;
        PVector pvect = new PVector(x, 0, z);
        pins.add(new Pin(pvect));
      }
    }
  }
  @Override void draw() {
    background(0, 0, 0);
    ambientLight(155, 155, 155);
    pointLight(220, 220, 220, 500, -500, 600);
    if (ball.pvect.z>0) {
      camera(ball.pvect.x/3, -100+ball.pvect.z/6.0f, ball.pvect.z+350, 0, 0, 0, 0, 1, 0);
    }
    noStroke();
    checkKeys();
    ball.move();
    ball.show();
    for (Pin p1 : pins) {
      p1.move();
      p1.show();
      if (p1.intersects(ball.pvect)) {
        p1.tumbling=true;
        p1.topple(ball.dpvect, ball.pvect);
      }
      for (Pin p2 : pins) {
        if (p2.intersects(p1.pvect) && p1!=p2) {
          p2.tumbling=true;
          p2.topple(p1.dpvect, p1.pvect);
        }
      }
    }
    drawScrim();
    floor.show();

    logoRightLower(color(255, 0, 0));
  }

  boolean checkKeyArrow() {
    if (keyCode == UP) {
      ball.dpvect.z-=.1;
      return true;
    }
    if (keyCode == RIGHT) {
      ball.dpvect.x+=.1;
      return true;
    }
    if (keyCode == LEFT) {
      ball.dpvect.x-=.1;
      return true;
    }
    return false;
  }
  void checkKeys() {
    if (checkKeyArrow()) {
      keyCode = 0;
    }
    if (abs(ball.pvect.x)>300) {
      ball.pvect.x-=ball.dpvect.x;
      ball.dpvect.x*=-.8;
    }
  }

  class Ball {
    PVector pvect;
    PVector dpvect;
    PVector ddpvect;
    PVector avect;
    PVector davect;
    Ball() {
      this.reset();
    }
    void reset() {
      this.pvect = new PVector(0, 0, 1600);
      this.dpvect = new PVector(0, 0, 0);
      this.ddpvect = new PVector(0, 0, 0);
      this.avect = new PVector(0, 0, 0);
      this.davect = new PVector(0, 0, 0);
    }
    void roll() {
      this.dpvect.z=-11;
      this.dpvect.x=(mouseX-width/2.0f)/50.0f;
      if (this.dpvect.x>6) {
        this.dpvect.x=6;
      }
      if (this.dpvect.x<-6) {
        this.dpvect.x=-6;
      }
      this.ddpvect.x=-ball.dpvect.x/50.0f;
    }
    void move() {
      this.dpvect.add(this.ddpvect);
      this.pvect.add(this.dpvect);
      this.avect.add(this.dpvect);
      if (this.pvect.z<-700) {
        this.dpvect.z=0;
        this.dpvect.x=0;
        this.ddpvect.x=0;
        this.davect.x=0;
      }
    }
    void show() {
      push();
      translate(this.pvect.x, this.pvect.y+37, this.pvect.z);
      this.avect = this.pvect;
      rotateX(radians(this.avect.z*-2));
      rotateY(radians(this.avect.y));
      rotateZ(radians(this.avect.x));
      //texture(img);
      //sphere(60);
      shape(shapeBall);
      pop();
    }
  }
  class Floor {
    PVector pvect;
    Floor() {
      this.pvect = new PVector(0, 0, 400);
    }
    void show() {
      push();
      translate(this.pvect.x, this.pvect.y+110, this.pvect.z);
      stroke(255, 200);
      fill(250, 30);
      rotateY(radians(90));
      box(2500, 30, 650);
      pop();
    }
  }
  class Pin {
    PVector pvect;
    PVector opvect;
    PVector dpvect;
    PVector avect;
    PVector davect;
    boolean tumbling;
    Pin(PVector pvect) {
      this.pvect=pvect;
      this.opvect = new PVector(pvect.x, pvect.y, pvect.z);
      this.dpvect = new PVector(0, 0, 0);
      this.avect = new PVector(90, 0, 0);
      this.davect = new PVector(0, 0, 0);
      this.tumbling = false;
    }
    void reset() {
      this.pvect = new PVector(this.opvect.x, this.opvect.y, this.opvect.z);
      this.dpvect=new PVector(0, 0, 0);
      this.avect=new PVector(90, 0, 0);
      this.davect=new PVector(0, 0, 0);
      this.tumbling=false;
    }

    void move() {
      this.pvect.add(this.dpvect);
      this.avect.add(this.davect);
      this.dpvect.mult(.9);
      this.davect.mult(.95);
      if (this.tumbling) {
        this.dpvect.y+=5;
      }
      if (this.pvect.z<-1800) {
        this.dpvect.z*=0;
        this.davect.mult(0);
      }
    }
    void show() {
      push();
      translate(this.pvect.x, this.pvect.y+110, this.pvect.z);
      rotateX(radians(this.avect.x));
      rotateY(radians(this.avect.y));
      rotateZ(radians(this.avect.z));
      //    ambientMaterial(200, 200, 200);
      ambient(200, 200, 200);
      scale(5);
      shape(obj);
      pop();
    }
    void topple(PVector dpvect, PVector pvect) {
      if (this.tumbling) {
        this.dpvect.add(dpvect);
        this.davect.sub(pvect);
        this.dpvect.mult(2);
        this.dpvect.y-=25;
        this.davect.div(6);
      }
    }
    boolean intersects(PVector pvect) {
      return this.pvect.dist(pvect)<100;
    }
  }
  void drawScrim() {
    push();
    translate(0, 0, -1200 -(1200-ball.pvect.z)/4.0f);
    texture(img3);
    //  plane(12000, 6000);
    shape(shapeSpace);
    pop();
  }
  @Override void mousePressed() {
    if (ball.pvect.z<1200) {
      ball.reset();
    } else {
      ball.roll();
    }
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key==' ') {
      if (ball.pvect.z<1200) {
        ball.reset();
      }
      return;
    }
    if (key=='r') {
      for (Pin p : pins) {
        p.reset();
      }
      return;
    }
    if (checkKeyArrow()) {
      keyCode = 0;
      return;
    }
    gGameStack.change(new GameSceneTitle());
  }
}
