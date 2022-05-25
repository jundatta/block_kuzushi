class Bar extends Box {
  Bar() {
    mSy = (height / 6) * 5;
    mW = 100;
    mH = 30;
    mC = color(0, 0, 100);
  }
  void move(int x) {
    mSx = x;
    // 左側にはみでないようにする
    if (mSx < 0) {
      mSx = 0;
      return;
    }
    // 右側にはみでないようにする
    if (width < mSx + mW) {
      mSx = width - mW;
      return;
    }
  }
}
