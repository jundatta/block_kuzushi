// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Flow field
// https://openprocessing.org/sketch/1243386
//

class GameSceneCongratulations85 extends GameSceneCongratulationsBase {
  PVector[] blackholes = new PVector[5];
  ArrayList<PVector> stars = new ArrayList();
  float timer = 0.0f;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    stroke(255);
    for (int i = int(3e3); 0 < i; i-- ) {
      stars.add(new PVector(1, 0).rotate(i));
    }
  }
  @Override void draw() {
    push();
    //  background(0, 64);
    clearBackground(32);
    translate(width / 2, height / 2);

    timer += .003;
    for (int i = blackholes.length - 1; 0 <= i; i--) {
      PVector b = blackholes[i] = new PVector(i * 70, 0).rotate(timer * i);
      circle(b.x, b.y, 5);
    }

    for (PVector s : stars) {
      float d = 0;
      for (PVector b : blackholes) {
        d += atan2(b.y - s.y, b.x - s.x);
      }
      line(s.x, s.y, s.x += cos(d) * 5, s.y += sin(d) * 5);
    }
    pop();

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
