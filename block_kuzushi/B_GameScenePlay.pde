// ゲーム画面
class GameScenePlay extends GameSceneScene {
  @Override void draw() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);
    
    draw(mouseX);
  }
  @Override void keyPressed() {
    // ESCキーが入力されたら中断する
    if (key == ESC) {
      key = 0;  // プログラムが終了しないように書き換えた
      gGameStack.push(new GameScenePause());
    }
  }
}
