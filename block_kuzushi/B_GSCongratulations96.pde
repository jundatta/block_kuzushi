// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Troy Robinsonさん
// 【作品名】Marble generator
// https://openprocessing.org/sketch/16209
//

class GameSceneCongratulations96 extends GameSceneCongratulationsBase {
  PGraphics circleMask;
  PGraphics circleHighlight;

  int ellipseW;
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    ellipseW = int(width * 1.0f);
    smooth();

    drawMask(); //build the image for masking the circle
    drawHighlights();//build the image used for highlights
    drawMarble(); //draw a marble to screen
  }
  @Override void draw() {
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  void drawMarble() {
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(50, 40, 40); //Dark brown background

    pg.noStroke(); //now draw a gradient circle background
    for (int i = ellipseW; i>300; i-=5) {
      pg.fill(i-280, i-300, i-300); //fill light brown circle
      pg.ellipse(width/2, height/2, i, i);
    }
    pg.noFill();

    //draw some random bezier splines and points at different widths. get the color from the pallette image.
    for (int x = 0; x < 35; x++) {
      //    color newcolor = img.get( int(random(img.width)), int(random (img.height)) );
      color newcolor = color(random(255), random(255), random(255));
      pg.stroke(newcolor, random(255)); //color from image pallette with random transparency
      //stroke(newcolor); //opaque color from image pallette
      pg.strokeWeight (random(50));
      int dX = (int)random(50);
      int dY = (int)random(50);
      pg.bezier (dX, dY, random(width), random(height), random(width), random(height), width-dX, height-dY);
      pg.point(random(width), random(random(height)));
    }

    //  pg.noStroke();
    pg.strokeWeight (random(5));
    pg.ellipse(width/2, height/2, ellipseW, ellipseW); // outline the circle

    pg.blend (circleHighlight, 0, 0, width, height, 0, 0, width, height, SCREEN); //add the highlight layer
    pg.blend (circleMask, 0, 0, width, height, 0, 0, width, height, MULTIPLY); // mask out the final image
    pg.endDraw();
  }

  void drawMask() {
    // This draws a white circle on black that is used to mask the image
    circleMask = createGraphics(width, height);
    circleMask.beginDraw();
    circleMask.noStroke();
    circleMask.smooth();
    circleMask.background(0);
    circleMask.fill(255);
    circleMask.ellipse(width/2, height/2, ellipseW, ellipseW);
    circleMask.endDraw();
  }

  void drawHighlights() {
    //this creates a highlight layer that is added to the image
    circleHighlight = createGraphics(width, height);
    circleHighlight.beginDraw();
    circleHighlight.smooth();
    circleHighlight.fill(255, 96);
    circleHighlight.stroke(255);
    circleHighlight.strokeWeight(10);
    circleHighlight.ellipse(175, 150, 450, 300);
    circleHighlight.noStroke();
    circleHighlight.fill(255);
    for (int i = 0; i<25; i++) {
      float rad = random(35);
      circleHighlight.ellipse(random(width), random(height/2)+20, rad, rad);
      circleHighlight.filter (BLUR, 2);
    }
    circleHighlight.endDraw();
  }

  @Override void mousePressed() {
    drawMarble();
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
