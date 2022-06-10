// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Neon Tube-Java
// https://openprocessing.org/sketch/882718
//

class GameSceneCongratulations6 extends GameSceneCongratulationsBase {
  //inspired by https://twitter.com/yuruyurau/status/1227244326301757441
  final int H=100;
  float x=0, y=0;

  @Override void setup() {
    colorMode(RGB, 255);
    background(0);
    noStroke();
  }
  @Override void draw() {
    background(0);
    float f=frameCount*.01;
    for (int i=0; i<H; i++) {
      for (int j=0; j<H; j++) {
        float a=i*2-y+f;
        float b=x+a/H+f;
        x=sin(b)-cos(a);
        y=cos(b)-sin(a);
        fill(map(i, 0, H, 0, 255), map(j, 0, H, 0, 255), (x+y)*256);
        //        rect(x*width/4+width/2, y*height/4+height/2, 3, 3);
        rect(x*width/4+width/2, y*width/4+height/2, 3, 3);
        //        rect(x*height/4+width/2, y*height/4+height/2, 3, 3);
      }
    }

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
