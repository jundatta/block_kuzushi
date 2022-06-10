// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】DEC_HLさん
// 【作品名】NoiselatedPlane
// https://openprocessing.org/sketch/1211028
//

class GameSceneCongratulations36 extends GameSceneCongratulationsBase {
  float flip = 0;
  float noiseScale = 0.05;
  float timeScale = 0.01;
  float rot = 0;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100, 100);
  }
  @Override void draw() {
    push();
    translate(width / 2, height / 2);
    if (flip == 1) scale(1, -1);
    float pS = 20 + 10 * sin(radians(frameCount));
    float pD = pS + 18 + 5 * cos(radians(frameCount));
    float pW = int(height / pD) - 1;
    float pH = int(height / pD) - 1;

    background(0, 0, 0);
    rotateX(radians(60));
    rotateZ(radians(rot * 0.75));
    for (float x = -pW; x < pW; x++) {
      push();
      float cX = x * pD;
      translate(cX, 0, 0);
      for (float y = -pH; y < pH; y++) {
        float noiseVal = noise(x * noiseScale, y * noiseScale, frameCount * timeScale);
        float cY = y * pD;
        float cZ = noiseVal * 256;
        push();
        fill(noiseVal*360, 1*100, 1*100, 0.5*100);
        stroke(noiseVal*360, 0*100, 1*100, 1*100);
        translate(0, cY, cZ);
        box(pS, pS, -cZ);
        pop();
      }
      pop();
    }
    rot++;
    pop();

    translate(0, -150, 200);
    logo(color(0, 100, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
