// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Che-Yu Wuさん
// 【作品名】Birds on Wires
// https://openprocessing.org/sketch/1247594
//

class GameSceneCongratulations81 extends GameSceneCongratulationsBase {
  ArrayList<BirdBar> birdBars = new ArrayList();
  PGraphics overAllTexture;
  FloatList floors = new FloatList();

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(255);
    overAllTexture=createGraphics(width, height);
    overAllTexture.beginDraw();
    for (var i=0; i<width+50; i++) {
      for (var o=0; o<height+50; o++) {
        overAllTexture.set(i, o, color(150, noise(i/10, o/10)*P5JSrandom(0, 0, 0, 50, 120)));
      }
    }
    overAllTexture.endDraw();

    for (int o=0; o<4; o++) {
      float barDist = random(200, 800);
      float startY = o*200+50;
      floors.push(startY);
      for (int i=0; i<7; i++) {
        float startX = -300 + barDist*i;
        int num = (int)random(colors123.length);
        color[] colors = colors123[num];
        birdBars.add(new BirdBar(
          new PVector(startX, startY),
          new PVector(startX+barDist, startY),
          colors,
          new PVector(15, random(30, 30)),
          new PVector(4+o*2, 500),
          startY
          ));

        num = (int)random(colors123.length);
        colors = colors123[num];
        birdBars.add(new BirdBar(
          new PVector(startX, startY+50),
          new PVector(startX+barDist, startY+50+50),
          colors,
          new PVector(15, random(30, 30)),
          new PVector(4+o*2, 500),
          startY
          ));

        num = (int)random(colors123.length);
        colors = colors123[num];
        birdBars.add(new BirdBar(
          new PVector(startX, startY+120),
          new PVector(startX+barDist, startY+50),
          colors,
          new PVector(15, random(30, 30)),
          new PVector(4+o*2, 500),
          startY
          ));
      }
    }
    IntList bgColors = new IntList();
    for (color[] colors : colors123) {
      for (color c : colors) {
        if (c == #ffffff) {
          continue;
        }
        bgColors.push(c);
      }
    }
    int num = (int)random(bgColors.size());
    bgColor=bgColors.get(num);
  }
  color bgColor;
  @Override void draw() {
    background(bgColor);

    noStroke();
    for (float flr : floors) {
      push();
      rectMode(CENTER);
      fill(255, 80);
      rotate(sin(flr)/30 );
      rect(width/2, flr+height/2+200, width*1.2, height);
      pop();
    }

    for (BirdBar bar : birdBars) {
      bar.update();
      bar.draw();
    }

    push();
    //  blendMode(MULTIPLY);
    image(overAllTexture, 0, 0);
    pop();

    logoRightUpper(color(255, 0, 0));
  }

  color[] colors1 = { #0c090d, #e01a4f, #f15946, #f9c22e, #53b3cb };
  color[] colors2 = { #447604, #6cc551, #9ffcdf, #52ad9c, #47624f };
  color[] colors3 = { #173753, #6daedb, #2892d7, #1b4353, #1d70a2, #ffffff, #222222 };
  color[][] colors123 = { colors1, colors2, colors3 };

  class BirdBar {
    PVector leftPoint;
    PVector rightPoint;
    float randomId;
    PVector barSize;
    PVector birdSize;
    color[] colors;
    color barColor;
    color lineColor;
    float startY;

    BirdBar(PVector leftPoint, PVector rightPoint, color[] colors,
      PVector birdSize, PVector barSize, float startY) {
      this.leftPoint = leftPoint;
      this.rightPoint = rightPoint;
      this.randomId = random(1000000);
      this.barSize = barSize;
      this.birdSize = birdSize;
      this.colors = colors;
      this.barColor = color(0);
      this.lineColor = color(0);
      this.startY = startY;
    }
    void draw() {
      push();
      stroke(this.lineColor);
      strokeWeight(1.5);
      noFill();
      final int nodeCount = 30;
      beginShape();
      translate(mouseX/(float)(height-this.startY)*8.0f, 0);
      for (int i=0; i<=nodeCount; i++) {
        PVector midPoint = PVector.lerp(this.leftPoint, this.rightPoint, i/(float)nodeCount);
        midPoint.y+=sin(i/(float)nodeCount*PI)*60;
        vertex(midPoint.x, midPoint.y);
      }
      endShape();
      for (int i=0; i<=nodeCount; i++) {
        PVector midPoint = PVector.lerp(this.leftPoint, this.rightPoint, i/(float)nodeCount);
        midPoint.y+=sin(i/(float)nodeCount*PI)*60;

        if (i!=0 && i!=nodeCount && (i%3==0) ) {
          push();
          translate(midPoint.x, midPoint.y-this.birdSize.y/2.0f);
          if ( sin(i/10.0f+frameCount/10.0f+this.randomId)>0.95) {
            translate(0, -20);
          }
          noStroke();
          // fill(colors[i%5])
          int colorIndex = int(noise(i, this.randomId)*20) % this.colors.length;
          fill(this.colors[colorIndex]);
          arc(0, 0, this.birdSize.x, this.birdSize.y, 0, PI);
          int colorIndex2 = int(3 + noise(i, this.randomId)*20) % this.colors.length;
          fill(this.colors[colorIndex2]);
          arc(0, 0, this.birdSize.x, this.birdSize.y, PI, 2*PI);
          int colorIndex3 = int(2 + noise(i, this.randomId)*20) % this.colors.length;
          fill(this.colors[colorIndex3]);

          // ellipse(-5,-5,6,6)
          // ellipse(5,-5,6,6)
          translate(0, -5);
          triangle(-5, 0, 0, 10, 5, 0);
          pop();
        }
      }
      noStroke();
      fill(this.barColor);
      rect(this.leftPoint.x-this.barSize.x/2.0f, this.leftPoint.y, this.barSize.x, this.barSize.y);
      rect(this.rightPoint.x-this.barSize.x/2.0f, this.rightPoint.y, this.barSize.x, this.barSize.y);
      rectMode(CENTER);
      push();
      translate(this.leftPoint.x, this.leftPoint.y);
      shearY(PI/4.0f);
      rect(0, 0, 80, 5);
      pop();
      push();
      translate(this.rightPoint.x, this.rightPoint.y);
      shearY(PI/4.0f);
      rect(0, 0, 80, 5);
      pop();
      pop();
    }
    void update() {
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
