// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】aadebdebさん
// 【作品名】Motion #2
// https://neort.io/art/bmo51uk3p9f7m1g027n0
//

class GameSceneCongratulations195 extends GameSceneCongratulationsBase {
  PShader s;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    s = loadShader("data/195/neort.glsl");
    s.set("resolution", width, height);
  }
  @Override void draw() {
    s.set("backbuffer", getGraphics());
    s.set("time", millis() / 1000.0f);
    s.set("mouse", (float)mouseX / (float)width, (float)mouseY / (float)height);
    shader(s);
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
