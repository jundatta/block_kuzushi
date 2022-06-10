// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Factory Tour
// https://openprocessing.org/sketch/1202118
//

class GameSceneCongratulations86 extends GameSceneCongratulationsBase {
  class Nums {
    float speed;
    int scale;
    int  texture_depth;
    Nums() {
      this.speed=.1;
      this.scale=22;
      this.texture_depth=10;
    }
  }
  Nums nums = new Nums();

  PGraphics T;
  PShape box;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    int s = 64;
    PGraphics pg=createGraphics(s, s);
    pg.beginDraw();
    for (int i = 0; i < 10; i++) {
      for (int y=s; 0 < y--; ) {
        for (int x=s; 0 < x--; ) {
          //    pg.stroke((i+x+y^i+x-y)%9?[0, 0]:[255]).point(x, y);
          if (((i + x+y)^(i + x-y))%9 != 0) {
            pg.stroke(0, 0, 0, 0);
          } else {
            pg.stroke(255, 255, 255, 255);
          }
          pg.point(x, y);
        }
      }
    }
    pg.endDraw();
    T=createGraphics(s, s);
    T.beginDraw();
    T.image(pg, 0, 0, s, s);
    T.endDraw();

    box = createShape(BOX, 1.0f, 1.0f, 1.0f);
    box.setTexture(T);
  }

  float t=0;
  @Override void draw() {
    push();
    translate(width/2, height/2);

    //  texture(T);
    rotateX(.05);
    background(0);
    scale(nums.scale);
    t+=nums.speed;
    for (int i=300; 0 < i--; ) {
      PVector p = PVector.fromAngle(i%PI).mult(4);
      push();
      translate(p.x, p.y, (i+t)%32);
      float s = pow(i, 9)%9;
      //    box(cos(s)*2, sin(s)*2, s);
      scale(cos(s)*2, sin(s)*2, s);
      shape(box);
      pop();
    }
    pop();

    logo(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
