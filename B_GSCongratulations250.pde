// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】watabo_shiさん
// 【作品名】LEGO Lion
// https://openprocessing.org/sketch/1292325
//

class GameSceneCongratulations250 extends GameSceneCongratulationsBase {
  // let url = 'https://coolors.co/072ac8-1e96fc-a2d6f9-fcf300-ffc600';
  // let palette = url.replace('https://coolors.co/', '').split('-').map(c => '#' + c);
  int num = 32;
  float size;
  float step;
  ArrayList<Integer> colorArr = new ArrayList();
  ArrayList<Float> sizeArr = new ArrayList();

  PShape cylinder;

  @Override void setup() {
    PImage img = loadImage("data/250/lion.png");

    pixelDensity(1);
    ortho(-width / 2.0f, width / 2.0f, height / 2.0f, -height / 2.0f, 0, 2000);

    int vmin = (width < height) ? width : height;
    size = vmin / (float)(num * 4);
    step = size * 4;
    img.resize(num, num);
    PGraphics pg = createGraphics(num, num);
    pg.beginDraw();
    pg.image(img, 0, 0, pg.width, pg.height);
    pg.endDraw();
    pg.loadPixels();

    for (int i = 0; i < num * num; i++) {
      // p5.jsの場合、pixelsはcolorの配列ではなくbyte単位（r,g,b,a）の配列（4倍のサイズ）に見える
      //int r = pg.pixels[i * 4 + 0];
      //int g = pg.pixels[i * 4 + 1];
      //int b = pg.pixels[i * 4 + 2];
      //int a = pg.pixels[i * 4 + 3];
      color p = pg.pixels[i];
      int r = (int)red(p);
      int g = (int)green(p);
      int b = (int)blue(p);
      int a = (int)alpha(p);
      colorArr.add(color(r, g, b));
      int inMax = 255*2;
      int rgb = r+g+b;
      if (inMax < rgb) {
        rgb = inMax;
      }
      sizeArr.add(map(r+g+b, 0, inMax, 0, 4) * (a / 255.0f));
    }
    pg.updatePixels();

    cylinder = createCan(0.15, 0.2, 6, true, false);
  }
  @Override void draw() {
    translate(width / 2, height / 2);

    background(31, 19, 1);
    float fc = frameCount * 0.02;
    float sn = sin(fc) * 0.5 + 0.5;
    rotateX(PI * (0.5 - sn * 0.35));
    rotateY(PI * (sn * 0.25));

    ambientLight(160, 160, 160);
    directionalLight(200, 200, 200, +1, +1, +1);

    noStroke();

    for (int i = 0; i < num; i++) {
      float pz = (i - num / 2.0f + 0.5) * step;
      for (int j = 0; j < num; j++) {
        float px = (j - num / 2.0f + 0.5) * step;
        int idx = i * num + j;
        float sz = size * sizeArr.get(idx);
        float s = floor(sizeArr.get(idx) * 2 * sn * 2) / 2.0f;
        if (s < 0.5) continue;
        fill(colorArr.get(idx));
        cylinder.setFill(colorArr.get(idx));
        push();
        {
          translate(px, sz * s / 2.0f, pz);

          push();
          {
            translate(-sz / 4.0f, sz * s / 2.0f, -sz / 4.0f);
            scale(sz, sz, sz);
            //          cylinder(0.15, 0.2, 6);
            shape(cylinder);
          }
          pop();
          push();
          {
            translate(sz / 4.0f, sz * s / 2.0f, -sz / 4.0f);
            scale(sz, sz, sz);
            //          cylinder(0.15, 0.2, 6);
            shape(cylinder);
          }
          pop();
          push();
          {
            translate(sz / 4.0f, sz * s / 2.0f, sz / 4.0f);
            scale(sz, sz, sz);
            //          cylinder(0.15, 0.2, 6);
            shape(cylinder);
          }
          pop();
          push();
          {
            translate(-sz / 4.0f, sz * s / 2.0f, sz / 4.0f);
            scale(sz, sz, sz);
            //cylinder(0.15, 0.2, 6);
            shape(cylinder);
          }
          pop();

          scale(sz, sz * s, sz);
          box(1);
        }
        pop();
      }
    }

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
