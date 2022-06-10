// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】kusakariさん
// 【作品名】0133
// https://openprocessing.org/sketch/956841
// 【移植】サンタさん
//
import com.sun.jna.*;
import java.awt.*;
import java.awt.geom.*;


public interface Blur extends Library {
  void Exec(int[] x, int w, int h, int cx, int cy, int cw, int ch, float[] kernel, int len);
}

class GameSceneCongratulations113 extends GameSceneCongratulationsBase {
  final int DrawW = 496;    // 16の倍数とすること（グラフィック側の都合）
  final int DrawH = DrawW;  // 幅と高さを同じにすること（アルゴリズム側の都合）
  PGraphics pg;

  float _nsRate;
  static final int _maxPoint = 50;
  Line[] _aryObject = new Line[10];

  static final float SCALE = 0.125;
  PGraphics blur;
  float[] buffer;
  float[] kernel;
  Blur blurNative;
  AffineTransform identity = new AffineTransform();
  float[] segment = new float[2];
  Survey survey = new Survey();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    colorMode(HSB, 360, 100, 100, 255);
    noStroke();

    pg = createGraphics(DrawW, DrawH);

    _nsRate = 0.001;
    for (int i = 0; i < _aryObject.length; i++) {
      _aryObject[i] = new Line();
    }
    blur = createGraphics(int(pg.width * SCALE), int(pg.height * SCALE));
    // calculate blur kernel
    final float R = round(pg.width * SCALE / 10);
    final float variance = R * R * -0.5 / log(0.04);
    kernel = new float[1 + (int)R];
    float total = 0.0;
    for (int i = 0; i < kernel.length; i++) {
      kernel[i] = exp(i * i * -0.5 / variance);
      total += (i == 0 ? 1 : 2) * kernel[i];
    }
    for (int i = 0; i < kernel.length; i++) {
      kernel[i] /= total;
    }
    //blurNative = (Blur)Native.loadLibrary(sketchPath("blur.dll"), Blur.class);
  }
  @Override void draw() {
    background(0);
    pg.beginDraw();
    pg.colorMode(HSB, 360, 100, 100, 255);
    pg.strokeCap(ROUND);
    pg.strokeJoin(MITER);
    pg.background(360.0);
    for (Line l : _aryObject) {
      l.update();
      l.draw();
    }
    pg.endDraw();
    image(pg, (width-pg.width)/2, (height-pg.height)/2);
    survey.print_();

    logoRightLower(color(0, 100, 100));
  }

  class Line {
    float nsX;
    float nsY;
    float weight;
    color _color;
    float[] aryPoints = new float[_maxPoint * 2];
    int top;
    Path2D path;
    Stroke stroke;
    Line() {
      nsX = random(100);
      nsY = random(100);
      weight = random(pg.width / 20, pg.width / 4);
      _color = color(random(360), 100, 100, 255);
      update();
      for (int i = 2; i < aryPoints.length; i++) {
        aryPoints[i] = aryPoints[i & 1];
      }
      path = new Path2D.Float();
      stroke = new BasicStroke(weight, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
    }

    void update() {
      nsX += _nsRate;
      nsY += _nsRate;
      aryPoints[top++] = pg.width / 3 * cos(5 * PI * (nsX));
      aryPoints[top++] = pg.height / 3 * sin(8 * PI * (nsY));
      if (top == aryPoints.length)top = 0;
    }

    void draw() {
      path.reset();
      final int num = aryPoints.length;
      for (int i = 0; i < _maxPoint; i++) {
        int j = (top + i * 2) % num;
        if (i == 0) {
          path.moveTo(aryPoints[j], aryPoints[j + 1]);
        } else {
          path.lineTo(aryPoints[j], aryPoints[j + 1]);
        }
      }
      var s = createShape();
      var strokedLine = new Area(stroke.createStrokedShape(path));
      var clip = strokedLine.getBounds();
      clip.grow(pg.width / 10, pg.width / 10);
      clip.translate(pg.width / 2, pg.height / 2 + pg.width / 10);
      clip = clip.intersection(new Rectangle(0, 0, pg.width, pg.height));
      var it = strokedLine.getPathIterator(identity, 1);
      float x = 0, y = 0;
      while (!it.isDone()) {
        switch(it.currentSegment(segment)) {
        case PathIterator.SEG_CLOSE:
          s.vertex(x, y);
          s.endShape();
          break;
        case PathIterator.SEG_MOVETO:
          s.beginShape();
          x = segment[0];
          y = segment[1];
          s.vertex(x, y);
          break;
        case PathIterator.SEG_LINETO:
          s.vertex(segment[0], segment[1]);
          break;
        }
        it.next();
      }

      blur.beginDraw();
      blur.background(0, 0);
      blur.noStroke();
      s.setFill(color(0));
      blur.scale(SCALE);
      blur.translate(pg.width / 2, pg.height / 2 + pg.width / 10);
      blur.shape(s);
      blur.endDraw();
      //Blur();
      BlurHack();
      //BlurNative(clip);
      pg.scale(1 / SCALE);
      pg.image(blur, 0, 0);
      pg.scale(SCALE);

      s.setFill(_color);
      pg.translate(pg.width / 2, pg.height / 2);
      pg.shape(s);
      pg.resetMatrix();
    }
  }

  void BlurNative(Rectangle clip) {
    blur.loadPixels();
    int cx = int(clip.x * SCALE);
    int cy = int(clip.y * SCALE);
    blurNative.Exec(blur.pixels, blur.width, blur.height, cx, cy, int(ceil((clip.x + clip.width) * SCALE)) - cx, int(ceil((clip.y + clip.height) * SCALE)) - cy, kernel, kernel.length);
    blur.updatePixels();
  }

  void BlurHack() {
    blur.loadPixels();
    final color[] p = blur.pixels;
    if (buffer == null || buffer.length < p.length) {
      buffer = new float[p.length];
    }
    final float[] d = buffer;
    final int w = blur.width;
    final int h = blur.height;
    final int n = kernel.length;
    final int t = p.length;
    int i = 0;
    int di = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++, i++) {
        float a = 0.0;
        for (int j = Math.max(1 - n, -x), end = Math.min(n - 1, w - 1 - x); j < end; j++) {
          a += (p[i + j] >>> 24) * kernel[j < 0 ? -j : j];
        }
        d[di] = a;
        di += w;
        if (di >= t) {
          di -= t - 1;
        }
      }
    }
    i = di = 0;
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++, i++) {
        float a = 0.0;
        for (int j = Math.max(1 - n, -y), end = Math.min(n - 1, h - 1 - y); j < end; j++) {
          a += d[i + j] * kernel[j < 0 ? -j : j];
        }
        p[di] = int(a) << 24;
        di += h;
        if (di >= t) {
          di -= t - 1;
        }
      }
    }
    blur.updatePixels();
  }

  void Blur() {
    blur.loadPixels();
    final color[] p = blur.pixels;
    if (buffer == null || buffer.length < p.length * 4) {
      buffer = new float[p.length * 4];
    }
    final float[] d = buffer;
    final int w = blur.width;
    final int h = blur.height;
    final int n = kernel.length;
    final int t = p.length;
    int min = 0;
    int max = w - 1;
    int di = 0;
    for (int i = 0; i < t; i++) {
      color c = p[i];
      float a = (c >>> 24 & 255) * kernel[0];
      float r = (c >>> 16 & 255) * kernel[0];
      float g = (c >>> 8 & 255) * kernel[0];
      float b = (c >>> 0 & 255) * kernel[0];
      for (int j = 1; j < n; j++) {
        final float coef = kernel[j];
        c = p[Math.min(i + j, max)];
        a += (c >>> 24 & 255) * coef;
        r += (c >>> 16 & 255) * coef;
        g += (c >>> 8 & 255) * coef;
        b += (c >>> 0 & 255) * coef;
        c = p[Math.max(i - j, min)];
        a += (c >>> 24 & 255) * coef;
        r += (c >>> 16 & 255) * coef;
        g += (c >>> 8 & 255) * coef;
        b += (c >>> 0 & 255) * coef;
      }
      d[di * 4] = a;
      d[di * 4 + 1] = r;
      d[di * 4 + 2] = g;
      d[di * 4 + 3] = b;
      di += w;
      if (i == max) {
        min += w;
        max += w;
        di -= t - 1;
      }
    }
    min = 0;
    max = h - 1;
    di = 0;
    for (int i = 0; i < t; i++) {
      int k = i * 4;
      float a = d[k] * kernel[0];
      float r = d[k + 1] * kernel[0];
      float g = d[k + 2] * kernel[0];
      float b = d[k + 3] * kernel[0];
      for (int j = 1; j < n; j++) {
        final float coef = kernel[j];
        k = Math.min(i + j, max) * 4;
        a += d[k] * coef;
        r += d[k + 1] * coef;
        g += d[k + 2] * coef;
        b += d[k + 3] * coef;
        k = Math.max(i - j, min) * 4;
        a += d[k] * coef;
        r += d[k + 1] * coef;
        g += d[k + 2] * coef;
        b += d[k + 3] * coef;
      }
      p[di] = (int(a) << 24)|(int(r) << 16)|(int(g) << 8)|int(b);
      di += h;
      if (i == max) {
        min += h;
        max += h;
        di -= t - 1;
      }
    }
    blur.updatePixels();
  }

  class Survey {
    int fpsf;
    long nowTime;
    long frameTime;
    double f;
    float fps;
    int frame_survey;
    long startTime = System.currentTimeMillis();

    void print_() {
      frame_survey++;
      if (frame_survey == 1)frameTime = System.currentTimeMillis();
      fpsf++;
      nowTime= System.currentTimeMillis();
      double time=Math.floor((nowTime-startTime)/1000);
      fill(color(0, 100, 100));
      String s = fpsf +" fps / "+((nowTime-frameTime)/fpsf)+" ms ";
      text(s, 50, 80);
      if ( time - f >= 1)
      {
        fpsf=0;
        f=time;
        frameTime = System.currentTimeMillis();
      }
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
