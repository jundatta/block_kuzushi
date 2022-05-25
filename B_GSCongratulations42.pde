// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】yooyooyさん
// 【作品名】A Star is Born
// https://openprocessing.org/sketch/1208436
//

class GameSceneCongratulations42 extends GameSceneCongratulationsBase {
  float a = 0.2;
  float b = 0.3;
  float x, y, X, Y;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100);
    //    rectMode(CENTER);
    background(50, 2, 0);
    noFill();
    //  strokeWeight(2);
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    for (float theta=0*PI; theta<20*PI; theta+=PI/48.0f) {
      x = a*exp(b*theta)*cos(theta);
      y = a*exp(b*theta)*sin(theta);
      float d = dist(0, 0, x, y);
      stroke(millis()/36%360, 78, 100);
      translate(x, y);
      rotate(frameCount*PI/1800.0f);
      //    point(0, 0);
      circle(0, 0, 1);
    }
    pop();

    translate(0, 0, +1);
    logoRightLower(color(((millis()/36%360)+180)%360, 100, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
