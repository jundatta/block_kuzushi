// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1333084
//

class GameSceneCongratulations218 extends GameSceneCongratulationsBase {
  PShader sea;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    sea = loadShader("data/218/frag.glsl", "data/218/vert.glsl");
  }
  @Override void draw() {
    sea.set("time", millis() / 200.0f);
    sea.set("resolution", (float)width, (float)height);

    shader(sea);
    rect(0, 0, width, height);
    resetShader();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
