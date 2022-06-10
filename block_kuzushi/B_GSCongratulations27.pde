// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Robert D'Arcyさん
// 【作品名】Eternal Mandalas
// https://openprocessing.org/sketch/1211350
//

class GameSceneCongratulations27 extends GameSceneCongratulationsBase {
  // generative, sin, cos, abs, sqrt, atan2, TWO_PI, ellipse, mandala, transparent
  // This sketch was constructed by combining  Dan Anderson's "Final Snowflake",
  // sketch #396703, with the 'mover' code from "Spinning Tops", sketch #151089.
  // A mandala generator. A different design every 1200 frames.
  // As with most(all?) generative code, " some are better than others ".
  // No interaction.

  float x, y, ang, dst, alpha, alpha2, sze;
  Mover   c;
  int count, select;

  @Override void setup() {
    colorMode(RGB, 255);
    noStroke();
    background(0);
    c = new Mover();
    alpha = alpha2 = 0;
    sze = 5;
    select = int(random(2));
  }
  @Override void draw() {
    count++;
    if (count > 1200) fadeOut();

    fill(0, alpha);
    rect(0, 0, width, height);

    alpha2 += 1;
    if (alpha2 > 255) alpha2 = 255;
    //fill(abs(sin(frameCount * .02) * 255), abs(sin(frameCount * .03) * 255),
    //  abs(sin(frameCount * .01) * 255), abs(sin(frameCount * .005) * alpha2));
    color fillColor = color(abs(sin(frameCount * .02) * 255), abs(sin(frameCount * .03) * 255),
      abs(sin(frameCount * .01) * 255), abs(sin(frameCount * .005) * alpha2));
    fill(fillColor);

    c.move();
    if (select == 0) {
      x = c.x-width/2;
      y = c.y-height/2;
    } else {
      x = c.x2-width/2;
      y = c.y2-height/2;
    }

    dst = sqrt(x*x + y*y);
    ang = atan2(y, x);
    for (float i = 0; i < TWO_PI; i += TWO_PI/16) {
      x = width/2 + dst * cos(ang + i);
      y = height/2 + dst * sin(ang + i);
      ellipse(x, y, sze, sze);
      x = width/2 + dst * cos(-ang + i);
      y = height/2 + dst * sin(-ang + i);
      ellipse(x, y, sze, sze);
    }

    logoRightLower(fillColor);
  }

  class Mover {
    float x, y, x2, y2, ang, max, min, radius, incr;
    int howFar, dir, dir2;
    PVector pos, vel;

    Mover() {
      max = 1;
      min = .05;
      howFar = 200;
      pos = new PVector(random(howFar, width-howFar), random(howFar, height-howFar));
      vel = new PVector(random(-1, 1), random(-1, 1));
      dir = random(2) > 1 ? 1 : -1;
      dir2 = random(2) > 1 ? 1 : -1;
      incr = random(.01, .02);
    }

    void move() {
      update();
      boundsCheck();
    }

    void update() {
      pos.add(vel);
      ang +=  incr;
      x = pos.x + 50 * cos(ang)*dir;
      y = pos.y + 50 * sin(ang);
      radius = 40 * sin(ang*0.3);
      x2 = x + radius * sin(ang*2*dir2);
      y2 = y + radius * cos(ang*2*dir2);
    }

    void boundsCheck() {
      if (pos.x > width-howFar) vel.x = -random(min, max);
      else if (pos.x < howFar) vel.x = random(min, max);
      if (pos.y > height-howFar)vel.y = -random(min, max);
      else if ( pos.y < howFar)vel.y = random(min, max);
    }
  }

  void fadeOut() {
    alpha += 1;
    alpha2 -= 1;
    if (alpha > 50) alpha += 5;
    if (alpha > 150) alpha += 15;
    if (alpha > 200) {
      c = new Mover();
      background(0);
      alpha = 0;
      count = 0;
      alpha2 = 0;
      select = int(random(2));
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
