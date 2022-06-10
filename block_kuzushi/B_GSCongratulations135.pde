// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】ゆんたロボさん
// 【作品名】deep sea
// https://neort.io/art/bnorkcs3p9f5erb53rlg
//

class GameSceneCongratulations135 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    sd = loadShader("data/135/neort.glsl");
    sd.set("resolution", (float)width, (float)height);
  }
  @Override void draw() {
    sd.set("time", millis() / 1000.0);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    //sd.set("mouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
