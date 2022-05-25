// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】tinbaneさん
// 【作品名】Three Sides
// https://openprocessing.org/sketch/1249026
//

class GameSceneCongratulations82 extends GameSceneCongratulationsBase {
  final int grid_len = 100;
  class Grid {
    ArrayList<Circle> arr = new ArrayList();
  }
  Grid[][] grid;
  IntList palette;

  float theta_a = 45;
  float theta_b = -45;
  float cr = 100;

  ArrayList<Circle> cirs = new ArrayList();

  PGraphics pg;
  PShape pillar;

  int startTime;
  int elapsedTime;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    colorMode(HSB, 360, 100, 100, 100);
    //  angleMode(DEGREES);
    //  palette = shuffle(Chromotome.get().colors);
    palette = new IntList();
    for (int c : Chromotome.get().colors) {
      palette.push(c);
    }
    palette.shuffle();

    ortho(-width / 4, width / 4, -height / 4, height / 4, -5000, 5000);

    //camera = createCamera();
    //camera.setPosition(
    //  cos(theta_a) * cos(theta_b) * cr,
    //  cos(theta_a) * sin(theta_b) * cr,
    //  sin(theta_b) * cr
    //  );
    //camera.lookAt(0, 50, 0);
    float eyeX = cos(radians(theta_a)) * cos(radians(theta_b)) * cr;
    float eyeY = cos(radians(theta_a)) * sin(radians(theta_b)) * cr;
    float eyeZ = sin(radians(theta_b)) * cr;
    float centerX = 0;
    float centerY = 50;
    float centerZ = 0;
    float upX = 0;
    float upY = 1;
    float upZ = 0;
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);

    pg = createGraphics(1, 1);
    pillar = createCan(1.0f, 1.0f, 3);
    pillar.setTexture(pg);

    startTime = millis() - 6600;
  }

  void drawUpdate() {
    elapsedTime = millis() - startTime;
    if (elapsedTime < 6666) {
      return;
    }
    startTime = millis();

    //palette = shuffle(Chromotome.get().colors);
    palette = new IntList();
    for (int c : Chromotome.get().colors) {
      palette.push(c);
    }
    palette.shuffle();

    cirs = new ArrayList();
    grid = new Grid[grid_len][grid_len];

    for (int y = 0; y < grid_len; y++) {
      //    grid.push([]);
      grid[y] = new Grid[grid_len];
      for (int x = 0; x < grid_len; x++) {
        grid[y][x] = new Grid();
      }
    }

    for (int i = 0; i < 250; i++) {
      Circle cir = createCircle(0, 100);
      ArrayList<Circle> arr = getGridCircles(cir);
      boolean retry = false;
      int retryCount = 0;
      for (int p = 0; p < arr.size(); p++) {
        Circle c = arr.get(p);
        float len = dist(cir.x, cir.y, 0, c.x, c.y, 0) - c.l;
        if (len < 0) {
          retry = true;
          retryCount++;
          if (retryCount > 100) {
            continue;
          }
          break;
        }
        if (p == 0) {
          cir.l = len;
          arr = getGridCircles(cir);
          continue;
        }
        if (len < cir.l) {
          cir.l = len;
        }
      }
      if (retry && retryCount < 100) {
        i--;
        continue;
      }
      gridAddCircle(cir);
      cirs.add(cir);
    }
  }
  @Override void draw() {
    //  orbitControl();

    push();
    drawUpdate();

    ambientLight(0, 0, 50);
    directionalLight(0, 0, 80, 1, 0, -1);
    directionalLight(0, 0, 30, -1, 0, -1);
    directionalLight(0, 0, 50, 0, 1, 0);

    background(0);
    translate(0, height / 4, 0);

    for (Circle cir : cirs) {
      cir.display();
    }
    pop();

    push();
    ortho();
    camera();
    logoRightUpper(color(0, 100, 100));
    ortho(-width / 4, width / 4, -height / 4, height / 4, -5000, 5000);
    pop();
  }

  class Circle {
    float x;
    float y;
    float l;
    float h;
    int xRes;
    int yRes;
    color[] clr;
    int num;

    Circle(float x, float y, float l) {
      this.x = x;
      this.y = y;
      this.l = l;
      this.h = this.l;
      this.xRes = int(random(5, 10));
      this.yRes = int(random(5, 10));
      //    this.clr = shuffle(palette.concat());
      IntList tmp = palette.copy();
      tmp.shuffle();
      this.clr = tmp.array();
      this.num = int(random(2, 6));
    }
    void display() {
      float h = noise(this.x, this.y, millis() / 1666f) * this.h * 2;

      push();
      translate(this.x - width / 2, -h / 2.0f, this.y - height / 2);
      rotateZ(radians(180));
      noStroke();

      for (int i = 1; i <= this.num; i++) {
        // fill(this.color[i % this.color.length]);
        // cylinder((this.l * i) / this.num, h, 4, 1, false, false);

        push();
        float xScale = (this.l * i) * 0.2f;
        float yScale = h;
        float zScale = (this.l * i) * 0.2f;
        scale(xScale, yScale, zScale);

        //pillar.setFill(this.clr[i % this.clr.length]);
        color rgb = this.clr[i % this.clr.length];
        color hsb = color(hue(rgb), saturation(rgb), brightness(rgb));
        pg.beginDraw();
        pg.set(0, 0, hsb);
        pg.endDraw();
        shape(pillar);
        pop();
      }
      pop();
    }
  }

  Circle createCircle(float minL, float maxL) {
    return new Circle(random(0, width), random(0, height), random(minL, maxL));
  }

  int gridX(float x) {
    return constrain(int(x / grid[0].length), 0, grid[0].length - 1);
  }

  int gridY(float y) {
    return constrain(int(y / grid.length), 0, grid.length - 1);
  }

  ArrayList<Circle> getGridCircles(Circle cir) {
    //arr = [];
    //arr = arr.concat(grid[gridY(cir.y)][gridX(cir.x)]);
    ArrayList<Circle> arr = new ArrayList();
    for (Circle c : grid[gridY(cir.y)][gridX(cir.x)].arr) {
      arr.add(c);
    }

    int x1 = gridX(cir.x - cir.l),
      x2 = gridX(cir.x + cir.l);
    int y1 = gridY(cir.y - cir.l),
      y2 = gridY(cir.y + cir.l);
    for (int y = y1; y <= y2; y++) {
      for (int x = x1; x <= x2; x++) {
        //      arr = arr.concat(grid[y][x]);
        for (Circle c : grid[gridY(cir.y)][gridX(cir.x)].arr) {
          arr.add(c);
        }
      }
    }
    return arr;
  }

  void gridAddCircle(Circle cir) {
    int x1 = gridX(cir.x - cir.l),
      x2 = gridX(cir.x + cir.l);
    int y1 = gridY(cir.y - cir.l),
      y2 = gridY(cir.y + cir.l);
    for (int y = y1; y <= y2; y++) {
      for (int x = x1; x <= x2; x++) {
        grid[y][x].arr.add(cir);
      }
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
