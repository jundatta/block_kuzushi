// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Xiaohanさん
// 【作品名】Planet Cube
// https://openprocessing.org/sketch/1225378
//

class GameSceneCongratulations34 extends GameSceneCongratulationsBase {
  // rotating cubes color set
  color[] colorSet = {#CCCCFF, #FFCC99, #FFCCCC, #6666FF, #6699CC, #FFFFCC, #CC6633};
  ArrayList<Cube> cubes = new ArrayList();

  class Cube {
    float angle;
    float radius;
    float size;
    float speed;
    color cubeColor;
    float zDiff;
    float xR;
    float yR;
    float changeRate;

    Cube() {
      // position is replaced with polar angle and radius below
      this.angle = random(0, TWO_PI);
      this.radius = random(270, 750);

      this.size = random(10, 15); // size control
      this.speed = 0.02;
      this.cubeColor = color(P5JSrandom(colorSet));

      // other controls
      this.zDiff = random(-5, 5); // plane control
      this.xR = random(0, TWO_PI); // self rotateX
      this.yR = random(0, TWO_PI); // self rotateY

      this.changeRate = random(-0.1, 0.1); // size and z change rate
    }

    void nextState() {
      if (this.size < 5 || this.size > 20) this.changeRate = -this.changeRate;
      this.size=this.size*(1.0f+this.changeRate);
      this.angle+=this.speed;
      this.xR+=0.01;
      this.yR+=0.01;
      this.zDiff+=this.changeRate;
    }
  }

  // universe, planet and light colors
  final color COLOR_UNIVERSE = #000033;
  final color COLOR_PLANET = #AAFFFF;
  final color COLOR_ALIGHT = #F9E79F;
  final color COLOR_BLIGHT = #FFCCFF;

  @Override void setup() {
    colorMode(RGB, 255);
    // create 500 cubes
    for (int i=0; i<500; ++i) {
      cubes.add(new Cube());
    }
  }
  @Override void draw() {
    background(COLOR_UNIVERSE);

    push();
    translate(width / 2, height / 2, 0);

    // rotation of the whole system
    rotateX(-PI/6.0f+frameCount * 0.005);
    rotateY(frameCount * 0.01);
    rotateZ(-PI/10.0f);

    lights();
    // simulate some "day-night" effect by lighting
    if (frameCount%300>150) {
      ambientLight(red(COLOR_ALIGHT) * 0.2, green(COLOR_ALIGHT) * 0.2, blue(COLOR_ALIGHT) * 0.2);
      pointLight(red(COLOR_BLIGHT), green(COLOR_BLIGHT), blue(COLOR_BLIGHT), 2000, 0, 0);
    } else {
      ambientLight(red(COLOR_BLIGHT) * 0.2, green(COLOR_BLIGHT) * 0.2, blue(COLOR_BLIGHT) * 0.2);
      pointLight(red(COLOR_ALIGHT), green(COLOR_ALIGHT), blue(COLOR_ALIGHT), 2000, 0, 0);
    }

    noStroke();

    // draw central planet
    //  ambientMaterial(COLOR_PLANET);
    fill(COLOR_PLANET);
    box(200);

    // draw planet ring with particle system
    for (int i=0; i<cubes.size(); i++) {
      Cube cube = cubes.get(i);

      /*if (cube.lifeSpan <= 0) {
       // replace the expired cube with brand new one
       cubes.splice(i, 1);
       cubes.push(new Cube(0));
       }*/

      push();
      translate(cube.radius*cos(cube.angle), cube.zDiff, cube.radius*sin(cube.angle));
      rotateX(cube.xR);
      rotateY(cube.yR);
      //    ambientMaterial(cube.cubeColor);
      fill(cube.cubeColor);
      sphere(cube.size/2.0f);
      cube.nextState(); // update the cube
      pop();
    }
    pop();

    translate(0, 0, +200);
    ambientLight(255, 255, 255);
    logo(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
