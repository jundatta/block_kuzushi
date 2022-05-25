// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Joseph Aronsonさん
// 【作品名】Cubic
// https://openprocessing.org/sketch/1047696
//

class GameSceneCongratulations43 extends GameSceneCongratulationsBase {
  ArrayList<Cube> c = new ArrayList();
  float SIZE;
  float fc = 0;
  final float count = 10;

  @Override void setup() {
    // （デバッグ用に残します。色味がおかしいときに活かしてみると幸せになれるかも？）
    //PGraphics g = getGraphics();
    //PStyle s = g.getStyle();
    //println("R: " + s.ambientR);
    //println("setAmbient: " + g.setAmbient);

    //  angleMode(DEGREES);
    noStroke();
    SIZE = width / 40.0f;
    loadCubes();
    //colorMode(HSB, 360);
    colorMode(HSB, 360, 360, 360);
  }
  @Override void draw() {
    push();
    rectMode(CENTER);
    translate(width/2, height/2, 50);
    background(0);
    ambientLight(360, 0, 360);
    pointLight(360, 0, 180, 0, 0, 0);
    rotateX(radians(60));
    rotateZ(radians(fc));
    rotateY(radians(fc));

    for (int i = 0; i < c.size(); i++) {
      c.get(i).move();
      c.get(i).display();
    }
    fc += 0.3f;
    pop();

    logo(color(0, 360, 360));
  }

  class Cube {
    float x;
    float y;
    float z;
    float off;

    Cube(float x, float y, float z) {
      this.x = -SIZE * (count / 2) + x * (SIZE);
      this.y = -SIZE * (count / 2) + y * (SIZE);
      this.z = -SIZE * (count / 2) + z * (SIZE);
      this.off = 1;
    }
    void display() {
      float d = dist(this.x, this.y, this.z, 0, 0, 0);
      float m = map(d, 0, 200, 0, 1);
      push();

      translate(this.x * this.off, this.y * this.off, this.z * this.off);
      //    specularMaterial((d * 2 + fc) % 360, 360, 360);
      specular((d * 2 + fc) % 360, 360, 360);
      fill((d * 2 + fc) % 360, 360, 360);
      box(SIZE - ((this.off - 1) * m) * width / 8.0f);

      pop();
    }
    void move() {
      this.off += sin(radians(fc)) / (width / 5.0f);
    }
  }

  void loadCubes() {

    for (float i = 0; i <= count; i++) {
      for (float j = 0; j <= count; j++) {
        for (float k = 0; k <= count; k++) {
          c.add(new Cube(i, j, k));
        }
      }
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
