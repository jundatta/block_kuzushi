// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Sayamaさん
// 【作品名】Wavy Sphere
// https://openprocessing.org/sketch/926372
//

class GameSceneCongratulations44 extends GameSceneCongratulationsBase {
  final float CYCLE = 100;
  PGraphics tex;
  float hu = 0;

  PShape sh;

  @Override void setup() {
    imageMode(CORNER);
    colorMode(RGB, 255);

    float s = min(width, height);
    noStroke();
    smooth();
    //  sphereDetail(60);
    sh = createShape(SPHERE, s*0.42);
    tex = createGraphics((int)s*2, (int)s*2);
    //texture(tex);
    //smooth();
    //noStroke();
    sh.setTexture(tex);
  }
  @Override void draw() {
    background(0);

    push();
    //  orbitControl();
    //texture
    float fc = (frameCount % CYCLE)/CYCLE;
    float step = (tex.width)/30.0f;

    //    image(tex, 0, 0, width, height);
    translate(width/2, height/2, 0);

    tex.beginDraw();
    tex.colorMode(HSB, 255);
    //  tex.noFill();
    //tex.clear();
    //  tex.background(0, 10);
    tex.noStroke();
    tex.fill(0, 10);
    tex.rect(0, 0, tex.width, tex.height);
    //tex.stroke(255);
    tex.strokeWeight(step/10.0f);
    for (float x = step*(- 3); x < tex.width + step*3; x+=step) {
      //tex.stroke(hu%255, 200, 255);
      tex.stroke(abs(x)%255, 200, 255);
      tex.beginShape();
      for (float y = 0; y <= tex.height; y+=10) {
        float r = map(y, 0, tex.height, 0, TAU*4) + fc*TAU;
        tex.vertex(x + sin(r)*step*(1 + cos(fc*TAU)*0.2), y);
      }
      tex.endShape();
    }
    tex.endDraw();
    rotateY(0.8);
    rotateX(1);
    //  sphere(min(width, height)*0.42, 60, 30);
    shape(sh);
    hu++;
    pop();

    colorMode(RGB, 255);
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
