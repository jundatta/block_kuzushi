// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1316835
//

class GameSceneCongratulations171 extends GameSceneCongratulationsBase {
  PShader myShader;
  int properFrameCount = 0;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    pixelDensity(1);
    noStroke();
    myShader = loadShader("data/171/fs.glsl");
    myShader.set("u_resolution", (float)width, (float)height);
  }
  @Override void draw() {
    myShader.set("u_mouse", (float)mouseX, (float)mouseY);
    myShader.set("u_count", (float)properFrameCount);
    shader(myShader);
    rect(0, 0, width, height);
    resetShader();

    properFrameCount++;
    
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
