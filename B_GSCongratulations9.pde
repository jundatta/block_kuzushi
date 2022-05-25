// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】reona396さん
// 【作品名】あの空間っぽいやつ
// https://openprocessing.org/sketch/1026345
//

class GameSceneCongratulations9 extends GameSceneCongratulationsBase {
  int objsNum = 70;
  Obj[] objs = new Obj[objsNum];
  float Rmax;
  final color[] palette = {#70d6ff, #ff70a6, #ff9770, #ffd670, #e9ff70};//["#e00065", "#fa5a0f", "#ffda0a", "#00a0d1", "#6a17de"];

  @Override void setup() {
    colorMode(RGB, 255);
    Rmax = min(width, height) * 0.385;

    for (int i = 0; i < objsNum; i++) {
      objs[i] = new Obj();
    }

    lights();
    ambientLight(40, 40, 40);
  }
  @Override void draw() {
    background(0xfe, 0xfe, 0xfe);

    push();
    translate(width / 2, height /2);
    for (int i = 0; i < objs.length; i++) {
      objs[i].move();
      objs[i].display();
    }
    pop();

    logo(color(255, 0, 0));
  }

  class Obj {
    int boxNum;
    float s;
    color c;
    PVector rot;
    PVector step;
    float bt;
    float R;
    float xsMax;
    float stw;
    int xt;

    Obj() {
      this.boxNum = floor(random(5, 11));
      this.s = random(5, 20);
      //    this.c = random(palette);
      int ix = (int)random(palette.length);
      //      this.c = color(red(palette[ix]), green(palette[ix]), blue(palette[ix]));
      this.c = palette[ix];
      //    this.rot = createVector(random(-360, 360), random(-360, 360), random(-360, 360));
      this.rot = PVector.random3D();
      this.rot.mult(360);
      //    this.step = createVector(random(-1, 1), random(-1, 1), random(-1, 1));
      this.step = PVector.random3D();
      this.bt = random(0, 360);
      this.R = random(Rmax * 0.95, Rmax);
      this.xsMax = this.s * random(2, 5);
      this.stw = this.xsMax * 0.65 / this.s;
      this.xt = (int)random(360);
    }

    void move() {
      this.rot.add(this.step);
      this.xt++;
    }

    void display() {
      strokeWeight(this.stw);
      //    stroke("#E44C49");
      stroke(0xE4, 0x4C, 0x49);
      fill(this.c);
      push();
      rotateX(radians(this.rot.x));
      rotateY(radians(this.rot.y));
      rotateZ(radians(this.rot.z));
      for (int i = 0; i < this.boxNum; i++) {
        float t = this.s * 3 * i / this.boxNum;
        float x = this.R * cos(radians(t + this.bt));
        float z = this.R * sin(radians(t + this.bt));
        float xs = this.xsMax * abs(sin(radians(i * 13 + this.xt)));
        push();
        translate(x, xs * 2, z);
        rotateY(radians(-(t + this.bt)));
        box(xs, this.s, this.s);
        pop();
      }
      pop();
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
