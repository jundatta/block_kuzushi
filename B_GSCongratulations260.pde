// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Anonymousさん
// 【作品名】Christmas Tree - Epic
// https://openprocessing.org/sketch/1398166
//

class GameSceneCongratulations260 extends GameSceneCongratulationsBase {
  float rotSpeed;

  @Override void setup() {
    smooth();
  }
  @Override void draw() {
    push();
    rotSpeed += 0.1;
    background(0);
    noStroke();
    lights();

    translate(width/2, height - 100);

    for (int iter = 0; iter < 100; iter++) {
      translate(0, -6, 0);
      rotateY(radians(rotSpeed));
      fill(iter*5, iter/10, iter*10);
      box(500 - iter*(500/100), 6, 50);

      pushMatrix();
      translate(-350, 0, 0);
      sphere(10);
      popMatrix();
    }
    pop();

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
