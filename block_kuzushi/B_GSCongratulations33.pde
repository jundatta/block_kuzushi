// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Minfeng Jiangさん
// 【作品名】Rect Spinner
// https://openprocessing.org/sketch/1225105
//

class GameSceneCongratulations33 extends GameSceneCongratulationsBase {
  float f = 10;          // this line sets spectrum linearity correction
  float hu = 0;

  @Override void setup() {
    colorMode(HSB, 360, 255, 255, 100);
    background(0);
  }
  @Override void draw() {
    push();
    //  background(0, .15);
    fill(0, 15);
    rect(0, 0, width, height);
    noStroke();
    translate(width/2, height/2);
    for (float i=0; i<1000; i+=3) {
      rotate(sin((frameCount)/2000.0));
      hu = i/2.3%360;
      float h = hu + f * sin(3 * hu / 57.0f);    // linearity corrected for 360 degrees
      // ellipse(i, 50, 5, 5);
      fill(h, 200, 255);
      rect(i, 50, 18, 18);
      // *map(i,0,1000,1,10)
    }
    pop();

    push();
    colorMode(RGB, 255);
    logoRightLower(color(255, 0, 0));
    pop();
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
