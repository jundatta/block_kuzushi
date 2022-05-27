// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】fumixさん
// 【作品名】particlock
// https://neort.io/art/c80siac3p9f3k6tguo4g
//

class GameSceneCongratulations190 extends GameSceneCongratulationsBase {
  Vehicle[] vehicles;
  ArrayList<PVector> target = new ArrayList();
  int targetCount;
  final int[][] numberArray = {
    {
      0, 1, 1, 0,
      1, 0, 0, 1,
      1, 0, 0, 1,
      1, 0, 0, 1,
      0, 1, 1, 0
    },
    {
      0, 1, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 1, 1, 1
    },
    {
      1, 1, 1, 0,
      0, 0, 0, 1,
      0, 1, 1, 0,
      1, 0, 0, 0,
      1, 1, 1, 1
    },
    {
      1, 1, 1, 0,
      0, 0, 0, 1,
      0, 1, 1, 0,
      0, 0, 0, 1,
      1, 1, 1, 0
    },
    {
      1, 0, 0, 1,
      1, 0, 0, 1,
      1, 1, 1, 1,
      0, 0, 0, 1,
      0, 0, 0, 1
    },
    {
      1, 1, 1, 1,
      1, 0, 0, 0,
      1, 1, 1, 0,
      0, 0, 0, 1,
      1, 1, 1, 0
    },
    {
      0, 1, 1, 1,
      1, 0, 0, 0,
      1, 1, 1, 0,
      1, 0, 0, 1,
      0, 1, 1, 0
    },
    {
      1, 1, 1, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 1, 0,
      0, 0, 1, 0
    },
    {
      0, 1, 1, 0,
      1, 0, 0, 1,
      0, 1, 1, 0,
      1, 0, 0, 1,
      0, 1, 1, 0
    },
    {
      0, 1, 1, 0,
      1, 0, 0, 1,
      0, 1, 1, 1,
      0, 0, 0, 1,
      0, 1, 1, 0
    },
  };
  ArrayList<ArrayList<PVector>> numberCoordunate;

  boolean clicked;
  int[] shuffleColor = {0, 1, 2};

