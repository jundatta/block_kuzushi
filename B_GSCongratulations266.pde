// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】watabo_shiさん
// 【作品名】Xmas Tree
// https://openprocessing.org/sketch/1416184
//

class GameSceneCongratulations266 extends GameSceneCongratulationsBase {
  float vmin, vmax;
  PShader glsl;
  float radius;
  float depth;
  float thickness;
  float angle;
  float h;
  int NUM = 280;
  class Sphere {
    float x, y, z;
    int i;
    color c;
    Sphere(float x, float y, float z, int i, color c) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.i = i;
      this.c = c;
    }
  }
  Sphere[] sphereArr = new Sphere[NUM];

  void preload() {
    glsl = loadShader("data/266/shader.frag", "data/266/shader.vert");
  }

  Sphere getTreePos(int i, int num, float radius, float rOffset, float depth, float thickness, float angle) {
    float u = (float)i / (float)num;
    float a = u * angle;
    float r = (1 - u) + rOffset;
    float v = 0.5;
    float x = cos(a) * r;
    float y = map(v + u * depth, 0, 1, 0, -1) * thickness;
    float z = sin(a) * r;

    x *= radius;
    y *= radius;
    z *= radius;
    color c = color(i*100%255, 255, 255);
    return new Sphere(x, y, z, i, c);
  }

  @Override void setup() {
    preload();
    colorMode(HSB, 255, 255, 255);
    noStroke();
    vmin = min(width, height);
    vmax = max(width, height);

    radius = vmin / 4;
    depth = 14;
    thickness = 0.2;
    angle = TWO_PI * 11;
    h = radius * thickness * depth;

    for (int i = 0; i < NUM; i++) {
      sphereArr[i] = getTreePos(i, NUM, radius, 0.03, depth, thickness, angle);
    }
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    float sec = millis() / 1000.0f;
    float ry = -sec * 0.5;

    background(#001710);

    rotateY(ry);

    //gl.enable(gl.DEPTH_TEST);
    // ⇒Zバッファのチェックはする。
    //gl.depthFunc(gl.ALWAYS);
    // ⇒でも、Zバッファのチェックは「常に手前」と判定する。の意？
    //   。。。Zバッファのチェックはしない。（であってる？）
    //gl.enable(gl.BLEND);
    //gl.blendFunc(gl.SRC_ALPHA, gl.ONE);

    // vvv ？？？さんありがとう＼(^_^)／ vvv
    hint(DISABLE_DEPTH_TEST);
    // (gl.SRC_ALPHA, gl.ONE)の近似値になってる？
    blendMode(ADD);

    for (Sphere s : sphereArr) {
      push();
      {
        float x = s.x;
        float y = s.y;
        float z = s.z;
        int i = s.i;
        color c = s.c;

        translate(x, y + h / 2, z);
        rotateY(-ry);
        scale(1.0f + (1.0f - ((float)i / (float)NUM)) * 2.0f);
        shader(glsl);
        int r = (c >> 16) & 0xff;
        int g = (c >> 8) & 0xff;
        int b = c & 0xff;
        glsl.set("uColor", r/255.0f, g/255.0f, b/255.0f);
        //plane(vmin / 6);
        //      box(vmin / 6, vmin / 6, 1.0f);
        rect(-vmin/12, -vmin/12, vmin/6, vmin/6);
      }
      pop();
    }
    // ^^^ ？？？さんありがとう＼(^_^)／ ^^^
    resetShader();
    pop();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
