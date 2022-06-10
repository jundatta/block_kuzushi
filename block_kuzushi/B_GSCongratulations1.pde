// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】kusakari？さん
// 【作品名】Morph Balls
// https://openprocessing.org/sketch/1111225
// 【移植】PC-8001（TN8001）さん
// https://gist.github.com/TN8001/98678d6c658ac6201e7b6fd64c28fe2c
// https://www.nicovideo.jp/watch/sm39049052
// https://www.nicovideo.jp/watch/sm39049157
// https://www.nicovideo.jp/watch/sm39049906
//

class GameSceneCongratulations1 extends GameSceneCongratulationsBase {
  final int SPHERE_NUM = 4;
  final int COUNT_LIMIT = 3;
  final float NOISE_STEP = 0.006;
  float SPHERE_RADIUS; // width / 50.0;
  float MAX_SPHERE_RADIUS; // width / 3.0;

  final PVector INIT_ROTATION = new PVector(random(360), random(360), random(360));
  final PVector INIT_NOISE = new PVector(random(100), random(100), random(100));
  final PVector NOISE_RANGE = new PVector(1.0 / 1.5 / 4, 1.0 / 1.5 / 4, 1.0 / 1.5 / 4);

  final Sphere[] _spheres = new Sphere[SPHERE_NUM];

  @Override void setup() {
    //setAttributes('premultipliedAlpha', true);
    //frameRate(30);
    sphereDetail(12); // デフォルト30

    colorMode(HSB, 360, 100, 100, 255);
    noStroke();

    MAX_SPHERE_RADIUS = width / 3.0;
    SPHERE_RADIUS = width / 50.0;

    final float initHue = random(360);
    final int initDirection = int(random(2)) * 2 - 1; // [-1, 1]
    for (int i = 0; i < SPHERE_NUM; i++) {
      final float r = MAX_SPHERE_RADIUS / float(SPHERE_NUM) * (i + 1);
      final float hue = (initHue + 300 / float(SPHERE_NUM) * i * initDirection + 360) % 360;
      _spheres[i] = new Sphere(r, hue);

      final Triangle[] triangles = {
        new Triangle(+r, 0, 0, 0, 0, +r, 0, -r, 0), new Triangle(-r, 0, 0, 0, 0, +r, 0, -r, 0),
        new Triangle(+r, 0, 0, 0, 0, -r, 0, -r, 0), new Triangle(-r, 0, 0, 0, 0, -r, 0, -r, 0),
        new Triangle(+r, 0, 0, 0, 0, +r, 0, +r, 0), new Triangle(-r, 0, 0, 0, 0, +r, 0, +r, 0),
        new Triangle(+r, 0, 0, 0, 0, -r, 0, +r, 0), new Triangle(-r, 0, 0, 0, 0, -r, 0, +r, 0)};
      for (final Triangle triangle : triangles) {
        addPoints(triangle, 1, r, i);
      }
    }
  }

  void addPoints(final Triangle triangle, final int count, final float radius, final int index) {
    if (count <= COUNT_LIMIT) {
      final Triangle midTriangle = triangle.divide(radius);

      final Triangle[] triangles = {
        new Triangle(triangle.v1, midTriangle.v1, midTriangle.v3),
        new Triangle(midTriangle.v1, triangle.v2, midTriangle.v2),
        new Triangle(midTriangle.v3, midTriangle.v2, triangle.v3),
        midTriangle};
      for (Triangle t : triangles) {
        addPoints(t, count + 1, radius, index);
      }
    } else {
      _spheres[index].points.add(new Point(triangle));
    }
  }

  @Override void draw() {
    background(0);

    push();
    translate(width / 2, height / 2);

    lights();
    directionalLight(0, 0, 1000, -1, 1, -1);
    //ambientLight(80);

    rotateX(INIT_ROTATION.x + frameCount / 300.0);
    rotateY(INIT_ROTATION.y + frameCount / 100.0);
    rotateZ(INIT_ROTATION.z + frameCount / 200.0);

    int c = 0;
    final int freq = 4;
    final int d = 4;
    final float threshold = 0.5;
    for (final Sphere sphere : _spheres) {
      for (final Point point : sphere.points) {
        final PVector v = P5JS.P5Vector.mult(NOISE_RANGE, point.center).div(MAX_SPHERE_RADIUS).add(INIT_NOISE);
        final float f = noise(v.x, v.y, v.z + NOISE_STEP * frameCount);
        final float noiseValue = pow(sin(freq * TWO_PI * f), d);

        final float ratio = (noiseValue - threshold) / (1 - threshold);
        if (threshold < noiseValue) {
          fill(sphere.hue, 80, 100);

          push();
          rotateZ(HALF_PI);
          rotateX(-point.rotation.x);
          rotateZ(point.rotation.z);
          translate(0, -sphere.radius, 0);
          sphere(SPHERE_RADIUS * ratio);
          pop();
          c++;
        }
      }
    }
    pop();

    text("  fps: " + frameRate, 20, 50);
    text("count: " + c, 20, 100);
  }

  class Triangle {
    final PVector v1;
    final PVector v2;
    final PVector v3;

    Triangle(final PVector v1, final PVector v2, final PVector v3) {
      this.v1 = v1;
      this.v2 = v2;
      this.v3 = v3;
    }
    Triangle(final float x1, final float y1, final float z1, final float x2, final float y2, final float z2, final float x3, final float y3, final float z3) {
      this(new PVector(x1, y1, z1), new PVector(x2, y2, z2), new PVector(x3, y3, z3));
    }

    Triangle divide(final float radius) {
      final PVector mid12 = PVector.lerp(this.v1, this.v2, 0.5);
      final PVector mid23 = PVector.lerp(this.v2, this.v3, 0.5);
      final PVector mid31 = PVector.lerp(this.v3, this.v1, 0.5);
      final PVector newv1 = mid12.div(mid12.mag()).mult(radius);
      final PVector newv2 = mid23.div(mid23.mag()).mult(radius);
      final PVector newv3 = mid31.div(mid31.mag()).mult(radius);

      return new Triangle(newv1, newv2, newv3);
    }
  }

  class Sphere {
    final float radius;
    final float hue;
    // 512 = 4^3*8 addPointsのtriangles ^ COUNT_LIMIT（再帰段数） * setupのtriangles
    final ArrayList<Point> points = new ArrayList<Point>();

    Sphere(final float radius, final float hue) {
      this.radius = radius;
      this.hue = hue;
    }
  }

  class Point {
    final PVector center;
    final PVector rotation;

    Point(Triangle triangle) {
      this.center = PVector.add(triangle.v1, triangle.v2).add(triangle.v3).div(3);

      final PVector copy = this.center.copy();
      copy.y = 0;
      final float x = atan2(this.center.z, this.center.x);
      final float z = atan2(this.center.y, copy.mag());
      this.rotation = new PVector(x, 0, z); // 位置は使う側に合わせた
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
