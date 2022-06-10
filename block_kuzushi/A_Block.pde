class Block extends Box {
  boolean mbDeath = false;  // 死亡フラグ
  int mctBonusDraw;  // 獲得スコア描画用カウンタ
  final int mkBaseBonus = 100;  // ブロックの基準スコア
  int mDrawBonus;  // 描画するボーナス

  Block(int blockX, int blockY, int w, int h, int hue, 
    int offsetX, int offsetY, int weight) {
    mSx = offsetX + blockX * w;
    mSy = offsetY + blockY * h;
    mW = w;
    mH = h;
    mC = color(hue, 100, 100);

    // 描画するボーナスを設定する
    mDrawBonus = mkBaseBonus * weight;
  }
  @Override void draw() {
    // フラグちゃんを回避できなかった
    if (mbDeath) {
      // 獲得スコア描画用カウンタが0になるまでボーナスを描画する
      if (0 < mctBonusDraw) {
        fill(0, 0, 0);
        textSize(50);
        text(str(mDrawBonus), mSx + 5, (mSy - (60 - mctBonusDraw)) + 5);
        fill(mC);
        text(str(mDrawBonus), mSx, mSy - (60 - mctBonusDraw));
        mctBonusDraw--;
      }
      return;
    }

    super.draw();
  }
  @Override boolean reflection(Ball b) {
    // 返事がない。ただのしかばねのようだ。。。
    if (mbDeath) {
      return false;
    }

    return super.reflection(b);
  }
}
