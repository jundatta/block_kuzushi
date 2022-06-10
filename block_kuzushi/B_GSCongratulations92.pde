// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】かじるプログラミングさん
// 【作品名】WorkSlot
// https://openprocessing.org/sketch/861315
//

class GameSceneCongratulations92 extends GameSceneCongratulationsBase {
  class Sprite {
    int num;
    int x, y;
    PImage[] images;

    Sprite(int x, int y, PImage[] images) {
      num = 0;
      this.x = x;
      this.y = y;
      this.images = images;
    }
    void update() {
      int min = 0;
      int max = images.length - 1;
      num = min + (int)Math.floor(Math.random() * (max-min+1));
    }
    void draw() {
      image(images[num], x, y);
    }
  };
  Sprite[] sprites = new Sprite[3];

  boolean rollFlg = true;

  String msg = "Click TO STOP!!";

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    // Images
    PImage[] images = new PImage[11];
    for (int i=0; i<images.length; i++) {
      String fName = "data/92/" + "s" + i + ".png";
      images[i] = loadImage(fName);
    }
    int imageW = images[0].width;
    int imageH = images[0].height;

    // Sprites
    int startX = (width / 2) - int(imageW * 2.5f);
    int startY = (height / 2) - int(imageH * 1.5f);
    for (int i = 0; i < sprites.length; i++) {
      sprites[i] = new Sprite(startX + 60 * i, startY, images);
    }
  }
  @Override void draw() {
    background(0, 0, 0);

    // Roll
    if (rollFlg) {
      for (int i=0; i<sprites.length; i++) {
        sprites[i].update();
      }
    }
    for (int i=0; i<sprites.length; i++) {
      sprites[i].draw();
    }

    // Text
    fill(255, 255, 255);
    textSize(32);
    textAlign(CENTER);
    int startY = sprites[0].y;
    text(msg, width / 2, startY + 100);

    logoRightLower(color(255, 0, 0));
  }

  void judge() {
    if (sprites[0].num == sprites[1].num
      && sprites[0].num == sprites[2].num) {
      msg = "ATARI!! (^o^ )";
    } else {
      msg = "HAZURE!! (*_*;)";
    }
  }
  @Override void mousePressed() {
    // Toggle
    if (rollFlg) {
      rollFlg = false;
      judge();
      return;
    }
    rollFlg = true;
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
