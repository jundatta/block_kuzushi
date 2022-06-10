// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】takawoさん
// 【作品名】Cityscape
// https://openprocessing.org/sketch/1239875
//

class GameSceneCongratulations51 extends GameSceneCongratulationsBase {
  color[] palette;

  @Override void setup() {
    imageMode(CORNER);

    colorMode(HSB, 360, 100, 100, 100);
    //  angleMode(DEGREES);
    //  palette = shuffle(chromotome.get().colors);
    palette = Chromotome.get().colors;
    while (palette.length < 3) {
      palette = Chromotome.get().colors;
    }
    palette = P5JS.shuffle(palette);
    // noLoop();
  }
  @Override void draw() {
    randomSeed(100);

    background(P5JSrandom(palette));

    float minY = -height;
    float minX = -width / 10.0f;
    float maxY = height;
    float maxW = (width * 11) / 10.0f;

    float x = minX;
    float y = minY;
    float xStep, yStep;
    while (y < maxY) {
      yStep = random(height / 5.0f);
      x = minX;
      while (x < maxW) {
        xStep = random(width / 10.0f, width / 5.0f);
        if (random(100) > 50.0f) {
          drawBuilding(
            x,
            y + random(-height / 10.0f, height / 10.0f),
            xStep,
            height - y + height / 10.0f
            );
        }
        x += xStep;
      }
      y += yStep;
    }

    logoRightLower(color(0, 100, 100));
  }


  void drawBuilding(float x, float y, float w, float h) {
    noStroke();
    color[] colors = P5JS.shuffle(palette);
    color c1 = colors[0];
    color c2 = colors[1];
    color c3 = colors[2];

    boolean isFrontWindow = random(1.0f) > 0.5;
    boolean isSideWindow = random(1.0f) > 0.5;
    while (!isFrontWindow && !isSideWindow) {
      isFrontWindow = random(1.0f) > 0.5;
      isSideWindow = random(1.0f) > 0.5;
    }

    int cols = int(random(1, 4));
    int rows = cols * ceil(h / w);

    float r = w / random(1.5, 5);

    float angle = radians(-45);

    float tx1 = x;
    float ty1 = y;
    float tx2 = x + w - cos(angle) * r;
    float ty2 = y;
    float tx3 = tx2 + cos(angle) * r;
    float ty3 = ty2 + sin(angle) * r;
    float tx4 = tx1 + cos(angle) * r;
    float ty4 = ty1 + sin(angle) * r;

    push();
    fill(c1);
    //  drawingContext.shadowColor = color(0, 0, 0, 33);
    //  drawingContext.shadowBlur = w / 5;
    beginShape();
    vertex(tx1, ty1);
    vertex(tx4, ty4);
    vertex(tx3, ty3);
    vertex(tx3, ty3 + h);
    vertex(tx4, ty4 + h);
    vertex(tx1, ty1 + h);

    endShape(CLOSE);
    pop();

    float _tw = tx2 - tx1;
    float _th = abs(ty3 - ty2);
    // quad(tx1, ty1, tx2, ty2, tx3, ty3, tx4, ty4);

    push();
    translate(x, y);
    shearX(radians(90) - angle);
    scale(1, -1);
    fill(0, 0, 0, 0);
    rect(0, 0, _tw, _th);

    int top_cols = 0; //int(random(1, 4));
    int top_rows = 0; //top_cols * ceil(h / w);
    float top_offset = (tx2 - tx1) / 10.0f;
    float top_margin = top_offset;

    float tw = (_tw - top_offset * 2 - top_margin * (top_cols - 1)) / (float)top_cols;
    float th = (_th - top_offset * 2 - top_margin * (top_rows - 1)) / (float)top_rows;

    for (int j = 0; j < top_rows; j++) {
      for (int i = 0; i < top_cols; i++) {
        float tx = top_offset + i * (tw + top_margin);
        float ty = top_offset + j * (th + top_margin);
        push();
        translate(tx, ty);
        rect(0, 0, tw, th);
        pop();
      }
    }

    pop();

    float rh = h - sin(angle) * r;
    float rw = w - cos(angle) * r;

    push();
    translate(x, y);
    fill(0, 0, 0, 15);
    rect(0, 0, rw, rh);

    if (isFrontWindow) {
      int front_cols = int(random(1, 4));
      int front_rows = front_cols * ceil(h / w);

      float front_offset = (tx2 - tx1) / 15.0f;
      float front_margin = front_offset;

      float fw =
        (tx2 - tx1 - front_offset * 2 - front_margin * (front_cols - 1)) /
        (float)front_cols;
      float fh =
        (rh - front_offset * 2 - front_margin * (front_rows - 1)) / (float)front_rows;

      for (int j = 0; j < front_rows; j++) {
        for (int i = 0; i < front_cols; i++) {
          float fx = front_offset + i * (fw + front_margin);
          float fy = front_offset + j * (fh + front_margin);
          push();
          translate(fx, fy);

          float n = noise(x + fx, y + fy, frameCount / 100.0f);
          if (n > 0.5) {
            fill(c2);
            // drawingContext.shadowColor = c2;
          } else {
            fill(c3);
            // drawingContext.shadowColor = c3;
          }
          // drawingContext.shadowBlur = fw / 2;

          rect(0, 0, fw, fh, min(fw, fh) / 10.0f);
          pop();
        }
      }
    }
    pop();

    push();
    fill(0, 0, 0, 30);
    quad(tx2, ty2, tx3, ty3, tx3, ty3 + rh, tx2, ty2 + rh);

    if (isSideWindow) {
      //    drawingContext.clip();
      translate(tx2, ty2);
      shearY(angle);

      int side_cols = int(random(1, 4));
      int side_rows = side_cols * ceil(h / w);

      float side_offset = r / 7.5;
      float side_margin = side_offset;

      float sw =
        (tx3 - tx2 - side_offset * 2 - side_margin * (side_cols - 1)) / (float)side_cols;
      float sh = (rh - side_offset * 2 - side_margin * (side_rows - 1)) / (float)side_rows;

      for (int j = 0; j < side_rows; j++) {
        for (int i = 0; i < side_cols; i++) {
          float cx = side_offset + i * (sw + side_margin);
          float cy = side_offset + j * (sh + side_margin);
          push();
          translate(cx, cy);
          float n = noise(x + cx, y + cy, frameCount / 100.0f);
          if (n > 0.5) {
            fill(c3);
            // drawingContext.shadowColor = c3;
          } else {
            fill(c2);
            // drawingContext.shadowColor = c2;
          }
          // drawingContext.shadowBlur = sw / 2;

          rect(0, 0, sw, sh, min(sw, sh) / 10.0f);
          pop();
        }
      }
    }
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