  DigitalDisplayGlid digitaldisplay;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noSmooth();
    reset();
  }

  void reset() {
    background(0);

    digitaldisplay = new DigitalDisplayGlid();

    vehicles = new Vehicle[1200];
    for (int i = 0; i < vehicles.length; i++) {
      vehicles[i] = new Vehicle(digitaldisplay.resolution, random(width), random(height));
    }

    //デジタル数値用の各種座標を設定する
    numberCoordunate = new ArrayList();
    int resolution = int(height / 5.0f);
    if (resolution * 4 > width) {
      resolution = int(width / 4.0f);
    }

    for (int index = 0; index < numberArray.length; index++) {
      int[] element = numberArray[index];
      ArrayList<PVector> field = new ArrayList();
      for (int j = 0; j < 5; j++) {
        for (int i = 0; i < 4; i++) {
          if (element[i + j * 4] == 1) {
            PVector d = new PVector(i * resolution + resolution / 2.0f +  width / 2.0f - 4*resolution / 2.0f, j * resolution + resolution / 2.0f +  height / 2.0f - 5*resolution / 2.0f);
            field.add(d);
          }
        }
      }
      numberCoordunate.add(field);
    }
    targetCount = 0;
    target = numberCoordunate.get(targetCount);

    clicked = false;
  }

  ArrayList<PVector> setNumber(int num, float offsetX) {
    //  String numStr = num.toString().padStart(2, '0');
    //int numLeft = numStr.substr(0, 1);
    //int numRight = numStr.substr(1, 1);
    int numLeft = num / 10;
    int numRight = num % 10;
    ArrayList<PVector> target = new ArrayList();
    for (int r=0; r<5; r++) {
      for (int c=0; c<4; c++) {
        if (numberArray[numLeft][c + r*4]==1) {
          target.add(digitaldisplay.lookup(new PVector(c+offsetX, r)));
        }
      }
    }
    for (int r=0; r<5; r++) {
      for (int c=0; c<4; c++) {
        if (numberArray[numRight][c + r*4]==1) {
          target.add(digitaldisplay.lookup(new PVector(c+offsetX+5, r)));
        }
      }
    }
    return target;
  }

  @Override void draw() {
    fill(0, 15);
    noStroke();
    blendMode(BLEND);
    rect(0, 0, width, height);

    //let dObj    = new Date();
    //let hours   = dObj.getHours();
    //let minutes = dObj.getMinutes();
    //let seconds = dObj.getSeconds();
    int hours = hour();
    int minutes = minute();
    int seconds = second();

    target = new ArrayList();

    //時：
    target.addAll(setNumber(hours, 1));
    target.add(digitaldisplay.lookup(new PVector(11, 1)));
    target.add(digitaldisplay.lookup(new PVector(11, 3)));
    //分：
    target.addAll(setNumber(minutes, 13));
    target.add(digitaldisplay.lookup(new PVector(23, 1)));
    target.add(digitaldisplay.lookup(new PVector(23, 3)));
    //秒
    target.addAll(setNumber(seconds, 25));


    blendMode(ADD);
    int loop = floor(vehicles.length / (float)target.size());
    for (int i = 0; i < target.size(); i++) {
      PVector elemen = target.get(i);
      for (int j = 0; j < loop; j++) {
        Vehicle vehicle = vehicles[j+i*loop];
        if (!clicked) {
          vehicle.seek(elemen);
        }
        vehicle.update();
        vehicle.checkEdges();
        vehicle.display();
      }
    }

    logoRightLower(#ff0000);
  }

  class Vehicle {
    PVector location, oldlocation, velocity, acceleration, target;
    float resolution, r;
    float maxspeed, maxforce;
    int count;
    color[] col = {0, 0, 0};

    Vehicle(float r, float x, float y) {
      this.location = new PVector(x, y);
      this.oldlocation = new PVector(x, y);
      this.velocity = new PVector(0, 0);
      this.acceleration = new PVector(0, 0);
      this.target = new PVector(0, 0);
      this.resolution = r*0.5;
      this.r = 3.0;
      this.maxspeed = 14;
      this.maxforce =5;//加速度
      this.count = frameCount;
      this.col[0] = int(random(1)*128+128);
      this.col[1] = int(random(1)*(this.col[0]*0.60) + this.col[0]*0.20);
      this.col[2] = int(random(1)*(this.col[1]*0.60) + this.col[1]*0.20);
    }
    void update() {
      this.velocity.add(this.acceleration);
      this.velocity.limit(this.maxspeed);
      this.location.add(this.velocity);
      this.acceleration.mult(0);
    }
    void applyForce(PVector force) {
      this.acceleration.add(force);
    }
    void seek(PVector target) {//追求能力のアルゴリズム
      if (this.count < frameCount) {
        PVector t = new PVector(1, 0);
        t.rotate(random(TWO_PI));
        t.mult(this.resolution);
        this.target = PVector.add(target, t);
        this.count = frameCount +0;
      }
      final PVector desired = PVector.sub(this.target, this.location);
      float d = desired.mag();
      this.maxspeed = d * 0.5;
      desired.normalize();
      desired.mult(this.maxspeed);
      PVector steer = PVector.sub(desired, this.velocity);
      steer.limit(this.maxforce);
      this.applyForce(steer);
    }

    void checkEdges() {
      PVector desired;
      PVector steer;
      if (this.location.x > width - 15) {
        desired = new PVector(-this.maxspeed, this.velocity.y);
        steer = PVector.sub(desired, this.velocity);
        steer.limit(this.maxforce);
        this.applyForce(steer);
        //this.location.x = width;
        //this.velocity.x *= -1;
      } else if (this.location.x < 15) {
        desired = new PVector(this.maxspeed, this.velocity.y);
        steer = PVector.sub(desired, this.velocity);
        steer.limit(this.maxforce);
        this.applyForce(steer);
        //this.velocity.x *= -1;
        //this.location.x = 0;
      }
      if (this.location.y > height - 15) {
        desired = new PVector(this.velocity.x, -this.maxspeed);
        steer = PVector.sub(desired, this.velocity);
        steer.limit(this.maxforce);
        this.applyForce(steer);
        //this.velocity.y *= -1;
        //this.location.y = height;
      } else if (this.location.y < 15) {
        desired = new PVector(this.velocity.x, this.maxspeed);
        steer = PVector.sub(desired, this.velocity);
        steer.limit(this.maxforce);
        this.applyForce(steer);
        //this.velocity.y *= -1;
        //this.location.y = 0;
      }
    }

    void display() {
      stroke(color(this.col[shuffleColor[0]], this.col[shuffleColor[1]], this.col[shuffleColor[2]]));
      line(this.location.x, this.location.y, this.oldlocation.x, this.oldlocation.y);
      this.oldlocation = new PVector(this.location.x, this.location.y);
    }
  }
  class DigitalDisplayGlid {
    int cols, rows;
    int resolution;
    ArrayList<PVector> field;

    DigitalDisplayGlid() {
      this.cols = 35;
      this.rows = 5;
      this.resolution = int(width / (float)this.cols);
      if (this.resolution * this.rows > height) {
        this.resolution = int(height / (float)this.rows);
      }
      this.field = new ArrayList();
      for (int j = 0; j < this.rows; j++) {
        for (int i = 0; i < this.cols; i++) {
          PVector d = new PVector(i * this.resolution + this.resolution / 2.0f, j * this.resolution + this.resolution / 2.0f +height / 2.0f -this.rows*this.resolution / 2.0f);
          this.field.add(d);
        }
      }
    }
    PVector lookup(PVector lookup) {// 位置に基づいてベクトルを返す
      int index = (int)lookup.x + (int)(lookup.y * this.cols);
      return this.field.get(index);
    }
  }

  @Override void mousePressed() {
    clicked = !clicked;
    if (clicked) shuffleColor = P5JS.shuffle(shuffleColor);
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
