// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Javierさん
// 【作品名】Naves espaciales
// https://openprocessing.org/sketch/1373027
//

class GameSceneCongratulations226 extends GameSceneCongratulationsBase {
  PVector gravity;
  int mass = 20;
  float floorFriction;
  ArrayList<StarShip> balls = new ArrayList();
  float e = 0;
  float k = 0.85;
  PImage backgroundImage;
  PImage starshipImage;
  PImage explosion;
  PImage disparoImg;
  ArrayList<Hit> hits = new ArrayList();
  float score = 0;
  int timeToGameOver = 30;
  float frames = 0;
  CountDown countDown;
  PImage gameOverImg;
  PImage playerImg;
  // var hitSound;
  float level = 1;
  int numShips=5;

  void preload() {
    backgroundImage = loadImage("data/226/espacioo.jpg");
    starshipImage = loadImage("data/226/meteoritoo.png");
    explosion = loadImage("data/226/explosion.png");
    gameOverImg = loadImage("data/226/gameover.jpeg");
    playerImg = loadImage("data/226/deathstar-swe.png");
    //  hitSound = loadSound("data/226/disparo.mp3");
    mMA.entry("hit!!", "data/226/disparo.mp3");
    disparoImg = loadImage("data/226/bola de fuego.png");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();
    loadGame(numShips);
  }

  void loadGame(int num) {
    frames = 0;
    int numballs = num;
    gravity = new PVector(0, 0);
    floorFriction = 0.15;
    for (int i = 0; i < numballs; i ++) {
      StarShip ss = new StarShip( starshipImage,
        new PVector(random(0, width), random (0, height)),
        new PVector(random(10, -10), random(-10, 10)),
        random(30, 30),
        gravity, floorFriction, 1, false);
      balls.add(ss);
    }

    hits = new ArrayList();

    balls.get(0).manual = true;
    balls.get(0).radius = 50;
    balls.get(0).mass = 3;
    balls.get(0).image = playerImg;
    countDown = new CountDown(timeToGameOver, width*0.4f, height*0.2f, 32);
  }

