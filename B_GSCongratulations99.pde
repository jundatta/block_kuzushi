// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】dcc#43#Romantic"
// https://openprocessing.org/sketch/894584
// 【参考】
// https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/createLinearGradient
//

class GameSceneCongratulations99 extends GameSceneCongratulationsBase {
  //2020-05-13 dcc#43#Romantic"
  //Reference: http://blog.livedoor.jp/reona396/archives/55828329.html
  //Reference:p5js Examples"star" :  https://p5js.org/examples/form-star.html
  Star[] hosi = new Star[30];
  PGraphics pg;
  PGraphics mask;
  PGraphics hosiImg;
  final int kOrgW = 400;
  final int kOrgH = 400;
  int TopX, TopY;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    TopX = (width - kOrgW) / 2;
    TopY = (height - kOrgH) / 2;

    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(color(#293241));
    pg.endDraw();
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.rect(TopX + 50, TopY + 50, 300, 200);
    mask.endDraw();
    pg.mask(mask);

    hosiImg = createGraphics(kOrgW, kOrgH);
    for (int i = 0; i < hosi.length; i++) {
      hosi[i] = new Star(random(-200, 200), random(-200, 200), 5, random(10, 50), 4);
    }
  }
  @Override void draw() {
    background(color(#3868cb));

    //let gradientFill = drawingContext.createLinearGradient(
    //  width * 0.5,
    //  height * 0.1,
    //  width,
    //  height
    //  );

    //gradientFill.addColorStop(0, color("#3868cb"));
    //gradientFill.addColorStop(0.5, color("#1b3466"));
    //gradientFill.addColorStop(1, color("#1b3466"));

    //drawingContext.fillStyle = gradientFill;

    //rect(0,0,400);

    loadPixels();
    gradientRect(pixels, TopX + 50, TopY + 50, 300, 200, width, color(#3868cb), color(#1b3466));
    updatePixels();

    hosiImg.beginDraw();
    hosiImg.translate(hosiImg.width / 2, hosiImg.height / 2);
    for (int i = 0; i < hosi.length; i++) {
      hosi[i].show(hosiImg);
    }
    hosiImg.endDraw();
    image(hosiImg, TopX, TopY);

    image(pg, 0, 0);

    fill(255, 30);
    float r = random(20, 50);
    ellipse(random(width), random(height), r, r);

    //文字----------------------
    textSize(20);
    //  textFont("helvetica");
    textAlign(CENTER);

    fill(220);
    noStroke();
    text("R o m a n t i c", TopX + 200, TopY + 330);
    glass(TopX + 250, TopY + 180);

    logoRightLower(color(255, 0, 0));
  }


  class Star {
    float x;
    float y;
    float radius1;
    float radius2;
    float npoints;

    Star(float x, float y, float radius1, float radius2, float npoints) {
      this.x = x;
      this.y = y;
      this.radius1 = radius1;
      this.radius2 = radius2;
      this.npoints = npoints;
    }
    void show(PGraphics p) {
      float angle = TWO_PI / this.npoints;
      float halfAngle = angle / 2.0;
      p.fill(color(#ff68a8));
      p.stroke(color(#867ab9));
      p.strokeWeight(2);
      float r = this.radius2;
      p.ellipse(this.x, this.y, r, r);
      p.fill(color(#faeb11));
      p.noStroke();
      p.beginShape();
      for (float a = 0; a < TWO_PI; a += angle) {
        float sx = this.x + cos(a) * this.radius2;
        float sy = this.y + sin(a) * this.radius2;
        p.vertex(sx, sy);
        sx = this.x + cos(a + halfAngle) * this.radius1;
        sy = this.y + sin(a + halfAngle) * this.radius1;
        p.vertex(sx, sy);
      }
      p.endShape(CLOSE);

      r = this.radius2 / 2.0f;
      p.ellipse(this.x, this.y, r, r);
    }
  }

  void glass(float x, float y) {
    float w = 80;
    float h = 130;
    push();
    noFill();
    stroke(color(#ca7cd8));

    strokeWeight(5);
    strokeCap(ROUND);
    strokeJoin(ROUND);
    line(x+w/2, y+h/3, x+w/2, y+h-h/10);

    strokeWeight(3);
    fill(255, 255, 255, 70);
    triangle(x, y, x+w, y, x+w/2, y+h/3);
    triangle(x+w/10, y+h, x+w-w/10, y+h, x+w/2, y+h-h/10);

    fill(color(#0be7e2));
    noStroke();
    triangle(x+12, y+10, x+w-12, y+10, x+w/2, y+h/3-2);

    fill(220, 0, 0, 70);
    stroke(color(#ca7cd8));
    strokeWeight(2);
    float r = 18;
    ellipse(x+50, y+5, r, r);
    pop();
  }


  float gradient(int startColor, int endColor, int w) {
    float colorLength = endColor - startColor;
    return colorLength / (float)w;
  }
  color gradientRGB(int sR, int sG, int sB, float dR, float dG, float dB, int i) {
    int r = sR + int(dR * i);
    int g = sG + int(dG * i);
    int b = sB + int(dB * i);
    return color(r, g, b);
  }
  void gradientLine(color[] p, int y, int x, int w, int pitch, color startColor, color endColor) {
    int sR = (int)red(startColor);
    int sG = (int)green(startColor);
    int sB = (int)blue(startColor);
    int eR = (int)red(endColor);
    int eG = (int)green(endColor);
    int eB = (int)blue(endColor);
    float dR = gradient(sR, eR, w);
    float dG = gradient(sG, eG, w);
    float dB = gradient(sB, eB, w);

    int sy = y * pitch;
    for (int i = 0; i < w; i++) {
      color c = gradientRGB(sR, sG, sB, dR, dG, dB, i);
      p[sy + x + i] = c;
    }
  }
  void gradientRect(color[] p, int sx, int sy, int w, int h, int pitch, color startColor, color endColor) {
    int sR = (int)red(startColor);
    int sG = (int)green(startColor);
    int sB = (int)blue(startColor);
    int eR = (int)red(endColor);
    int eG = (int)green(endColor);
    int eB = (int)blue(endColor);
    int mR = (sR + eR) / 2;
    int mG = (sG + eG) / 2;
    int mB = (sB + eB) / 2;

    float sdR = gradient(sR, mR, h);
    float sdG = gradient(sG, mG, h);
    float sdB = gradient(sB, mB, h);
    float edR = gradient(mR, eR, h);
    float edG = gradient(mG, eG, h);
    float edB = gradient(mB, eB, h);

    for (int y = 0; y < h; y++) {
      color sC = gradientRGB(sR, sG, sB, sdR, sdG, sdB, y);
      color eC = gradientRGB(mR, mG, mB, edR, edG, edB, y);
      gradientLine(p, sy + y, sx, w, pitch, sC, eC);
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
