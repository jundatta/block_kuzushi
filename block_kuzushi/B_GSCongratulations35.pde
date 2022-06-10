// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】postredioriさん
// 【作品名】Plot3D
// https://openprocessing.org/sketch/1225362
//

class GameSceneCongratulations35 extends GameSceneCongratulationsBase {
  final PVector[] UV = {
    new PVector(0, 0),
    new PVector(0, 1),
    new PVector(1, 1),
    new PVector(1, 0),
  };

  float t = 0;

  final color bgColor = #002030;
  final color lineColor = #1e353d;
  float hu = 0;

  PVector coord3d(float x, float y, float z) {
    return new PVector(width/2.0f-15*x-13*y, height/2.0f-4*x+5*y+35*z);
  }

  float func(float x, float y) {
    x/=3.0f;
    y/=3.0f;
    return sin(y)+cos(x+sin(t)*cos(y));
  }

  void plot3d(PGraphics pg, float x, float y) {
    float z=func(x, y);
    PVector c=coord3d(x, y, z);
    pg.vertex(c.x, c.y);
  }

  PGraphics pg;
  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.colorMode(HSB, 255);
    pg.stroke(lineColor);

    t+=0.05;
    pg.background(bgColor);

    for (float x=24; x>=-24; x--) {
      for (float y=-24; y<=24; y++) {
        pg.fill((hu + (x + 24)*5)%255, 200, 255);
        pg.beginShape();
        for (PVector uv : UV) {
          plot3d(pg, x+uv.x, y+uv.y);
        }
        pg.endShape();
      }
    }
    hu++;
    pg.endDraw();
    image(pg, 0, 0);

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
