// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1368816
//

class GameSceneCongratulations242 extends GameSceneCongratulationsBase {
  // reference:https://github.com/beneater/boids/blob/master/boids.js

  // 課題1:コードを洗練させる（ループとか1回でいいでしょ）
  // 課題2:GPGPUに落とす（128ごとにグループ分けする感じで）
  // そうなると群れが2x512で1024個・・多すぎる？そうね。
  // あと軌跡が表現できないからつらいわね
  // まあ256x16くらいにとどめておくか。で、ランダム値は
  // 例の方法で放り込む感じで。重くなりそうなのが問題ね。
  // 256回のlengthくらいじゃびくともしないですね・・・fetchも。

  PGraphics head, bg;

  final float SPEED_LIMIT = 12; // 10/640にしよう。つまり1/64ね。1/50にしようかな・・1/50で。違う1/25だ。スケールが1/320だから。

  float visualRange = 64; // 1/10でいいと思う・・1/5か？

  class Boid {
    float x;
    float y;
    float dx;
    float dy;

    Boid(float x, float y, float dx, float dy) {
      this.x = x;
      this.y = y;
      this.dx = dx;
      this.dy = dy;
    }
  }
  Boid[] boids;

  // boidsの初期化
  void initBoids() {
    boids = new Boid[256];
    for (int i = 0; i < boids.length; i++) {
      float x = random(1) * width; // 単純に0~1を2倍して1を引く
      float y = random(1) * height;
      float dx = random(1) * 10 - 5; // 32で割って1/64を引けば良さそう
      float dy = random(1) * 10 - 5;
      Boid boid = new Boid(x, y, dx, dy);
      boids[i] = boid;
    }
  }

  // 単純にユークリッド距離
  float distance(PVector boid1, PVector boid2) {
    return sqrt((boid1.x - boid2.x) * (boid1.x - boid2.x) + (boid1.y - boid2.y) * (boid1.y - boid2.y));
  }

  // 3つの処理をまとめて行う
  void calcSpeed(Boid boid) {
    final float centeringFactor = 0.005; // factorはいじらなくてOK

    // flyTowardsCenter
    // 群れの中央に向かって加速
    // 平均位置を算出して差を取りファクターを掛けて足す
    float centerX = 0;
    float centerY = 0;
    float numNeighborsCenter = 0;

    // avoidOthers
    // 近づきすぎたら離れる
    final float minDistance = 20; // 1/16です
    final float avoidFactor = 0.05; // factorはいじらなくてOK
    float moveX = 0;
    float moveY = 0;

    // matchVelocity
    // 群れの速度に追従する
    // 平均速度を算出してファクターを掛けて足す
    final float matchingFactor = 0.05; // factorはいじらなくてOK
    float avgDX = 0;
    float avgDY = 0;
    float numNeighborsAverage = 0;

    for (Boid otherBoid : boids) {
      if (otherBoid == boid) {
        continue;
      }
      PVector vBoid = new PVector(boid.x, boid.y);
      PVector vOtherBoid = new PVector(otherBoid.x, otherBoid.y);
      float d = PVector.dist(vBoid, vOtherBoid);
      if (d < visualRange) {
        centerX += otherBoid.x;
        centerY += otherBoid.y;
        numNeighborsCenter++;
        avgDX += otherBoid.dx;
        avgDY += otherBoid.dy;
        numNeighborsAverage++;
      }
      if (d < minDistance) {
        moveX += boid.x - otherBoid.x;
        moveY += boid.y - otherBoid.y;
      }
    }

    if (numNeighborsCenter != 0) {
      centerX /= numNeighborsCenter;
      centerY /= numNeighborsCenter;

      boid.dx += (centerX - boid.x) * centeringFactor;
      boid.dy += (centerY - boid.y) * centeringFactor;
    }

    boid.dx += moveX * avoidFactor;
    boid.dy += moveY * avoidFactor;

    if (numNeighborsAverage != 0) {
      avgDX /= numNeighborsAverage;
      avgDY /= numNeighborsAverage;

      boid.dx += avgDX * matchingFactor;
      boid.dy += avgDY * matchingFactor;
    }
  }

  // 速度制限
  void limitSpeed(Boid boid) {
    final float speed = sqrt(boid.dx * boid.dx + boid.dy * boid.dy);
    if (speed > SPEED_LIMIT) {
      boid.dx = (boid.dx / speed) * SPEED_LIMIT;
      boid.dy = (boid.dy / speed) * SPEED_LIMIT;
    }
  }

  // 端っこに来たら折り返す方に加速
  void keepWithinBounds(Boid boid) {
    final float margin = 192; // 3割。6割？絶対値>0.4かなぁ。
    final float turnFactor = 1; // 1/320.
    if (boid.x < margin) {
      boid.dx += turnFactor;
    }
    if (boid.x > width - margin) {
      boid.dx -= turnFactor;
    }
    if (boid.y < margin) {
      boid.dy += turnFactor;
    }
    if (boid.y > height - margin) {
      boid.dy -= turnFactor;
    }
  }

  void drawBoid(Boid boid) {
    //circle(boid.x, boid.y, 4);
    final float x = boid.x;
    final float y = boid.y;
    final float t = atan2(boid.dy, boid.dx);
    final float x1 = x - 6*cos(t);
    final float y1 = y - 6*sin(t);
    final float x2 = x - 18*cos(t-PI/6.0f);
    final float y2 = y - 18*sin(t-PI/6.0f);
    final float x3 = x - 18*cos(t+PI/6.0f);
    final float y3 = y - 18*sin(t+PI/6.0f);
    //orbit.line(boid.x, boid.y, boid.preX, boid.preY);
    // まあ難しくないけどquad使ってですね・・
    // boid.x, boid.yから反対方向に10進んで
    // そこから後方45°で上下に10ずつ進む感じ？
    // atanで方向とって±PI*3/4かなぁ。で、
    head.quad(x, y, x2, y2, x1, y1, x3, y3);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    initBoids();
    head = createGraphics(width, height);
    bg = createGraphics(width, height);
    bg.beginDraw();
    bg.noStroke();
    bg.colorMode(HSB, 100);
    for (int i=0; i<255; i++) {
      bg.fill(55, 100-i*100/255.0f, 100);
      bg.rect(0, i*height/255.0f, width, height/255.0f);
    }
    bg.endDraw();
  }
  @Override void draw() {
    for (Boid boid : boids) {
      // Update the velocities according to each rule
      // 距離をアップデート
      calcSpeed(boid);

      limitSpeed(boid);
      keepWithinBounds(boid);

      // Update the position based on the current velocity
      boid.x += boid.dx;
      boid.y += boid.dy;
    }
    clear();
    head.beginDraw();
    head.noStroke();
    head.fill(255, 64, 0);
    head.clear();
    for (Boid boid : boids) {
      drawBoid(boid);
    }
    head.endDraw();
    image(bg, 0, 0);
    image(head, 0, 0);

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    clear();
    head.clear();
    initBoids();
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
