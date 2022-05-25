// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Manual Typewriter
// https://openprocessing.org/sketch/1049439
//

class GameSceneCongratulations79 extends GameSceneCongratulationsBase {
  PFont font;
  String alphabet;
  PVector cpos, ctarget;
  PVector cang, atarget;
  float pheight, bheight, theight, thtarget;
  float zoom = 0.5;
  float zvel = 0.15;
  ArrayList<Letter> letters = new ArrayList();
  ArrayList<Hammer> hammers = new ArrayList();
  float shift;
  float button, row, character;
  float lastStamp = 0;
  float interval=150;
  float pLight = -1000;

  PShape carriage;
  PShape paper;

  void P5preload() {
    font = createFont("data/79/SpecialElite.ttf", 50, true);
    mMA.entry("click", "data/79/key1.wav");
    mMA.entry("bell", "data/79/bell.mp3");
    mMA.entry("space", "data/79/reset3.mp3");
    mMA.entry("creturn", "data/79/return2.wav");
    mMA.entry("shifton", "data/79/shift-on.wav");
    mMA.entry("shiftoff", "data/79/shift-off.wav");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    // いい悪いは別として＼(^_^)／
    frameCount = 0;

    P5preload();

    textFont(font);
    cpos = new PVector(0, height/20.0f, 0);
    ctarget = new PVector(height/5.0f, height/24.0f, 0);
    cang = new PVector(0, 0, 0);
    atarget = new PVector(PI/24.0f, 0, 0);
    pheight = height/2.0f;
    bheight = height/12.0f;
    theight = 0;
    row = 800;
    character = 0;
    shift = height/13.0f;
    createHammers();

    carriage = createCan(height/20.0f, 3*height/5.0f, 96, true, true);
    paper = createCan(height/20.0f, height/2.0f, 96); //Mask bottom of roller
  }

  void createHammers() {
    float interval = HALF_PI/27.0f;
    alphabet = "abcdefghijklmnopqrstuvwxyz,.";
    int i = 0;
    for (float a=PI/4.0f; a<3*PI/4.0f; a+=interval) {
      PVector ang = new PVector(0, 0, (a-HALF_PI));
      char letter = alphabet.charAt(i);
      hammers.add( new Hammer(ang, ang.z, letter) );
      i+=1;
    }
  }

  @Override void draw() {
    push();
    translate(width/2, height/2);

    //  orbitControl();
    setScene();
    drawCarriage();
    drawPaper();
    for (Letter l : letters) {
      l.show();
    }
    drawHammers();
    checkArrows();
    pop();

    logoRightLower(color(255, 0, 0));
  }

  void setScene() {
    background(0);
    //  ambientLight(90, 90, 90);
    //  pointLight(60, 60, 60, 0, pLight, 500);
    ambientLight(128, 128, 128);
    pointLight(255, 255, 255, 0, pLight, 500);
    lightSpecular(255, 255, 255);
    if (frameCount>20) {
      zoom+=zvel;
      if (zoom<0.5 || zoom>4) {
        zoom-=zvel;
        zvel*=-0.5;
      }
      zvel*=0.85;
    }
    if (frameCount==40) mMA.playAndRewind("creturn");
    if (frameCount>40 && frameCount<100) {
      bheight = lerp(bheight, height/2.0f, 0.3);
      pheight = lerp(pheight, height/12.0f, 0.3);
    }
    if (frameCount>40) {
      atarget.x = lerp(atarget.x, (mouseY-height/2)/-600, 0.1);
      //if(!keyIsDown(RIGHT_ARROW) && !keyIsDown(LEFT_ARROW)) atarget.y = lerp(atarget.y, (mouseX-width/2)/800,0.1);
      cang.lerp(atarget, 0.1);
      cpos.lerp(ctarget, 0.3);
    }
    //  orbitControl(1, 1, 0.01);
    scale(zoom);
    rotateX(cang.x);
    rotateY(cang.y);
    rotateZ(cang.z);
  }

