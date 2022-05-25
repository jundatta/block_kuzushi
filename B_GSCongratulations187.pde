// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1292407
//

class GameSceneCongratulations187 extends GameSceneCongratulationsBase {
  PShader Shader;
  class Ball {
    float x, y;
    float vx, vy;
    float rad;

    Ball(float x, float y, float vx, float vy, float rad) {
      this.x = x;
      this.y = y;
      this.vx = vx;
      this.vy = vy;
      this.rad = rad;
    }
  }
  final int num = 25;
  final Ball[] balls = new Ball[num];
  final float radius=20;
  final float maxSpeed=15;
  final float G=radius/num*20.0f;

  float[] data = new float[num * 3];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    Shader = loadShader("data/187/flag.glsl", "data/187/vert.glsl");
    Shader.set("WIDTH", (float)width);
    Shader.set("HEIGHT", (float)height);

    pixelDensity(1);
    noStroke();
    for (int i=0; i<num; i++) {
      float a=random(2*PI);
      Ball b = new Ball(random(width), random(height), cos(a), sin(a), 20);
      balls[i] = b;
    }
  }
  @Override void draw() {
    if (!(keyPressed && key == ' ')) {
      // スペースキーが押されていなければこっち
      for (Ball b : balls) {
        for (Ball bb : balls) {
          if (b!=bb) {
            //          let dstSq=(b.x-bb.x)**2+(b.y-bb.y)**2;
            float bx = b.x-bb.x;
            float by = b.y-bb.y;
            float dstSq = (bx * bx) + (by * by);
            //          if (dstSq<((b.rad+bb.rad)/2)**2) {
            float r = (b.rad+bb.rad)/2.0f;
            float rr = r * r;
            if (dstSq < rr) {
              dstSq = rr;
            }
            float f=G*b.rad*bb.rad/dstSq;
            float a=atan2(bb.y-b.y, bb.x-b.x);
            b.vx=constrain(b.vx+cos(a)*f/b.rad, -maxSpeed, maxSpeed);
            b.vy=constrain(b.vy+sin(a)*f/b.rad, -maxSpeed, maxSpeed);
          }
        }
      }
    } else {
      // スペースキーが押されていればこっち
      key = 0;
      for (Ball b : balls) {
        float f=(num/radius);
        float a=atan2(mouseY-b.y, mouseX-b.x);
        b.vx=constrain(b.vx+cos(a)*f/b.rad, -maxSpeed, maxSpeed);
        b.vy=constrain(b.vy+sin(a)*f/b.rad, -maxSpeed, maxSpeed);
      }
    }
    //  for (Ball b : balls) {
    for (int i = 0; i < balls.length; i++) {
      Ball b = balls[i];
      b.x+=b.vx;
      b.y+=b.vy;
      if (b.x<       b.rad) {
        b.x=       b.rad;
        b.vx*=-1;
      }
      if (b.x>width -b.rad) {
        b.x=width -b.rad;
        b.vx*=-1;
      }
      if (b.y<       b.rad) {
        b.y=       b.rad;
        b.vy*=-1;
      }
      if (b.y>height-b.rad) {
        b.y=height-b.rad;
        b.vy*=-1;
      }
      //    data.push(b.x, b.y, b.rad);
      data[i*3 + 0] = b.x;
      data[i*3 + 1] = b.y;
      data[i*3 + 2] = b.rad;
    }
    shader(Shader);
    //  Shader.setUniform("balls", data);
    Shader.set("balls", data);
    rect(0, 0, width, height);
    resetShader();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    // スペースキーを拾うのでキーが押されても遷移しない
//    gGameStack.change(new GameSceneTitle());
  }
}
