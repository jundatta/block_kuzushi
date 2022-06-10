// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】jsyehさん
// 【作品名】Earth
// https://openprocessing.org/sketch/920691
//

class GameSceneCongratulations88 extends GameSceneCongratulationsBase {
  PShape sphere;
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(0);
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(0);
    for (int t = 0; t < 50; t++) {
      float sz = random(1, 4);
      pg.ellipse(random(0, width), random(0, height), sz, sz);
    }
    pg.endDraw();

    sphere = createShape(SPHERE, 300);
    PImage img=loadImage("data/88/earth.jpg");
    sphere.setTexture(img);
    sphere.setStrokeWeight(0);
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    image(pg, -width/2, -height/2);

    rotateX(-.5);
    rotateY(radians(frameCount/4.0f));
    lights();
    ambientLight(128, 128, 128);
    directionalLight(128, 128, 128, 0, 0, -1);
    shape(sphere);
    pop();

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
