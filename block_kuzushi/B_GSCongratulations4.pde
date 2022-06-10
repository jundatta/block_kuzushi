// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】Scribbledisks Green
// https://openprocessing.org/sketch/742750
//

class GameSceneCongratulations4 extends GameSceneCongratulationsBase {
  ArrayList<Dot> Dots=new ArrayList();
  float R=TWO_PI/360;

  class Dot {
    float rad, dept;
    int status, count, gray;

    Dot() {
      dept=0;
      status=0;
      rad=random(TWO_PI);
      count=(int)random(10, 20);
      gray=(int)random(64, 255);
    }
    boolean update() {
      if (count--<0) {
        count=(int)random(10, 20);
        status=status!=0?0:int(random(1)*2)*2-1;
      }
      if (status==0) {
        dept+=0.1;
        if (dept>30)return false;
      } else {
        rad+=status*R;
        write();
        rad+=status*R;
      }
      write();
      return true;
    }
    void write() {
      stroke(0, gray, 0);
      pushMatrix();
      rotate(rad);
      scale(pow(1.1, dept));
      //      point(25, 0);
      point(60, 0);
      popMatrix();
    }
  }

  @Override void setup() {
    colorMode(RGB, 255);
    background(0);
    strokeWeight(1);
  }
  @Override void draw() {
    fill(0, 5);
    noStroke();
    rect(0, 0, width-1, height-1);
    if (frameCount%3==0)Dots.add(new Dot());

    pushMatrix();
    translate(width/2, height/2);
    for (int i=0; i<Dots.size(); i++) {
      if (!(Dots.get(i)).update()) {
        Dots.remove(i);
      }
    }
    popMatrix();

    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
