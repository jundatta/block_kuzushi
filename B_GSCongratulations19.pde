// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】FALさん
// 【記事の名前】p5.js でゲーム制作
// https://fal-works.github.io/make-games-with-p5js/
//
/**
 * @preserve Credits
 *
 * "p5.js でゲーム制作" ( https://fal-works.github.io/make-games-with-p5js/ )
 * Copyright (c) 2020 FAL
 * Used under the MIT License
 * ( https://fal-works.github.io/make-games-with-p5js/docs/license/ )
 */

class GameSceneCongratulations19 extends GameSceneCongratulationsBase {
  int mFrame;

  // ---- エンティティ関連の関数 --------------------------------------------------

  // 全エンティティ共通

  void updatePosition(Entity entity) {
    entity.x += entity.vx;
    entity.y += entity.vy;
  }

  // エンティティ
  class Entity {
    float x;
    float y;
    float vx;
    float vy;
    Entity(float _x, float _y, float _vx, float _vy) {
      x = _x;
      y = _y;
      vx = _vx;
      vy = _vy;
    }
  }

  // プレイヤーエンティティ用
  Entity createPlayer() {
    return new Entity(200, 300, 0, 0);
  }

  void applyGravity(Entity entity) {
    entity.vy += 0.15;
  }

  void applyJump(Entity entity) {
    entity.vy = -5;
  }

  void drawPlayer(Entity entity) {
    square(entity.x, entity.y, 40);
  }

  boolean playerIsAlive(Entity entity) {
    // プレイヤーの位置が生存圏内なら true を返す。
    return entity.y < height;
  }

  // ブロックエンティティ用
  Entity createBlock(float y) {
    return new Entity(40 + width, y, -2, 0);
  }

  void drawBlock(Entity entity) {
    rect(entity.x, entity.y, 80, 400);
  }

  boolean blockIsAlive(Entity entity) {
    // ブロックの位置が生存圏内なら true を返す。
    // -100 は適当な値（ブロックが見えなくなる位置であればよい）
    return -100 < entity.x;
  }

  // 複数のエンティティを処理する関数

  /**
   * 2つのエンティティが衝突しているかどうかをチェックする
   *
   * @param entityA 衝突しているかどうかを確認したいエンティティ
   * @param entityB 同上
   * @param collisionXDistance 衝突しないギリギリのx距離
   * @param collisionYDistance 衝突しないギリギリのy距離
   * @returns 衝突していたら `true` そうでなければ `false` を返す
   */
  boolean entitiesAreColliding(
    Entity entityA,
    Entity entityB,
    float collisionXDistance,
    float collisionYDistance
    ) {
    // xとy、いずれかの距離が十分開いていたら、衝突していないので false を返す

    float currentXDistance = abs(entityA.x - entityB.x); // 現在のx距離
    if (collisionXDistance <= currentXDistance) return false;

    float currentYDistance = abs(entityA.y - entityB.y); // 現在のy距離
    if (collisionYDistance <= currentYDistance) return false;

    return true; // ここまで来たら、x方向でもy方向でも重なっているので true
  }

  // ---- 画面効果 ---------------------------------------------------------------

  // スクリーンシェイク

  /** シェイクの現在の強さ */
  float shakeMagnitude;

  /** シェイクの減衰に使う係数 */
  float shakeDampingFactor;

  /** シェイクをリセット */
  void resetShake() {
    shakeMagnitude = 0;
    shakeDampingFactor = 0.95;
  }

  /** シェイクを任意の強さで発動 */
  void setShake(float magnitude) {
    shakeMagnitude = magnitude;
  }

  /** シェイクを更新 */
  void updateShake() {
    shakeMagnitude *= shakeDampingFactor; // シェイクの大きさを徐々に減衰
  }

  /** シェイクを適用。描画処理の前に実行する必要あり */
  void applyShake() {
    if (shakeMagnitude < 1) return;

    // currentMagnitude の範囲内で、ランダムに画面をずらす
    translate(
      random(-shakeMagnitude, shakeMagnitude),
      random(-shakeMagnitude, shakeMagnitude)
      );
  }

  // スクリーンフラッシュ

  /** フラッシュのα値 */
  float flashAlpha;

  /** フラッシュの持続時間（フレーム数） */
  float flashDuration;

  /** フラッシュの残り時間（フレーム数） */
  float flashRemainingCount;

  /** フラッシュをリセット */
  void resetFlash() {
    flashAlpha = 255;
    flashDuration = 1;
    flashRemainingCount = 0;
  }

