// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】時計02
// https://neort.io/art/c4ee6ms3p9ffolj0604g
//

class GameSceneCongratulations145 extends GameSceneCongratulationsBase {
  float cx, cy;
  float dia;
  float sl, ml, hl;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);


    cx = width/2.0f;
    cy = height/2.0f;
    dia = width;
    if (width > height)dia = height;
    sl = dia * 0.8;
    ml = dia * 0.5;
    hl = dia * 0.2;

    textSize(dia*0.1);
    textAlign(CENTER, CENTER);
  }
  @Override void draw() {
    float sec = second();
    float min = minute() + (second() % 60)/60.0f;
    float hou = hour() + (minute() % 60)/60.0f;
    float ss = map(sec, 0, 60, 0, TAU) - PI/2.0f;
    float mm = map(min, 0, 60, 0, TAU) - PI/2.0f;
    float hh = map(hou, 0, 24, 0, TAU*2) - PI/2.0f;
    float aa = PI*0.15;

    background(255);
    strokeCap(SQUARE);
    fill(255);
    noFill();
    strokeWeight(dia * 0.02);
    stroke(0);
    //  arc(cx, cy, sl, sl, ss+aa*0.45, ss-aa*0.45);
    float start = ss+aa*0.45;
    float stop = ss-aa*0.45 + 2*PI;
    arc(cx, cy, sl, sl, start, stop);
    dispChar(floor(sec), cx + sl * 0.5 * cos(ss), cy + sl * 0.5 * sin(ss), ss);
    start = mm+aa*0.66;
    stop = mm-aa*0.66 + 2*PI;
    arc(cx, cy, ml, ml, start, stop);
    dispChar(floor(min), cx + ml * 0.5 * cos(mm), cy + ml * 0.5 * sin(mm), mm);
    start = hh+aa;
    stop = hh-aa + 2*PI;
    arc(cx, cy, hl, hl, start, stop);
    dispChar(int(hou%12), cx + hl * 0.5 * cos(hh), cy + hl * 0.5 * sin(hh), hh);
    strokeCap(ROUND);
    point(cx, cy);

    logoRightLower(color(255, 0, 0));
  }

  void dispChar(int letter, float x, float y, float a) {
    push();
    translate(x, y);
    rotate(a + PI/2.0f);
    fill(0);
    noStroke();
    text(letter, 0, 0);
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
