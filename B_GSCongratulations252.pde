// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】watabo_shiさん
// 【作品名】Snowflake
// https://openprocessing.org/sketch/1406956
//

class GameSceneCongratulations252 extends GameSceneCongratulationsBase {
  color[] palette = {#edfaff, #99e5ff};
  float vmin, vmax;
  float cx, cy;
  PImage tex;

  @Override void setup() {
    vmin = min(width, height);
    vmax = max(width, height);
    cx = width / 2;
    cy = height / 2;
    tex = loadImage("data/252/background.png");
  }
  @Override void draw() {
    push();
    hint(DISABLE_DEPTH_TEST);
    image(tex, 0, 0);
    hint(ENABLE_DEPTH_TEST);
    translate(width / 2, height / 2);

    float size = vmin / 3.0f;
    float s = size / 20.0f;
    float sec = millis() / 1000.0f;

    //background(palette[0]);
    noStroke();

    push();
    {
      //texture(tex);
      //    plane(width, height);
      //plane(width, height);
      //box(width, height, 1);
    }
    pop();
    //gl.clear(gl.DEPTH_BUFFER_BIT);

    ambientLight(160, 160, 200);
    pointLight(255, 200, 255, vmin, -vmin * 1.5, vmin);

    rotateY(-sec / 2.0f);

    fill(160, 255, 255);

    for (int i = 0; i < 6; i++) {
      push();
      {
        rotate(i * TWO_PI / 6.0f  - PI / 2.0f);

        // axis
        push();
        {
          translate(size / 2.0f, 0, 0);
          box(size, s, s);
        }
        pop();

        // hex
        push();
        {
          translate(size * 0.4, 0, 0);
          box(s, size * 0.49, s);
        }
        pop();

        // repeat 3
        push();
        {
          translate(size * 0.55, 0, 0);

          for (int j = 0; j < 3; j++) {
            push();
            {
              translate(j * size * 0.1, 0, 0);
              box(s, size / 2.0f - j * size * 0.15, s);
            }
            pop();
          }
        }
        pop();
      }
      pop();
    }
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
