class Box {
  int mSx;
  int mSy;
  int mW;
  int mH;
  color mC;

  void draw() {
    fill(mC);
    rect(mSx, mSy, mW, mH, 5);
  }
  boolean reflection(Ball b) {
    // 下側に当たったか？
    if (hitLowerSide(b)) {
      // 進むy方向をプラスに変える
      b.mSignY = +1;
      return true;
    }
    // 上側に当たったか？
    if (hitUpperSide(b)) {
      // 進むy方向をマイナスに変える
      b.mSignY = -1;
      return true;
    }
    // 左側に当たったか？
    if (hitLeftSide(b)) {
      // 進むx方向をマイナスに変える
      b.mSignX = -1;
      return true;
    }
    // 右側に当たったか？
    if (hitRightSide(b)) {
      // 進むx方向をプラスに変える
      b.mSignX = +1;
      return true;
    }
    return false;
  }
  boolean hitSide(PVector a, PVector b, PVector c, PVector d) {
    // [PC-8001(TN8001)様に頂きました！！（外積）]
    PVector ab = PVector.sub(b, a);
    PVector ac = PVector.sub(c, a);
    PVector ad = PVector.sub(d, a);
    float d1 = ab.cross(ac).z;
    float d2 = ab.cross(ad).z;
    if (d1 * d2 > 0.0f) return false;

    PVector cd = PVector.sub(d, c);
    PVector ca = PVector.sub(a, c);
    PVector cb = PVector.sub(b, c);
    float d3 = cd.cross(ca).z;
    float d4 = cd.cross(cb).z;
    if (d3 * d4 > 0.0f) return false;

    return true;
  }
  // 下側に当たったか？
  boolean hitLowerSide(Ball b) {
    PVector p1 = new PVector(b.mLastX, b.mLastY);
    PVector p2 = new PVector(b.mX, b.mY);
    PVector p3 = new PVector(mSx, mSy + (mH - 1));
    PVector p4 = new PVector(mSx + (mW - 1), mSy + (mH - 1));
    //    return hitSide(p1, p2, p3, p4);
    if (hitSide(p1, p2, p3, p4)) {
      return true;
    }
    return false;
  }
  // 上側に当たったか？
  boolean hitUpperSide(Ball b) {
    PVector p1 = new PVector(b.mLastX, b.mLastY);
    PVector p2 = new PVector(b.mX, b.mY);
    PVector p3 = new PVector(mSx, mSy);
    PVector p4 = new PVector(mSx + (mW - 1), mSy);
    //    return hitSide(p1, p2, p3, p4);
    if (hitSide(p1, p2, p3, p4)) {
      return true;
    }
    return false;
  }
  // 左側に当たったか？
  boolean hitLeftSide(Ball b) {
    PVector p1 = new PVector(b.mLastX, b.mLastY);
    PVector p2 = new PVector(b.mX, b.mY);
    PVector p3 = new PVector(mSx, mSy);
    PVector p4 = new PVector(mSx, mSy + (mH - 1));
    //    return hitSide(p1, p2, p3, p4);
    if (hitSide(p1, p2, p3, p4)) {
      return true;
    }
    return false;
  }
  // 右側に当たったか？
  boolean hitRightSide(Ball b) {
    PVector p1 = new PVector(b.mLastX, b.mLastY);
    PVector p2 = new PVector(b.mX, b.mY);
    PVector p3 = new PVector(mSx + (mW - 1), mSy);
    PVector p4 = new PVector(mSx + (mW - 1), mSy + (mH - 1));
    //    return hitSide(p1, p2, p3, p4);
    if (hitSide(p1, p2, p3, p4)) {
      return true;
    }
    return false;
  }
}
