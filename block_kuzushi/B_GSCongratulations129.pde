// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Flip Clock
// https://openprocessing.org/sketch/982843
//

class GameSceneCongratulations129 extends GameSceneCongratulationsBase {
  PFont font;
  float tabsize;
  float lastval = -1;
  int h0, h1, m0, m1, s0, s1;
  Digit hour0, hour1, min0, min1, sec0, sec1;
  //float zoom = 1500;
  float zoom = 3150;
  float zvel = -20;
  float xpos = 800;
  float xvel = -16;
  //let click;
  boolean soundon=true;
  float orientation = 1;
  float mX = 0;

  void preload() {
    font = createFont("data/129/ArchivoBlack-Regular.ttf", 50, true);
    mMA.entry("click2", "data/129/click2.mp3");
  }
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();
    //  angleMode(DEGREES);
    //colorMode(HSB);
    tabsize=height/3.5;
    textSize(1.2*tabsize);
    textFont(font);
    textAlign(CENTER, CENTER);
    getTime();
    hour0 = new Digit(-2.6*tabsize, 2, h0);
    hour1 = new Digit(-1.6*tabsize, 10, h1);
    min0 = new Digit(-.5*tabsize, 6, m0);
    min1 = new Digit(.5*tabsize, 10, m1);
    sec0 = new Digit(1.6*tabsize, 6, s0);
    sec1 = new Digit(2.6*tabsize, 10, s1);
  }
  @Override void draw() {
    background(0);
    logoRightLower(color(255, 0, 0));

    push();
    noStroke();
    setLighting();
    zoomCamera();
    getTime();
    if (zoom>0) orientation = 1;
    else orientation = -1;
    if (s1!=lastval) {
      //    if (soundon && lastval!=-1) click.play();
      if (soundon && lastval!=-1) mMA.playAndRewind("click2");
      lastval = s1;
      hour0.update(h0);
      hour1.update(h1);
      min0.update(m0);
      min1.update(m1);
      sec0.update(s0);
      sec1.update(s1);
    }
    hour0.show();
    hour1.show();
    min0.show();
    min1.show();
    sec0.show();
    sec1.show();
    pop();
  }

  void getTime() {
    int h = hour();
    if (h>12) h-=12;
    h0 = int(h/10);
    h1 = h%10;
    m0 = int(minute()/10);
    m1 = minute()%10;
    s0 = int(second()/10);
    s1 = second()%10;
  }

  void setLighting() {
    ambientLight(125, 125, 125);
    mX = lerp(mX, orientation*(mouseX - (width / 2)), 0.1);
    pointLight(200, 125, 125, mX, -orientation*height/2, orientation*150);
    pointLight(200, 125, 125, mX, -orientation*height/2, orientation*150);
  }

  void zoomCamera() {
    zoom+=zvel;
    zvel*=.98;
    xpos+=xvel;
    xvel*=.98;
    if (xpos >1200 || xpos<-1200) {
      xvel*=-1;
    }
    if (keyCode == UP) {
      zvel-=0.5*orientation;
    }
    if (keyCode == DOWN) {
      zvel+=0.5*orientation;
    }
    if (keyCode == LEFT) {
      xvel-=0.5*orientation;
    }
    if (keyCode == RIGHT) {
      xvel+=0.5*orientation;
    }
    // キーの値が残らないようにどれにもかららない0を入れておく
    keyCode = 0;
    camera(xpos, 30, zoom, 0, 0, 0, 0, 1, 0);
  }

  class Digit {
    float x;
    int digits;
    float start;
    Tab[] tabs;
    PShape cylinder0;
    PShape cylinder1;
    Digit(float x, int digits, int start) {
      this.x = x;
      this.digits = digits;
      this.start = start;
      this.tabs = new Tab[digits];
      for (int i=0; i<digits; i++) {
        float a = (180/float(digits-1))*i;
        this.tabs[i] = new Tab(a, i, x, start, start, digits);
      }
      cylinder0 = createCan(0.02*tabsize, 0.95*tabsize, 24);
      // （PShader.setSpecular()。。。（効いてないような気がする。。。けど確証がにゃい））
      //cylinder0.setSpecular(color(155));
      cylinder0.setAmbient(color(155));
      cylinder1 = createCan(0.04*tabsize, 0.9*tabsize, 24);
      // （PShader.setSpecular()。。。（効いてないような気がする。。。けど確証がにゃい））
      //cylinder1.setSpecular(color(200, 0, 0, 220));
      cylinder1.setAmbient(color(200, 0, 0, 220));
    }
    void update(int target) {
      for (Tab t : this.tabs) {
        int delta = target - t.position;
        if (delta<0) delta=(this.digits-t.position)+target;
        t.ticks=delta;
        t.position=target;
        t.counter=0;
      }
    }
    void show() {
      push();
      translate(this.x, 0, 0);
      rotateZ(radians(90));
      //specular(155);
      //    cylinder(0.02*tabsize, 0.95*tabsize);
      shape(cylinder0);
      //specular(color(200, 0, 0, 220));
      //    cylinder(0.04*tabsize, 0.9*tabsize);
      shape(cylinder1);
      pop();
      for (Tab t : this.tabs) {
        t.hop();
        t.show();
      }
    }
  }

  class Tab {
    float a;
    float da;
    int id;
    float x;
    int position;
    int digits;
    int ticks;
    int counter;
    Tab(float a, int id, float x, int position, int adjust, int digits) {
      this.a = a;
      this.da = 18/float(digits-1);
      this.id = ((digits-id)+adjust)%digits;
      this.x = x;
      this.position = position;
      this.digits = digits;
      this.ticks = 0;
      this.counter = 0;
    }
    void show() {
      push();
      if (this.counter<10*this.ticks) {
        this.a+=this.da;
        this.counter+=1;
        if (this.a>360) {
          this.a=0;
        }
      }
      translate(this.x, 0, 0);
      rotateX(radians(-this.a));
      translate(0, tabsize/2.0f, 0);
      fill(color(200, 0, 0, 150));
      //specular(color(200, 0, 0, 150));
      box(0.9*tabsize, tabsize, 0.02*tabsize);
      fill(color(255, 150, 150));
      ambient(color(200, 100, 100));
      translate(0, -0.1*tabsize, 0.02*tabsize);
      scale(5.5);
      text((this.id)%10, 0, 0);
      pop();
    }
    void hop() {
      if ( this.a%360>=180 && this.a%360<=360) {
        this.da=20;
      } else {
        this.da=18/float(this.digits-1);
      }
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == ' ') soundon=!soundon;
  }
}
