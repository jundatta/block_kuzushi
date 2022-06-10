// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Snow Globe
// https://openprocessing.org/sketch/968372
//

class GameSceneCongratulations142 extends GameSceneCongratulationsBase {
  final float radius = 300;
  Flake[] flakes = new Flake[250];
  float cameraX = 0;
  float cameraY = 0;
  float cameraZ = 800;
  float masterAngle = 0;

  PShape torus;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    for (int i=0; i<flakes.length; i++) {
      flakes[i] = new Flake();
    }
    torus = createTorus(125, 20, 24, 16, color(255, 100));
    sphereDetail(24);
  }
  @Override void draw() {
    background(0);
    ambientLight(200, 200, 200);
    if (mousePressed) {
      masterAngle-=(pmouseX-mouseX)/5.0f;
      cameraZ-=pmouseY-mouseY;
    }
    masterAngle+=.3;
    cameraX=cameraZ*cos(radians(masterAngle));
    cameraY=cameraZ*sin(radians(masterAngle));
    //cam.setPosition(cameraX, -200, cameraY);
    //cam.lookAt(0, 0, 0);
    camera(cameraX, -200, cameraY, 0, 0, 0, 0, 1, 0);
    pointLight(255, 255, 255, -width, height, cameraY);
    pointLight(255, 255, 255, -width, height, cameraY);


    noFill();
    stroke(255, 50);
    strokeWeight(.5);
    sphere(radius);
    push();
    translate(0, radius, 0);
    rotateX(radians(90));
    //stroke(255, 100);
    //strokeWeight(1);
    //  torus(125, 20);
    shape(torus);
    pop();
    for (Flake f : flakes) {
      push();
      f.move();
      f.bounce();
      f.show();
      pop();
    }

    logoRightLower(color(255, 0, 0));
  }

  class Flake {
    PVector vvect;
    PVector pvect;
    PVector cvect;
    float s;
    Flake() {
      this.vvect = PVector.random3D();
      this.pvect = PVector.random3D().mult(random(radius*0.9));
      this.cvect = PVector.random3D().mult(200);
      this.s = random(5, 8);
    }
    void move() {
      this.pvect.add(this.vvect);
      this.vvect.y+=0.02;
    }
    void bounce() {
      PVector center = new PVector(0, 0, 0);
      if (this.pvect.dist(center)>radius-this.s) {
        this.pvect.sub(this.vvect);
        PVector centerLine = this.pvect.copy().mult(-1);
        this.vvect = P5JS.reflect(centerLine, this.vvect);
        this.vvect.mult(0.5);
      }
    }
    void show() {
      translate(this.pvect.x, this.pvect.y, this.pvect.z);
      fill(200);
      noStroke();
      //    specularMaterial(this.cvect.x, this.cvect.y, this.cvect.z, 255);
      emissive(this.cvect.x, this.cvect.y, this.cvect.z);
      ambient(this.cvect.x, this.cvect.y, this.cvect.z);
      sphere(this.s);
    }
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == ' ') {
      for (Flake f : flakes) {
        f.vvect.y-=3;
        f.vvect.x*=1.5;
        f.vvect.z*=1.5;
      }
    }
  }
}
