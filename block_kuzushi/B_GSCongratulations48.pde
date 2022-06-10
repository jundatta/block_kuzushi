// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Slot Machine
// https://openprocessing.org/sketch/1025533
//

class GameSceneCongratulations48 extends GameSceneCongratulationsBase {
  //final String[] reel0={"7", "Bell", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar", "Berry", "Orange"};
  //final String[] reel1={"7", "Berry", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell", "Bar", "Cherry"};
  //final String[] reel2={"7", "Berry", "Bell", "Orange", "Bell", "Berry", "Bell", "Orange", "Bell", "Berry", "Bell", "Bar", "Bell", "Orange", "Bell", "Berry", "Bell", "Orange", "Bell", "Berry", "Bell", "Orange"};
  final String[] reel0={"7", "Bell", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar", "Berry", "Orange", "Berry", "Cherry", "Berry", "Bar"};
  final String[] reel1={"7", "Berry", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell", "Bar", "Cherry", "Bar", "Orange", "Bar", "Bell"};
  final String[] reel2={"7", "Berry", "Bell", "Orange", "Bell", "Berry", "Bell", "Orange", "Bell", "Berry", "Bell", "Bar", "Bell", "Orange", "Bell", "Berry", "Bell", "Orange", "Bell", "Berry"};
  final String[][] reels={reel0, reel1, reel2};
  PImage[] strips= new PImage[3];
  Wheel[] wheels = new Wheel[3];
  ArrayList<Coin> coins = new ArrayList();
  //let click, lever, coins1, coins2;
  Arm arm;
  Cabinet cabinet;
  Chart chart;
  PImage logo;
  PFont font;
  int counter0=0;
  int counter1=10000;
  int counter1target=0;
  PVector rotate, rotatev;
  float total=0.0f;

  // 360°を割り切れるようにしたいので図柄を22[個]から20[個]に変更した
  final float MARK_NUM = 20;

  PGraphics pg;

  void P5preload() {
    strips[0] = loadImage("data/48/20Strip1.jpg");
    strips[1] = loadImage("data/48/20Strip2.jpg");
    strips[2] = loadImage("data/48/20Strip3.jpg");
    logo = loadImage("data/48/Bally.png");
    mMA.entry("click", "data/48/clicker.mp3");
    mMA.entry("lever", "data/48/lever.mp3");
    mMA.entry("coins1", "data/48/coins.wav");
    mMA.entry("coins2", "data/48/coins2.wav");
    font = createFont("data/48/ArchivoBlack-Regular.ttf", 50, true);
  }

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);
    pg = createGraphics(width, height);
    pg.beginDraw();
    logo(pg, color(255, 0, 0));
    pg.endDraw();

    P5preload();

    //  angleMode(DEGREES);
    for (int i=0; i<3; i++) {
      PVector pos = new PVector(-60+(i*60), 0, 0);
      wheels[i] = new Wheel(pos, strips[i], i);
    }
    arm = new Arm();
    cabinet = new Cabinet();
    chart = new Chart();
    //reels.push(reel0);
    //reels.push(reel1);
    //reels.push(reel2);
    logo.resize(160, 0);
    imageMode(CENTER);
    textFont(font);
    counter0=0;
    rotate = new PVector(180, -180, 0);
    rotatev = new PVector(-9, 9, 0);
  }
  @Override void draw() {
    push();
    translate(width / 2, height / 2, +200);

    checkKeys();
    setScene();
    for (Wheel w : wheels) {
      w.spin();
      w.show();
    }
    arm.rotate();
    arm.show();
    counter0+=1;
    if (counter0==60) {
      threeBarSpin();
    }
    if (counter0==120) {
      arm.angtarget.x=-30;
    }
    cabinet.show();
    chart.show();
    for (Coin c : coins) {
      if (c.alive) c.move();
      c.show();
    }

    push();
    scale(0.8);
    translate(0, -140, 110 + 50);
    image(pg, 0, 0);
    pop();

    counter1+=1;
    if (counter1%10==0 && counter1<=counter1target) {
      coins.add(new Coin());
      total+=0.25;
    }
    if (counter0==260) {
      checkResult();
    }
    pop();
  }

  void setScene() {
    background(0);
    //    lights();
    ambientLight(200, 200, 200);
    //  pointLight(150, 150, 150, 200, 200, 200);
    pointLight(255, 255, 255, 200, 200, 200);
    pointLight(255, 255, 255, 200, 200, 200);
    pointLight(255, 255, 255, 200, 200, 200);
    pointLight(255, 255, 255, 200, 200, 200);
    pointLight(255, 255, 255, 200, 200, 200);
    //  orbitControl(1, 1, 0.1);
    scale(0.9);
    rotate.add(rotatev);
    rotatev.mult(0.95);
    rotateX(radians(rotate.x));
    rotateY(radians(rotate.y));
    translate(0, -50, 0);
  }

