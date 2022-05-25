// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1331203
//

class GameSceneCongratulations220 extends GameSceneCongratulationsBase {
  float t;
  ArrayList<Float> mountainHeights = new ArrayList();
  color c1, c2;

  boolean bInit = false;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(0);
    init();

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    if (!bInit) {
      return;
    }
    bInit = false;
    pg.beginDraw();
    pg.background(0);
    gradationBackground(pg, 0, 0, width, height, c1, c2);
    starLight(pg);
    moon(pg);
    deppMountain(pg);

    townLight(pg);
    mountain(pg);
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(#ff0000);
  }


  void init() {
    bInit = true;

    mountainHeights.clear();
    t = 0;
    noiseSeed(int(random(5)));
    for (int x = 0; x < width; x++) {
      float n = noise(t);
      t += 0.01;
      mountainHeights.add(n * 100);
    }
    c1 = color(0);
    c2 = color(0, 102, int(random(100, 255)));
  }

  void gradationBackground(PGraphics pg, float x, float y, float w, float h, color _c1, color _c2) {
    for (float i = y; i <= y + h; i += 1) {
      float inter = map(i, y, y + h, 0, 1);
      color c = lerpColor(_c1, _c2, inter);
      pg.stroke(c);
      pg.line(x, i, x + w, i);
    }
  }

  void mountain(PGraphics pg) {
    pg.push();
    pg.stroke(0);
    pg.strokeWeight(5);
    float rand = random(1.1, 1.7);
    for (int x = 0; x < width; x++) {
      pg.line(x, height, x, ((height - rand * 100) - mountainHeights.get(x)));
    }
    pg.pop();
  }

  void deppMountain(PGraphics pg) {
    pg.push();
    pg.stroke(10);
    pg.strokeWeight(1);
    var rand = random(0.1, 1.3);
    for (int x = width - 1; x >= 0; x--) {
      pg.line(width - x, height / 2.0f + 10, width - x, height / 2.0f - (mountainHeights.get(x) * rand));
    }
    pg.pop();
  }

  void townLight(PGraphics pg) {
    pg.push();
    pg.noStroke();
    for (int i = 0; i < 1000; i++) {
      float x = random(0, width);
      float y = random(height / 2.0f, height / 2.0f + height / 10.0f);
      float r = map(y, height / 2.0f, height, 1, 2);
      pg.fill(255);
      pg.ellipse(x, y, r, r);
    }

    for (int i = 0; i < 3000; i++) {
      float x = random(0, width);
      float y = random(height / 2.0f, height / 2.0f + height / 10.0f);
      float r = map(y, height / 2, height, 1, 2);
      int rand = int(random(360));
      pg.colorMode(HSB, 360, 100, 100, 1.0f);
      //    fill('hsla(' + rand + ', 100%, 50%, 0.5)');
      pg.fill(color(rand, 100, 50, 0.5f));
      pg.colorMode(RGB, 255, 255, 255, 255);
      pg.ellipse(x, y, r, r);
    }

    for (int i = 0; i < 1000; i++) {
      float x = random(0, width);
      float y = random(height / 2.0f, height);
      float r = map(y, height / 2.0f, height, 1, 10);
      pg.fill(255);
      pg.ellipse(x, y, r, r);
    }
    for (int i = 0; i < 2000; i++) {
      float x = random(0, width);
      float y = random(height / 2.0f, height);
      float r = map(y, height / 2.0f, height, 1, 10);
      int rand = int(random(360));
      pg.colorMode(HSB, 360, 100, 100, 1.0f);
      //    fill('hsla(' + rand + ', 100%, 80%, 1)');
      pg.fill(rand, 100, 80, 0.6f);
      pg.colorMode(RGB, 255, 255, 255, 255);
      pg.ellipse(x, y, r, r);
    }
    pg.pop();
  }

  void starLight(PGraphics pg) {
    pg.push();
    var rand = random(100, 200);
    for (var i = 0; i < rand; i++) {
      float x = random(0, width);
      float y = random(0, 350);
      pg.noStroke();
      pg.fill(255);
      pg.ellipse(x, y, 1, 1);
    }
    pg.pop();
  }

  void moon(PGraphics pg) {
    pg.push();
    pg.noStroke();
    var moonX = random(100, width - 100);
    var moonY = random(100, height / 2.0f - 100);
    var diamater = random(20, 80);
    for (var i = 0; i < diamater; i++) {
      int c = int(map(i, 0, 100, 80, 100));
      pg.colorMode(HSB, 360, 100, 100, 1.0f);
      //    fill('hsla(200, 50%,' + c + '%, 0.3)');
      pg.fill(200, 50, c, 0.3f);
      pg.colorMode(RGB, 255, 255, 255, 255);
      pg.ellipse(moonX, moonY, diamater - i, diamater - i);
    }

    pg.pop();
    pg.push();
    for (t = 0; t<400; t+=2) {
      var wl = t/12.0f + diamater / 3.0f + random(t/10.0f, t/5.0f);
      pg.stroke(255, t/40.0f + random(150, 200)/3.0f);
      pg.strokeWeight(2 + t/60);
      pg.line(moonX - wl, 430+t, moonX + wl, 430 + t);
    }
    pg.pop();
  }

  @Override void mousePressed() {
    init();
    redraw();
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
