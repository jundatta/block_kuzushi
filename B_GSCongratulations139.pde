// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】タービュランス
// https://neort.io/art/c6i88m43p9f79lb76c10
//

class GameSceneCongratulations139 extends GameSceneCongratulationsBase {
  Thread[] threads = new Thread[40];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i=0; i<threads.length; i++) {
      float len = random(0.1, 0.9)*width;
      //    float x1 = randomGaussian(0.5, 0.12) * width;  // 0.38～0.68に収まってほしいにゃー
      float x1 = P5JS.randomGaussian(0.5, 0.12) * width;
      //    float y1 = randomGaussian(0.5, 0.12) * height;
      float y1 = P5JS.randomGaussian(0.5, 0.12) * height;
      float x2 = x1 + len * (int(random(3))-1);
      float y2 = y1 + len * (int(random(3))-1);
      threads[i] = new Thread(x1, y1, x2, y2);
    }
  }
  @Override void draw() {
    background(255);
    for (Thread t : threads) {
      t.run();
    }

    logoRightLower(color(255, 0, 0));
  }

  float easeInOutQuart(float x) {
    return x < 0.5 ? 8 * x * x * x * x : 1 - pow(-2 * x + 2, 4) / 2.0f;
  }

  class Thread {
    float x1;
    float y1;
    float x2;
    float y2;
    int t;
    int tt;
    ArrayList<Ball> balls;
    Thread(float x1, float y1, float x2, float y2) {
      this.x1 = x1;
      this.y1 = y1;
      this.x2 = x2;
      this.y2 = y2;
      this.t = 0;
      this.init();
      this.balls = new ArrayList();
    }

    void run() {
      stroke(0, 100);
      line(this.x1, this.y1, this.x2, this.y2);
      if (this.t % this.tt == 0) {
        this.balls.add(new Ball(this.x1, this.y1, this.x2, this.y2));
        this.init();
      }
      for (Ball b : this.balls) {
        b.show();
        b.move();
      }

      for (int i = 0; i < this.balls.size(); i++) {
        if (this.balls.get(i).isDead) {
          this.balls.remove(i);
        }
      }
      this.t++;
    }

    void init() {
      this.tt = int(random(50, 500));
    }
  }


  class Ball {
    PVector p1;
    PVector p2;
    PVector p;
    float d;
    float maxD;
    boolean isDead;
    float dst;
    float span;
    float t;
    Ball(float x1, float y1, float x2, float y2) {
      this.p1 = new PVector(x1, y1);
      this.p2 = new PVector(x2, y2);
      this.p = new PVector(x1, y1);
      this.d = 0;
      this.maxD = random(5, 30);
      this.isDead = false;
      this.dst =  PVector.dist(this.p1, this.p2);
      this.span =  int(random(0.25, 1) * this.dst);
      this.t = 0;
    }

    void show() {
      fill(0);
      stroke(0);
      circle(this.p.x, this.p.y, this.d);
    }

    void move() {
      float nrm = norm(this.t, 0, this.span);
      this.p = PVector.lerp(this.p1, this.p2, easeInOutQuart(nrm));
      this.d = lerp(0, this.maxD, sin(nrm*PI));
      if (this.t > this.span)this.isDead = true;

      this.t ++;
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
