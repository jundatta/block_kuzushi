// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】iqさん
// 【作品名】Elevated
// https://www.shadertoy.com/view/MdX3Rr
//

class GameSceneCongratulations186 extends GameSceneCongratulationsBase {
  PShader sd;
  PShader bfA;

  PGraphics buffer1;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();

    sd = loadShader("data/186/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height);
    buffer1 = createGraphics(width, height, P3D);
    buffer1.beginDraw();
    buffer1.blendMode(REPLACE);
    buffer1.endDraw();

    bfA = loadShader("data/186/BufferA.glsl");
    bfA.set("iResolution", (float)width, (float)height);
    bfA.set("iChannel0", loadImage("data/186/noise.png"));
  }
  @Override void draw() {
    // ※Shadertoyの場合、透明度は指定しても反映されない
    // void mainImage( out vec4 fragColor, in vec2 fragCoord )の
    // fragCoordの透明度の指定は反映されない
    // なのでfragCoordの透明度は1.0（不透明）固定で返すように注意する
    //  background(0);
    bfA.set("iTime", millis() / 1000.0f);
    // iMouseのz,wはそれぞれマウスドラッグ時のx,y座標になるが
    // シミュレートをあきらめる
    // このためz,wにはそれぞれ0.0fを固定で渡す
    bfA.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    buffer1.beginDraw();
    buffer1.background(0);
    buffer1.shader(bfA);
    buffer1.rect(0, 0, width, height);
    buffer1.resetShader();
    buffer1.endDraw();

    sd.set("iChannel0", buffer1);
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
