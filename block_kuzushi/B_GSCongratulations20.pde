// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】RGB Color Cube
// https://openprocessing.org/sketch/1201884
//

class GameSceneCongratulations20 extends GameSceneCongratulationsBase {
  @Override void setup() {
    colorMode(RGB, 255);
    noStroke();
  }
  @Override void draw() {
    background(255);
    //  orbitControl(1, 1, 0.1);

    push();
    translate(width / 2, height / 2, -200);
    rotateX(radians(frameCount * 0.08));
    pointLight(200, 200, 200, 100, 100, 250);
    ambientLight(255, 255, 255);

    int step = 256 / 9;
    for (int r = 0; r <= 255; r += step) {
      for (int g = 0; g <= 255; g += step) {
        for (int b = 0; b <= 255; b += step) {
          push();
          translate((r - 127) * 2.5, (g - 127) * 2.5, (b - 127) * 2.5);
          fill(r, g, b);
          sphere(15);
          pop();
        }
      }
    }
    pop();

    translate(-70, -110, +200);
    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
