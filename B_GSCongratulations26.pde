// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】dina gjertsenさん
// 【作品名】Squiggle
// https://openprocessing.org/sketch/1203465
//

class GameSceneCongratulations26 extends GameSceneCongratulationsBase {
  ArrayList<Particle> particles;

  class Particle
  {
    PVector position;
    PVector vec;
    color col;
    float cnt;

    Particle(PVector _vec, color _col)
    {
      this.position= new PVector(0, 0);
      this.vec=_vec;
      this.col=_col;
      this.cnt=0;
    }
  }

  @Override void setup() {
    particles=new ArrayList();
    noStroke();
    colorMode(HSB, 360, 100, 100, 100);
  }

  void xyz(Particle element) {
    element.cnt++;
    element.position.add(element.vec);
    if (element.cnt<800)
    {
      element.vec.rotate(0.07);
    }
    fill(element.col);
    ellipse(element.position.x, element.position.y, 3, 7);
  }

  @Override void draw() {
    push();
    clearBackground(99);
    translate(width/2, height/2);

    color c = color(frameCount%360, 80, 100, 80);
    particles.add(new Particle(new PVector(5, 0).rotate(cos(frameCount*frameCount/10000.0f)*PI+PI/4.0f), c));
    for (Particle element : particles) {
      xyz(element);
    }
    pop();

    logoRightLower(c);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