  /** フラッシュを、任意のα値と持続時間で発動 */
  void setFlash(float alpha, float duration) {
    flashAlpha = alpha;
    flashDuration = duration;
    flashRemainingCount = duration;
  }

  /** フラッシュを更新 */
  void updateFlash() {
    flashRemainingCount -= 1;
  }

  /** フラッシュを適用。描画処理の後に呼ぶ必要あり */
  void applyFlash() {
    if (flashRemainingCount <= 0) return;

    float alphaRatio = flashRemainingCount / flashDuration;
    background(255, alphaRatio * flashAlpha);
  }

  // ---- ゲーム全体に関わる部分 --------------------------------------------

  /** プレイヤーエンティティ */
  Entity player;

  /** ブロックエンティティの配列 */
  ArrayList<Entity> blocks;

  /** ゲームの状態。"play" か "gameover" を入れるものとする */
  String gameState;

  /** ブロックを上下ペアで作成し、`blocks` に追加する */
  void addBlockPair() {
    float y = random(-100, 100);
    blocks.add(createBlock(y)); // 上のブロック
    blocks.add(createBlock(y + 600)); // 下のブロック
  }

  /** ゲームオーバー画面を表示する */
  void drawGameoverScreen() {
    background(0, 192); // 透明度 192 の黒
    fill(255);
    textSize(64);
    textAlign(CENTER, CENTER); // 横に中央揃え ＆ 縦にも中央揃え
    text("GAME OVER", width / 2, height / 2); // 画面中央にテキスト表示
  }

  /** ゲームのリセット */
  void resetGame() {
    // 状態をリセット
    resetCount();

    gameState = "play";

    // プレイヤーを作成
    player = createPlayer();

    // ブロックの配列準備
    blocks = new ArrayList();

    // 画面効果をリセット
    resetShake();
    resetFlash();
  }

  void setGameOver() {
    gameState = "gameover";
    setShake(300);
    setFlash(128, 60);

    // しばらく操作がなければタイトル画面に飛べるように
    // "gameover"になった時間を覚えておく
    mFrame = frameCount;
  }

  /** ゲームの更新 */
  void updateGame() {
    // 画面効果を更新
    updateShake();
    updateFlash();

    // ゲームオーバーなら更新しない
    if (gameState.equals("gameover")) return;

    // ブロックの追加と削除
    if (getCount() % 120 == 1) addBlockPair(); // 一定間隔でブロック追加
    //  blocks = blocks.filter(blockIsAlive); // 生きているブロックだけ残す
    ArrayList<Entity> newBlocks = new ArrayList();
    for (Entity block : blocks) {
      if (blockIsAlive(block)) {
        newBlocks.add(block);
      }
    }
    blocks = newBlocks;

    // 全エンティティの位置を更新
    updatePosition(player);
    for (Entity block : blocks) updatePosition(block);

    // プレイヤーに重力を適用
    applyGravity(player);

    // プレイヤーが死んでいたらゲームオーバー
    if (!playerIsAlive(player)) {
      setGameOver();
      return;
    }

    // 衝突判定
    for (Entity block : blocks) {
      if (entitiesAreColliding(player, block, 20 + 40, 20 + 200)) {
        setGameOver();
        break;
      }
    }
  }

  /** ゲームの描画 */
  void drawGame() {
    // スクリーンシェイクを適用
    applyShake();

    // 全エンティティを描画
    background(0);
    drawPlayer(player);
    for (Entity block : blocks) drawBlock(block);

    // ゲームオーバー状態なら、それ用の画面を表示
    // 何も操作されなければタイトル画面に戻る
    if (gameState.equals("gameover")) {
      drawGameoverScreen();

      // 3秒間放置されたらタイトル画面にとべよ～
      if (mFrame + 60 * 3 < frameCount) {
        // タイトル状態に遷移する
        gGameStack.change(new GameSceneTitle());
        return;
      }
    }

    // スクリーンフラッシュを適用
    applyFlash();
  }

  /** マウスボタンが押されたときのゲームへの影響 */
  void onMousePress() {
    switch (gameState) {
    case "play":
      // プレイ中の状態ならプレイヤーをジャンプさせる
      applyJump(player);
      break;
    case "gameover":
      // ゲームオーバー状態ならリセット
      resetGame();
      break;
    }
  }

  // ---- setup/draw 他 ----------------------------------------------------------

  @Override void setup() {
    colorMode(RGB, 255);

    rectMode(CENTER);

    resetGame();
  }
  @Override void draw() {
    updateGame();
    drawGame();
  }
  @Override void mousePressed() {
    onMousePress();
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
