// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Solar System
// https://openprocessing.org/sketch/1054533
//

class GameSceneCongratulations114 extends GameSceneCongratulationsBase {
  ArrayList<PImage> imgs = new ArrayList();
  ArrayList<Planet> planets = new ArrayList();
  float[] sizes = {60, 1.5, 3.7, 3.9, 2.1, 43.4, 36.1, 15.8, 15.3};
  float[] radii = {0, 57.9, 108.2, 149.6, 227.9, 778.6, 1433.5, 2872.5, 4495.1};
  float[] days = {1, 88, 225, 365, 687, 4333, 10759, 30687, 60190};
  boolean[] bRing = {false, false, false, false, false, false, true, false, false};
  PVector scenePos, scenePosVel;
  PVector sceneAng, sceneAngVel;
  PImage stars;

  PShape sphere;

  void preload() {
    imgs.add(loadImage("data/114/sun.png"));
    imgs.add(loadImage("data/114/mercury.png"));
    imgs.add(loadImage("data/114/venus.png"));
    imgs.add(loadImage("data/114/earth.png"));
    imgs.add(loadImage("data/114/mars.png"));
    imgs.add(loadImage("data/114/jupiter.png"));
    imgs.add(loadImage("data/114/saturn.png"));
    imgs.add(loadImage("data/114/uranus.png"));
    imgs.add(loadImage("data/114/neptune.png"));
    stars = loadImage("data/114/stars2.png");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();
    scenePos = new PVector(0, 0, 0);
    scenePosVel = new PVector(0, 0, 5);
    sceneAng = new PVector(PI / 12.0f, 0, 0);
    sceneAngVel = new PVector(-0.03, 0.03, 0);

    for (int i = 0; i < imgs.size(); i++) {
      PVector pos;
      if (i == 0) {
        pos = new PVector(0, 0, 0);
      } else {
        pos = new PVector(100 + (radii[i] / 4.0f), 0, 0);
      }
      PVector ang = new PVector(PI / 12.0f, 0, 0);
      PVector avel = new PVector(0, 0.01, 0);
      ang.x = -PI / 12.0f;
      ang.y = PI / 12.0f;
      PImage txt = imgs.get(i);
      float size = sizes[i];
      float orbit = random(TWO_PI);
      float ovel = 1 / days[i];
      planets.add(new Planet(pos, ang, avel, txt, size, orbit, ovel, bRing[i]));
    }

    sphere = createShape(SPHERE, 1500);
    sphere.setTexture(stars);
    sphere.setStrokeWeight(0);
  }
  @Override void draw() {
    push();
    translate(width / 2, height / 2);
    setScene();
    for (Planet p : planets) {
      p.move();
      p.show();
    }
    pop();

    logoRightLower(color(255, 0, 0));
  }


  void setScene() {
    background(0);
    scenePos.add(scenePosVel);
    if (scenePos.z < -450 || scenePos.z > 930) {
      scenePos.z -= scenePosVel.z;
      scenePosVel.z *= -1;
    }
    scenePosVel.mult(0.95);
    sceneAng.add(sceneAngVel);
    sceneAngVel.mult(0.95);
    translate(scenePos.x, scenePos.y, scenePos.z);
    rotateX(sceneAng.x);
    rotateY(sceneAng.y);
    rotateZ(sceneAng.z);
    noStroke();
    //  texture(stars);
    //  sphere(1500);
    shape(sphere);
  }

  final PVector ZERO = new PVector(0, 0, 0);

  class Planet {
    PVector pos;
    PVector ang;
    PVector avel;
    //  PImage txt;
    //  float size;
    float orbit;
    float ovel;
    PShape sphare;
    PShape ring;

    Planet(PVector pos, PVector ang, PVector avel, PImage txt, float size, float orbit, float ovel, boolean bRing) {
      this.pos = pos;
      this.ang = ang;
      this.avel = avel;
      //this.txt = txt;
      //this.size = size;
      this.orbit = orbit;
      this.ovel = ovel;
      this.ring = null;
      this.sphare = createShape(SPHERE, size);
      this.sphare.setTexture(txt);
      this.sphare.setStrokeWeight(0);
      if (bRing) {
        this.ring = createCan(size*1.5, 2, 24, true, true);
      } else {
        this.ring = null;
      }
    }
    void move() {
      if (!this.pos.equals(ZERO)) {
        this.orbit += this.ovel;    // 公転
        this.ang.y += this.avel.y;    // 自転
      }
    }
    void show() {
      push();
      rotateY(this.orbit);
      translate(this.pos.x, this.pos.y, this.pos.z);
      rotateX(this.ang.x);
      rotateY(this.ang.y);
      rotateZ(this.ang.z);
      noStroke();
      //texture(this.txt);
      //sphere(this.size);
      shape(this.sphare);
      if (this.ring != null) {
        rotateY(-this.ang.y);
        //      cylinder(this.size*1.5, 2);
        shape(this.ring);
      }
      pop();
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
