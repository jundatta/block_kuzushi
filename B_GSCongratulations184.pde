// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bqb72pc3p9f6qoqnndqg?index=66&origin=popular
//
// 2022/04/29
// VMware(R) Workstation 16 Player 16.2.3 build-19376536
// にて"data/184/neort.glsl"のコンパイルがおかしい？！
// ⇒Vmware SVGA 3D 8.17.2.14
//   ray = camPos + dir * rLen;
//   に絡む処理の計算結果があやしい？
//   計算後？for()ループを戻ってきたときの
//   d = map(ray);
//   のrayの値がおかしく？なっているように見える
// 。。。ホストOS上の
// 　　　Intel(R) UHD Graphics 630 30.0.101.1660
// 　　　では現象が再現しない（期待通りにうごいている）

class GameSceneCongratulations184 extends GameSceneCongratulationsBase {
  PShader s;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    s = loadShader("data/184/neort.glsl");
    s.set("resolution", width, height);
  }
  @Override void draw() {
    //s.set("backbuffer", getGraphics());
    s.set("time", millis() / 1000.0f);
    //s.set("mouse", (float)mouseX / (float)width, (float)mouseY / (float)height);
    shader(s);
    rect(0, 0, width, height);
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
