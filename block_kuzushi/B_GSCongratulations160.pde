// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】iapafotoさん
// 【作品名】On the salt lake
// https://www.shadertoy.com/view/fsXcR8
//

class GameSceneCongratulations160 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/160/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height);
    sd.set("iChannel0", loadImage("data/160/iChannel0.jpg"));
  }
  @Override void draw() {
    sd.set("iTime", millis() / 1000.0);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    //    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    //    sd.set("iFrame", frameCount);
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
