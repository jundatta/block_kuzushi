// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】dcc#27 "Essential"
// https://openprocessing.org/sketch/882420
//

class GameSceneCongratulations106 extends GameSceneCongratulationsBase {
  //2020-04-27 dcc#27 "Essential"
  float t = 0.0;
  final color c1 = #EE6C4D; //bgcolor
  final color c2 = #E0FBFC; //text color
  final color c3 = #F9FAFF; //coffeecup color
  final color c4 = #69585f; //coffee color
  final color c5 = #faf3dd; //hot steam color
  final color c6 = #3D5A80; //table color

  final int kOrgW = 400;
  final int kOrgH = 400;
  int TopX, TopY;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    TopX = (width - kOrgW) / 2;
    TopY = (height - kOrgH) / 2;

    noStroke();
  }
  @Override void draw() {
    background(c1);

    //hot steam-------------------
    hotSteam();
    //table----------------
    fill(c6);
    rect(TopX + 0, TopY + 220, kOrgW, 200);
    //coffee------------
    push();
    translate(0, -20);
    coffee();
    pop();

    //text--------
    fill(c2);
    //fill("#FF1654");
    noStroke();
    textSize(20);
    //  textFont("helvetica");
    textAlign(CENTER);
    text("E s s e n t i a l ", TopX + (kOrgW / 2), TopY + 330);

    logoRightLower(color(255, 0, 0));
  }

  void coffee() {
    float w = width / 2;
    float h = height / 2;
    float cupw = 100;
    stroke(c3);
    strokeWeight(8);
    noFill();
    arc(w + cupw / 2, h + 35, 40, 50, PI + HALF_PI, HALF_PI);

    fill(c3);
    noStroke();
    rect(w - cupw / 2, h, cupw, 90, 0, 0, 50, 50);
    ellipse(w, h, cupw, 30);

    fill(c4);
    ellipse(w, h + 3, 90, 20);
  }

  void hotSteam() {
    push();
    translate(TopX + (kOrgW / 2), TopY - 200);
    //hot steam-------------------
    fill(c5);

    for (float i = 0; i < 12; i += 0.05) {
      float sx = -sin(i + t) * 20;
      float sy = i * 50;
      ellipse(sx, sy, 70 - i * 9, 70 - i * 9);
    }
    t += 0.01;
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
