// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Sayama？さん
// 【作品名】Tiles
// https://openprocessing.org/sketch/1201950
//

class GameSceneCongratulations18 extends GameSceneCongratulationsBase {
  final int CYCLE = 450;
  final int NUM = 40;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100);

    //ortho
    int dep = max(width, height);
    ortho(-width / 2, width / 2, -height / 2, height / 2, -dep*3, dep*3);
  }
  @Override void draw() {
    push();
    translate(width / 2, height / 2);

    strokeWeight(0.5);

    final int frameSpan = CYCLE / NUM;
    final float unitMaxSize = width * 0.15;
    lights();
    float radius = 0.5 * (width - unitMaxSize * 1.2);

    background(0);

    //noStroke();
    rotateX(-PI/4.0f);
    rotateY(-PI/4.0f);

    for (int i = 0; i < NUM; i++) {
      float angle = getRaioEased(frameCount + i * frameSpan) * TAU;
      //let r = unitMaxSize * (0.6 + 0.4 * sin(i / NUM * TAU));
      float r = 140;
      float x = radius * cos(angle);
      float y = 0;
      float z = radius * sin(angle);

      ellipseMode(CENTER);
      //    ambientMaterial(i/NUM*360, 100, 100);
      emissive(i/(float)NUM*360, 100, 100);
      fill(i/(float)NUM*360, 100, 100);
      push();
      translate(x, y, z);
      rotateX(PI/2.0f);
      rotate (angle*2.0f);
      //    cylinder(r/3,r/30,5,1)
      pushMatrix();
      //scale(1.0f, 10.0f, 10.0f);
      //shape.stroke(0).strokeWeight(1).fill(color(0, 0, 100)); // set fill color and drawmode
      //shape.draw(getGraphics());
      rotateY(PI/4.0f);
      float Width = r / 3.0f * 2.0f / sqrt(2.0f);
      float Height = r / 30.0f;
      float Depth = r / 3.0f * 2.0f / sqrt(2.0f);
      line(-(Width/2.0f), -(Height/2.0f), -(Depth/2.0f), +(Width/2.0f), -(Height/2.0f), +(Depth/2.0f));
      line(+(Width/2.0f), -(Height/2.0f), -(Depth/2.0f), -(Width/2.0f), -(Height/2.0f), +(Depth/2.0f));
      line(-(Width/2.0f), +(Height/2.0f), -(Depth/2.0f), +(Width/2.0f), +(Height/2.0f), +(Depth/2.0f));
      line(+(Width/2.0f), +(Height/2.0f), -(Depth/2.0f), -(Width/2.0f), +(Height/2.0f), +(Depth/2.0f));
      box(Width, Height, Depth);
      popMatrix();
      pop();
    }
    pop();

    logo(color(frameCount % 360, 100, 100));
  }

  float getRatio(int count)
  {
    float frameRatio  = (count % CYCLE) / (float)CYCLE;

    return frameRatio;
  }

  float getRaioEased(int count)
  {
    float ratio = getRatio(count);
    float easeRatio = easingEaseInOutQuint(ratio)  * 0.9 + ratio * 0.1 ;

    return easeRatio;
  }

  float easingEaseInOutQuint(float x)
  {
    if (x < 0.5) {
      return 0.5 * pow(2 * x, 5);
    } else {
      return 0.5* pow(2 * (x - 1), 5) + 1;
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
