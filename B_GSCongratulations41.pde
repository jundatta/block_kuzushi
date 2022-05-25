// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】游千又さん
// 【作品名】Spinner
// https://openprocessing.org/sketch/1218214
//

class GameSceneCongratulations41 extends GameSceneCongratulationsBase {
  float num = 0;
  float click = 0;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100, 100);
    background(0);
    noStroke();
  }
  @Override void draw() {
    fill(0, 10);
    rect(0, 0, width, height);
    fill(frameCount%360, 80, 100);
    for (float i = 0; i < 360; i++) {
      float angle = cos(radians(i*26+num))*400;
      float x = width/2+sin(radians(i))*angle;
      float y = height/2+cos(radians(i))*angle;
      ellipse(x, y, 6, 6);
    }
    num += 0.5;

    logoRightUpper(color(((frameCount%360) + 180)%360, 100, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
