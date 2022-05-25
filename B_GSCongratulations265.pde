// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/c7r35ks3p9fclnodut9g
//

class GameSceneCongratulations265 extends GameSceneCongratulationsBase {
  PShader[] theShader;
  int NI = 50;

  float w;

  int N;
  int nn;
  float t0, t1, t2, t3;
  float tc;
  int ns;

  @Override void setup() {
    w = min(width, height);

    N = 5;
    nn = N*12;
    theShader = new PShader[N];

    background(0);

    colorMode(HSB, 360, 100, 100);
    noStroke();

    theShader = new PShader[N];
    for (int i=0; i<N; i++) {
      theShader[i] = loadShader("data/265/neort.frag", "data/265/neort.vert");
      shader(theShader[i]);
      set_uniform(theShader[i]);
    }

    t0 = random(12, 16) * P5JSrandom(-1, 1);
    t1 = random(2, 5) * P5JSrandom(-1, 1);
    t2 = random(2, 5) * P5JSrandom(-1, 1);
    t3 = random(15, 22) * P5JSrandom(-1, 1);

    tc = random(15, 22) * P5JSrandom(-1, 1);

    ns = int(random(6, 9));
  }

  @Override void draw() {
    push();
    rectMode(CENTER);
    translate(width/2, height/2);

    background(0);
    float t = frameCount/12.0f;
    fill(0, 0);

    push();
    shader(theShader[0]);
    rotateZ(t/tc);
    rect(0, 0, w*0.3, w*0.3);
    pop();

    float r0 = w/8.0f;
    float r1 = w/4.0f;
    float r2 = w/14.0f;
    float l0 = w/8.0f;
    for (int i=0; i<nn; i++) {
      push();
      shader(theShader[i%N]);
      float r = r0 + r1*abs(sin(t/t0)) + r2*sin(TAU/nn*i*ns + t/t1);
      float l = l0 * sin(TAU/nn*i*4 + t/t2);
      float x = r * cos(TAU/nn*i + t/t3);
      float y = r * sin(TAU/nn*i + t/t3);
      rect(x, y, l, l);
      pop();
    }
    resetShader();
    pop();

    logoRightLower(#ff0000);
  }

  void set_uniform(PShader in_shader) {
    for (int i = 0; i < NI; i++) {
      String name = "u_rnd" + i;
      in_shader.set(name, random(1.0/5.0), random(1.0/64.0), random(-1.0, 1.0), random(-1.0, 1.0));
    }

    for (int i = 0; i < 4; i++) {
      String name = "u_color" + i;
      PVector u_c = color_set(rand_color_A());
      in_shader.set(name, u_c.x, u_c.y, u_c.z);
    }

    for (int i = 0; i < 2; i++) {
      String name = "u_color" + (i+4);
      PVector u_c = color_set(rand_color_B());
      in_shader.set(name, u_c.x, u_c.y, u_c.z);
    }
  }
  PVector color_set(color in_color) {
    // RGBで取り出したいときにはcolorMode()をRGBに戻す
    // ⇒Processing Javaの場合はそうしないといけないように見える
    // 　p5.jsではそれはしなくてもいいように見える
    push();
    colorMode(RGB, 255, 255, 255);
    PVector vec_color = new PVector(red(in_color)/255.0, green(in_color)/255.0, blue(in_color)/255.0);
    pop();

    //int r = (in_color & 0x00FF0000) >> 16;
    //int g = (in_color & 0x0000FF00) >> 8;
    //int b = (in_color & 0x000000FF);
    //PVector vec_color = new PVector(r / 255.0, g / 255.0, b / 255.0);

    return vec_color;
  }
  color rand_color_A() {
    return color(random(100, 280), random(80, 100), random(70, 100));
  }
  color rand_color_B() {
    return color(random(50, 360), random(30, 70), random(70, 100));
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
