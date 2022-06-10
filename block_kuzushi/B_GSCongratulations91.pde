// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】かじるプログラミングさん
// 【作品名】チャリ走_v0.0.1
// https://openprocessing.org/sketch/925405
//

class GameSceneCongratulations91 extends GameSceneCongratulationsBase {
  final int BOX_W = 32;
  final int BOX_SPD = 6;
  float boxX = 0;
  Player player = null;
  int[] nums = {
    300, 290, 280, 270, 260, 250, 240, 230, 220, 210,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    300, 290, 280, 270, 100, 250, 240, 230, 220, 210,
    200, 210, 220, 100, 100, 250, 260, 270, 280, 290};
  Box[] boxes = new Box[nums.length];
  final String msg = "Click to jump!!";

  int startMs;
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noStroke();
    textAlign(CENTER);
    textSize(64);

    // Player
    player = new Player(135, height-300, 16, 16);

    // Boxes
    for (int i=0; i<nums.length; i++) {
      int x = i * BOX_W;
      int y = height - nums[i];
      Box box = new Box(x, y, BOX_W, nums[i]);
      boxes[i] = box;
    }

    startMs = millis();
  }

  boolean bStop = false;
  @Override void draw() {
    int now = millis();
    if (now < startMs + 100 /* [ms] */) {
      return;
    }
    startMs = now;

    if (bStop) {
      return;
    }

    int indexL = floor((player.x()+player.w()/2-boxX)/BOX_W);
    int indexR = floor((player.x()+player.w()-boxX)/BOX_W);
    if (boxes.length <= indexR) return;// Stop

    background(180);
    fill(255);
    text(msg, width*0.5, 64);

    // Player
    player.draw();
    player.checkL(boxes[indexL]);// Check
    if (player.checkR(boxes[indexR])) bStop = true;// Stop

    for (int i=0; i<boxes.length; i++) {
      fill(33);
      if (i==indexL) fill(99, 99, 33);
      if (i==indexR) fill(99, 33, 99);
      boxes[i].draw();
    }
    boxX -= BOX_SPD;// Move all boxes...

    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    if (bStop) {
      gGameStack.change(new GameSceneTitle());
      return;
    }

    if (player != null) player.jump();
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (bStop) {
      gGameStack.change(new GameSceneTitle());
      return;
    }

    if (player != null) player.jump();
  }

  class Player {
    int _x;
    int _y;
    int _w;
    int _h;
    int _vY;
    int _gY;
    int _aY;
    int _jumpCnt;

    Player(int x, int y, int w, int h) {
      this._x = x;
      this._y = y;
      this._w = w;
      this._h = h;
      this._vY = 0;     // Velocity
      this._gY = 4;     // Gravity
      this._aY = -24;   // Accel
      this._jumpCnt = -1;// Counter
    }

    int x() {
      return this._x;
    }
    void x(int n) {
      this._x = n;
    }
    int y() {
      return this._y;
    }
    void y(int n) {
      this._y = n;
    }
    int w() {
      return this._w;
    }
    int h() {
      return this._h;
    }

    void jump() {
      if (2 < this._jumpCnt) return;
      if (this._jumpCnt < 0) this._jumpCnt = 0;
      this._vY = this._aY;
      this._jumpCnt++;
    }

    void checkL(Box box) {
      if (box.y() < this._y+this._h) {
        this._y = box.y() - this._h;
        this._vY = 0;
        this._jumpCnt = 0;
      }
      if (player._jumpCnt <= 0) {
        if (this._y+this._h+2 < box.y()) {
          this._jumpCnt = -1;
        }
      }
    }

    boolean checkR(Box box) {
      if (box.y() < this._y) return true;
      return false;
    }

    void draw() {
      fill(255);
      rect(this._x, this._y, this._w, this._h);
      if (this._jumpCnt != 0) {
        this._vY += this._gY;
        this._y += this._vY;
      }
    }
  }

  class Box {
    int _x;
    int _y;
    int _w;
    int _h;

    Box(int x, int y, int w, int h) {
      this._x = x;
      this._y = y;
      this._w = w;
      this._h = h;
    }

    int x() {
      return this._x;
    }
    void x(int n) {
      this._x = n;
    }
    int y() {
      return this._y;
    }
    void y(int n) {
      this._y = n;
    }
    int w() {
      return this._w;
    }
    int h() {
      return this._h;
    }

    void draw() {
      if (boxX+this._x+this._w < 0) return;
      if (width < boxX+this._x) return;
      rect(this._x+boxX, this._y, this._w, this._h);
    }
  }
}