  @Override void draw() {
    if (frames == 0) {
      countDown.start();
    }
    if (!countDown.finished) {
      imageMode(CORNER);
      image(backgroundImage, 0, 0, width, height);
      frames++;
      if (frames%60==0) {
        countDown.update();
      }
      countDown.draw();
      boolean imalone = true;
      //Update the velocity depending of the current gravity
      for (int i = 0; i < balls.size(); i++) {
        balls.get(i).draw();
        balls.get(i).update();
        if (i!=0 && balls.get(i).alive) {
          imalone = false;
        }
      }
      if (imalone) {
        numShips*=2;
        level++;
        loadGame(numShips);
      }
      //    console.log(hits.length);
      for (int i = 0; i < hits.size(); i++) {
        hits.get(i).draw();
        hits.get(i).update();
        for (int j = 0; j < balls.size(); j++) {
          if (j!=0 && balls.get(j).isTouching(hits.get(i).pos.x, hits.get(i).pos.y) && !balls.get(j).exploding)
          {
            score++;
            balls.get(j).explode();
          }
        }
        if (hits.get(i).pos.x<0 || hits.get(i).pos.x>width || hits.get(i).pos.y<0 || hits.get(i).pos.y>height) {
          hits.remove(i);
          i--;
        }
      }

      stroke(255, 255, 255);
      fill(255, 255, 255);
      textSize(32);
      text(score, width*0.7f, height*0.2f);
      textSize(64);
      textAlign(LEFT);
      text("Level "+level, width*0.2f, height*0.1f);
    } else {
      imageMode(CORNER);
      image(gameOverImg, 0, 0, width, height);
      if (isKey(ENTER)) {
        loadGame(numShips);
      }
    }

    logoRightLower(#ff0000);
  }

  class CountDown {
    //time in seconds,
    //x, y in pixels
    //size in text size
    int time, _time;
    float x, y;
    int size;
    boolean finished;
    int status;

    CountDown(int time, float x, float y, int size) {
      this.y = y;
      this.time = time;
      this.x = x;
      this.size = size;

      this._time = time;
      this.finished = false;
      this.status = 0; //0: Stopped, 1: Paused, 2:Playing
    }

    void update() {
      if (this.status==2) {
        this._time--;
        if (this._time==0) {
          this.finished = true;
          this.status = 0;
        }
      }
    }

    void draw() {
      fill(255, 255, 255);
      stroke(255, 255, 0);
      textAlign(CENTER);
      textSize(this.size);
      text(this._time, this.x, this.y);
    }

    void start() {
      this.finished = false;
      this.status = 2;
      this._time = this.time;
    }

    void pause() {
      this.status = 1;
    }

    void stop() {
      this.status = 0;
    }
  }

  class Explosion {
    PVector pos;
    float dim;
    float frame;
    boolean end;

    Explosion(PVector pos, float dim) {
      this.pos = pos;
      this.frame = 0;
      this.dim = dim;
      this.end = false;
    }

    void draw() {
      if (!this.end) {
        P5JS.image(getGraphics(), (int)this.pos.x, (int)this.pos.y, (int)this.dim, (int)this.dim,
          explosion, floor(this.frame%8)*240, floor(this.frame/8)*240, 240, 240);
        this.frame += 0.7;
        if (this.frame>=48) {
          this.end = true;
        }
      }
    }
  }


  class Hit {
    PVector pos;
    PVector vel;

    Hit(PVector pos, PVector vel) {
      this.pos = pos;
      this.vel = vel;
    }

    void draw() {
      if (this.vel.x>0) {
        push();
        stroke(255, 255, 0);
        strokeWeight(2);
        imageMode(CENTER);
        translate(this.pos.x, this.pos.y);
        rotate(PI);
        image(disparoImg, 0, 0, 200, 50);
        pop();
      } else {
        push();
        stroke(255, 255, 0);
        strokeWeight(2);
        imageMode(CENTER);
        translate(this.pos.x, this.pos.y);
        rotate(0);
        image(disparoImg, 0, 0, 200, 50);
        pop();
      }
    }

    void update() {
      this.pos.add(this.vel);
    }
  }

  class StarShip {
    PVector pos;
    PVector vel;
    float radius;
    PVector gravity;
    float friction;
    int mass;
    boolean manual;
    Explosion explosion;
    boolean exploding;
    boolean alive;
    PImage image;
    int hitRate, hitTime;

    StarShip(PImage image, PVector pos, PVector vel, float r, PVector gravity, float friction, int mass, boolean manual) {
      //objeto creado
      this.pos = pos;
      //variable pos del obs va a ser igual a la pos que me han pasado
      this.vel = vel;
      this.radius = r;
      this.gravity = gravity;
      this.friction = friction;
      this.mass = mass;
      this.manual = manual;
      this.explosion = new Explosion(this.pos, this.radius*2);
      this.exploding= false;
      this.alive = true;
      this.image = image;
      this.hitRate = 10;
      this.hitTime = 0;
    }

    boolean isTouching(float x, float y) {
      return (x>= this.pos.x-this.radius && x <= this.pos.x+this.radius &&
        y>= this.pos.y -this.radius && y <= this.pos.y+this.radius);
    }
    void checkCollisions() {
      for (int i = 0; i < balls.size(); i++) {
        if (balls.get(i)!=this && !balls.get(i).exploding && !this.exploding) {
          float d = PVector.dist(this.pos, balls.get(i).pos);
          if (d <= this.radius + balls.get(i).radius) {
            PVector pDiff = PVector.sub(balls.get(i).pos, this.pos);
            if (pDiff.mag()!= 0) {
              PVector n = PVector.div(pDiff, pDiff.mag());
              PVector vDiff = PVector.sub(balls.get(i).vel, this.vel);
              float spring = -k * (this.radius + balls.get(i).radius - d);
              float j = (1 + e) * (this.mass * balls.get(i).mass / (this.mass + balls.get(i).mass)) * PVector.dot(vDiff, n);
              PVector impulse = PVector.mult(n, j + spring);
              this.vel.add(impulse);
            }
          }
        }
      }
    }
    void draw() {
      if (!this.exploding) {
        imageMode(CENTER);
        image(this.image, this.pos.x, this.pos.y, this.radius*2, this.radius*2);
      } else {
        this.explosion.draw();
        if (this.explosion.end)
          this.alive = false;
      }
    }

    void explode() {
      this.exploding = true;
    }

    void update() {
      if (this.manual) {
        if (isKey(RETURN)) {
          this.vel.mult(0);
        }
        if (isKey(LEFT)) {
          this.vel.add(new PVector(-0.3, 0));
        }
        if (isKey(RIGHT)) {
          this.vel.add(new PVector(0.3, 0));
        }
        if (isKey(UP)) {
          this.vel.add(new PVector(0, -0.3));
        }
        if (isKey(DOWN)) {
          this.vel.add(new PVector(0, 0.3));
        }
        if (isKey(' ')) {
          if (this.hitTime==0)
          {
            //          hitSound.play();
            mMA.playAndRewind("hit!!");
            if (this.vel.x > 0)
              hits.add(new Hit(this.pos.copy(), new PVector(20, 0)));
            else
              hits.add(new Hit(this.pos.copy(), new PVector(-20, 0)));
          }
          this.hitTime++;
          if (this.hitTime>=this.hitRate)
            this.hitTime = 0;
        }
      }
      this.vel.add(this.gravity);
      this.pos.add(this.vel);

      if (this.pos.x - this.radius <= 0) {
        this.pos.x = this.radius;
        this.vel.mult(1-this.friction);
        this.vel.x *= -1;
      }
      if (this.pos.x + this.radius >= width) {
        this.pos.x = width - this.radius;
        this.vel.mult(1-this.friction);
        this.vel.x *= -1;
      }
      if (this.pos.y - this.radius <= 0) {
        this.pos.y = this.radius;
        this.vel.mult(1-this.friction);
        this.vel.y *= -1;
      }

      if (this.pos.y + this.radius >= height) {
        this.pos.y = height - this.radius;
        this.vel.mult(1-this.friction);
        this.vel.y *= -1;
      }
      if (this.alive)
        this.checkCollisions();
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    //    gGameStack.change(new GameSceneTitle());
  }
}
