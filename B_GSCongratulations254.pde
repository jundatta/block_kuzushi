// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Interactive Logos
// https://openprocessing.org/sketch/1409955
//

class GameSceneCongratulations254 extends GameSceneCongratulationsBase {
  /*
Interactive logos
   
   jasonlabbe3d.com
   twitter.com/russetPotato
   */

  final int SPIN_MULTIPLIER = 45;
  final int MIN_PARTICLE_COUNT = 1200;
  final int MAX_PARTICLE_COUNT = 1000;
  final int MIN_PARTICLE_SIZE = 10;
  final int MAX_PARTICLE_SIZE = 18;
  final float MIN_FORCE = 0.4;
  final float MAX_FORCE = 0.6;
  final float REPULSION_RADIUS = 100;
  final float REPULSION_STRENGTH = 0.25;
  final int IMG_RESIZED_WIDTH = 300;
  final int IMG_SCAN_STEPS = 2;

  String[] imgNames = {
    "data/254/facebook.png", "data/254/amazon.png", "data/254/twitter.png",
    "data/254/visa.png", "data/254/mcdonalds.png", "data/254/mastercard.png"};
  ArrayList<Particle> particles;
  ArrayList<Integer> indices;
  int imgIndex = 0;
  int particleCount = 550;
  float maxSize = 0;
  PImage img;
  DrawType drawType;

  @Override void setup() {
    particles = new ArrayList();
    indices = new ArrayList();
    drawType = new TypeRect();

    loadImg(imgNames[0]);
  }
  @Override void draw() {
    background(0);

    guideDisplay();

    push();
    translate(width / 2 - img.width / 2, height / 2 - img.height / 2);

    fill(255);
    noStroke();

    rectMode(CENTER);

    for (Particle particle : particles) {
      particle.move();

      push();
      translate(particle.pos.x, particle.pos.y);

      float spin = particle.vel.mag() * SPIN_MULTIPLIER;
      rotate(radians(particle.mapped_angle + spin));

      fill(particle.col);
      drawType.draw(particle);

      pop();
    }

    rectMode(CORNER);

    if (mousePressed) {
      image(img, 0, 0);
    }

    pop();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (keyCode == ' ') {
      drawType = drawType.next();
      return;
    }
    if (key == TAB) {
      loadNextImg();
      return;
    }
  }
  class Particle {
    PVector pos, vel, acc, target;
    float size;
    float mapped_angle;
    color col;
    float maxForce;

    Particle(float _x, float _y, float _size, color _col) {
      this.pos = new PVector(img.width / 2, img.height / 2);
      this.vel = new PVector(0, 0);
      this.acc = new PVector(0, 0);
      this.target = new PVector(_x, _y);
      this.size = _size;
      this.mapped_angle = map(_x, 0, img.width, -180, 180) + map(_y, 0, img.height, -180, 180);
      this.col = _col;
      this.maxForce = random(MIN_FORCE, MAX_FORCE);
    }

    void goToTarget() {
      PVector steer = new PVector(this.target.x, this.target.y);

      float distance = dist(this.pos.x, this.pos.y, this.target.x, this.target.y);
      if (distance > 0.5) {
        float distThreshold = 20;
        steer.sub(this.pos);
        steer.normalize();
        steer.mult(map(min(distance, distThreshold), 0, distThreshold, 0, this.maxForce));
        this.acc.add(steer);
      }
    }

    void avoidMouse() {
      float mx = mouseX - width / 2 + img.width / 2;
      float my = mouseY - height / 2 + img.height / 2;

      float mouseDistance = dist(this.pos.x, this.pos.y, mx, my);

      if (mouseDistance < REPULSION_RADIUS) {
        PVector repulse = new PVector(this.pos.x, this.pos.y);
        repulse.sub(mx, my);
        repulse.mult(map(mouseDistance, REPULSION_RADIUS, 0, 0, REPULSION_STRENGTH));
        this.acc.add(repulse);
      }
    }

