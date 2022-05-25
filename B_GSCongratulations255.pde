// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/c731bn43p9f3hsje9avg?index=89&origin=user_like
//

class GameSceneCongratulations255 extends GameSceneCongratulationsBase {
  float gridTopX;
  float gridTopY;
  float sideLength;
  final ArrayList<Cube> cubes = new ArrayList();

  int current;

  PGraphics pg;

  @Override void setup() {
    pg = createGraphics(width, height, P2D);

    sideLength = floor((height / 2) / 30.0f);

    gridTopX = width / 2.0f;
    gridTopY = height / 2.0f + sideLength * 10;

    int h = 30;
    float ang = 20 * PI / 180.0f;

    for (int ch = 0; ch <= h; ch++) {
      float cz = h - ch;
      float radius = ch * tan(ang);
      for (int deg = 0; deg < 360; deg += 5) {
        float rad = deg * PI / 180.0f;
        float cx = floor(radius * cos(rad));
        float cy = floor(radius * sin(rad));
        cubes.add(new Cube(cx, cy, cz));
      }
    }
    // Sort so the cubes are drawn in the right order
    //cubes.sort((a, b) => {
    //  return a.getSortString().localeCompare(b.getSortString());
    //}
    //);
    cubes.sort((a, b) -> (a.getSortString().compareTo(b.getSortString())));
    pg.loadPixels();
    pg.background(0, 0, 0);
    current = 0;
  }
  @Override void draw() {
    if (current >= cubes.size()) {
      return;
    }
    pg.beginDraw();
    //HSBモードでの色指定に変更
    pg.colorMode(HSB, 360, 100, 100, 100);
    //指定後は色指定が
    //H（色相）:0-360
    //S（彩度）:0-100
    //B（明度）:0-100
    //A（透明度）:0-100
    //のパラメータで指定する
    cubes.get(current).draw(pg);
    pg.endDraw();
    image(pg, 0, 0);
    current++;

    logoRightLower(#ff0000);
  }

  class Cube {
    float c, r, z;
    float h, s, b;
    Cube(float c, float r, float z) {
      this.c = c;
      this.r = r;
      this.z = z;
      this.h = random(60, 150);
      this.s = 100;
      this.b = random(30, 70);
      if (random(1)<0.15) {
        this.h = 0;
        this.s = 100;
        this.b = 100;
      } else if (random(1)<0.15) {
        this.h = 0;
        this.s = 0;
        this.b = 100;
      }
    }
    void draw(PGraphics pg) {

      //iso(c,r,z)からx,y,zへ変換
      //https://clintbellanger.net/articles/isometric_math/
      final float x = gridTopX + (this.c - this.r) * sideLength * sqrt(3) / 2.0f;
      final float y = gridTopY + (this.c + this.r) * sideLength / 2.0f - sideLength * this.z;


      //6角形の頂点を計算(60度毎)
      ArrayList<PVector> ps = new ArrayList();
      for (int angle = 30; angle <= 330; angle += 60) {
        ps.add(
          new PVector(x + cos(PI / 180 * angle) * sideLength, y + sin(PI / 180 * angle) * sideLength)
          );
      }
      PVector[] points = new PVector[ps.size()];
      for (int i = 0; i < points.length; i++) {
        points[i] = ps.get(i);
      }
      //放射線
      pg.line(x, y, points[0].x, points[0].y);
      pg.line(x, y, points[1].x, points[1].y);
      pg.line(x, y, points[2].x, points[2].y);
      pg.line(x, y, points[3].x, points[3].y);
      pg.line(x, y, points[4].x, points[4].y);
      pg.line(x, y, points[5].x, points[5].y);
      //面
      pg.fill(this.h, this.s, this.b);
      pg.quad(x, y, points[5].x, points[5].y, points[0].x, points[0].y, points[1].x, points[1].y);
      pg.fill(this.h, this.s, this.b * 0.75);
      pg.quad(x, y, points[3].x, points[3].y, points[4].x, points[4].y, points[5].x, points[5].y);
      pg.fill(this.h, this.s, this.b * 0.5);
      pg.quad(x, y, points[1].x, points[1].y, points[2].x, points[2].y, points[3].x, points[3].y);
    }
    String getSortString() {
      String sr, sc, sz;
      int d;
      d = (int)(10000+this.z);
      sz = String.format("%05d", d);
      d = (int)(10000+this.r);
      sr = String.format("%05d", d);
      d = (int)(10000+this.c);
      sc = String.format("%05d", d);
      return sz + '.' + sr + '.' + sc;
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