  void checkKeys() {
    if (keyCode==RIGHT) rotatev.y+=0.3;
    if (keyCode==LEFT) rotatev.y-=0.3;
    if (keyCode==DOWN) rotatev.x-=0.3;
    if (keyCode==UP) rotatev.x+=0.3;
  }

  void threeBarSpin() {
    arm.angtarget.x=-80;
    mMA.playAndRewind("lever");
    wheels[0].av=28.146454;
    wheels[0].spinning=true;
    wheels[1].av=121.12816;
    wheels[1].spinning=true;
    wheels[2].av=543.10364;
    wheels[2].spinning=true;
  }

  void spinWheels() {
    if (arm.angtarget.x!=-80 && counter1>counter1target+30 && wheels[2].spinning==false) {
      if (total>0) {
        total-=0.25;
        //      coins.pop();
        if (0 < coins.size()) {
          coins.remove(coins.size()-1);
        }
        arm.angtarget.x=-80;
        counter0=61;
        mMA.playAndRewind("lever");
        wheels[0].av=random(20, 40);
        wheels[0].spinning=true;
        wheels[1].av=random(100, 150);
        wheels[1].spinning=true;
        wheels[2].av=random(500, 550);
        wheels[2].spinning=true;
      } else {
        mMA.playAndRewind("coins1");
      }
    }
  }

  void checkResult() {
    String itema = reels[wheels[0].id][(int)wheels[0].a];
    String itemb = reels[wheels[1].id][(int)wheels[1].a];
    String itemc = reels[wheels[2].id][(int)wheels[2].a];
    if (itema == "7" && itemb == "7" && itemc == "7") makeCoins(80);
    if (itema == "Bar" && itemb == "Bar" && itemc == "Bar") makeCoins(20);
    if (itema == "Bell" && itemb == "Bell" && itemc == "Bell") makeCoins(18);
    if (itema == "Bell" && itemb == "Bell" && itemc == "Bar") makeCoins(18);
    if (itema == "Berry" && itemb == "Berry" && itemc == "Berry") makeCoins(15);
    if (itema == "Berry" && itemb == "Berry" && itemc == "Bar") makeCoins(15);
    if (itema == "Orange" && itemb == "Orange" && itemc == "Orange") makeCoins(10);
    if (itema == "Orange" && itemb == "Orange" && itemc == "Bar") makeCoins(10);
    if (itema == "Cherry" && itemb == "Cherry") makeCoins(5);
    else if (itema=="Cherry") makeCoins(3);
  }

  void makeCoins(int number) {
    counter1=0;
    counter1target=10*number;
  }

  class Arm {
    PVector pos;
    PVector ang;
    PVector angtarget;
    PShape[] cylinders = new PShape[4];
    Arm() {
      this.pos = new PVector(120, 120, 40);
      this.ang = new PVector(-30, 0, 0);
      this.angtarget = new PVector(-30, 0, 0);
      cylinders[0] = createCan(10, 42, 24, true, true);
      cylinders[0].setFill(color(250, 0, 0, 150));
      cylinders[1] = createCan(20, 20, 24, true, true);
      cylinders[1].setFill(color(100));
      cylinders[2] = createCan(5, 100, 24, true, true);
      cylinders[2].setFill(color(100));
      cylinders[3] = createCan(5, 100, 24, true, true);
      cylinders[3].setFill(color(100));
    }
    void rotate() {
      this.ang.x+=(this.angtarget.x-this.ang.x)/3.0f;
    }

    void show() {
      push();
      translate(this.pos.x, this.pos.y, this.pos.z);
      rotateX(radians(this.ang.x));
      rotateY(radians(this.ang.y));
      rotateZ(radians(this.ang.z));
      noStroke();
      rotateZ(radians(90));
      //    specularMaterial(250, 0, 0, 150);
      //    fill(color(250, 0, 0, 150));
      //    cylinder(10, 42);
      shape(cylinders[0]);
      translate(0, -10, 0);
      //    specularMaterial(100);
      //    fill(100);
      //    cylinder(20, 20);
      shape(cylinders[1]);
      rotateZ(radians(-90));
      translate(0, -50, 0);
      //    cylinder(5, 100);
      shape(cylinders[2]);
      translate(0, -50, 0);
      sphere(5);
      rotateX(radians(30));
      translate(0, -50, 0);
      //    cylinder(5, 100);
      shape(cylinders[3]);
      translate(0, -50, 0);
      //    specularMaterial(250, 0, 0, 150);
      fill(color(250, 0, 0, 150));
      sphere(16);
      pop();
    }
  }

