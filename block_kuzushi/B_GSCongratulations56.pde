// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】XT95さん
// 【作品名】Flame
// https://www.shadertoy.com/view/MdX3zr
//

class GameSceneCongratulations56 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    noStroke();
    sd = loadShader("data/56/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height);
  }
  @Override void draw() {
    background(0);
    sd.set("iTime", millis() / 1000.0);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    //sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
