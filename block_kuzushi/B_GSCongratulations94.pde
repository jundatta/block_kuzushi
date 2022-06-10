// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Robert D'Arcyさん
// 【作品名】rubberDucky<br>
// https://openprocessing.org/sketch/396954
//

// There are about 4 or 5 (??) examples of this type of water simulation on Open Processing, nearly all archived.
// All of the sketches that I was able to find use variations of this code: http://www.neilwallis.com/projects/java/water/index.php
// So anyhoo, I just wanted to  put one together out of interest.
// Duck movement from Daniel Shiffman's "The Nature of Code" Ch 6: Autonomous agents (steering and boundary behaviour).
// Slower... than...... slow... in Javascript mode.
// pixels, PImage, Array, int, nested for-loops, PVector

class GameSceneCongratulations94 extends GameSceneCongratulationsBase {
  PImage img;
  int hlfWidth, hlfHeight, rippleRad, oldInd, newInd, mapInd;
  int rippleMap[], ripple[];
  Vehicle duck;
  float dst = 100;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    PImage imgTiles = loadImage("data/94/tiles.jpg");
    img = createImage(width, height, ARGB);
    img.copy(imgTiles, 0, 0, imgTiles.width, imgTiles.height, 0, 0, width, height);
    hlfWidth = width/2;
    hlfHeight = height/2;
    rippleRad = 3;
    rippleMap = new int[width * (height+2) * 2]; // 321,600 pixels
    ripple = new int[width*height];
    oldInd = width;
    newInd = width * (height+3);
    duck = new Vehicle(width/2, height/2);
    ellipseMode(CENTER);
    loadPixels();
  }
  @Override void draw() {
    updateData();
    for (int i = 0; i < pixels.length; i++) {
      pixels[i] = ripple[i];
    }
    updatePixels();
    duck.move();
    disturb(int(duck.pos.x), int(duck.pos.y));

    logo(color(255, 0, 0));
  }

  void updateData() {
    int i = oldInd;
    oldInd = newInd;
    newInd = i;
    i = 0;
    mapInd = oldInd;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int data = (rippleMap[mapInd-width]+rippleMap[mapInd+width]+rippleMap[mapInd-1]+rippleMap[mapInd+1]) >> 1;
        data -= rippleMap[newInd+i];
        data -= data  >> 5;
        // exclude wraparound effect
        if (x == 0 || y == 0)rippleMap[newInd + i] = 0;
        else rippleMap[newInd+i] = data;
        // where data == 0: still,  where data > 0: wave
        data = 1024-data;
        //offsets
        int a = int((x-hlfWidth)*data/1024+hlfWidth);
        int b = int((y-hlfHeight)*data/1024+hlfHeight);
        //bounds check
        if (a >= width) a = width-1;
        if (a < 0) a = 0;
        if (b >= height) b = height-1;
        if (b < 0) b = 0;

        ripple[i] = img.pixels[a+b*width];
        mapInd++;
        i++;
      }
    }
  }

  void disturb(int dx, int dy) {
    for (int j = dy-rippleRad; j < dy+rippleRad; j++) {
      for (int k = dx-rippleRad; k < dx+rippleRad; k++) {
        if (j >= 0 && j < height && k >= 0 && k < width) {
          rippleMap[oldInd+(j*width)+k] += 512;
        }
      }
    }
  }

  class Vehicle {
    PVector pos, vel, accel, steer, desired;
    float maxspeed, maxforce, theta;

    Vehicle(float x, float y) {
      pos = new PVector(x, y);
      accel = new PVector(0, 0);
      vel = new PVector(1, .8);
      vel.mult(3);
      maxspeed = 3;
      maxforce = .09;
    }

    void move() {
      update();
      boundaries();
      display();
    }

    void update() {
      vel.add(accel);
      vel.limit(maxspeed);
      pos.add(vel);
      accel.mult(0);
    }

    void boundaries() {
      desired = null;
      if (pos.x < dst) desired = new PVector(maxspeed, vel.y);
      else if (pos.x > width -dst) desired = new PVector(-maxspeed, vel.y);
      if (pos.y < dst) desired = new PVector(vel.x, maxspeed);
      else if (pos.y > height-dst) desired = new PVector(vel.x, -maxspeed);
      if (desired != null) {
        desired.normalize();
        desired.mult(maxspeed);
        steer = PVector.sub(desired, vel);
        steer.limit(maxforce);
        accel.add(steer);
      }
    }

    void display() {
      theta = vel.heading() + (PI * .5);
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(theta);
      drawDuck();
      popMatrix();
    }

    void drawDuck() {
      strokeWeight(3);
      stroke(#E8CE02, 150);
      fill(#FFE203);
      ellipse(0, 0, 40, 50);

      fill(#F78519);
      strokeWeight(1);
      stroke(#FF3B05);
      ellipse(0, -12, 18, 20);

      strokeWeight(3);
      stroke(#E8CE02, 150);
      fill(#FFE203);
      ellipse(0, 0, 25, 30);

      fill(0);
      noStroke();
      ellipse(-4, -9, 4, 4);
      ellipse(4, -9, 4, 4);
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
