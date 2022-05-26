// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】sttfff
// https://neort.io/art/bnn4ek43p9f5erb53gh0
//

class GameSceneCongratulations170 extends GameSceneCongratulationsBase {
  ArrayList<Piece> pieces = new ArrayList();
  color[] pallete = {#067bc2, #84bcda, #ecc30b, #f37748, #d56062};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    newForm();
  }
  @Override void draw() {
    push();
    rectMode(CENTER);
    background(0);
    for (int i=0; i<pieces.size(); i++) {
      pieces.get(i).run();
    }

    if (frameCount % (60*9) == 0) {
      newForm();
    }
    pop();

    logoRightLower(#ff0000);
  }

  void rectRec(float x_, float y_, float w_, float h_) {
    int c1 = int(random(2, 4));
    int c2 = int(random(2, 4));
    float w = w_/(float)c1;
    float h = h_/(float)c2;
    for (int i=0; i<c1; i++) {
      for (int j=0; j<c2; j++) {
        float x = x_+i*w;
        float y = y_+j*h;
        if (random(1) < 0.8 && w > 50 && h > 50) {
          rectRec(x, y, w, h);
        } else {
          pieces.add(new Piece(x + w/2.0f, y+h/2.0f, w, h));
        }
      }
    }
  }

  void newForm() {
    float w = width*0.5;
    float h = height*0.5;
    float x = (width-w)/2.0f;
    float y = (height-h)/2.0f;
    //pieces.length = 0;
    pieces.clear();
    rectRec(x, y, w, h);
  }

  float easeInOutQuart(float t, float b, float c, float d) {
    if ((t/=d/2.0f) < 1) return c/2.0f*t*t*t*t + b;
    return -c/2.0f * ((t-=2)*t*t*t - 2) + b;
  }

  //---------------------------------------------------------------

  class Piece {
    PVector pos0, pos;
    PVector center, vec1, vec2, pos1;
    float w0, h0, w, h, w1, h1;
    int maxT, t, t0, t1, t2, t3, t4, t5, t6, t7;
    DrawLine drawLine;
    color col0, col1, col2, fCol, sCol;

    Piece(float x, float y, float w, float h) {
      this.pos0 = new PVector(x, y);
      this.pos = this.pos0;
      this.center = new PVector(width / 2.0f, height / 2.0f);
      this.vec1 = PVector.sub(this.pos0, this.center);
      this.vec2 = PVector.mult(this.vec1, 2);
      this.pos1 = PVector.add(this.center, this.vec2);
      this.w0 = w*0.5;
      this.h0 = h*0.5;
      this.w = this.w0;
      this.h = this.h0;
      this.w1 = w;
      this.h1 = h;
      this.maxT = 100;
      this.t = -int(random(this.maxT));
      this.t0 = 0;
      this.t1 = this.t0+130;
      this.t2 = this.t1+50;
      this.t3 = this.t2+70;
      this.t4 = this.t3+(this.maxT+this.t)+10;
      this.t5 = this.t4+70;
      this.t6 = this.t5+80;
      this.t7 = this.t6+30;
      this.drawLine = new DrawLine(x, y, this.w0, this.h0, this.t0, this.t1, this.t);
      this.col0 = color(#ffffff);
      this.col1 = color(#000000);
      this.col2 = color(P5JSrandom(pallete));
      this.fCol = this.col1;
      this.sCol = this.col0;
    }

    void show() {
      if (this.t1 < this.t) {
        stroke(this.sCol);
        fill(this.fCol);
        rect(this.pos.x, this.pos.y, this.w, this.h);
      } else {
        this.drawLine.run();
      }
    }

    void move() {
      if (this.t1 < this.t && this.t < this.t2) {
        this.pos = PVector.lerp(this.pos0, this.pos1, this.easing(this.t1, this.t2 - 1));
      }
      if (this.t2 < this.t && this.t < this.t3) {
        //noStroke();
        float amt = this.easing(this.t2, this.t3-1);
        this.fCol = lerpColor(this.col1, this.col2, amt);
        this.w = lerp(this.w0, this.w1, amt);
        this.h = lerp(this.h0, this.h1, amt);
      }
      if (this.t4 < this.t && this.t < this.t5) {
        this.sCol = lerpColor(this.col0, this.col2, this.easing(this.t4, this.t5 - 1));
        this.pos = PVector.lerp(this.pos1, this.pos0, this.easing(this.t4, this.t5 - 1));
      }
      if (this.t6 < this.t && this.t < this.t7) {
        float alph = lerp(255, 0, this.easing(this.t6, this.t7 - 1));
        //this.sCol.setAlpha(alph);
        //this.fCol.setAlpha(alph);
        this.sCol = color(this.sCol, alph);
        this.fCol = color(this.fCol, alph);
      }
      this.t++;
    }

    void run() {
      this.show();
      this.move();
    }

    float easing(float start, float end) {
      float amt = map(this.t, start, end, 0, 1);
      return easeInOutQuart(amt, 0, 1, 1);
    }
  }

  //-------------------------------------------------------

  class DrawLine {
    PVector startP1, endP1, pos1;
    PVector startP2, endP2, pos2;
    PVector startP3, endP3, pos3;
    PVector startP4, endP4, pos4;
    int t, start, end, total;

    DrawLine(float x, float y, float w, float h, int start, int end, int current) {
      float hw = w/2.0f;
      float hh = h/2.0f;
      this.startP1 = new PVector(x-hw, y-hh);
      this.endP1 = new PVector(x+hw, y-hh);
      this.pos1 = this.startP1;
      this.startP2 = new PVector(x+hw, y-hh);
      this.endP2 = new PVector(x+hw, y+hh);
      this.pos2 = this.startP2;
      this.startP3 = new PVector(x+hw, y+hh);
      this.endP3 = new PVector(x-hw, y+hh);
      this.pos3 = this.startP3;
      this.startP4 = new PVector(x-hw, y+hh);
      this.endP4 = new PVector(x-hw, y-hh);
      this.pos4 = this.startP4;
      this.t = current;
      this.start = start;
      this.end = end;
      this.total = end-start;
    }

    void show() {
      if (this.start < this.t) {
        stroke(255);
        line(this.startP1.x, this.startP1.y, this.pos1.x, this.pos1.y);
        line(this.startP2.x, this.startP2.y, this.pos2.x, this.pos2.y);
        line(this.startP3.x, this.startP3.y, this.pos3.x, this.pos3.y);
        line(this.startP4.x, this.startP4.y, this.pos4.x, this.pos4.y);
      }
    }

    void move() {
      if (this.start < this.t && this.t <= this.end) {
        float amt = easeInOutQuart(this.t, this.start, this.end, this.total)/(float)this.total;
        this.pos1 = PVector.lerp(this.startP1, this.endP1, amt);
        this.pos2 = PVector.lerp(this.startP2, this.endP2, amt);
        this.pos3 = PVector.lerp(this.startP3, this.endP3, amt);
        this.pos4 = PVector.lerp(this.startP4, this.endP4, amt);
      }
      this.t ++;
    }

    void run() {
      this.show();
      this.move();
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
