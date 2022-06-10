// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Luis Correiaさん
// 【作品名】GMT Clock
// https://openprocessing.org/sketch/737576
//

class GameSceneCongratulations53 extends GameSceneCongratulationsBase {
  PFont myFont;

  int i, j, ms;
  float h, m, s, r;

  PGraphics pg;

  @Override void setup() {
    size(500, 800, P3D);
    //size(displayWidth, displayHeight);
    smooth();
    if (width > height) {
      r = height / 2;
    } else {
      r = width / 2;
    }
    r -= r / 8;
    myFont = createFont("Lucida Sans Typewriter", r, true);
    s = second();
    while (s == second());
    ms = millis();
    //  frameRate(8);

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.textFont(myFont);
    pg.textAlign(CENTER, CENTER);
    //strokeCap(SQUARE);
    pg.rectMode(CENTER);

    pg.background(0);
    //scale(2);
    pg.pushMatrix();
    pg.translate(width / 2, height / 2);
    draw_dial();
    pg.pushMatrix();
    for (i = 0; i < 120; i++) {
      if (i % 5 == 0) {
        pg.pushMatrix();
        pg.rotate(radians(7.5));
        _24hourTick();
        pg.popMatrix();
        pg.fill(192, 0, 0);
        pg.pushMatrix();
        pg.translate(r + r / 16, 0);
        pg.rotate(radians(90));
        pg.textSize(r / 10);
        pg.text((i / 5 + 5) % 24 + 1, 0, 0);
        pg.popMatrix();
        if (i % 10 == 0) {
          pg.fill(255, 192, 0);
          pg.stroke(192, 255, 192);
          if (i == 90) {
            pg.stroke(192, 192, 128);
          }
          largeTick();
          pg.fill(192, 192, 128);
          pg.pushMatrix();
          pg.translate(r - r / 3, 0);
          pg.rotate(radians(-3 * i));
          pg.textSize(r / 6);
          pg.text((i / 10 + 2) % 12 + 1, 0, 0);
          pg.popMatrix();
        }
      } else {
        if (i % 2 == 0) {
          smallTick();
        }
      }
      pg.rotate(radians(3));
    }
    pg.popMatrix();
    pg.pushMatrix();
    pg.rotate(radians(45));
    dateWindow();
    pg.popMatrix();
    h = float(hour());
    m = float(minute());
    s = float(second()) + float((millis() - ms) % 1000) / 1000.0;
    m += s / 60.0;
    h += m / 60.0;
    pg.pushMatrix();
    pg.rotate(radians(15 * h - 90));
    _24hourHand();
    pg.popMatrix();
    pg.pushMatrix();
    pg.rotate(radians(30 * h - 90));
    hourHand();
    pg.popMatrix();
    pg.pushMatrix();
    pg.rotate(radians(6 * m - 90));
    minuteHand();
    pg.popMatrix();
    pg.pushMatrix();
    pg.rotate(radians(6 * s -90));
    secondHand();
    pg.popMatrix();
    pg.popMatrix();

    pg.endDraw();

    image(pg, 0, 0);

    logoRightUpper(color(255, 0, 0));
  }

  void draw_dial() {
    pg.stroke(192, 192, 128);
    pg.strokeWeight(r / 128);
    pg.fill(192, 255, 192);
    pg.ellipse(0, 0, 2 * r + r / 4, 2 * r + r / 4);
    pg.fill(0);
    pg.ellipse(0, 0, 2 * r, 2 * r);
    pg.fill(192);
    pg.textSize(r / 10);
    pg.text("IWA", 0, -r / 3.5);
    pg.text("GMT", 0, r / 4);
  }

  void _24hourTick() {
    pg.stroke(192, 192, 128);
    pg.strokeWeight(r / 128);
    pg.line(r, 0, r + r / 8, 0);
  }

  void smallTick() {
    pg.stroke(192);
    pg.strokeWeight(r / 256);
    pg.line(r - r / 8, 0, r - r / 16, 0);
  }

  void largeTick() {
    pg.strokeWeight(r / 32);
    pg.line(r - r / 5, 0, r - r / 16, 0);
  }

  void dateWindow() {
    pg.stroke(0);
    pg.strokeWeight(r / 128);
    pg.fill(192);
    pg.rect(r - r / 4, 0, r / 8, r / 8);
    pg.fill(0);
    pg.textSize(r / 12);
    pg.text(day(), r - r / 4, 0);
  }

  void _24hourHand() {
    pg.stroke(192, 0, 0);
    pg.strokeWeight(r / 32);
    pg.line(r / 48, 0, r - r / 2, 0);
    pg.strokeWeight(r / 128);
    pg.line(r - r / 2, 0, r - 2 * r / 5, 0);
  }

  void hourHand() {
    pg.noStroke();
    pg.fill(192);
    pg.ellipse(0, 0, r / 12, r / 12);
    pg.stroke(192);
    pg.strokeWeight(r / 16);
    pg.line(r / 48, 0, r - r / 2, 0);
    pg.strokeWeight(r / 128);
    pg.line(r - r / 2, 0, r - 2 * r / 5, 0);
    pg.stroke(192, 255, 192);
    pg.strokeWeight(r / 64);
    pg.line(r / 16, 0, r - r / 2, 0);
  }

  void minuteHand() {
    pg.stroke(192);
    pg.strokeWeight(r / 16);
    pg.line(r / 48, 0, r - r / 4, 0);
    pg.strokeWeight(r / 128);
    pg.line(r - r / 4, 0, r - r / 6, 0);
    pg.stroke(192, 255, 192);
    pg.strokeWeight(r / 64);
    pg.line(r / 16, 0, r - r / 4, 0);
  }

  void secondHand() {
    pg.stroke(192);
    pg.strokeWeight(r / 128);
    pg.line(-r / 8, 0, r - r / 5, 0);
    pg.stroke(192, 0, 0);
    pg.line(r - r / 5, 0, r - r / 8, 0);
    pg.stroke(192);
    pg.strokeWeight(r / 256);
    pg.fill(192);
    pg.ellipse(-r / 8, 0, r / 16, r / 16);
    pg.stroke(192, 0, 0);
    pg.fill(192, 0, 0);
    pg.triangle(r - r / 4, -r / 64, r - r / 6, 0, r - r / 4, r / 64);
    pg.stroke(192);
    pg.fill(0);
    pg.ellipse(0, 0, r / 48, r / 48);
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
