// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://www.shadertoy.com/view/4sjSW1
//

class GameSceneCongratulations213 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/213/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    PImage iChannel0 = loadImage("data/213/iChannel0.png");
    sd.set("iChannel0", iChannel0);
    sd.set("iChannelResolution[0]", (float)iChannel0.width, (float)iChannel0.height, 0.0f);
  }
  @Override void draw() {
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
