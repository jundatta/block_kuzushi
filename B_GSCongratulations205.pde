// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://www.shadertoy.com/view/XsjXRm
//

class GameSceneCongratulations205 extends GameSceneCongratulationsBase {
  PShader sd;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/205/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);
    PImage iChannel0 = loadImage("data/205/iChannel0.png");
    sd.set("iChannel0", iChannel0);
  }
  @Override void draw() {
    // ※Shadertoyの場合、透明度は指定しても反映されない
    // void mainImage( out vec4 fragColor, in vec2 fragCoord )の
    // fragCoordの透明度の指定は反映されない
    // なのでfragCoordの透明度は1.0（不透明）固定で返すように注意する
    //  background(0);
    sd.set("iTime", millis() / 1000.0f);
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
