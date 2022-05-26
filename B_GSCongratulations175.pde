// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】aoaoao
// https://neort.io/art/bnfsei43p9f5erb52p4g
//

class GameSceneCongratulations175 extends GameSceneCongratulationsBase {
  ArrayList<Form> forms = new ArrayList();
  int minSize = 300;
  PGraphics bg;
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    rectRec(0, 0, width, height);
    bg = createGraphics(width, height);
    bg.beginDraw();
    bg.noStroke();
    for (int i = 0; i < 400000; i++) {
      float x = random(width);
      float y = random(height);
      float s = random(1);
      bg.fill(185, 50);
      bg.rect(x, y, s, s);
    }
    bg.endDraw();

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.background(255, 50);
    // https://processing.org/reference/background_.html
    // 　⇒主描画面の背景色に透明度パラメータ(alpha)を使用することはできません。
    //     PGraphicsオブジェクトとcreateGraphics()と一緒に使用することのみ可能です。
    //fill(255, 50);
    //rect(0, 0, width, height);

    pg.push();
    pg.rectMode(CENTER);

    for (Form f : forms) {
      f.show(pg);
      f.move();
    }
    if (frameCount % (60 * 7) == 0) {
      restart();
    }
    pg.image(bg, 0, 0);
    pg.pop();
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(#ff0000);
  }


  void rectRec(float x_, float y_, float w_, float h_) {
    int wCount = int(random(2, 6));
    int hCount = int(random(2, 4));
    float w = w_ / (float)wCount;
    float h = h_ / (float)hCount;
    for (int i = 0; i < wCount; i++) {
      for (int j = 0; j < hCount; j++) {
        float x = x_ + i * w;
        float y = y_ + j * h;
        if (random(1) < 0.8 && w + h > minSize) {
          rectRec(x, y, w, h);
        } else {
          forms.add(new Form(x + w / 2.0f, y + h / 2.0f, w, h));
        }
      }
    }
  }

  void restart() {
    //forms.length = 0;
    forms.clear();
    rectRec(0, 0, width, height);
  }

  class Form {
    float x, y, w, h;
    float ww, hh;
    float t, tStep;
    float myNoise;
    float col;

    Form(float x, float y, float w, float h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.ww = 0;
      this.hh = 0;
      this.t = random(10);
      this.tStep = random(0.006);
      this.myNoise = 0;
      this.col = 10;
    }

    void show(PGraphics pg) {
      pg.noFill();
      pg.stroke(this.col);
      pg.strokeWeight(0.5);
      //    rect(this.x, this.y, this.ww, this.hh, (1 - this.myNoise) * (this.w, this.h) / 4);
      // (this.w, this.h)の結果はカンマ演算子の構文でいくと後のthis.hが最終的に評価されていた
      // https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Comma_Operator
      pg.rect(this.x, this.y, this.ww, this.hh, (1 - this.myNoise) * this.h / 4.0f);
    }

    void move() {
      this.t += this.tStep;
      this.myNoise = constrain(map(noise(this.t), 0, 1, -3, 4), 0, 1);
      this.ww = this.w * constrain(this.myNoise, 0.2, 1);
      this.hh = this.h * constrain(this.myNoise, 0.2, 1);
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
