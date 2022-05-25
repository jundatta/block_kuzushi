// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Earth and Moon
// https://openprocessing.org/sketch/727689
//

class GameSceneCongratulations72 extends GameSceneCongratulationsBase {
  class Sphere {
    PImage img;
    PShape sphere;
    Sphere(String filename, float r) {
      img = loadImage(filename);
      sphere = createShape(SPHERE, r);
      sphere.setTexture(img);
      sphere.setStrokeWeight(0);
    }
    void draw() {
      shape(sphere);
    }
  }
  Sphere earth;
  Sphere moon;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    earth = new Sphere("data/72/earth.jpg", 200);
    moon = new Sphere("data/72/moon.jpg", 40);
  }
  @Override void draw() {
    background(0);

    push();
    translate(width/2, height/2);

    rotateY(frameCount * 0.005);
    push();
    earth.draw();
    pop();
    rotateY(frameCount * 0.001);
    push();
    translate(480, 0, 0);
    rotateY(frameCount * 0.001);
    moon.draw();
    pop();
    pop();

    translate(0, 0, +200);
    logo(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