    void move() {
      this.goToTarget();

      this.avoidMouse();

      this.vel.mult(0.95);

      this.vel.add(this.acc);
      this.pos.add(this.vel);
      this.acc.mult(0);
    }
  }
  void loadNextImg() {
    imgIndex++;
    if (imgIndex >= imgNames.length) {
      imgIndex = 0;
    }
    loadImg(imgNames[imgIndex]);
  }

  void loadImg(String imgName) {
    img = loadImage(imgName);
    img.loadPixels();
    img.resize(IMG_RESIZED_WIDTH, 0);
    spawnParticles();
  }

  // Collects valid positions where a particle can spawn onto.
  void setupImg() {
    indices = new ArrayList();

    for (int x = 0; x < img.width; x+=IMG_SCAN_STEPS) {
      for (int y = 0; y < img.height; y+=IMG_SCAN_STEPS) {
        int index = (x + y * img.width);

        color p = img.pixels[index];
        int a = (int)alpha(p);
        if (a > 10) {
          indices.add(index);
        }
      }
    }
  }

  void spawnParticles() {
    particles = new ArrayList();

    setupImg();

    maxSize = map(
      particleCount,
      MIN_PARTICLE_COUNT, MAX_PARTICLE_COUNT,
      MAX_PARTICLE_SIZE, MIN_PARTICLE_SIZE);

    if (indices.size() == 0) {
      return;
    }

    for (int i = 0; i < particleCount; i++) {
      int max_attempts = 20;
      int attempts = 0;
      Particle newParticle = null;

      // Pick a random position from the active image and attempt to spawn a valid particle.
      while (newParticle == null) {
        int index = indices.get(int(random(indices.size())));

        int x = index % img.width;
        int y = index / img.width;

        color p = img.pixels[index];
        int r = (int)red(p);
        int g = (int)green(p);
        int b = (int)blue(p);
        int a = (int)alpha(p);

        if (particles.size() > 0) {
          float smallestSize = Float.MAX_VALUE;

          for (int n = 0; n < particles.size(); n++) {
            Particle otherParticle = particles.get(n);
            float d = dist(x, y, otherParticle.target.x, otherParticle.target.y);
            float newSize = (d - (otherParticle.size / 2)) * 2;

            if (newSize < smallestSize) {
              smallestSize = newSize;
            }
          }

          if (smallestSize > 0) {
            newParticle = new Particle(
              x, y,
              min(smallestSize, maxSize) * 0.75,
              color(r, g, b, a));
          }
        } else {
          newParticle = new Particle(
            x, y,
            maxSize,
            color(r, g, b, a));
        }

        attempts += 1;
        if (attempts > max_attempts) {
          break;
        }
      }

      if (newParticle != null) {
        particles.add(newParticle);
      }
    }
  }

  class DrawType {
    void draw(Particle particle) {
      // 使う予定はないのですが使えと言われたので使ってみました。
      // （。。。いや、ただのワーニング対策ですwすまにゃいｗ）
      println(particle);
    }

    DrawType next() {
      return null;
    }
  }
  class TypeRect extends DrawType {
    void draw(Particle particle) {
      rect(0, 0, particle.size, particle.size);
    }

    DrawType next() {
      return new TypeEllipse();
    }
  }
  class TypeEllipse extends DrawType {
    void draw(Particle particle) {
      ellipse(0, 0, particle.size, particle.size);
    }

    DrawType next() {
      return new TypeTriangle();
    }
  }
  class TypeTriangle extends DrawType {
    void draw(Particle particle) {
      triangle(
        particle.size * -0.5, particle.size * -0.5,
        0, particle.size,
        particle.size * 0.5, particle.size * -0.5);
    }

    DrawType next() {
      return new TypeRect();
    }
  }

  void guideDisplay() {
    final String[] msg = {
      "",
      "** How to interact **",
      "Move mouse over to interact with it.",
      "",
      "** Controls **",
      "TAB : Switch image",
      "Space : Change particle type",
    };
    final int H = 20;

    push();
    fill(255);
    noStroke();
    textSize(H);
    for (int y = 0; y < msg.length; y++) {
      String s = msg[y];
      text(s, 50, 50+y*H);
    }
    pop();
  }
}
