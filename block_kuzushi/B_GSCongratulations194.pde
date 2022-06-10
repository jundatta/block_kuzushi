// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】deconbatchさん
// 【作品名】ぐーるぐるーのぼーとぼと
// https://openprocessing.org/sketch/1364088
//

class GameSceneCongratulations194 extends GameSceneCongratulationsBase {
  float hu = 0;

  @Override void setup() {
    colorMode(HSB, 255, 255, 255, 255);
    fill(255, 100);
    strokeWeight(1.0);
    background(255);
  }
  @Override void draw() {
    fill(255, 100);
    translate(width * 0.5, height * 0.5);

    final float rotation = PI * (1 + frameCount * 0.05);
    for (float i = 0; i < rotation; i += PI * 0.02) {
      float pc = map(i, 0, rotation, -width * 0.5, width * 0.5);
      float pSiz = map(i, 0, rotation, width * 0.05, width * 0.005);

      float px = pc * cos(i * i * 0.5);
      float py = pc * sin(i * i * 0.5);
      stroke(hu%255, 255, 200);
      ellipse(px, py, pSiz, pSiz);
    }
    hu++;

    // こっちをあきらめる
    //logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