  void drawHammers() {
    translate(-5, cpos.y+shift, cpos.z+height/19.0f);
    rotateX(PI/2.0f);
    for (Hammer h : hammers) {
      h.move();
      h.show();
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyTyped() {
    typeChar(key);
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key==ENTER) returnCarriage();
    else if (keyCode==SHIFT) {
      mMA.playAndRewind("shifton");
      shift=height/11.0f;
    } else if (keyCode==33 && pheight<290) rollPaper(1);
    else if (keyCode==34 && pheight>height/12.0f) rollPaper(-1);
    else if (keyCode==8) deleteChar();
  }

  void deleteChar() {
    //  if (creturn.isPlaying()) return;
    mMA.playAndRewind("space");
    if (letters.size()<=0) return;
    //  PVector pos = new PVector(height/5.0f, height/24.0f, 0);
    int last = letters.size() - 1;
    PVector pos = letters.get(last).pos;
    letters.remove(last);
    if (pos.y+5<abs(theight)) {
      rollPaper(-1);
      mMA.playAndRewind("creturn");
    }
    cpos.x = pos.x;
    ctarget.x = pos.x;
  }

  void checkArrows() {
    if (keyCode == RIGHT) atarget.y-=0.1;
    if (keyCode == LEFT) atarget.y+=0.1;
    if (keyCode == UP) zvel+=0.02;
    if (keyCode == DOWN) zvel-=0.02;

    // いい悪いは別として＼(^_^)／
    keyCode = 0;
  }

  @Override void keyReleased() {
    if (keyCode==SHIFT) {
      mMA.playAndRewind("shiftoff");
      shift = height/13.0f;
    }
  }

  void typeChar(char chr) {
    //  if (creturn.isPlaying()) return;
    if (chr==' ') {
      mMA.playAndRewind("space");
    } else {
      mMA.playAndRewind("click");
      var i = alphabet.indexOf(str(chr).toLowerCase());
      if (i>-1) {
        hammers.get(i).atarget.y=3*PI/4.0f;
        hammers.get(i).counter=0;
      } else {
        hammers.get(26).atarget.y=3*PI/4.0f;
        hammers.get(26).counter=0;
      }
    }
    PVector pos = new PVector(cpos.x, -5-theight, 1+height/20.0f);
    letters.add(new Letter(pos, chr));
    cpos.x-=4.5;
    ctarget.x-=4.5;
    if (ctarget.x<-height/5.0f) {
      mMA.playAndRewind("bell");
      returnCarriage();
    }
  }

  void returnCarriage() {
    mMA.playAndRewind("creturn");
    ctarget.x = height/5.0f;
    if (pheight<290) {
      pheight+=8;
      bheight-=8;
      theight-=8;
    }
  }

  void rollPaper(float dir) {
    mMA.playAndRewind("space");
    pheight+=dir*8;
    bheight-=dir*8;
    theight-=dir*8;
  }

  void startOver() {
    returnCarriage();
    letters = new ArrayList();
    bheight = height/2.0f;
    pheight = height/12.0f;
    theight = 0;
  }

  void drawCarriage() {
    push();
    translate(cpos.x, cpos.y, cpos.z);
    noStroke();
    specular(50);
    carriage.setFill(color(50));
    carriage.setSpecular(color(50));
    rotateZ(PI/2.0f);
    //  cylinder(height/20, 3*height/5);
    shape(carriage);
    pop();
  }

  class Hammer {
    PVector ang;
    PVector atarget;
    float bend;
    float l;
    char letter;
    float counter;
    Hammer(PVector ang, float bend, char letter) {
      this.ang = ang;
      this.atarget = new PVector(ang.x, ang.y, ang.z);
      this.bend = bend;
      this.l = 68;
      this.letter = letter;
      this.counter = 10;
    }
    void move() {
      this.ang.lerp(this.atarget, 0.5);
      this.counter+=1;
      if (this.counter==4) this.atarget.y=0;
    }
    void show() {
      push();
      specular(180);
      fill(180);
      noStroke();
      rotateZ(this.ang.z);
      translate(0, 3*this.l/4.0f, 0);
      rotateX(this.ang.y);
      translate(0, this.l/2.0f, 0);
      box(1, this.l, 4);
      translate(0, this.l/2.0f, 0);
      rotateX(-PI/4.0f);
      rotateY(-this.bend);
      translate(0, this.l/8.0f, 0);
      box(5, this.l/4.0f, 6);
      translate(0, 0, 4);
      textAlign(CENTER, BOTTOM);
      textSize(7);
      specular(50);
      fill(50);
      rotateX(PI);
      //    text(this.letter.toUpperCase(), 0, 0);
      text(str(this.letter).toUpperCase(), 0, 0);
      text(this.letter, 0, 7);
      pop();
    }
  }

  class Letter {
    PVector pos;
    float tilt;
    char character;
    Letter(PVector pos, char character) {
      this.pos = pos;
      this.tilt = PI/12.0f;
      this.character = character;
    }
    void show() {
      push();
      translate(cpos.x, cpos.y, cpos.z);
      rotateX(this.tilt);
      translate(-this.pos.x, this.pos.y+theight, this.pos.z+2);
      fill(20);
      textAlign(CENTER, TOP);
      textSize(8);
      text(this.character, 0, 0);
      pop();
    }
  }

  void drawPaper() {
    push();
    noStroke();
    specular(251, 243, 211);
    paper.setFill(color(251, 243, 211));
    paper.setSpecular(color(251, 243, 211));
    fill(251, 243, 211);
    translate(cpos.x, cpos.y, cpos.z);
    rotateX(PI/12.0f);
    translate(0, 1, 0);
    rotateZ(PI/2.0f);
    //  cylinder(height/20, height/2, 24, 1, false, false); //Mask bottom of roller
    shape(paper);

    translate(-pheight/2.0f, -0, height/20.0f);
    //  plane(pheight, height/2); //Front sheet
    box(pheight, height/2.0f, 1); //Front sheet
    translate(pheight/2.0f, 0, -height/10.0f);
    translate(-bheight/2.0f, 0, 0);
    //  plane(bheight, height/2); //Back sheet
    box(bheight, height/2.0f, 1); //Back sheet
    pop();
  }
}
