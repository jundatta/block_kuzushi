// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】かじるプログラミングさん
// 【作品名】MemoryGame
// https://openprocessing.org/sketch/1239051
//

class GameSceneCongratulations93 extends GameSceneCongratulationsBase {
  final String DIR = "data/93/";

  final int COLS  = 13;
  final int ROWS  = 4;
  int PAD_W = 35;
  int PAD_H = 47;

  final int SCALE = 4;
  final int WAIT = 500;  // [ms]
  int TopX = 0;
  final int TopY = 50;

  PImage makeCardImage(PImage ssCard, int x, int y) {
    PImage pi = createImage(PAD_W * SCALE, PAD_H * SCALE, ARGB);
    int imgW = pi.width;
    int imgH = pi.height;
    pi.copy(ssCard, x, y, PAD_W, PAD_H, 0, 0, imgW, imgH);
    return pi;
  }

  class Card {
    boolean bAtari;
    int num;
    PImage img;
    PImage back;
    boolean bFront;

    Card(int num, PImage ssCard, PImage back, int x, int y) {
      this.bAtari = false;
      this.num = num;
      this.back = back;
      this.bFront = false;
      img = makeCardImage(ssCard, x, y);
    }
    void draw(int x, int y) {
      // 当たってたら表示しない
      if (bAtari) {
        return;
      }

      int w = img.width;
      int h = img.height;
      PImage p = back;
      if (bFront) {
        p = img;
      }
      image(p, TopX + x * w, TopY + y * h);
    }
    int hit(int x, int y) {
      if (bAtari) {
        return -1;
      }
      if (bFront) {
        return -1;
      }

      int w = img.width;
      int h = img.height;
      int sx = TopX + x * w;
      int sy = TopY + y * h;
      int ex = sx + w;
      int ey = sy + h;
      if (mouseX < sx || ex < mouseX) {
        return -1;
      }
      if (mouseY < sy || ey < mouseY) {
        return -1;
      }
      bFront = true;
      return num;
    }
    void backFace() {
      bFront = false;
    }
    void atari() {
      if (bFront) {
        bAtari = true;
      }
      bFront = false;
    }
  }
  Card[][] cards;

  class State {
    void update() {
    }
    void mousePressed() {
    }
    void keyPressed() {
    }
    void keyReleased() {
    }
    void mouseDragged() {
    }

    int lastMouseX;

    int hitCards() {
      for (int y = 0; y < cards.length; y++) {
        for (int x = 0; x < cards[0].length; x++) {
          int num = cards[y][x].hit(x, y);
          if (0 < num) {
            return num;
          }
        }
      }
      return -1;
    }
  }
  State state;
  State backup;

  class stateScroll extends State {
    @Override void mousePressed() {
      lastMouseX = mouseX;
    }
    @Override void mouseDragged() {
      TopX += (mouseX - lastMouseX);
      lastMouseX = mouseX;
    }
    @Override void keyReleased() {
      if (keyCode == SHIFT) {
        cursor(ARROW);
        state = backup;
      }
    }
  }

  int firstNum = -1;
  class stateFirstClick extends State {
    @Override void mousePressed() {
      firstNum = hitCards();
      if (firstNum < 0) {
        return;
      }
      // カードが開いたので2枚目のチェックに遷移する
      state = new stateSecondClick();
    }
    @Override void keyPressed() {
      if (keyCode == SHIFT) {
        cursor(MOVE);
        backup = state;
        state = new stateScroll();
      }
    }
  }
  int startMs;
  class stateSecondClick extends State {
    @Override void mousePressed() {
      int secondNum = hitCards();
      // 新たにカードが開かれなかった場合は何もしない
      if (secondNum < 0) {
        return;
      }

      startMs = millis();
      // 開かれたカードが前に開いたカードと一致するか？
      if (firstNum != secondNum) {
        // 一致しなかったのでNGに遷移する
        mMA.playAndRewind("seNG");
        state = new stateNg();
        return;
      }
      // 一致したのでOKに遷移する
      mMA.playAndRewind("seOK");
      state = new stateOk();
    }
    @Override void keyPressed() {
      if (keyCode == SHIFT) {
        cursor(MOVE);
        backup = state;
        state = new stateScroll();
      }
    }
  }
  class stateNg extends State {
    @Override void update() {
      // 1[秒]時間つぶし
      int now = millis();
      if (now < startMs + WAIT) {
        return;
      }

      // 裏返す
      for (int y = 0; y < cards.length; y++) {
        for (int x = 0; x < cards[0].length; x++) {
          cards[y][x].backFace();
        }
      }
      // 最初に戻る
      state = new stateFirstClick();
    }
  }
  class stateOk extends State {
    @Override void update() {
      // 1[秒]時間つぶし
      int now = millis();
      if (now < startMs + WAIT) {
        return;
      }

      // 一致したカードを消す
      for (int y = 0; y < cards.length; y++) {
        for (int x = 0; x < cards[0].length; x++) {
          cards[y][x].atari();
        }
      }
      // 最初に戻る
      state = new stateFirstClick();
    }
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    PImage ssCard = loadImage(DIR + "s_card.png");
    PAD_W = ssCard.width / (COLS + 1);
    PAD_H = ssCard.height / ROWS;
    mMA.entry("seOK", DIR + "se_ok.mp3");
    mMA.entry("seNG", DIR + "se_ng.mp3");

    PImage back = makeCardImage(ssCard, 0, 0);
    cards = new Card[ROWS][COLS];
    for (int y = 0; y < cards.length; y++) {
      for (int x = 0; x < cards[0].length; x++) {
        cards[y][x] = new Card(x+1, ssCard, back, (x+1) * PAD_W, y * PAD_H);
      }
    }
    for (int y = 0; y < cards.length; y++) {
      for (int x = 0; x < cards[0].length; x++) {
        int dstY = int(random(cards.length));
        int dstX = int(random(cards[0].length));
        Card tmp = cards[y][x];
        cards[y][x] = cards[dstY][dstX];
        cards[dstY][dstX] = tmp;
      }
    }

    state = new stateFirstClick();
  }
  @Override void draw() {
    background(33);

    state.update();

    for (int y = 0; y < cards.length; y++) {
      for (int x = 0; x < cards[0].length; x++) {
        cards[y][x].draw(x, y);
      }
    }

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    state.mousePressed();
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (keyCode != SHIFT) {
      gGameStack.change(new GameSceneTitle());
      return;
    }
    state.keyPressed();
  }
  @Override void keyReleased() {
    super.keyReleased();

    state.keyReleased();
  }
  @Override void mouseDragged() {
    state.mouseDragged();
  }
}
