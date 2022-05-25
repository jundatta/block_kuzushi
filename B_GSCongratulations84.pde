// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Highway Star
// https://openprocessing.org/sketch/816184
//

class GameSceneCongratulations84 extends GameSceneCongratulationsBase {
  int C=0;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);
  }
  @Override void draw() {
    background(255);
    float D = height/2.0f;
    float x = width/2.0f;
    float y = height/2.0f;
    for (int i=C++; i<C+150; i++) {
      x+=cos(noise(i*.01)*PI*9)*5;
      D*=.965;
      line(x+D, y+D, x-D, y+D);
      if (i%32==0) {
        float[] array = new float[]{-D, D};
        for (float j : array) {
          float X=x+j*1.5;
          line(X, y-D, X, y+D);
          line(X, y-D, X-j/2, y-D*1.2);
        }
      }
    }

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
