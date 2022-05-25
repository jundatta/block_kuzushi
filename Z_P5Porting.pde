// PC-8001(TN8001)様に頂きました！！
//。。。random([-2,2,-5,5,-10,10] ⇒ P5Random(-2,2,-5,5,-10,10)
<T> T P5JSrandom(T... args) {
  return args[int(random(args.length))];
}
color P5JSrandom(color[] args) {
  return args[int(random(args.length))];
}
float P5JSrandom(float[] args) {
  return args[int(random(args.length))];
}

static class P5JS {
  static PApplet mPApplet;
  static void setup(PApplet pa) {
    mPApplet = pa;
  }

  static void swap(color[] arr, int i, int j) {
    color tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  // 元ネタは変更しません！！（副作用はありません）
  static color[] shuffle(color[] args) {
    color[] arr = args.clone();
    for (int i = arr.length; 1 < i; i--) {
      P5JS.swap(arr, i-1, (int)mPApplet.random(i));
    }
    return arr;
  }

  static float map(float value, float start1, float stop1, float start2, float stop2, boolean withinBounds) {
    if (withinBounds) {
      float nMin = min(start1, stop1);
      float nMax = max(start1, stop1);
      value = min(value, nMax);
      value = max(value, nMin);
    }
    return PApplet.map(value, start1, stop1, start2, stop2);
  }

  // ※angleMode(DEGREES)はsin(),cos()にも効いている

  static class P5Vector {
    static PVector mult(final PVector v1, final PVector v2) {
      return new PVector(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
    }
  }

  static float randomGaussian(float mean, float sd) {
    return (mPApplet.randomGaussian() * sd) + mean;
  }

  static PVector reflect(PVector surfaceNormal, PVector v) {
    PVector r = v.copy();
    surfaceNormal.normalize();
    return r.sub(surfaceNormal.mult(2 * r.dot(surfaceNormal)));
  }

  static void image(PGraphics out, int dx, int dy, int dWidth, int dHeight,
    PImage img, int sx, int sy, int sWidth, int sHeight) {
    PGraphics tmp = mPApplet.createGraphics(sWidth, sHeight);
    tmp.beginDraw();
    tmp.clear();
    tmp.loadPixels();
    color[] dst = tmp.pixels;
    color[] src = img.pixels;
    for (int y = 0; y < sHeight; y++) {
      for (int x = 0; x < sWidth; x++) {
        dst[y*tmp.width+x] = src[(sy+y)*img.width+(sx+x)];
      }
    }
    tmp.updatePixels();
    tmp.endDraw();
    out.image(tmp, dx, dy, dWidth, dHeight);
  }
}
