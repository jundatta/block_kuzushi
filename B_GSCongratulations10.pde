// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Karuttさん
// 【作品名】Easing Animation 1
// https://openprocessing.org/sketch/1235214
//

class GameSceneCongratulations10 extends GameSceneCongratulationsBase {
  ArrayList<Ripple> ripples = new ArrayList();
  ArrayList<Particle> particles = new ArrayList();
  ArrayList<Text> texts = new ArrayList();
  ArrayList<Ball> balls = new ArrayList();
  ArrayList<Mover> movers = new ArrayList();
  ArrayList<Button> buttons = new ArrayList();
  boolean white = false;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    buttons.add(new Button(width / 2, height / 2));

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.colorMode(HSB, 255, 255, 255, 100);
    pg.textFont(gPacifico);
    pg.textAlign(CENTER, CENTER);
    pg.rectMode(CENTER);

    if (white) {
      pg.background(255);
    } else {
      pg.background(#2e2e2e);
    }

    for (Button button : buttons) {
      button.display();
    }

    for (int i = movers.size() - 1; i >= 0; i--) {
      white = true;
      movers.get(i).applyForce(new PVector(0, 0.7));
      movers.get(i).update();
      movers.get(i).display();
      if (movers.get(i).isDead()) {
        //      movers.splice(i, 1);
        movers.remove(i);
        run(width / 2, height / 2);
      }
    }

    ArrayList<Ball> newBall = (ArrayList<Ball>)balls.clone();
    for (Ball ball : balls) {
      ball.update();
      ball.display();
      if (ball.isDead()) {
        newBall.clear();
      }
    }
    balls = newBall;

    //for (let obj of [ripples, particles, texts]) {
    //  for (let i = obj.length - 1; i >= 0; i--) {
    //    obj[i].update()
    //      obj[i].display()
    //  }
    //}
    for (int i = ripples.size() - 1; i >= 0; i--) {
      ripples.get(i).update();
      ripples.get(i).display();
    }
    for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).update();
      particles.get(i).display();
    }
    for (int i = texts.size() - 1; i >= 0; i--) {
      texts.get(i).update();
      texts.get(i).display();
    }

    pg.endDraw();
    image(pg, 0, 0);

    translate(0, 340);
    logo(color(255, 0, 0));
  }
  @Override void mousePressed() {
    for (Button button : buttons) {
      if (button.mouseIn()) {
        button.stateOn(true);
        button.reverseShadow();
        continue;
      }
      button.stateOn(false);
    }
  }
  @Override void mouseReleased() {
    for (Button button : buttons) {
      println(button.IsStateOn());
      if (button.IsStateOn() && button.mouseIn()) {
        //      button.reverseShadow();
        buttons.clear();
        balls.clear();
        ripples.clear();
        particles.clear();
        texts.clear();
        balls.add(new Ball());
        movers.add(new Mover(width / 2, -200));
        return;
      }
      button.stateOn(false);
    }
  }

  void run(float x, float y) {
    texts.add(new Text(x, y, "Open Processing"));
    ripples.add(new Ripple(x, y));
    ripples.add(new Ripple(x, y));
    for (int i = 0; i < 120; i++) {
      particles.add(new Particle(x, y));
    }
  }
  class Ball {
    float ease;
    float lifespan;
    float time;
    float resolution;
    float rows;
    float columns;
    Ball() {
      this.ease = 0;
      this.lifespan = 60;
      this.time = PI / 4.0f;

      this.resolution = 50;
      this.rows = height / this.resolution + 1;
      this.columns = width / this.resolution + 1;
    }

    void update() {
      this.lifespan -= 1;
      if (this.ease < 1) {
        this.ease += (1 - this.ease) * 0.1 + 0.001;
      } else {
        this.ease = 1;
        this.time += 0.013;
      }
    }

    void display() {
      pg.fill(#2feeff);
      pg.noStroke();
      for (int y = 0; y < this.rows; y += 1) {
        for (int x = 0; x < this.columns; x += 1) {
          float r = this.resolution*2*(1-this.ease)*(10+dist(x, y, this.columns/2, this.rows/2))*0.1;
          pg.ellipse(x * this.resolution, y * this.resolution, r, r);
        }
      }
      pg.noFill();
    }

    boolean isDead() {
      return this.ease == 1;
    }
  }
  class Button {
    float x;
    float y;
    color s1;
    color s2;

    PImage pOff;
    PImage pOver;
    PImage pOn;
    boolean bStateOn = false;
    Button(float x, float y) {
      this.x = x;
      this.y = y;
      this.s1 = color(255, 255, 255, 10);
      this.s2 = color(0, 0, 0, 90);

      this.pOff = loadImage("data/10/off.jpg");
      this.pOver = loadImage("data/10/over.jpg");
      this.pOn = loadImage("data/10/on.jpg");
    }

    void stateOn(boolean bOn) {
      bStateOn = bOn;
    }
    boolean IsStateOn() {
      return bStateOn;
    }

    void display() {
      pg.translate(this.x, this.y);

      if (this.mouseIn()) {
        if (this.bStateOn && mousePressed) {
          pg.image(this.pOn, -(this.pOn.width / 2), -(this.pOn.height / 2));
          return;
        }
        pg.image(this.pOver, -(this.pOver.width / 2), -(this.pOver.height / 2));
        return;
      }
      pg.image(this.pOff, -(this.pOff.width / 2), -(this.pOff.height / 2));

      //push();
      //  translate(this.x, this.y);
      //  //      let c = this.mouseIn() ? color("#2f2f2f") : color("#2e2e2e")
      //  color c = this.mouseIn() ? color(#606060) : color(#2e2e2e);
      //  fill(c);
      //  stroke(c);
      //  strokeWeight(20);
      //  shadow(0, 0, 30, this.s1);
      //  arc(0, 0, 160, 160, PI, TWO_PI);
      //  shadow(0, 0, 30, this.s2);
      //  arc(0, 0, 160, 160, 0, PI);
      //  noShadow();
      //  noStroke();
      //  ellipse(0, 0, 135, 120);

      //  //mask
      //  stroke(#2e2e2e);
      //  strokeWeight(40);
      //  noFill();
      //  ellipse(0, 0, 180, 180);

      //  //power icon
      //  stroke(#E6BC68);
      //  strokeWeight(3);
      //  translate(0, this.down ? 5 : 0);
      //  shadow(0, 0, 100, #9E9582);
      //  line(0, -25 + 8, 0, -25 - 8);
      //  arc(0, 0, 50, 50, -PI / 3, PI + PI / 3);
      //  if (this.mouseIn()) {
      //  shadow(0, 0, 70, #9E9582);
      //    arc(0, 0, 50, 50, -PI / 3, PI + PI / 3);
      //}
      //noShadow();
      //  pop();
    }

    void reverseShadow() {
      //    [this.s1, this.s2] = [this.s2, this.s1]
      color c = s1;
      s1 = s2;
      s2 = c;
    }

    boolean mouseIn() {
      return dist(mouseX, mouseY, width / 2, height / 2) < (this.pOff.width / 2) * 0.8f;
    }
  }
  class Mover {
    float ease;
    float lifespan;
    float time;
    float resolution;
    float rows;
    float columns;
    PVector pos;
    PVector velocity;
    PVector acc;
    float jump_count;
    Mover(float x, float y) {
      this.ease = 0;
      this.lifespan = 60;
      this.time = PI / 4.0f;

      this.resolution = 50;
      this.rows = height / this.resolution + 1;
      this.columns = width / this.resolution + 1;
      this.pos = new PVector(x, y);
      this.velocity = new PVector(0, 0);
      this.acc = new PVector(0, 0);
      this.jump_count = 0;
    }

    void update() {
      this.lifespan -= 1;
      this.physical_operation();
      this.easing();
      this.edge();
    }

    void physical_operation() {
      this.velocity.add(this.acc);
      this.pos.add(this.velocity);
      this.acc.mult(0);
    }

    void easing() {
      if (this.ease < 1) {
        this.ease += (1 - this.ease) * 0.1 + 0.001;
      } else {
        this.ease = 1;
        this.time += 0.013;
      }
    }

    void edge() {
      if (this.pos.y > height / 2) {
        this.pos.y = height / 2.0f;
        this.velocity.y *= -0.45;
        // this.acc.add(createVector(0, 3))
        this.jump_count += 1;
      }
    }

    void applyForce(PVector f) {
      this.acc.add(f);
    }

    void display() {
      pg.fill(#2e2e2e);
      pg.ellipse(this.pos.x, this.pos.y, 100, 100);
      pg.stroke(255);
      pg.ellipse(this.pos.x, this.pos.y, 98, 98);
      pg.ellipse(this.pos.x, this.pos.y, 96, 96);
      pg.ellipse(this.pos.x, this.pos.y, 38, 38);
      pg.ellipse(this.pos.x, this.pos.y, 43, 43);
      pg.strokeWeight(2);
      pg.ellipse(this.pos.x, this.pos.y, 30, 30);
      pg.strokeWeight(1);
      float r = map(height / 2 - this.pos.y, 0, height / 2, 80, 120);
      float a = map(height / 2 - this.pos.y, 0, height / 2, 50, 35);
      pg.fill(0, 0, 0, a);
      pg.ellipse(width / 2, height / 2 + 5 + 50, r, 10);
      pg.fill(255);
      pg.textSize(14);
      pg.text("K", this.pos.x, this.pos.y);
    }

    boolean isDead() {
      return this.jump_count >= 2;
    }
  }
  class Particle {
    float ease;
    float x;
    float y;
    float lifespan;
    float time;
    float r;
    float center;
    float s;
    float theta;
    float speed;
    float aspeed;
    float alpha;
    boolean flashing;
    float flashingspan;
    float flashingcount;
    Particle(float x, float y) {
      this.ease = 0;
      this.x = x;
      this.y = y;
      this.lifespan = 60;
      this.time = PI/4.0f;

      //    this.r = randomGaussian(240, 50);
      this.r = P5JS.randomGaussian(240, 50);
      this.center = 175;
      float s = (1.0f/(2.0f+abs(this.r-random(140, 210))))*10.0f;
      s = constrain(s, 0, 0.8);
      this.s = abs(random(1, 40))*s;
      this.theta = random(TWO_PI);
      this.speed = random(0.2, 0.45);
      this.aspeed = 0.0001/s;
      this.alpha = random(10, 255);
      this.flashing = false;
      this.flashingspan = 10;
      this.flashingcount = 0;
    }

    void update() {
      this.lifespan -= 1;
      if (this.ease < 1 && this.time == PI/4) {
        this.ease += (1 - this.ease)*this.speed + 0.001;
      } else {
        this.ease += cos(this.time)*0.0004;
        this.time += 0.013;
        this.theta += this.aspeed;
      }
    }

    void display() {
      pg.push();
      float a = this.isflash() ? 0 : this.alpha*this.ease;
      pg.fill(0, 0, 0, a);
      pg.noStroke();
      pg.translate(this.x, this.y);
      float x = cos(this.theta)*this.r*this.ease;
      float y = sin(this.theta)*this.r*this.ease;
      pg.ellipse(x, y, this.s*this.ease, this.s*this.ease);
      pg.pop();
    }

    boolean isflash() {
      if (random(1) < 0.0003 && !this.flashing) {
        this.flashing = true;
      }
      if (this.flashing) {
        this.flashingcount += 1;
        if (this.flashingcount > this.flashingspan) {
          this.flashing = false;
          this.flashingcount = 0;
        }
      }
      return this.flashing;
    }

    boolean isDead() {
      return this.lifespan < 0;
    }
  }
  class Ripple {
    float ease;
    float x;
    float y;
    float lifespan;
    float time;
    float r;
    float m;
    FloatList angle;
    FloatList linew;
    float theta;
    Ripple(float x, float y) {
      this.ease = 0;
      this.x = x;
      this.y = y;
      this.lifespan = 60;
      this.time = 0;

      this.r = 350;
      this.m = 275;
      final float rseed = random(1000000);
      float rw = random(0.1, 1.5);
      this.angle = new FloatList();
      this.linew = new FloatList();
      float[] a = new float[720];
      a[0] = noise(rseed);
      for (int i = 1; i < a.length; i++) {
        a[i] = noise(i / 3 + rseed);

        if (a[i] < 0.34) {
          if (a[i] < 0.4 && a[i - 1] > 0.4 || a[i] > 0.4 && a[i - 1] < 0.4) {
            rw = abs(P5JS.randomGaussian(0, 1.3)) * 0.4;
          }
          this.angle.push(i);
          this.linew.push(rw);
        }
      }

      this.theta = 0;
    }

    void update() {
      this.lifespan -= 1;
      if (this.ease < 1 && this.time == 0) {
        this.ease += (1 - this.ease) * 0.18 + 0.002;
      } else {
        this.ease += cos(this.time) * 0.0004;
        this.time += 0.013;
        this.theta += 0.0005;
      }
    }

    void display() {
      this.ripple();
      this.jagged();
      this.hline();
    }

    void ripple() {
      pg.push();
      pg.stroke(0);
      pg.fill(255);
      pg.strokeWeight(constrain((1 - this.ease) * 160, 1.8, 20));
      pg.ellipse(this.x, this.y, this.r * this.ease, this.r * this.ease);
      final float[] d = {0.98, 0.90, 0.91, 0.95, 1.01, 1.06};
      final float[] alpha = {0.8, 1.4, 0.5, 0.8, 1.2, 0.9};
      pg.noFill();
      for (int i = 0; i < d.length; i++) {
        pg.strokeWeight(alpha[i]);
        pg.stroke(160, 255, 255);
        pg.ellipse(this.x, this.y, this.r * this.ease * d[i], this.r * this.ease * d[i]);
      }
      pg.pop();
      //shadow
      // fill(0, 30)
      // noStroke()
      // ellipse(this.x, this.y + this.r * 0.7, this.ease * this.r * 0.5, 15)
    }

    void jagged() {
      pg.push();
      pg.translate(this.x, this.y);
      pg.rotate(this.theta);
      pg.strokeWeight(20);
      pg.stroke(210, 255, 255);
      pg.ellipse(0, 0, (this.m - 20) * 2 * this.ease, (this.m - 20) * 2 * this.ease);
      pg.strokeWeight(1);
      pg.stroke(0, 200);
      for (int i = 0; i < this.angle.size(); i++) {
        final float a = this.angle.get(i);
        final float d = this.linew.get(i) * this.m * 0.3;
        pg.stroke(160, 255, 255);
        pg.line(cos(radians(a / 2)) * (this.m - d * 0.7) * this.ease,
          sin(radians(a / 2)) * (this.m - d * 0.7) * this.ease, cos(radians(a / 2)) * (this.m + d) * this.ease, sin(radians(a / 2)) * (this.m + d) * this.ease);
      }
      pg.pop();
    }

    void hline() {
      pg.push();
      pg.translate(this.x, this.y);
      pg.stroke(0, 0, 0, 90);
      final float s = 0.5;
      final float s2 = 0.18;
      for (float i = 0; i < 6; i++) {
        pg.line(-this.m * (s - i / 10) * this.ease, -this.m * s2 - i * 2, this.m * (s - i / 10) * this.ease, -this.m * s2 - i * 2);
      }
      for (float i = 0; i < 6; i++) {
        pg.line(-this.m * (s - i / 10) * this.ease, this.m * s2 - (2 - i) * 2 + 5, this.m * (s - i / 10) * this.ease, this.m * s2 - (2 - i) * 2 + 5);
      }
      pg.pop();
    }

    boolean isDead() {
      return this.lifespan < 0;
    }
  }
  class Text {
    float ease;
    float x;
    float y;
    float lifespan;
    float time;
    String[] ts;
    float size;
    float space;
    float w;
    Text(float x, float y, String text) {
      this.ease = 0;
      this.x = x;
      this.y = y;
      this.lifespan = 60;
      this.time = 0;
      //this.ts = []
      //for (let t of text) {
      //  this.ts.push(t)
      //}
      this.ts = text.split("");
      this.size = 22;
      this.space = 16;
      this.w = (this.ts.length - 1) * this.space;
    }

    void update() {
      this.lifespan -= 1;
      if (this.ease < 1 && this.time == 0) {
        this.ease += (1 - this.ease) * 0.5 + 0.001;
      } else {

        this.ease += cos(this.time) * 0.0004;
        this.time += 0.013;
      }
    }

    void display() {
      pg.push();
      pg.textSize(this.size * 1.5 * this.ease);
      pg.fill(0);
      pg.translate(this.x, this.y);
      for (int i = 0; i < this.ts.length; i++) {
        float x = (i * this.space - this.w / 2) * this.ease;
        pg.stroke(100);
        pg.fill(240, 255, 255);
        // ellipse(x, 0, 10, 10)
        //fill(0)
        pg.noStroke();
        pg.text(this.ts[i], x, 0);
        pg.fill(0, 0, 0, 10);
      }
      pg.pop();
    }

    boolean isDead() {
      return this.lifespan < 0;
    }
  }

  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
