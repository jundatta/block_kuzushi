// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】yasai-gyaboさん
// 【作品名】Screw
// https://neort.io/art/bhra6ck3p9fdnjll5n7g
//

class GameSceneCongratulations123 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    sd = loadShader("data/123/neort.glsl");
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
