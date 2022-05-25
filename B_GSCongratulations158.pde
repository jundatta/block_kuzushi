// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/809970
//

class GameSceneCongratulations158 extends GameSceneCongratulationsBase {
  int W;
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    W=min(width, height);
    stroke(0, 255, 64);
  }
  @Override void draw() {
    background(0);
    push();
    translate(width/2, 0);
    float F=frameCount*0.5;
    for (int i=1; i<W*1.2; i++) {
      float y=sqrt(i*200);
      float r=pow(i/(float)W, 4)*i/2+150;
      float N=noise(i*0.1-F)*99+F*0.02;
      strokeWeight(i*0.01);
      line(cos(N)*r, y+sin(N)*r, cos(N+0.2)*r, y+sin(N+0.2)*r);
    }
    pop();

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
