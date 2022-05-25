// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1333391
//

class GameSceneCongratulations216 extends GameSceneCongratulationsBase {
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    randomSeed(777);

    // 背景は真っ白にしておく
    pg.background(255);

    pg.rectMode(CENTER);

    pg.translate(width / 2, height / 2);
    pg.scale(0.9);
    pg.translate(-width / 2, -height / 2);

    pg.strokeWeight(1.5);
    pg.stroke(0);
    //  noFill();
    pg.fill(255);
    pg.rect(width / 2, height / 2, width, height);

    // いい感じにクリップにゃ！！（by PC-8001（TN8001）さん）
    pg.imageMode(CENTER);
    pg.clip(width / 2, height / 2, width, height);

    // （☟恥ずかしいコメント）
    // 下地を描いたので描画を混ぜ混ぜモード（BLEND）に戻す
    //pg.blendMode(BLEND);

    var seg = int(random(7, 12));
    var w = height / (float)seg;
    for (var i = 0; i < seg; i++) {
      for (var j = 0; j < seg; j++) {
        var x = i * w + w / 2.0f;
        var y = j * w + w / 2.0f;
        superRandomShape(pg, x, y, w);
      }
    }
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(#ff0000);
  }

  void nna(PGraphics pg, float x, float y, float w) {
    pg.push();
    pg.translate(x, y);
    pg.noFill();
    pg.stroke(0);
    pg.arc(0, w / 2.0f, w, w, PI, TAU);

    //Eyes
    var eyx = w * 0.18;
    var eyy = w * 0.19;
    var eyw = w * 0.1;
    pg.line(eyx + eyw / 2.0f, eyy, eyx - eyw / 2.0f, eyy);
    pg.line(-eyx + eyw / 2.0f, eyy, -eyx - eyw / 2.0f, eyy);

    // line();
    //Nose
    pg.fill(0);
    pg.ellipse(0, w * 0.22, w * 0.02, w * 0.01);

    //Mouse
    pg.line(0, w * 0.25, w * 0.035, w * 0.29);
    pg.line(0, w * 0.25, -w * 0.035, w * 0.29);

    //Ear
    var erx = w * 0.35;
    var ery = w * 0.05;
    var erw = w * 0.15;
    pg.noFill();
    myTriangle(pg, erx, ery, erw, PI * 0.22);
    myTriangle(pg, -erx, ery, erw, -PI * 0.22);

    //Cheek
    eyx += w * 0.15;
    eyy += w * 0.03;
    var sl = w * 0.02;
    var sg = w * 0.03;
    pg.line(eyx + sg, eyy, eyx + sg + sl, eyy + sl);
    pg.line(eyx, eyy, eyx + sl, eyy + sl);
    pg.line(eyx - sg, eyy, eyx - sg + sl, eyy + sl);

    pg.line(-eyx + sg, eyy, -eyx + sg + sl, eyy + sl);
    pg.line(-eyx, eyy, -eyx + sl, eyy + sl);
    pg.line(-eyx - sg, eyy, -eyx - sg + sl, eyy + sl);

    pg.pop();
  }

  void myTriangle(PGraphics pg, float x, float y, float w, float a) {
    pg.push();
    pg.translate(x, y);
    pg.beginShape();
    for (var i = 0; i < 3; i++) {
      var ang = map(i, 0, 3, 0, TAU) + TAU * 0.75 + a;
      pg.vertex(w * 0.5 * cos(ang), w * 0.5 * sin(ang));
    }
    pg.endShape(CLOSE);
    pg.pop();
  }

  void superRandomShape(PGraphics pg, float x, float y, float w) {
    var rnd = int(random(4));
    pg.push();
    pg.translate(x, y);
    pg.scale(random(1) < 0.5 ? -1 : 1, 1);
    pg.rotate(int(random(4)) * TAU / 4.0f);
    if (rnd == 0) {
      nna(pg, 0, w * 0.1, w * 0.8);
      pg.line(w / 2.0f, w / 2.0f, -w / 2.0f, w / 2.0f);
    } else if (rnd == 1) {
      pg.noFill();
      pg.stroke(0);
      pg.arc(0, w * 0.5, w * 0.8, w * 0.8, PI, TAU, PIE);
      superWave(pg, 0, w * 0.1, 0, -w * 0.4);
      pg.line(w / 2.0f, w / 2.0f, -w / 2.0f, w / 2.0f);
    } else if (rnd == 2) {
      pg.circle(0, w * 0.35, w * 0.3);
      pg.line(w / 2.0f, w / 2.0f, -w / 2.0f, w / 2.0f);
    } else if (rnd == 3) {
      pg.line(w / 2.0f, w / 2.0f, -w / 2.0f, w / 2.0f);
      pg.line(0, 0, 0, w / 2.0f);
      var d = w * 0.3;
      pg.fill(255);
      pg.arc(w / 4.0f, 0, d, d, 0, PI, PIE);
      pg.arc(-w / 4.0f, 0, d, d, PI, TAU, PIE);
      pg.circle(0, 0, w * 0.1);
    }
    pg.pop();
  }

  void superWave(PGraphics pg, float x1, float y1, float x2, float y2) {
    var dst = dist(x1, y1, x2, y2);
    var ang = atan2(y2 - y1, x2 - x1);
    var cNum = dst;
    var waveNum = 3 * PI;
    pg.push();
    pg.translate(x1, y1);
    pg.rotate(ang);
    pg.beginShape();
    for (var i = 0; i < cNum; i++) {
      var nrm = norm(i, 0, cNum - 1);
      var amp = dst * 0.3 * sin(PI * nrm);
      var yy = lerp(0, amp, sin(nrm * waveNum));
      var xx = lerp(0, dst, nrm);
      pg.vertex(xx, yy);
    }
    pg.endShape();
    pg.pop();
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
