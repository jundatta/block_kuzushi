// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】時計01
// https://neort.io/art/c2v8q943p9f8s59bd0t0
//

class GameSceneCongratulations153 extends GameSceneCongratulationsBase {
  float cx, cy;
  float dia;
  float sl, ml, hl;
  color[] colors = {#ffffff, #ED4141, #FECA16, #2B8BDF, #159670, #d441ea};
  color tCol;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    cx = width/2;
    cy = height/2;
    dia = height*0.95;
    sl = dia * 0.40;
    ml = dia * 0.25;
    hl = dia * 0.10;
    tCol = color(#000000);

    textAlign(CENTER, CENTER);
    //  textFont("Roboto");
    textFont(gPacifico);
    //  shuffle(colors, true);
  }
  @Override void draw() {
    float s = map(second(), 0, 60, 0, TAU) - PI/2.0f;
    float m = map(minute(), 0, 60, 0, TAU) - PI/2.0f;
    float h = map(hour(), 0, 24, 0, TAU*2) - PI/2.0f;
    color sCol = colors[second() % colors.length];
    color mCol = colors[minute() % colors.length];
    color hCol = colors[hour() % colors.length];
    background(0);
    noStroke();
    fill(0);

    noStroke();
    fill(0);
    for (int i=0; i<60; i++) {
      float a = (TAU/60.0f) * i;
      float x = cx + cos(a) * sl;
      float y = cy + sin(a) * sl;
      float ps = dia*0.005;
      fill(colors[i % colors.length]);
      if (i % 5 == 0) ps = dia*0.02;
      circle(x, y, ps);
    }

    fill(hCol);
    circle(cx + hl * cos(h), cy + hl * sin(h), dia*0.3);
    fill(tCol);
    textSize(dia*0.2);
    text(int(hour()) % 12, (cx + hl * cos(h)), (cy + hl * sin(h)) + dia*0.03);

    fill(mCol);
    circle(cx + ml * cos(m), cy + ml * sin(m), dia*0.2);
    fill(tCol);
    textSize(dia*0.10);
    text(int(minute()), (cx + ml * cos(m)), (cy + ml * sin(m)) + dia*0.01);

    fill(sCol);
    circle(cx + sl * cos(s), cy + sl * sin(s), dia*0.08);
    fill(tCol);
    textSize(dia*0.04);
    text(int(second()), cx + sl * cos(s), (cy + sl * sin(s)) + dia*0.005);

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
