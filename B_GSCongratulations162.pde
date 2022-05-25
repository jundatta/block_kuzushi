// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1316396
//

/*
Fibonacci number
 https://ja.wikipedia.org/wiki/黄金比
 */

class GameSceneCongratulations162 extends GameSceneCongratulationsBase {
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    // （作者様はHSBにしたかった？のかも？！と思いつつ。。。）
    //  colorMode(RGB, 1.0f);
    colorMode(HSB, 1.0f);
  }

  float cosn(float v) {
    return cos(v * TWO_PI) * 0.5 + 0.5;
  }

  float invCosn(float v) {
    return 1 - cosn(v);
  }

  final float radius =  (float)Math.sqrt(0.5); //最も遠いobjの距離（バランスいい）
  final float dotSize = 0.04;
  final float PHI = (1 + (float)Math.sqrt(5)) / 2.0f; //黄金比

  final int frames = 1000;
  float t;

  @Override void draw() {
    translate((width - height)/2, 0);
    scale(height);
    // t = mouseX / width;
    //  t = fract(frameCount / (float)frames); //fractは少数部分
    t = (frameCount / (float)frames) % 1.0f; //fractは少数部分
    background(0);

    final float count = 2000;  //（ほぼ）画面内のobj数，upgrade対象
    for (float i=1; i< count; i++) {
      float f = i / count;
      float theta = i * PHI * TWO_PI;
      float dist = f * radius;

      float x = 0.5 + cos(theta - t) * dist;
      float y = 0.5 + sin(theta - t) * dist;

      float sig = pow(cosn(f - t * 6), 2); //sizeの波
      float r =  f * sig * dotSize;

      float hue = cosn(f - t * 1.3) / 2.0f;
      float sat = 0.8;
      float light = 0.6 * sig + 0.5;
      color clr = color(hue, sat, light);
      fill(clr);

      circle(x, y, r);
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
