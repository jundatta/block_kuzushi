// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】morgan3dさん
// 【作品名】Tiny Planet: Earth
// https://www.shadertoy.com/view/lt3XDM
//

class GameSceneCongratulations214 extends GameSceneCongratulationsBase {
  PShader sd;
  PShader sdA;
  PShader sdB;
  PShader sdC;

  PGraphics pgA;
  PGraphics pgB;
  PGraphics pgC;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();

    sd = loadShader("data/214/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    sdA = loadShader("data/214/BufferA.glsl");
    sdA.set("iResolution", (float)width, (float)height, 0.0f);
    PImage iChannel0 = loadImage("data/214/iChannel0.png");
    sdA.set("iChannel0", iChannel0);
    pgA = createGraphics(width, height, P3D);
    pgA.beginDraw();
    pgA.blendMode(REPLACE);
    pgA.endDraw();
    pgA.noStroke();

    sdB = loadShader("data/214/BufferB.glsl");
    sdB.set("iResolution", (float)width, (float)height, 0.0f);
    pgB = createGraphics(width, height, P3D);
    pgB.beginDraw();
    pgB.blendMode(REPLACE);
    pgB.endDraw();
    pgB.noStroke();

    sdC = loadShader("data/214/BufferC.glsl");
    sdC.set("iResolution", (float)width, (float)height, 0.0f);
    pgC = createGraphics(width, height, P3D);
    pgC.beginDraw();
    pgC.blendMode(REPLACE);
    pgC.endDraw();
    pgC.noStroke();
  }
  @Override void draw() {
    sdA.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    sdA.set("iTime", millis() / 1000.0f);
    pgA.beginDraw();
    pgA.shader(sdA);
    pgA.rect(0, 0, width, height);
    pgA.resetShader();
    pgA.endDraw();

    sdB.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    sdB.set("iTime", millis() / 1000.0f);
    sdB.set("iChannel0", pgA);
    pgB.beginDraw();
    pgB.shader(sdB);
    pgB.rect(0, 0, width, height);
    pgB.resetShader();
    pgB.endDraw();

    sdC.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    sdC.set("iTime", millis() / 1000.0f);
    sdC.set("iChannel0", pgA);
    sdC.set("iChannel1", pgB);
    sdC.set("iChannel2", pgC);
    pgC.beginDraw();
    pgC.shader(sdC);
    pgC.rect(0, 0, width, height);
    pgC.resetShader();
    pgC.endDraw();

    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
    sd.set("iTime", millis() / 1000.0f);
    sd.set("iChannel0", pgC);
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
