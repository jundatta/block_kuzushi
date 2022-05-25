// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Mechanical Hand
// https://openprocessing.org/sketch/1022520
//

class GameSceneCongratulations115 extends GameSceneCongratulationsBase {
  Digit[] digits = new Digit[5];
  PVector handPos, handVel;
  float zoom, ztarget;
  boolean auto = true;
  float angle = 0;

  PShape palmS;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    //  angleMode(DEGREES);
    makeDigits();
    zoom = 1;
    ztarget = 1.1;

    palmS = createTorus(65, 20, 10, 15);
  }
  @Override void draw() {
    translate(width / 2, height / 2);

    setLighting();
    orientDisplay();
    drawPalm();
    for (Digit d : digits) {
      d.show();
      d.flexback();
    }
    rotateHand();
    operateDigits();
    if (auto) curl();

    logoRightLower(color(255, 0, 0));
  }

  void makeDigits() {
    handPos = new PVector(40, 50, 10);
    handVel = new PVector(7, 5, -2.5);
    for (int i=0; i<4; i++) {
      float x = -85+i*35;
      float y = 20*sin(radians(55*i+10));
      PVector pos = new PVector(x, y, y);
      PVector angles = new PVector(-10+12*i, 3*i, -3*i);
      float l = 70+y/2.0f;
      digits[i] = new Digit(l, 2*l/3.0f, pos, angles, i);
    }
    PVector pos = new PVector(35, 0, -36);
    PVector angles = new PVector(65, -20, -65);
    digits[4] = new Digit(60, 60, pos, angles, 4); //Thumb
  }

  void setLighting() {
    background(0);
    //    ambientLight(100,100,100);
    ambient(100);
    pointLight(150, 150, 150, 200, 200, 200);
    pointLight(150, 150, 150, 200, 200, 200);
    //  orbitControl(1, 1, 0.01);
    noStroke();
    specular(50);
  }

  void orientDisplay() {
    scale(zoom);
    zoom = lerp(zoom, ztarget, 0.1);
    handPos.add(handVel);
    handVel.mult(0.95);
    rotateX(radians(handPos.x));
    rotateY(radians(handPos.y));
    rotateZ(radians(-handPos.z));
  }

  void drawPalm() {
    push();
    translate(-30, -5, -45);
    rotateZ(radians(0));
    rotateX(radians(-18));
    //  ellipsoid(65, 18);
    push();
    scale(1.0f, 18.0f/65.0f, 1.0f);
    sphere(65);
    pop();
    rotateX(radians(90));
    //  torus(65, 20, 10);
    shape(palmS);
    pop();
  }

  void rotateHand() {
    //if (keyCode == UP) handVel.x+=.2;
    //if (keyCode == DOWN) handVel.x-=.2;
    if (keyCode == UP) ztarget+=0.1;
    if (keyCode == DOWN) ztarget-=0.1;

    if (keyCode == LEFT) handVel.y+=.2;
    if (keyCode == RIGHT) handVel.y-=.2;
    if (keyCode == SHIFT) handVel.z+=.2;
    if (keyCode == CONTROL) handVel.z-=.2;
  }

  void operateDigits() {
    if (key == 'a') {
      digits[0].a1-=4;
      digits[0].a2-=8;
    }
    if (key == 's') {
      digits[1].a1-=4;
      digits[1].a2-=8;
    }
    if (key == 'd') {
      digits[2].a1-=4;
      digits[2].a2-=8;
    }
    if (key == 'f') {
      digits[3].a1-=4.5;
      digits[3].a2-=7;
    }
    if (key == ' ') {
      digits[4].a1-=5;
      digits[4].a2-=5;
    }
  }

  void curl() {
    digits[3].a1=-10+20*sin(radians(angle));
    digits[3].a2=-30+40*sin(radians(angle));
    digits[2].a1=-10+20*sin(radians(angle+20));
    digits[2].a2=-30+40*sin(radians(angle+20));
    digits[1].a1=-10+20*sin(radians(angle+40));
    digits[1].a2=-30+40*sin(radians(angle+40));
    digits[0].a1=-10+20*sin(radians(angle+60));
    digits[0].a2=-30+40*sin(radians(angle+60));
    digits[4].a1=-10+40*sin(radians(angle-20));
    digits[4].a2=-30+40*sin(radians(angle-20));
    angle-=1.5;
    handPos.z=-30+40*sin(radians(angle/2.0f));
  }

  class Digit {
    float l1;
    float l2;
    float l3;
    float r;
    PVector pos;
    PVector angles;
    float a1;
    float a2;
    int id;
    PShape[] baseS = new PShape[3];
    PShape[] middleS = new PShape[5];
    PShape[] tipS = new PShape[3];

    Digit(float l, float r, PVector pos, PVector angles, int id) {
      this.l1=l;
      this.l2=0.8*l;
      this.l3=0.6*l;
      this.r=r;
      this.pos=pos;
      this.angles=angles;
      this.a1 = -50;
      this.a2 = -75;
      this.id = id;
      this.baseS[0] = createCan(this.r/3.5, this.l1*0.6, 24);
      this.baseS[1] = createCan(this.r/4.0f, this.r/9.0f, 24);
      this.baseS[2] = createCan(this.r/12.0f, this.r/2.0f, 24);
      this.middleS[0] = createCan(this.r/4.0f, this.r/8.0f, 24);
      this.middleS[1] = createCan(this.r/4.0f, this.r/8.0f, 24);
      this.middleS[2] = createCan(this.r/3.5, this.l2*0.6, 24);
      this.middleS[3] = createCan(this.r/4.0f, this.r/9.0f, 24);
      this.middleS[4] = createCan(this.r/12.0f, this.r/2.0f, 24);
      this.tipS[0] = createCan(this.r/4.0f, this.r/8.0f, 24);
      this.tipS[1] = createCan(this.r/4.0f, this.r/8.0f, 24);
      this.tipS[2] = createCan(this.r/3.5, this.l3*0.5, 24);
    }
    void flexback() {
      this.a1*=0.9;
      this.a2*=0.9;
    }
    void show() {
      push();
      this.orient();
      this.base();
      this.middle();
      this.tip();
      pop();
    }

    void orient() {
      translate(this.pos.x, this.pos.y, this.pos.z);
      rotateZ(radians(90));
      rotateX(radians(this.angles.x));
      rotateY(radians(this.angles.y));
      rotateZ(radians(this.angles.z));
    }

    void base() {
      rotateY(radians(this.a1));
      translate(0, -this.r/6.0f, 0);
      box(this.r/4.0f, this.r/8.0f, this.r/1.7);
      translate(0, 0, this.l1/2.0f);
      rotateX(radians(90));
      //    cylinder(this.r/3.5, this.l1*0.6);
      shape(baseS[0]);
      rotateX(radians(-90));
      translate(0, 0, this.l1*0.15);
      box(this.r/2, this.r/9, this.l1*0.7);
      translate(0, 0, this.l1*0.35);
      //    cylinder(this.r/4, this.r/9);
      shape(baseS[1]);
      //    cylinder(this.r/12, this.r/2);
      shape(baseS[2]);
    }

    void middle() {
      rotateY(radians(-10+this.a2));
      translate(0, -this.r/8.0f, 0);
      //    cylinder(this.r/4, this.r/8);
      shape(middleS[0]);
      translate(0, this.r/4, 0);
      //    cylinder(this.r/4, this.r/8);
      shape(middleS[1]);
      translate(0, -this.r/8, 0);
      translate(0, 0, this.l2/2.0f);
      rotateX(radians(90));
      //    cylinder(this.r/3.5, this.l2*0.6);
      shape(middleS[2]);
      rotateX(radians(-90));
      translate(0, 0, this.l2*0.15);
      box(this.r/2.0f, this.r/9.0f, this.l2*0.7);
      translate(0, 0, this.l2*0.35);
      //    cylinder(this.r/4, this.r/9);
      shape(middleS[3]);
      //    cylinder(this.r/12, this.r/2);
      shape(middleS[4]);
    }
    void tip() {
      rotateY(radians(-15+this.a2));
      translate(0, -this.r/8, 0);
      //    cylinder(this.r/4, this.r/8);
      shape(tipS[0]);
      translate(0, this.r/4, 0);
      //    cylinder(this.r/4, this.r/8);
      shape(tipS[1]);
      translate(0, -this.r/8, 0);
      translate(0, 0, this.l3/2);
      rotateX(radians(90));
      //    cylinder(this.r/3.5, this.l3*0.5);
      shape(tipS[2]);
      rotateX(radians(-90));
      translate(0, 0, this.l3/3.8);
      sphere(this.r/3.5);
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == 'r') {
      auto=true;
      angle=-10;
    } else {
      auto=false;
    }
  }
}
