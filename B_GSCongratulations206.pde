// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】knarkowiczさん
// 【作品名】[SIG15] Mario World 1-1
// https://www.shadertoy.com/view/XtlSD7
//

class GameSceneCongratulations206 extends GameSceneCongratulationsBase {
  PShader sd;
  int startMillis;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();

    sd = loadShader("data/206/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);
    // 最初のミリ秒を取り込んでおく
    startMillis = millis();
  }
  @Override void draw() {
    // ※Shadertoyの場合、透明度は指定しても反映されない
    // void mainImage( out vec4 fragColor, in vec2 fragCoord )の
    // fragCoordの透明度の指定は反映されない
    // なのでfragCoordの透明度は1.0（不透明）固定で返すように注意する
    //  background(0);
    // 最初からのミリ秒として渡したいのでstartMillisをmillis()から引く
    sd.set("iTime", (millis() - startMillis) / 1000.0f);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
