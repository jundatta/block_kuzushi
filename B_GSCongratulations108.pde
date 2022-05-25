// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】 Senbakuさん
// 【作品名】dcc#23"ぬ"_"Rainfall"
// https://openprocessing.org/sketch/880100
//

class GameSceneCongratulations108 extends GameSceneCongratulationsBase {
  //codingChallange#03　紫の雨
  //https://www.youtube.com/watch?v=KkyIDI6rQJI
  //(138,43,226)
  //(230,230,350)
  Drop[] drop = new Drop[500];
  PGraphics pg;
  PGraphics mask;
  PGraphics rain;
  float x;
  float y;

  final int kOrgW = 400;
  final int kOrgH = 400;
  int TopX, TopY;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    //TopX = (width - kOrgW) / 2;
    //TopY = (height - kOrgH) / 2;
    TopX = 0;
    TopY = 0;

    pg=createGraphics(width, height);
    pg.beginDraw();
    pg.background(#3d5a80);
    //  pg.erase();
    //  pg.rect(100, 100, 200, 130, 10);
    //  pg.noErase();
    pg.endDraw();
    mask=createGraphics(width, height);
    mask.beginDraw();
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.rect(TopX + 100, TopY + 100, 200, 130, 10);
    mask.endDraw();
    pg.mask(mask);
    rain = createGraphics(width, height);

    for (int i = 0; i < drop.length; i++) {
      drop[i] = new Drop();
    }
  }
  @Override void draw() {
    background(#98c1d9);

    rain.beginDraw();
    rain.background(#98c1d9);
    for (int i = 0; i < drop.length; i++) {
      drop[i].fall();
      drop[i].show(rain);
    }
    rain.endDraw();
    image(rain, 0, 0);
    image(pg, 0, 0);
    neko(TopX + 200, TopY + 200);

    //text--------
    fill(#ee6c4d);
    noStroke();
    textSize(20);
    //  textFont("helvetica");
    textAlign(CENTER);
    text("R a i n f a l l ", TopX + kOrgW / 2, TopY + 330);

    logoRightLower(color(255, 0, 0, 64));
  }

  void neko(float x, float y) {
    noFill();
    stroke(#293241);
    strokeWeight(5);
    //  arc(x+5, y+79, 60, 40, PI+QUARTER_PI, HALF_PI);
    arc(x+5, y+79, 60, 40, -QUARTER_PI, HALF_PI);
    fill(#293241);
    noStroke();
    //head
    triangle(x - 17, y - 10, x - 12, y - 30, x - 2, y - 15); //left
    triangle(x + 2, y - 15, x + 12, y - 30, x + 17, y - 10); //right
    ellipse(x, y - 2, 40, 35);
    //body
    beginShape();
    curveVertex(x-5, y - 2);
    curveVertex(x-5, y - 2);
    curveVertex(x - 20, y + 80);
    curveVertex(x + 30, y + 80);
    curveVertex(x+10, y +5);
    curveVertex(x+10, y +5);
    endShape();
    ellipse(x+4, y+60, 60, 60);
    // //eye
    // fill(220);
    // ellipse(x-7,y-10,7);
    // ellipse(x+7,y-10,7);
  }

  class Drop {
    float x;
    float y;
    float z;
    float len;
    float yspeed;
    Drop() {
      this.x = random(width);
      this.y = random(-500, -50);

      this.z = random(0, 20);
      this.len = map(this.z, 0, 20, 10, 20);
      this.yspeed = map(this.z, 0, 20, 1, 20);
    }
    void fall() {
      this.y = this.y + this.yspeed;
      float grav = map(this.z, 0, 20, 0, 0.2);
      this.yspeed = this.yspeed + grav; //重力

      if (this.y > height) {
        this.y = random(-200, -50);
        this.yspeed = map(this.z, 0, 20, 1, 20);
      }
    }
    void show(PGraphics p) {
      float thick = map(this.z, 0, 20, 0.5, 1);
      p.strokeWeight(thick);
      p.stroke(#3d5a80);
      p.line(this.x, this.y, this.x, this.y + this.len);
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
