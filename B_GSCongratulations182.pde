// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Drifting noise. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20220131/
// 【移植】PC-8001(TN8001)さん
//

class GameSceneCongratulations182 extends GameSceneCongratulationsBase {
  PShape mesh;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    hint(ENABLE_STROKE_PURE);
    hint(DISABLE_OPENGL_ERRORS);
    hint(DISABLE_TEXTURE_MIPMAPS);

    //mesh = new Sphere(280, 6).get();
  }

  void update() {
    var noise_min = 0.45;
    var noise_max = 0.8;

    // 仕様変更？毎回初期化しないとsetFill()が追加されたイメージになってる？！
    mesh = new Sphere(280, 6).get();
    for (int index = 0; index < mesh.getVertexCount(); index++) {
      var noise_value = openFrameworks.ofNoise(mesh.getVertex(index).x * 0.0035,
        mesh.getVertex(index).y * 0.0035,
        mesh.getVertex(index).z * 0.02 + frameCount * 0.018);

      var color_value = 255;

      if (noise_value > noise_min) {
        if (noise_value < noise_max) {
          color_value = int(map(noise_value, noise_min, noise_max, 255, 0));
        } else {
          color_value = 0;
        }
      }

      mesh.setFill(index, color(color_value));
    }
  }

  @Override void draw() {
    update();
    background(255);
    fill(0);
    text(frameRate, 50, 50);

    push();
    translate(width / 2, height / 2);
    shape(mesh);
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
