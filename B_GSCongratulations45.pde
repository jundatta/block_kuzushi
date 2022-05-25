// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Drops
// https://openprocessing.org/sketch/1175874
//

class GameSceneCongratulations45 extends GameSceneCongratulationsBase {
  float t=0;
  @Override void setup() {
    colorMode(HSB, 255);
  }
  @Override void draw() {
    t+=.1;
    background(0);

    push();

    translate(width / 2, height / 2, 0);

    rotateX(t/9.0f);
    for (float d=36; d-- != 0; ) {
      rotate(TAU/36.0f);
      for (float i=24; i-- != 0; ) {
        float I=i-t%1;
        push();
        translate(I*24, 0, 90);
        if (i<6) translate(0, 0, pow(6-I, 2)*-30);
        fill(i*10, 255, 255);
        //      sin(d+I+t)>.75&&box(I*4);
        if (sin(d+I+t)>.75) {
          box(I*4);
        }
        pop();
      }
    }

    pop();

    logo(color(0, 255, 255));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
