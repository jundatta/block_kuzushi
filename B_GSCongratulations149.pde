// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Binary Bulbs
// https://openprocessing.org/sketch/555289
//

class GameSceneCongratulations149 extends GameSceneCongratulationsBase {
  Bulb[] bulbs = new Bulb[8];
  int brightness=0;

  int OrgY;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    OrgY = (800-416) / 2;
    for (int i = 0; i < 8; i++) {
      bulbs[i] = new Bulb(width/2 - 140 + i * 40, OrgY+190, 30, false, i);
    }
  }
  @Override void draw() {
    push();
    background(brightness);
    brightness=0;
    for (Bulb b : bulbs) {
      //    brightness+=b.value*b.state;
      if (b.state) {
        brightness+=b.value;
      }
      b.show();
    }
    fill(255-brightness/2);
    textSize(24);
    text("Decimal Value: "+ brightness, width/2, OrgY+120);
    //  String bin = ("000000000" + brightness.toString(2)).substr(-8);
    String bin = binary(brightness, 8);
    //String hex = brightness.toString(16);
    //if (brightness<16) {
    //  hex = "0"+hex;
    //}
    String hex = hex(brightness, 2);
    text("Binary Value: " + bin, width/2, OrgY+250);
    text("Hex Value: " + hex, width/2, OrgY+300);
    pop();

    logoRightLower(color(255, 0, 0));
  }

  class Bulb {
    int x;
    int y;
    int size;
    boolean state;
    int value;
    Bulb(int x, int y, int size, boolean state, int value) {
      this.x = x;
      this.y = y;
      this.size = size;
      this.state = state;
      this.value = (int)pow(2, 7-value);
    }
    void show() {
      noStroke();
      rectMode(CENTER);
      textAlign(CENTER, CENTER);
      textSize(14);
      if (this.state == true) {
        fill(200);
      } else {
        fill(50);
      }
      circle(this.x, this.y, this.size);
      rect(this.x, this.y+this.size/2, this.size/2, this.size/2);
      fill(100);

      circle(this.x, this.y+this.size, this.size/2.5);
      text(this.value, this.x, this.y);
    }
    void toggle() {
      if (dist(this.x, this.y, mouseX, mouseY) < this.size / 2) {
        this.state = !this.state;
      }
    }
  }

  @Override void mousePressed() {
    for (Bulb b : bulbs) {
      b.toggle();
    }
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
