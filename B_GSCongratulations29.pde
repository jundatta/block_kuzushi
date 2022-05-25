// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】postredioriさん
// 【作品名】Random flowers
// https://openprocessing.org/sketch/1213032
//

class GameSceneCongratulations29 extends GameSceneCongratulationsBase {
  /*jshint esversion: 7 */

  /*  */
  color bg_color;
  color petals_color;
  color stamens_color;


  /* */
  float N = 5;
  float D = 3;
  float K = N / D;

  float STAMENS_COUNT = 16;

  PVector get_rose_coord(float r, float angle) {
    float t = radians(angle);
    float s = r * cos(K * t);
    return new PVector(s * cos(t), s * sin(t));
  }

  PVector get_circle_coord(float r, float angle) {
    float t = radians(angle);
    return new PVector(r * cos(t), r * sin(t));
  }

  void draw_blossom(float x, float y, float r) {
    fill(petals_color);
    noStroke();

    beginShape();
    for (int i=0; i<360*2; i++) {
      PVector p = get_rose_coord(r, i);
      vertex(x + p.x, y + p.y);
    }
    endShape(CLOSE);

    float rc = r / 3.5;
    float dA = 360 / N;
    fill(bg_color);
    for (int i=0; i<N; i++) {
      PVector p = get_circle_coord(r, i * dA);
      circle(x+p.x, y+p.y, rc);
    }

    float rs = r / 3;
    float rrs = r / 23.3;
    float dS = 360 / STAMENS_COUNT;
    stroke(stamens_color);
    fill(stamens_color);
    for (int i = 0; i < STAMENS_COUNT; i++) {
      PVector p = get_circle_coord(rs * (i % 2 == 0 ? 1 : 0.8), i * dS);
      line(x, y, x + p.x, y + p.y);
      circle(x + p.x, y + p.y, rrs);
    }
  }


  /*  */
  //final float A0 = 240;
  final float A0 = 108;
  final float Z = 0.65;

  float g(float x) {
    return A0 * pow(x, -Z);
  }


  /*  */
  float circlesCount = 0;
  ArrayList<Circle> circles;

  void initialize() {
    circlesCount = 0;
    circles = new ArrayList();
    background(bg_color);
  }

  class Circle {
    float x;
    float y;
    float r;

    void randomize(float k) {
      this.x = random(width);
      this.y = random(height);
      this.r = g(k+1);
    }

    boolean intersect(Circle otherCircle) {
      float dx = otherCircle.x - this.x;
      float dy = otherCircle.y - this.y;
      float rr = otherCircle.r + this.r;
      return (dx * dx + dy * dy <= rr * rr);
    }

    boolean intersectAnyOther() {
      for (int k=0; k<circles.size(); k++) {
        if (this.intersect(circles.get(k))) {
          return true;
        }
      }
      return false;
    }

    void adjustPosition(float k) {
      int i = 0;
      while (i < 10) {  // 10は適当
        this.randomize(k);
        if (!this.intersectAnyOther()) {
          break;
        }
        i++;
      }
    }

    void display() {
      draw_blossom(this.x, this.y, this.r);
    }
  }

  @Override void setup() {
    colorMode(RGB, 255);
    bg_color = color(15, 15, 15);
    petals_color = color(255, 116, 140);
    stamens_color = color(255, 255, 255);

    initialize();
  }
  @Override void draw() {
    if (1000 < circlesCount) {
      initialize();
    }

    Circle newCircle = new Circle();

    newCircle.adjustPosition(circlesCount);
    newCircle.display();

    circles.add(newCircle);
    circlesCount += 1;

    logoRightLower(color(255));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
