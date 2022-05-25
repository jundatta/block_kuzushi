// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://www.shadertoy.com/view/MlXSWX
//

class GameSceneCongratulations212 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/212/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    sd.set("iChannel0", loadImage("data/212/iChannel0.jpg"));
    sd.set("iChannel1", loadImage("data/212/iChannel1.jpg"));
  }
  @Override void draw() {
    sd.set("iTime", millis() / 1000.0f);
    shader(sd);
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
