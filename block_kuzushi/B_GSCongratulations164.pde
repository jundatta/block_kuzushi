// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】201227
// https://neort.io/art/bvk7pfk3p9f30ks55nb0
//

class GameSceneCongratulations164 extends GameSceneCongratulationsBase {
  Mover[] movers = new Mover[3];
  color[] colors = {#FF0271, #02AFFE, #FFDE00, #FF6A03, #48FFAB, #ffffff, #000000};

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i=0; i<3; i++) {
      movers[i] = new Mover();
    }
  }
  @Override void draw() {
    background(colors[1]);
    push();
    rectMode(CENTER);
    for (Mover m : movers) {
      m.run();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }

  float pom() {
    return random(1) < 0.5 ? -1 : 1;
  }

  class Mover {
    float x;
    float y;
    float velX;
    float velY;
    ArrayList<Form> forms;
    Mover() {
      this.forms = new ArrayList();
      this.setValues();
    }

    void setValues() {
      this.x = random(width);
      this.y = random(height);
      this.velX = pom() * random(1, 12);
      this.velY = pom() * random(1, 12);
    }

    void show() {
      this.forms.add(new Form(this.x, this.y));
      for (Form f : this.forms) {
        f.run();
      }
    }

    void move() {
      float theta = noise(this.x * 0.004, this.y * 0.004, frameCount * 0.0001) * 50;
      this.x += cos(theta) * this.velX;
      this.y += sin(theta) * this.velY;
      for (int i = 0; i < this.forms.size(); i++) {
        if (this.forms.get(i).isDead()) {
          //        this.forms.splice(i, 1);
          this.forms.remove(i);
        }
      }

      if (this.x < 0 || width < this.x || this.y < 0 || height < this.y) {
        this.setValues();
      }
    }

    void run() {
      this.show();
      this.move();
    }
  }

  class Form {
    float x0;
    float y0;
    float x;
    float y;
    float x1;
    float y1;
    float s;
    float sMax;
    float ang;
    float aStep;
    float lifeSpan;
    float life;
    color col;
    int shprnd;
    Form(float x, float y) {
      float r = random(100);
      float a = random(10);
      this.x0 = x + r * cos(a);
      this.y0 = y + r * sin(a);
      this.x = this.x0;
      this.y = this.y0;
      this.x1 = x;
      this.y1 = y;
      this.s = 0;
      this.sMax = random(5, 40);
      this.ang = 0;
      this.aStep = random(-1, 1) * 0.1;
      this.lifeSpan = 100;
      this.life = this.lifeSpan;
      this.col = color(P5JSrandom(colors));
      this.shprnd = int(random(2));
    }
    void show() {
      push();
      stroke(0, 100);
      noStroke();
      fill(this.col);
      translate(this.x, this.y);
      rotate(this.ang);
      if (this.shprnd == 0)square(0, 0, this.s);
      if (this.shprnd == 1)circle(0, 0, this.s);
      pop();
    }
    void move() {
      this.x = map(this.life, this.lifeSpan, 0, this.x0, this.x1);
      this.y = map(this.life, this.lifeSpan, 0, this.y0, this.y1);
      this.ang += this.aStep;
      this.life --;
      if (int(this.lifeSpan*0.9) < this.life) {
        this.s = map(this.life, this.lifeSpan, this.lifeSpan*0.9, 0, this.sMax);
      } else {
        this.s = map(this.life, this.lifeSpan*0.9, 0, this.sMax, 0);
      }
    }
    void run() {
      this.move();
      this.show();
    }
    boolean isDead() {
      if (this.life < 0) return true;
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