  class Cabinet {
    Cabinet() {
    }
    void show() {
      push();
      translate(0, 195, 110);
      noStroke();
      //    specularMaterial(100);
      fill(100);
      translate(0, 40, 0);
      box(160, 30, 4);
      translate(0, 0, 60);
      box(160, 30, 1);
      translate(0, 0, 2);
      textAlign(CENTER, CENTER);
      textSize(24);
      push();
      fill(50);
      if (total>0) text("$"+String.format("%.02f", total), 0, 0);
      else text("BUST!", 0, 0);
      pop();
      translate(-80, 0, -32);
      box(1, 30, 60);
      translate(160, 0, 0);
      box(1, 30, 60);
      translate(-80, 15, 0);
      box(160, 1, 60);
      translate(0, -248, -42);
      //    specularMaterial(255, 0);
      fill(color(255, 255, 255, 0));
      //stroke(200);
      box(150, 40, 22); //Reel slot
      translate(0, 195, 0);
      box(120, 30, 22); //Coin slot
      translate(0, -115, -100);
      //    specularMaterial(250, 0, 0, 80);
      fill(color(250, 0, 0, 80));
      box(200, 400, 220); //Body
      translate(0, -242, 80);
      box(logo.width, logo.height, 10);
      translate(0, 0, 6);
      tint(180, 0, 0);
      image(logo, 0, 0);
      pop();
    }
  }

  class Chart {
    Chart() {
    }
    void show() {
      push();
      translate(0, 105, 112);
      //    specularMaterial(200);
      fill(200);
      textAlign(CENTER, CENTER);
      textSize(9);
      text("7 - 7 - 7 = 50", 0, 0);
      text("Bar - Bar - Bar = 20", 0, 8);
      text("Bell - Bell - Bell = 18", 0, 16);
      text("Berry - Berry - Berry = 15", 0, 24);
      text("Berry - Berry - Bar = 15", 0, 32);
      text("Orange - Orange - Orange = 12", 0, 40);
      text("Orange - Orange - Bar = 10", 0, 48);
      text("Cherry - Cherry - Any = 5", 0, 56);
      text("Cherry - Any - Any = 3", 0, 64);
      pop();
    }
  }

  class Coin {
    PVector pos;
    PVector posv;
    PVector ang;
    PVector angv;
    boolean alive;
    PShape cylinder;
    Coin() {
      this.pos = new PVector(random(-12, 12), 170, 85);
      this.posv = new PVector(random(-2, 2), 0, random(2, 3.5));
      this.ang = new PVector(0, 0, 0);
      this.angv = new PVector(random(-30, 30), random(-10, 10), 0);
      this.alive=true;
      cylinder = createCan(12, 2, 24, true, true);
      cylinder.setFill(color(207, 181, 159));
    }
    void move() {
      if (this.pos.y<230) {
        this.pos.add(this.posv);
        this.ang.add(this.angv);
        this.posv.y+=.3;
      } else {
        this.posv = this.posv.mult(0);
        this.angv = this.angv.mult(0);
        this.pos.y+=10;
        this.ang.mult(0);
        mMA.playAndRewind("coins2");
        this.alive=false;
      }
    }
    void show() {
      push();
      translate(this.pos.x, this.pos.y, this.pos.z);
      rotateX(radians(this.ang.x));
      rotateY(radians(this.ang.y));
      rotateZ(radians(this.ang.z));
      noStroke();
      //    specularMaterial(207, 181, 159);
      //    cylinder(12, 2);
      shape(cylinder);
      pop();
    }
  }

  class Wheel {
    PVector pos;
    float a;
    float av;
    PImage txt;
    boolean spinning;
    int id;
    PShape cylinder;
    Wheel(PVector pos, PImage txt, int id) {
      this.pos=pos;
      this.a=0;
      this.av=0;
      this.txt=txt;
      this.spinning=false;
      this.id=id;
      cylinder = createCan((800/TWO_PI), this.txt.height, 20);
      cylinder.setTexture(this.txt);
    }
    void spin() {
      this.a+=this.av;
      this.av*=0.95;
      if (this.av<0.1) {
        this.av=0;
        this.a=floor(this.a);
        this.a%=MARK_NUM;
        if (this.spinning) {
          mMA.playAndRewind("click");
          this.spinning=false;
        }
      }
    }
    void show() {
      push();
      scale(0.8);
      translate(this.pos.x, this.pos.y, this.pos.z);
      rotateZ(radians(-90));
      rotateY(radians((360/MARK_NUM*this.a)+7));
      //    if (this.id==0) P5RotateY(1); //Fix left wheel alignment
      texture(this.txt);
      noStroke();
      //    cylinder(800/TWO_PI, this.txt.height, 24, 1, false, false);
      shape(cylinder);
      pop();
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (keyCode==32) spinWheels();
  }
  @Override void keyReleased() {
    keyCode = 0;
  }
}
