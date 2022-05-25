// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Ivan Rudnicki
// https://openprocessing.org/sketch/969236
//

class GameSceneCongratulations146 extends GameSceneCongratulationsBase {
  int faces[][][] = {
    {
      {0, 0, 0},
      {0, 1, 0},
      {0, 0, 0},
    },
    {
      {1, 0, 1},
      {1, 0, 1},
      {1, 0, 1},
    },
    {
      {1, 0, 0},
      {0, 0, 0},
      {0, 0, 1},
    },
    {
      {1, 0, 1},
      {0, 1, 0},
      {1, 0, 1},
    },
    {
      {1, 0, 0},
      {0, 1, 0},
      {0, 0, 1},
    },
    {
      {1, 0, 1},
      {0, 0, 0},
      {1, 0, 1},
    }
  };
  class Orientation {
    float x;
    float y;
    float z;
    Orientation(float x, float y, float z) {
      this.x = x;
      this.y = y;
      this.z = z;
    }
  }
  Orientation[] orientation = {
    new Orientation(0, 0, 0),
    new Orientation(0, 0, PI),
    new Orientation(0, 0, PI/2),
    new Orientation(0, 0, PI),
    new Orientation(PI/2, PI, 0),
    new Orientation(PI, PI, 0)
  };
  float size;

  PShape edge;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    ambientLight(255, 255, 255);
    pointLight(255, 255, 255, 500, 500, 500);
    size=height/5.0f;
    edge = createCan(0.2*size, 0.05*size, 24, true, true);
  }
  @Override void draw() {
    background(0);
    push();
    //  orbitControl();
    translate(width/2, height/2);
    rotateX(frameCount/50.0f);
    rotateY(frameCount/50.0f);
    ambientLight(100, 100, 100);
    pointLight(200, 200, 200, width, -height, width);
    pointLight(200, 200, 200, width, -height, width);
    noStroke();
    //  specularMaterial(255, 255, 255, 150);
    fill(255, 255, 255, 150);
    for (int i=0; i<6; i+=1) {
      rotateX(orientation[i].x);
      rotateY(orientation[i].y);
      rotateZ(orientation[i].z);
      for (int row=0; row<3; row++) {
        for (int col=0; col<3; col++) {
          float x = -0.6*size+(0.6*size*col);
          float z = -0.6*size+(0.6*size*row);
          push();
          translate(x, 0.95*size, z);
          if (faces[i][row][col]!=0) {
            //          cylinder(0.2*size, .05*size);
            shape(edge);
          }
          pop();
        }
      }
    }
    //  specularMaterial(250, 0, 0, 100);
    fill(250, 0, 0, 100);
    box(2*size);
    pop();

    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
