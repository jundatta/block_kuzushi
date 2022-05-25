// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Paint Puddles
// https://openprocessing.org/sketch/1087993
//

class GameSceneCongratulations71 extends GameSceneCongratulationsBase {
  float flip = 1;  // set flip = -1 before saving image or thumb. Afterward, set flip = 1
  PImage[] imgs = new PImage[2];
  ArrayList<Drop> drops = new ArrayList();
  float x, z, total, stretch;
  float dpr = 20;
  PVector cam, cvel;
  boolean done = false;
  int id = 0;
  float spacing;

  void P5preload() {
    imgs[0] = loadImage("data/71/Mona_Lisa.jpg");
    imgs[1] = loadImage("data/71/Frida_Kahlo.PNG");
  }

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    P5preload();

    setVariables(imgs[id]);
  }

  void setVariables(PImage img) {
    drops = new ArrayList();
    spacing = img.width/dpr;
    x=spacing/2.0f;
    z=spacing/2.0f;
    total = 2*dpr*dpr;
    stretch = 1200/(float)img.width;
    float camx = random(-800, 800);
    float camy = random(-1400, -1000);
    cam = new PVector(camx, camy, (height/2.5) / tan(PI*30.0 / 180.0));
    cvel = new PVector(-camx/30, 0, 0);
  }

  @Override void draw() {
    push();
    //  orbitControl();
    scale(1, -1);
    translate(0, 0, 200);
    setScene();
    spawnDrips(imgs[id]);
    for (Drop d : drops) {
      if (d.moving) d.move();
      d.show();
    }
    checkKeys();
    pop();

    logoRightLower(color(255, 0, 0));
  }

  void spawnDrips(PImage img) {
    if (x<=img.width) {
      color c = img.get((int)x, (int)z);
      drops.add(new Drop((x*stretch)-width/2.0f, random(-1.8*height, -1.2*height), -1100+z*stretch, red(c), green(c), blue(c)));
      z+=spacing;
      if (z>=img.height) {
        z=spacing/2.0f;
        x+=spacing;
      }
    }
  }

  void setScene() {
    background(0);
    lights();
    //  ambient(255);
    pointLight(255, 255, 255, 0, 200, 600);
    pointLight(255, 255, 255, 0, 200, 600);
    cam.add(cvel);
    if (cam.y>0 || cam.y<-1500) {
      cam.sub(cvel);
      cvel.y*=-0.3;
    }
    if (cam.x>1000 || cam.x<-1000) {
      cam.sub(cvel);
      cvel.x*=-0.3;
    }
    cvel.mult(0.98);
    camera(cam.x, cam.y, cam.z, 0, 0, 0, 0, flip, 0);
  }

  void P5ellipsoid(float x, float y, float z) {
    push();
    float m = max(x, y);
    m = max(m, z);
    scale(x/m, y/m, z/m);
    sphere(m);
    pop();
  }

  class Drop {
    PVector pos;
    PVector dim;
    PVector dvel;
    float dy;
    boolean moving;
    float r;
    float g;
    float b;
    Drop(float x, float y, float z, float r, float g, float b) {
      this.pos = new PVector(x, y, z);
      this.dim = new PVector(10, 10, 10);
      this.dvel = new PVector(0, 0, 0);
      this.dy = 0;
      this.moving = true;
      this.r = r;
      this.g = g;
      this.b = b;
    }
    void move() {
      this.pos.y+=this.dy;
      this.dy+=0.5;
      this.dim.add(this.dvel);
      if (this.pos.y>140) {
        this.dvel.x += 3;
        this.dvel.z += 3;
        this.dvel.y -= 1;
      }
      if (this.pos.y>220) {
        this.pos.y = random(221, 223);
        this.dy = 0;
        this.dvel.mult(0);
        this.moving = false;
      }
    }
    void show() {
      //    specular(this.r, this.g, this.b));
      fill(this.r, this.g, this.b);
      noStroke();
      push();
      translate(this.pos.x, this.pos.y, this.pos.z);
      P5ellipsoid(this.dim.x, this.dim.y, this.dim.z);
      pop();
    }
  }

  void checkKeys() {
    if (keyCode == UP) cvel.y-=2;
    if (keyCode == DOWN) cvel.y+=2;
    if (keyCode == RIGHT) cvel.x+=2;
    if (keyCode == LEFT) cvel.x-=2;

    keyCode = 0;
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (keyCode==32) {
      id=1-id;
      setVariables(imgs[id]);
    }
  }
}
