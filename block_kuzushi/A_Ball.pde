class Ball {
  int mX;
  int mY;
  int mSignX = +1;
  int mSignY = +1;
  int mDx = 5;
  int mDy = 6;
  int mLastX;
  int mLastY;

  Ball(int x, int y) {
    mX = x;
    mY = y;
    mLastX = mX;
    mLastY = mY;
  }
  void draw() {
    fill(0, 0, 100);
    ellipse(mX, mY, 10, 10);
  }
  void move() {
    mLastX = mX;
    mX += mSignX * mDx;
    mLastY = mY;
    mY += mSignY * mDy;
  }
}
