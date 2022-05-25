// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/c7sjma43p9fclnodvjf0?index=81&origin=user_like
//

class GameSceneCongratulations263 extends GameSceneCongratulationsBase {
  final color[] colors = { #50d0d0, #be1e3e, #7967c3, #ffc639, };
  final color bgColor = #255699;

  CircleMover[] movers = new CircleMover[12];

  @Override void setup() {
    background(bgColor);

    float seed = random(10000);
    for (int i = 0; i < movers.length; i++) {
      float theta = TWO_PI / movers.length * i;
      movers[i] = new CircleMover(height * 0.2, theta, seed);
    }
  }
  @Override void draw() {
    push();
    //background(red(bgColor), green(bgColor), blue(bgColor), 120);
    fill(red(bgColor), green(bgColor), blue(bgColor), 120);
    rect(0, 0, width, height);

    noFill();
    stroke(255);

    blendMode(ADD);
    ellipseMode(CENTER);
    circle(width/2, height/2, height * 0.4);

    for (int i = movers.length-1; i >= 0; i--) {
      movers[i].update();
      movers[i].display();
    }
    blendMode(BLEND);
    pop();

    logoRightLower(#ff0000);
  }

  class CircleMover {
    float r;
    float theta;
    PVector pos;
    float seed;
    float aVel;
    float radius;
    ArrayList<CircleBullet> bullets;

    CircleMover(float r, float theta, float seed) {
      this.r = r;
      this.theta = theta;
      this.pos = new PVector(r * cos(theta), r * sin(theta));
      this.seed = seed;
      this.aVel = map(noise(cos(seed), sin(seed)), 0, 1, -0.1, 0.1);
      this.radius = 20;

      this.bullets = new ArrayList();
    }

    void update() {
      this.aVel = map(noise(cos(this.seed), sin(this.seed), frameCount * 0.01), 0, 1, -0.1, 0.1);
      this.theta += this.aVel;
      this.pos.x = r * cos(this.theta);
      this.pos.y = r * sin(this.theta);

      if (frameCount % 12 == 0) {
        this.bullets.add(new CircleBullet(width/2 + this.pos.x, height/2 + this.pos.y));
      }
    }

    void display() {
      fill(100);
      stroke(255);
      ellipseMode(CENTER);
      push();
      translate(width/2, height/2);
      circle(this.pos.x, this.pos.y, this.radius);
      pop();

      for (int i = this.bullets.size()-1; i >= 0; i--) {
        this.bullets.get(i).update();
        this.bullets.get(i).display();
        if (this.bullets.get(i).isOut()) {
          this.bullets.remove(i);
        }
      }
    }
  }

  class CircleBullet {
    PVector pos;
    PVector dir;
    PVector vel;
    float radius;
    int alpha;
    color col;

    CircleBullet(float x, float y) {
      this.pos = new PVector(x, y);
      this.dir = PVector.sub(this.pos, new PVector(width/2, height/2));
      this.dir.normalize();
      this.vel = this.dir.copy().mult(6);
      this.radius = 15;
      this.alpha = 0;
      this.col = P5JSrandom(colors);
    }

    void update() {
      this.pos.add(this.vel);
      this.alpha += 20;
      this.alpha = constrain(this.alpha, 0, 255);
    }

    void display() {
      noFill();
      stroke(red(this.col), green(this.col), blue(this.col), this.alpha);
      ellipseMode(CENTER);
      for (int i = 0; i < 5; i++) {
        float r = this.radius + this.radius * sin(i + frameCount*0.8);
        PVector p = PVector.add(this.pos, this.dir.normalize().mult(r));
        circle(p.x, p.y, r);
      }
    }

    boolean isOut() {
      if (this.pos.x > width + 100) {
        return true;
      }
      if (this.pos.x < -100) {
        return true;
      }
      if (this.pos.y > height + 100) {
        return true;
      }
      if (this.pos.y < -100) {
        return true;
      }
      return false;
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
