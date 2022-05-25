// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Eli Clarkさん
// 【作品名】Tiled Box
// https://openprocessing.org/sketch/1157423
//

class GameSceneCongratulations28 extends GameSceneCongratulationsBase {
  @Override void setup() {
    colorMode(RGB, 255);
    background(0);
    noStroke();
  }

  @Override void draw() {
    push();
    background(173, 216, 230);
    float speed = frameCount * 2;

    translate(width / 2, height / 2, -100);

    fill(100, 149, 237);
    //  ambientLight(30, 30, 30);    //環境光を当てる
    pointLight(255, 255, 255, 0, 100, 350);
    pointLight(255, 255, 255, 0, 100, 350);
    pointLight(255, 255, 255, 0, 100, 350);
    //  lightSpecular(255, 255, 255);
    //  specular(100, 149, 237);  //オブジェクトの色を設定

    stroke(227, 227, 227);
    strokeWeight(3);
    rotateY(radians(speed));
    rotateX(radians(speed));
    rotateZ(radians(speed));

    //  pointLight(100, 149, 237, 0, 100, 700);
    //  specularMaterial(100, 149, 237);

    for (float z = 4.5; z != -4.5; z--) {
      for (float y = -4.5; y != 4.5; y++) {
        for (float x = -4.5; x != 4.5; x++) {
          push();
          translate(x * 40, y * 40, z * 40);
          box(40);
          pop();
        }
      }
    }
    pop();

    noLights();
    translate(0, 0, +200);
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
