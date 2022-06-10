// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】David Shoreyさん
// 【作品名】Tiki Torch
// https://openprocessing.org/sketch/1187149
//

class GameSceneCongratulations22 extends GameSceneCongratulationsBase {
  ArrayList<Particle> particles = new ArrayList();

  @Override void setup() {
    colorMode(RGB, 255);
    Particle p = new Particle();
    particles.add(p);
  }
  @Override void draw() {
    background(0);
    for (int t = 0; t < 9; t++) {
      fill(100 + t * 10);
      rect(width/2 - 8 + t, height/2 + 30, 1, height);
      rect(width/2 + 8 - t, height/2 + 30, 1, height);
      rect(width/2 - 16 + t*2, height/2 + 25, 2, 60);
      rect(width/2 + 16 - t*2, height/2 + 25, 2, 60);
    }
    //rect(width/2 - 20, height/2+20, 40, 80);
    blendMode(ADD);
    for (int i = 0; i < 5; i++) {
      Particle p = new Particle();
      particles.add(p);
    }

    for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).update();
      particles.get(i).show();
      if (particles.get(i).finished()) {
        //      particles.splice(i, 1);
        particles.remove(i);
      }
    }
    blendMode(BLEND);

    logoRightLower(color(255, 0, 0));
  }

  class Particle {
    float x;
    float y;
    float vx;
    float vy;
    float alpha;
    float r;
    float g;
    float b;

    Particle() {
      this.x = width / 2;
      this.y = height / 2;
      this.vx = random(-1, 1);
      this.vy = random(-5, -1);
      this.alpha = 17;
      this.r = random(255, 200);
      this.g = random(150, 170);
      this.b = random(150, 95);
    }
    void update() {
      this.x += this.vx;
      this.y += this.vy;
      this.alpha -= 0.1;
      this.r -= 2;
      this.g -= 4;
      this.b -= 6;
    }
    void show() {
      noStroke();
      fill(this.r, this.g, this.b, this.alpha);
      ellipse(this.x, this.y, 40, 60);
    }

    boolean finished() {
      return this.alpha < 0;
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
