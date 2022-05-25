// ゲーム画面
class GameSceneDemo extends GameSceneScene {
  @Override void draw() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);
    
    draw(mBall.mX - mBar.mW / 2);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    // キー入力されたらタイトルに戻る
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
