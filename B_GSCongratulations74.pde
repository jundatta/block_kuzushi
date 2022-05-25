// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Anderienさん
// 【作品名】Mixing Bowl
// https://openprocessing.org/sketch/743355
//

class GameSceneCongratulations74 extends GameSceneCongratulationsBase {
  float r=100;
  float k=0;
  float m=0;
  float ang=270;
  float speed=5;
  float red=255;
  float green=255;
  float blue=255;
  boolean dr=false;
  boolean dg=false;
  boolean db=false;
  float ri=0;
  float gi=0;
  float bi=0;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);
    ri=random(.05, 1);
    gi=random(.05, 1);
    bi=random(.05, 1);
    smooth(4);

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.background(200, 200, 230);
    pg.translate(width/2, height/2);
    pg.scale(3);
    pg.noFill();
    pg.strokeWeight(1);
    pg.stroke(0, 50);
    pg.arc(.5, 0, 2*r+2, 2*r+2, 0, PI, CHORD);
    wave(1, 100, red, green, blue);
    wave(-1, 255, red, green, blue);

    pg.strokeWeight(6);
    pg.stroke(255, 100);
    pg.arc(0, 0, 2*(r-10), 2*(r-10), radians(10), radians(30));
    pg.arc(0, 0, 2*(r-10), 2*(r-10), radians(35), radians(38));

    if (k>-ang) {
      k-=speed;
    } else {
      k=0;
    }

    pg.strokeWeight(6);
    pg.stroke(0, 50);
    pg.line(0, -100, 50*cos(radians(m)), 60+20*sin(radians(m)));
    m+=speed;
    if (red<255) {
      if (dr==false) {
        red+=ri;
      }
    } else {
      dr=true;
    }
    if (dr==true) {
      if (red>0) {
        red-=ri;
      } else {
        dr=false;
      }
    }

    if (green<255) {
      if (dg==false) {
        green+=gi;
      }
    } else {
      dg=true;
    }
    if (dg==true) {
      if (green>0) {
        green-=gi;
      } else {
        dg=false;
      }
    }

    if (blue<255) {
      if (db==false) {
        blue+=bi;
      }
    } else {
      db=true;
    }
    if (db==true) {
      if (blue>0) {
        blue-=bi;
      } else {
        db=false;
      }
    }
    pg.endDraw();
    image(pg, 0, 0);

    logoRightUpper(color(255, 0, 0));
  }

  void wave(float val, float opacity, float red, float green, float blue) {
    for (float i=-r; i<r; i++) {
      float y = 15*cos(radians((i+k*val)*ang/(float)(2*r)));
      float dis = dist(0, 0, i, y+35);
      if (dis<100) {
        float yy = sqrt(sq(r)-sq(i));
        pg.stroke(red, green, blue, opacity);
        pg.line(i, y+35, i, yy);
      }
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
