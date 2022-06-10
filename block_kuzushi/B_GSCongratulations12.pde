// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】reona396さん
// 【作品名】Vapor_Shapes
// https://openprocessing.org/sketch/304012
//

class GameSceneCongratulations12 extends GameSceneCongratulationsBase {
  MyShape[] myshapes = new MyShape[10];

  int line_val = 8;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100);

    background(360);
    for (int i = 0; i < myshapes.length; i++) {
      myshapes[i] = new MyShape();
    }
  }
  @Override void draw() {
    background(360);

    strokeWeight(1.5);
    stroke(0);
    for (int i = 1; i < line_val; i++) {
      line(0, i * height / line_val, width, i*height/line_val);
      line(i * width / line_val, 0, i*width/line_val, height);
    }

    for (int i = 0; i < myshapes.length; i++) {
      myshapes[i].display();
      myshapes[i].move();
    }

    push();
    translate(0, 0, +1);
    logoRightLower(color(0, 100, 100));
    pop();
  }

  class MyShape {
    float x;
    float y;
    float spd;
    float theta;
    float theta_spd;
    int vertex_val;
    float[] R;
    float R_max;

    float hue;

    MyShape() {
      spd = random(1, 2) / 2;
      theta_spd = spd;

      hue = random(360);

      vertex_val = (int)random(3, 6);
      R = new float[vertex_val];

      for (int i = 0; i < vertex_val; i++) {
        R[i] = random(20, 60);
      }
      R_max = max(R);

      x = random(-R_max * 2, R_max * 2+width);
      y = random(height);
    }

    void display() {
      noStroke();

      fill(0);
      drawShape(x+5, y+5);

      fill(hue, 80, 100);
      drawShape(x, y);
    }

    void move() {
      x -= spd;
      theta -= theta_spd;

      if (x < - R_max * 2) {
        hue = random(360);
        x = width + R_max * 2;
      }
    }

    void drawShape(float ox, float oy) {
      pushMatrix();
      translate(ox, oy, +1);
      rotate(radians(theta));

      beginShape();
      for (int i = 0; i < vertex_val; i++) {
        vertex(R[i] * cos(i * TWO_PI / vertex_val), R[i] * sin(i * TWO_PI / vertex_val));
      }
      endShape(CLOSE);
      popMatrix();
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
