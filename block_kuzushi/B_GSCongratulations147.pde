// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】whisky_shusukyさん
// 【作品名】Octagrams
// https://www.shadertoy.com/view/tlVGDt
//

class GameSceneCongratulations147 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    noStroke();
    sd = loadShader("data/147/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height);
  }
  @Override void draw() {
    sd.set("iTime", millis() / 1000.0);
    //    sd.set("iMouse", (float)mouseX, (float)mouseY);
    shader(sd);
    rect(0, 0, width, height);

    resetShader();
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
