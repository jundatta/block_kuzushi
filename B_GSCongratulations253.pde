// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/bvm534c3p9f30ks562l0?index=85&origin=user_like
//

class GameSceneCongratulations253 extends GameSceneCongratulationsBase {
  class Stars {
    Star s1;
    Star s2;
    Star s3;

    Stars() {
      s1 = new Star();
      s2 = new Star();
      s3 = new Star();
    }
    void move(float dirX, float dirY) {
      s1.move(dirX, dirY);
      s2.move(dirX * 1.5, dirY * 1.5);
      s3.move(dirX * 3, dirY * 3);
    }
    void draw(PGraphics bf) {
      s1.draw(bf);
      s2.draw(bf);
      s3.draw(bf);
    }
  }
  Stars[] stars;
  PGraphics buffer;
  PGraphics buffer2;

  @Override void setup() {
    stars = new Stars[100];
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Stars();
    }
    // P2Dを指定しないデフォルトのレンダラーはimage()を重ねるとうまく画面に反映されなくなる
    // P2DまたはP3Dをつけるとうまくいくようになる（PC-8001（TN8001）さんありがとう！！）
    // ＼(^_^)／（謎）
    buffer = createGraphics(width, height, P2D);
    buffer2 = createGraphics(width / 16, height / 16, P2D);
  }
  float dirX = 2;
  float dirY = 2;

  @Override void draw() {
    background(0);

    buffer.beginDraw();
    buffer.noFill();
    buffer.stroke(255);
    buffer.strokeWeight(2.0);
    buffer.clear();
    for (int i = 0; i < stars.length; i++) {
      stars[i].move(dirX, dirY);
      stars[i].draw(buffer);
    }
    buffer.endDraw();

    buffer2.beginDraw();
    buffer2.clear();
    buffer2.image(buffer, 0, 0, buffer2.width, buffer2.height, 0, 0, width, height);
    buffer2.endDraw();
    image(buffer, 0, 0);
    image(buffer2, 0, 0, width, height, 0, 0, buffer2.width, buffer2.height);

    logoRightLower(#ff0000);
  }
  @Override void mouseMoved() {
    ellipse(mouseX, mouseY, 5, 5);
    if (mouseX < width * 0.5) {
      dirX = -2;
    } else {
      dirX = 2;
    }
    if (mouseY < height * 0.5) {
      dirY = -2;
    } else {
      dirY = 2;
    }
  }

  final color[] list = {
    color(251, 248, 255),
    color(255, 189, 111),
    color(255, 221, 180),
    color(255, 244, 232),
    color(202, 216, 255),
    color(170, 191, 255),
    color(155, 176, 255),
  };
  class Star {
    float x, y;
    color c;

    Star() {
      this.x = random(1) * width;
      this.y = random(1) * height;
      float r = random(1) * 100;
      if (r < 70) {
        this.c = list[0];
      } else if (r > 70 && r < 75) {
        this.c = list[1];
      } else if (r > 75 && r < 80) {
        this.c = list[2];
      } else if (r > 80 && r < 85) {
        this.c = list[3];
      } else if (r > 85 && r < 90) {
        this.c = list[4];
      } else if (r > 90 && r < 95) {
        this.c = list[5];
      } else {
        this.c = list[6];
      }
    }
    void move(float x, float y) {
      this.x += x;
      if (this.x > width) {
        this.x -= width;
        this.y = random(1) * height;
      }
      if (this.x < 0) {
        this.x += width;
        this.y = random(1) * height;
      }
      this.y += y;
      if (this.y > height) {
        this.y -= height;
        this.x = random(1) * width;
      }
      if (this.y < 0) {
        this.y += height;
        this.x = random(1) * width;
      }
    }
    void draw(PGraphics bf) {
      bf.stroke(red(this.c), green(this.c), blue(this.c));
      bf.point(this.x, this.y);
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
