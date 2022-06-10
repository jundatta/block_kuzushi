// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Buildings
// https://openprocessing.org/sketch/810217
// 【移植】PC-8001(TN8001)さん）
//

class GameSceneCongratulations7 extends GameSceneCongratulationsBase {
  int t=0;

  @Override void setup() {
    colorMode(RGB, 255);
    background(0);
    //    noStroke();
    //  strokeWeight(150);  // (P3Dでは3Dには対応していない？)
  }
  @Override void draw() {
    background(255);

    pushMatrix();
    camera(0, 0, 400, 0, 0, 0, 0, 1, 0);
    //  clear();
    t++;
    float r=PI/12;
    rotateZ(r);
    rotateX(-r);
    rotateY(-r);
    translate(1100, 300, 180+(t%8)*100/8);
    for (int i=0; i<32; i++) {
      stroke(i*8-t%8);
      fill(i*8-t%8);
      int weight = 150;
      int halfWeight = weight / 2;
      for (int j=0; j<5; j++) {
        //      square(-j*1000-t*3%1000,0,750);
        int sx = -j*1000-t*3%1000;
        rect(sx-halfWeight, 0, 750+weight, 750);
        rect(sx, 0-halfWeight, 750, 750+weight);
      }
      translate(0, 0, -100);
    }
    popMatrix();
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
