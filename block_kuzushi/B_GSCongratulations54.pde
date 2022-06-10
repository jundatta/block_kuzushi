// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】nimitzさん
// 【作品名】Protean clouds
// https://www.shadertoy.com/view/3l23Rh
// 【参考】@mizumasaさん
// ProcessingでGLSLシェーダーを始めるサンプルコード(Java, Pythonどちらでも)
// https://qiita.com/mizumasa/items/887c4e85c688a2b0d5f1
//

class GameSceneCongratulations54 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    noStroke();
    sd = loadShader("data/54/ProteanClouds.glsl");
    sd.set("iResolution", (float)width, (float)height);
  }
  @Override void draw() {
    sd.set("iTime", millis() / 1000.0);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
