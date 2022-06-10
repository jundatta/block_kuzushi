// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Machine
// https://openprocessing.org/sketch/1246917
//

class GameSceneCongratulations83 extends GameSceneCongratulationsBase {
  int timer=0;
  final int range=28;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    background(0);
    directionalLight(255, 255, 255, 0, -1, -1);
    float angle=timer/120.0f;
    timer++;
    rotateX(angle);
    rotateZ(angle);
    scale(18);
    translate(-range/2.0f, -range/2.0f, -range/2.0f);
    for (int z=range; z != 0; z--) {
      for (int y=range; y != 0; y--) {
        for (int x=range; x != 0; x--) {
          //        if (x^y^z)
          int a = x^y;
          a ^= z;
          if (a != 0) {
            continue;
          }
          push();
          translate(x, y, z);
          box(tan(x+timer/557.0f), tan(y), tan(z+timer/787.0f));
          pop();
        }
      }
    }
    pop();

    translate(0, 0, -100);
    logo(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
