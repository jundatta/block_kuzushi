// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1356670
//

class GameSceneCongratulations200 extends GameSceneCongratulationsBase {
  // By Roni Kaufman
  // https://ronikaufman.github.io/
  // https://twitter.com/KaufmanRoni

  float l = 720;
  float seeed;
  color[] colors = {#008cff, #0099ff, #00a5ff, #00b2ff, #00bfff, #00cbff, #00d8ff, #00e5ff, #00f2ff, #00ffff, #ff7b00, #ff8800, #ff9500, #ffa200, #ffaa00, #ffb700, #ffc300, #ffd000, #ffdd00, #ffea00};
  final int N_FRAMES = 500;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noFill();
    strokeCap(SQUARE);
    seeed = random(1000);
  }
  @Override void draw() {
    push();
    clear();
    background(0);
    randomSeed((long)seeed);
    blendMode(ADD);
    translate(width/2, height/2);
    rotate(frameCount/200.0f);
    float z = (frameCount%N_FRAMES)/(float)N_FRAMES;

    for (int i = 0; i < 6; i++) {
      stroke(P5JSrandom(colors));
      strokeWeight(random(2, 5));
      float n = floor(random(1, 13))*P5JSrandom(-1, 1);
      float h = random(5, l/6.0f);
      h *= -sq(2*z-1)+1;
      float sp = P5JSrandom(-3, -2, -2, -1, -1, -1, 1, 1, 1, 2, 2, 3);
      makeWave(n, h, sp);
    }

    stroke(255);
    strokeWeight(4);
    circle(0, 0, l);

    if (frameCount % N_FRAMES == 0) {
      seeed = random(1000*frameCount);
    }
    pop();

    logoRightLower(#ff0000);
  }

  void makeWave(float n, float h, float sp) {
    float t = TWO_PI*(frameCount%N_FRAMES)/(float)N_FRAMES;
    beginShape();
    for (float x = -l/2.0f; x < l/2.0f; x++) {
      float z = map(x, -l/2.0f, l/2.0f, 0, 1);
      float alpha = -sq(2*z-1)+1;
      float off = sin(n*TWO_PI*(x+l/2.0f)/l+sp*t)*h*alpha;
      curveVertex(x, off);
    }
    endShape();
  }
  
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
