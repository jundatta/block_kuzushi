// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】zosignさん
// 【作品名】Viral Invasion
// https://openprocessing.org/sketch/1225962
//

class GameSceneCongratulations37 extends GameSceneCongratulationsBase {
  //Reference:
  // Daniel Shiffman  Attraction / Repulsion
  // https://youtu.be/OAcXnzRNiCY

  ArrayList<Attractor> attractors = new ArrayList();
  ArrayList<Particle> particles = new ArrayList();
  final color COLS[] = {#8c8c8c, #4a4a4a};
  PGraphics bg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    background(200, 0, 0);

    final float pNum = 300;
    for (float i = 0; i < pNum; i ++) {
      particles.add(new Particle(random(width), random(height)));
    }

    float span = min(width, height) / 3.0f;
    for (float y = (height % span) /2.0f; y < height + span; y +=span) {
      for (float x = (width % span)/2.0f; x < width + span; x +=span) {
        attractors.add(new Attractor(x + random(-span/2.0f, span/2.0f), y, random(0.1, 0.3) * span, -20));
      }
    }

    bg = createGraphics(width + 10, height + 10);
    bg.beginDraw();
    bg.noStroke();
    bg.fill(200, 0, 0, 10);
    for (int i = 0; i < 500000; i++) {
      float x = random(bg.width);
      float y = random(bg.height);
      float s = noise(x*0.01, y*0.01)*1 + 1;
      bg.rect(x, y, s, s);
    }
    bg.endDraw();
  }
  @Override void draw() {
    for (final Particle particle : particles) {
      PVector force = new PVector(0, 0);
      for (final Attractor attractor : attractors) {
        force.add(attractor.getAttractForce(particle.pos, particle.radius, particle.vel));
      }
      if (attractors.size() > 0) {
        force.div(attractors.size());
      }
      particle.applyForce(force);
      particle.update();
      particle.show();
    }

    image(bg, int(random(-10)), int(random(-10)));
    for (final Attractor i : attractors) {
      i.display();
    }

    logoRightLower(color(0));
  }

  class Particle {
    PVector pos;
    float radius;
    PVector vel;
    PVector acc;
    float maxVel;
    color col;
    PVector accBaseDir;

    Particle(float x, float y) {
      this.pos = new PVector(x, y);
      this.radius = 7.0f;
      this.vel = PVector.random2D();
      this.acc = new PVector(0, 0);
      this.maxVel = random(1, 3);
      this.col = P5JSrandom(COLS);
      this.accBaseDir = new PVector(random(0.2), random(-0.2));
    }

    void update() {
      this.acc.add(this.accBaseDir);
      this.vel.add(this.acc);
      this.vel.limit(this.maxVel);
      this.pos.add(this.vel);
      this.pos = repeatPos(this.pos);
      this.acc.mult(0);
    }

    void show() {
      noStroke();
      fill(this.col);
      circle(this.pos.x, this.pos.y, this.radius * 2);
    }

    void applyForce(PVector force) {
      this.acc.add(force);
    }
  }

  /////////////////////

  class Attractor {
    PVector pos;
    float radius;
    float G;
    float arrtactMaxDist;
    boolean rotateClockwise;
    float rn;
    PVector vel;

    Attractor(float x, float y, float radius, float g) {
      this.pos = new PVector(x, y);
      this.radius = radius;
      this.G = g;
      this.arrtactMaxDist = 50;
      this.rotateClockwise = random(1) > 0.5 ? true: false;
      this.rn = random(100);
      this.vel =  new PVector(random(-1, 1), random(-1, 1)).normalize();
    }

    void display() {
      this.pos.add(this.vel);
      if (this.pos.x  > width || this.pos.x < 0) {
        this.vel.x *= -1;
      }
      if (this.pos.y > height || this.pos.y < 0) {
        this.vel.y *= -1;
      }

      //this.pos.add(cos(frameCount/50 + this.rn), sin(frameCount/50 + this.rn) );
      noStroke();
      fill(255);
      circle(this.pos.x, this.pos.y, this.radius * 2);
    }

    PVector getAttractForce(PVector particlePos, float particleRadius, PVector particleDir) {
      PVector dir = PVector.sub(this.pos, particlePos);
      float dist = dir.mag() - (this.radius + particleRadius);
      if (dist > this.arrtactMaxDist) {
        return new PVector(0, 0);
      }

      //F = G * (M*m) / (r*r)
      float posDist = max(dist, 0.000001);
      float strength =  this.G / posDist * posDist;

      //アトラクタの接線ベクトル
      PVector forceDir = this.rotateClockwise == true ? new PVector(-dir.y, dir.x) : new PVector(dir.y, -dir.x);

      //反発ベクトルも少々加算
      forceDir.add(PVector.mult(dir, 0.5));

      //強さの反映
      PVector force = forceDir.setMag(strength);

      return force;
    }
  }

  PVector repeatPos(PVector pos)
  {
    float x = pos.x;
    if (x > width) x %= width;
    if (x < 0) x+=width;
    float y = pos.y;
    if (y > height) y %= height;
    if (y < 0) y += height;
    return new PVector(x, y);
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
