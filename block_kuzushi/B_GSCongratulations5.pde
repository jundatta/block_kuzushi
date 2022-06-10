// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Torus Light
// https://openprocessing.org/sketch/856969
// 【移植】PC-8001(TN8001)さん
//

class GameSceneCongratulations5 extends GameSceneCongratulationsBase {
  float C = 0;
  PGraphics pg;
  PShape shape;

  @Override void setup() {
    colorMode(RGB, 255);
    background(0);
    noStroke();

    pg = createGraphics(480, 480);
    //    shape = getTorus(500, 400, 50, 50);
    shape = createTorus(width * 0.8, width * 0.6, 50, 50);
    shape.setTexture(pg);
  }
  @Override void draw() {
    C += 0.0005;
    background(0);

    pg.beginDraw();
    pg.noStroke();
    float size = pg.width / 60;
    for (int y = 0; y < 60; y++) {
      for (int x = 0; x < 60; x++) {
        int n = int(noise(mag(x, y) / width, C) * pow(2, 24));
        pg.fill(red(n), green(n), blue(n));
        pg.rect(x * size, y * size, size * 10.0 / 12.0, size * 10.0 / 12.0);
      }
    }

    logo(pg, color(255, 0, 0));
    pg.endDraw();

    translate(width / 2, height / 2);
    rotateX(C * 4);
    rotateY(C * 6);

    shape(shape);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
