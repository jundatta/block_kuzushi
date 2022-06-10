// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】kevinさん
// 【作品名】Slow Motion Race
// https://openprocessing.org/sketch/1028109
//

class GameSceneCongratulations70 extends GameSceneCongratulationsBase {
  ArrayList<Runner> runners = new ArrayList();

  class CColorPalette {
    color dark = #384269;
    color light = #b4cdee;
    color shadow = #a6acf8;
    color normal = #7aa7c4;
  }
  final CColorPalette ColorPalette = new CColorPalette();

  int msFrame;
  int deltaTime;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    for (int i=0; i<30; i++) {
      Runner runner = new Runner();
      runners.add(runner);
    }
    runners.sort((a, b) -> (int)(a.pos.y - b.pos.y));

    pg = createGraphics(width, height);

    msFrame = millis();
  }
  @Override void draw() {
    int now = millis();
    deltaTime = now - msFrame;
    msFrame = now;

    pg.beginDraw();
    pg.background(ColorPalette.light);

    for (int i=0; i<runners.size(); i++) {
      Runner runner = runners.get(i);
      runner.update();
      runner.draw();
    }
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  class Runner {
    float curTime;
    float speedt;
    float angoffset;
    float layang;
    float legang;
    float speed;
    float bodylen;
    float leglen;
    float headrad;
    float armlen;
    float armang;
    float armbend;
    float bounceheight;
    PVector pos;
    float shift;
    Runner() {
      this.curTime = random(10000.0);
      this.speedt = random(0.5, 2.0);
      this.angoffset = PI;
      this.layang = -15 * this.speedt;
      this.legang = 45 * this.speedt;
      this.speed = 100 * this.speedt;
      this.bodylen = random(30, 40);
      this.leglen = this.bodylen * 0.8;
      this.headrad = this.bodylen * 0.18;
      this.armlen = this.bodylen * 0.6;
      this.armang = 30 * this.speedt;
      this.armbend = 1.5;
      this.bounceheight = this.bodylen * 0.15 * this.speedt;
      this.pos = new PVector(random(width), random(height));
      this.shift = random(1.0f);
    }

    void update() {
      this.pos.add(new PVector(-this.speedt * 5, 0));

      if (this.pos.x < -this.leglen-this.armlen) {
        this.pos.x = width + this.leglen + this.armlen;
      }

      this.curTime += deltaTime * 0.001;
    }

    void draw() {
      this.drawShadow();
      this.drawRunner();
    }

    void drawRunner() {
      pg.strokeWeight(7);
      color bcol = lerpColor(color(ColorPalette.normal), color(ColorPalette.dark), (this.pos.y / (float)height * 0.4 + this.shift * 0.6));
      pg.stroke(bcol);
      pg.fill(bcol);
      pg.push();
      pg.translate(this.pos.x, this.pos.y);
      pg.push();
      pg.translate(0, sin(radians(this.curTime * this.speed * 2)) *this.bounceheight);

      pg.push();
      pg.rotate(map(sin(radians(this.curTime * this.speed)), -1.0, 1.0, radians(this.layang), radians(this.legang)));
      pg.line(0, 0, 0, this.leglen);
      pg.translate(0, this.leglen);
      pg.rotate(map(sin(radians(this.curTime * this.speed) + radians(45)), -1.0, 1.0, radians(-0), radians(-this.legang * 2)));
      pg.line(0, 0, 0, this.leglen);
      pg.pop();

      pg.push();
      pg.rotate(map(sin(radians(this.curTime * this.speed) + PI), -1.0, 1.0, radians(this.layang), radians(this.legang)));
      pg.line(0, 0, 0, this.leglen);
      pg.translate(0, this.leglen);
      pg.rotate(map(sin(radians(this.curTime * this.speed) + radians(45) + PI), -1.0, 1.0, radians(-0), radians(-this.legang * 2)));
      pg.line(0, 0, 0, this.leglen);
      pg.pop();

      pg.push();
      pg.rotate(radians(this.layang * 0.25));
      pg.push();
      pg.line(0, 0, 0, -this.bodylen);
      pg.translate(0, -this.bodylen - this.headrad);

      pg.ellipse(0, 0, this.headrad * 2, this.headrad * 2);
      pg.pop();

      pg.push();
      pg.translate(0, -this.bodylen * 0.8);
      pg.rotate(map(sin(radians(this.curTime * this.speed)), -1.0, 1.0, radians(-this.armang), radians(this.armang)));
      pg.line(0, 0, 0, this.armlen);
      pg.translate(0, this.armlen);
      pg.rotate(map(sin(radians(this.curTime * this.speed) + radians(45)), -1.0, 1.0, radians(this.armang*this.armbend * 0.5), radians(this.armang*this.armbend)));
      pg.line(0, 0, 0, this.armlen);
      pg.pop();

      pg.push();
      pg.translate(0, -this.bodylen * 0.8);
      pg.rotate(map(sin(radians(this.curTime * this.speed) + PI), -1.0, 1.0, radians(-this.armang), radians(this.armang)));
      pg.line(0, 0, 0, this.armlen);
      pg.translate(0, this.armlen);
      pg.rotate(map(sin(radians(this.curTime * this.speed) + radians(45) + PI), -1.0, 1.0, radians(this.armang*this.armbend * 0.5), radians(this.armang*this.armbend)));
      pg.line(0, 0, 0, this.armlen);
      pg.pop();
      pg.pop();
      pg.pop();
      pg.pop();
    }

    void drawShadow() {
      pg.strokeWeight(15);
      color col = lerpColor(color(ColorPalette.normal), color(ColorPalette.shadow), pow((this.pos.y / (float)height * 0.7 + this.shift * 0.3), 2));//lerpColor(color(ColorPalette.light), color(ColorPalette.shadow), this.pos.x / width);
      //    col._array[3] = this.pos.x / width;
      col = color(red(col), green(col), blue(col), 255 * (this.pos.x / (float)width));
      pg.stroke(col);

      pg.line(width, this.pos.y + this.leglen * 2 + this.bounceheight, this.pos.x, this.pos.y + this.leglen * 2 + this.bounceheight);
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
