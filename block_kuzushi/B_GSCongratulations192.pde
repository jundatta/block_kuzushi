// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】clustahさん
// 【作品名】Shader Sketch
// https://openprocessing.org/sketch/1362193
//

class GameSceneCongratulations192 extends GameSceneCongratulationsBase {
  PShader myShader;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    // Use createShader in setup rather than loadShader in preload because we're
    // using shader programs that are declared in javascript as strings.
    // NOTE: it is important that this come after createCanvas is called.
    myShader = loadShader("data/192/frag.glsl", "data/192/vert.glsl");
  }
  @Override void draw() {
    background(255);

    shader(myShader);

    // These correspond to the custom uniforms declared in our fragment shader.
    myShader.set("uTime", millis() / 1000.0);
    //myShader.set("uResolution", (float)width, (float)height);

    //orbitControl(2, 2, 0.1);

    // Draw some geometry to the screen
    //sphere(300);
    //sphere(width / 3.5, 200, 200);
    push();
    noStroke();
    translate(width / 2, height / 2);
    sphere(width / 3.5);
    sphereDetail(200, 200);
    pop();
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
