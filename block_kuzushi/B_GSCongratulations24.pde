// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Junichiro Horikawaさん
// 【作品名】Climbing
// https://openprocessing.org/sketch/881286
//
import java.util.HashMap;

class GameSceneCongratulations24 extends GameSceneCongratulationsBase {
  float flip = -1;     // set flip = 1 before saving an image or thumbnail. at other times, set flip = -1.
  float seed;
  float lapse = 0;    // mouse timer

  HashMap<String, Integer> ColorPalette;

  @Override void setup() {
    colorMode(RGB, 255);
    noStroke();

    ColorPalette = new HashMap<String, Integer>();
    ColorPalette.put("yellow", #fff5a5);
    ColorPalette.put("orange", #ffaa64);
    ColorPalette.put("darkorange", #ff8264);
    ColorPalette.put("red", #ff6464);
    ColorPalette.put("lightblue", #dff6f0);
    ColorPalette.put("blue", #46b3e6);
    ColorPalette.put("purple", #4d80e4);
    ColorPalette.put("darkblue", #2e279d);

    //  perspective(PI / 3.0, width / height, 0.1, 100000);
    seed = random(100.0, 1000.0);
  }
  @Override void draw() {
    perspective(PI / 3.0, 0.4f, 0.1, 100000);
    background(255);

    push();
    // to save an image or thumbnail you must first flip the screen upside down.
    // remove the minus sign from the second-last parameter in the next line.
    // to watch the animation the correct way up, replace the minus sign.
    camera(0, 1800, (height/2.0) / tan(PI*30.0 / 180.0), 0, 1800, 0, 0, flip, 0);
    directionalLight(200, 200, 200, -0.5, -0.7, -1);
    ambientLight(200, 200, 200);
    noStroke();
    float stepNum = 50;
    float stepHeight = 150.0;
    float stepDepth = 300.0;
    float stepRatio = stepHeight / stepDepth;
    //  float speed = 10.0;
    float speed = 3.0;

    push();
    translate(0, -frameCount * speed * stepRatio, frameCount * speed);
    int stepgo = floor((frameCount * speed) / stepDepth);
    for (int i=stepgo; i<stepNum + stepgo; i++) {
      push();
      translate(0, i * stepHeight, -i * stepDepth + 2000);
      rotateY(0);
      float colthresh = map(i, stepgo, stepNum + stepgo-1, 0.0, 1.0);
      colthresh = map(min(colthresh, 0.7), 0, 0.7, 0.0, 1.0);
      color col1 = lerpColor(color(ColorPalette.get("blue")), color(ColorPalette.get("lightblue")), pow(colthresh, 1.5));
      fill(col1);
      box(100000, stepHeight, stepDepth);
      pop();
    }


    float buildstep = 3;
    int stepgo2 = (int)(floor(stepgo / buildstep) * buildstep);

    for (int i=stepgo2; i<stepNum*2 + stepgo2; i+=buildstep) {
      float sizex = random(2000, 10000);
      randomSeed(i * (long)seed);
      float sizey = random(300, 1500) + stepHeight * i;
      float sizez = random(500, 3000);

      for (int n=-1; n<=1; n+=2) {
        push();
        translate((sizex * 0.5 + width * 0.75) * n, sizey * 0.5, -i * stepDepth + 2000);
        translate((cos(radians(i * 10)) - cos(radians(75 + frameCount * speed / buildstep * 0.1))) * width * 0.5, 0, 0); //75 -
        float thresh = map(i, stepgo2, stepNum*2 + stepgo2, 0.0, 1.0);
        thresh = map(min(thresh, 0.4), 0.0, 0.4, 0.0, 1.0);
        color col1 = lerpColor(color(ColorPalette.get("blue")), color(ColorPalette.get("purple")), random(1));
        color col2 = color(ColorPalette.get("lightblue"));
        // ambientMaterial(lerpColor(col1, col2, pow(thresh, 1.5)));
        fill(lerpColor(col1, col2, pow(thresh, 1.5)));
        box(sizex, sizey, sizez);
        pop();
      }
    }
    pop();
    pop();
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
