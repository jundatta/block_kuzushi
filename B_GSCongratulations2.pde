// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】@mikitttさん
// 【記事の名前】Processingによる花火
// https://qiita.com/mikittt/items/776e6f2a114866386b54
//

class GameSceneCongratulations2 extends GameSceneCongratulationsBase {
  color gLogoColor;
  ArrayList<Fireworks> fireworks=new ArrayList<Fireworks>();

  @Override void setup() {
    imageMode(CENTER);

    colorMode(RGB, 255);
    blendMode(ADD);
    //    blendMode(SCREEN);
    hint(DISABLE_DEPTH_TEST);
    gLogoColor = color(0, 0, 40);
    mMA.entry("たまや～！！", "data/2/new_fireworks_festival1.mp3");
    mMA.loop("たまや～！！");
  }
  @Override void draw() {
    background(0, 0, 40);

    image(gMoon, 0, 0, gMoon.width, gMoon.height);

    // 1秒間に35%程度？
    if (frameCount % 60 == 0) {
      if (random(100) < 35) {
        fireworks.add(new Fireworks(80));
      }
    }

    for (int i=0; i<fireworks.size(); i++) {
      Fireworks art=fireworks.get(i);
      if (art.centerPosition.y-art.radius>height) {
        fireworks.remove(i);
      }
      art.display();
      art.update();
    }

    logoRightLower(gLogoColor);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    fireworks.add(new Fireworks(80));
  }

  //花火クラス
  class Fireworks {
    //花火の火の数
    int num=512;
    //花火の中心の初期位置
    PVector centerPosition=new PVector(random(width/8, width*7/8), random(height/2, height*4/5), random(-100, 100));
    //花火の中心の初期速度
    //    PVector velocity=new PVector(0, -22, 0);
    PVector velocity=new PVector(0, -8, 0);
    //重力
    //    PVector accel=new PVector(0, 0.4, 0);
    PVector accel=new PVector(0, 0.1, 0);
    PImage img;

    float radius;

    PVector[] firePosition=new PVector[num];


    Fireworks(float r) {
      float cosTheta;
      float sinTheta;
      float phi;
      float colorchange=random(0, 5);

      radius=r;
      for (int i=0; i<num; i++) {
        cosTheta = random(0, 1) * 2 - 1;
        sinTheta = sqrt(1- cosTheta*cosTheta);
        phi = random(0, 1) * 2 * PI;
        firePosition[i]=new PVector(radius * sinTheta * cos(phi), radius * sinTheta * sin(phi), radius * cosTheta);
        firePosition[i]=PVector.mult(firePosition[i], 1.12);
      }
      //色をランダムで初期化(綺麗な色が出やすいように調整)
      if (colorchange>=3.8) {
        img=createLight(0.9, random(0.2, 0.5), random(0.2, 0.5));
      } else if (colorchange>3.2) {
        img=createLight(random(0.2, 0.5), 0.9, random(0.2, 0.5));
      } else if (colorchange>2) {
        img=createLight(random(0.2, 0.5), random(0.2, 0.5), 0.9);
      } else {
        img=createLight(random(0.5, 0.8), random(0.5, 0.8), random(0.5, 0.8));
      }
    }

    void display() {
      for (int i=0; i<num; i++) {
        pushMatrix();
        translate(centerPosition.x, centerPosition.y, centerPosition.z);
        translate(firePosition[i].x, firePosition[i].y, firePosition[i].z);
        image(img, 0, 0);
        popMatrix();

        firePosition[i]=PVector.mult(firePosition[i], 1.015);
      }
    }

    void update() {
      radius=dist(0, 0, 0, firePosition[0].x, firePosition[0].y, firePosition[0].z);
      centerPosition.add(velocity);
      velocity.add(accel);
    }

    //発光表現の元となるクラス
    PImage createLight(float rPower, float gPower, float bPower) {
      int side=64;
      float center=side/2.0;
      gLogoColor = color(255 * rPower, 255 * gPower, 255 * bPower);

      PImage img=createImage(side, side, RGB);

      for (int y=0; y<side; y++) {
        for (int x=0; x<side; x++) {
          float distance=(sq(center-x)+sq(center-y))/10.0;
          int r=int((255*rPower)/distance);
          int g=int((255*gPower)/distance);
          int b=int((255*bPower)/distance);
          img.pixels[x+y*side]=color(r, g, b);
        }
      }
      return img;
    }
  }
}
