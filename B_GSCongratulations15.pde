// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Processorさん
// 【作品名】Metaball Shader
// https://openprocessing.org/sketch/781343
// 【移植】PC-8001(TN8001)さん
//

class GameSceneCongratulations15 extends GameSceneCongratulationsBase {
  PShader metaballShader;

  int N_balls = 20;
  Metaball[] metaballs = new Metaball[N_balls];

  @Override void setup() {
    colorMode(RGB, 255);
    metaballShader = loadShader("data/15/shader.frag", "data/15/shader.vert");

    //  shader(metaballShader);

    for (int i = 0; i < N_balls; i ++)
      metaballs[i] = new Metaball();
  }
  @Override void draw() {
    float[] data = new float[N_balls * 3];

    for (int i = 0; i < N_balls; i ++) {
      Metaball ball = metaballs[i];
      ball.update();
      data[i * 3] = ball.pos.x;
      data[i * 3 + 1] = ball.pos.y;
      data[i * 3 + 2] = ball.radius;
    }

    metaballShader.set("metaballs", data, 3);
    metaballShader.set("WIDTH", float(width));
    metaballShader.set("HEIGHT", float(height));
    shader(metaballShader);
    rect(0, 0, width, height);
  }

  class Metaball {
    PVector vel;
    PVector pos;
    float size;
    float radius;

    Metaball() {
      size = pow(random(0.5), 2);
      vel = PVector.random2D().mult(5 * (1 - size) + 2);
      radius = 100 * size + 20;
      pos = new PVector(random(radius, width - radius), random(radius, height - radius));
    }

    void update() {
      pos.add(vel);

      if (pos.x < radius || pos.x > width  - radius) vel.x *= -1;
      if (pos.y < radius || pos.y > height - radius) vel.y *= -1;
    }
  }

  @Override void mousePressed() {
    resetShader();
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    resetShader();
    gGameStack.change(new GameSceneTitle());
  }
}
