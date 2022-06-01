// ゲーム画面とデモ画面の親
//
// こちらがオリジナルです。
// 【作者】GreenOwlさん
// 【作品URL】GreenOwl 初心者のためのゲームプログラミング入門
//           プログラミングとゲームの杜
//           14．ブロック崩しを作ろう
// https://greenowl5.com/gprogram/processing/processing140.html
//
class GameSceneScene extends GameScene {
  final int demoSec = 6;  // ブロック崩しのデモ秒数
  int mScore = 0;
  int mDispScore = 0;
  int mctDeath = 0;
  Ball mBall;
  ArrayList<Block> mBlock;
  final int mkColumn = 5;  // [列]
  final int mkRow = 5;  // [行]
  Bar mBar;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);

    int startX = (int)random(width);
    mBall = new Ball(startX, height / 2);
    // ブロックを作る
    mBlock = new ArrayList<Block>();
    for (int i = 0; i < mkColumn * mkRow; i++) {
      int blockX = i % mkColumn;
      int blockY = i / mkRow;
      Block block = new Block(blockX, blockY,
        (int)(width / (float)mkColumn), 30, (360 / mkRow) * blockY, 0, 50,
        mkRow - blockY);
      mBlock.add(block);
    }
    // パドルを作る
    mBar = new Bar();
  }
  void draw(int BarX) {
    // PC-8001（TN8001）さんに教えていただきました！！
    // LIGHTEST：最も明るい色だけが成功します。
    // C = max(A*factor, B)
    push();
    blendMode(LIGHTEST);
    image(gEarth, 0, 0, gEarth.width, gEarth.height);
    pop();

    // 背景消去
    clearBackground(20);

    // ボールを動かす
    mBall.move();
    // パドルを動かす
    mBar.move(BarX);

    // 当たり判定をする
    reflection();

    // 描画する
    mBall.draw();
    for (Block b : mBlock) {
      b.draw();
    }
    mBar.draw();

    fill(0, 0, 100);
    textSize(40);
    if (mDispScore < mScore) {
      mDispScore += 10;
    }
    text("Score:" + mDispScore, 10, 40);

    if (gbAutoDemo) {
      push();
      colorMode(RGB, 255);
      fill(128, 0, 0);
      textAlign(RIGHT, TOP);
      text(str((mFrame - frameCount) / 60), 0, 0, width, height);
      pop();
    }
  }
  @Override void draw() {
    draw(mouseX);
  }
  // 当たり判定をする
  void reflection() {
    // 左の壁に当たったか？
    if (mBall.mX <= 0) {
      // 進むx方向をプラスに変える
      mBall.mSignX = +1;
      return;
    }
    // 上の壁に当たったか？
    if (mBall.mY <= 0) {
      // 進むy方向をプラスに変える
      mBall.mSignY = +1;
      gMinimAssistance.playAndRewind("壁！！");
      return;
    }
    // 右の壁に当たったか？
    if ((width-1) <= mBall.mX) {
      // 進むx方向をマイナスに変える
      mBall.mSignX = -1;
      return;
    }
    // 下の壁に当たったか？
    if ((height-1) <= mBall.mY) {
      // 進むy方向をマイナスに変える
      mBall.mSignY = -1;
      gMinimAssistance.playAndRewind("堕ちました。");
      // ゲームオーバー画面へとべよー
      gGameStack.change(new GameSceneGameOver());
      return;
    }

    // ブロックに当たったか？
    for (Block b : mBlock) {
      if (b.reflection(mBall)) {
        b.mbDeath = true;  // モブ男さん、それは死亡フラグです！！
        b.mctBonusDraw = demoSec;  // 獲得スコア描画用カウンタをdemoSec[秒]に初期化する
        gMinimAssistance.playAndRewind("立ちました！！");
        mScore += b.mDrawBonus;
        mctDeath++;
        if (mctDeath < mBlock.size()) {
          return;
        }
        // コングラチュレーション画面へとべよー
        gCongratulations.jump();
        return;
      }
    }

    // パドルに当たったか？
    if (mBar.reflection(mBall)) {
      gMinimAssistance.playAndRewind("ポン！！");
      return;
    }
  }
  @Override void keyPressed() {
    super.keyPressed();
  }

  int mFrame;
  @Override void autoSetup() {
    // demoSec秒間放置を監視する
    mFrame = frameCount + demoSec * 60;
  }
  // true:遷移した
  @Override boolean autoDraw() {
    // デモ状態でなければ何もしない
    if (gbAutoDemo == false) {
      return false;
    }
    // デモ状態なので。。。
    // 放置されたらコングラチュレーション画面にとべよ～
    if (mFrame < frameCount) {
      gCongratulations.jump();
      return true;
    }
    return false;
  }
}
