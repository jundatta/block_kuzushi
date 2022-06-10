// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】medi kidさん
// 【作品名】proc test5
// https://openprocessing.org/sketch/1359379
//

class GameSceneCongratulations196 extends GameSceneCongratulationsBase {
  int NumLayers;     // how many layers of buildings to draw
  int Waterline;     // height of waterline
  float MaxHeight;   // maximmum building height
  color WindowColor;  // average color of windows
  boolean Redraw = true;  // do we need to draw a new postcard?

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    smooth();        // draw everything pretty
    noStroke();      // don't draw outlines

    WindowColor = color(220, 220, 20);
  }
  @Override void draw() {
    if (Redraw) {
      makeNewCard();  // make a new cared
      Redraw = false; // don't repeat until requested
    }

    logoRightLower(#ff0000);
  }

  void makeNewCard() {   // create a new card
    Waterline = int(height * 0.8);            // height of waterline
    MaxHeight = random(.2*height, .6*height); // building max height
    NumLayers = int(random(6, 10));           // building density
    drawSkyline();                            // and draw the result
  }

  void drawSkyline() {
    drawBackground();   // draw the sky and water
    for (int layer=0; layer<NumLayers; layer++) {  // draw each layer of the building
      drawLayer(layer);
    }
    drawLights();  // draw the lights and reflections
  }

  void drawLayer(int layer) {  // draw one layer of buildings
    float a = norm(layer, 0, NumLayers-1);  // how far back we are
    float avgWidth = lerp(width/50.0, width/20.0, a);   // average building width
    float avgHeight = lerp(MaxHeight, height/20.0, a);  // and height
    float layerDensity = lerp(.1, 1, a);  // guides how many buildings get drawn
    float left = -avgWidth;               // draw left to right, starting here

    while (left < width) {
      float buildingWidth = vary(avgWidth, .1);    // pick a width
      float buildingHeight = vary(avgHeight, .2);  // and height
      boolean drawMe = random(0, 1) < layerDensity;  // draw this one?
      if (drawMe) {
        drawBuilding(left, Waterline, buildingWidth, buildingHeight);  // draw it
      }
      left += buildingWidth; // and move right
    }
  }

  void drawBuilding(float bLeft, float bBottom, float bWid, float bHgt) {
    float buildingGrayColor = random(30, 90);  // basic building color
    fill(buildingGrayColor);                   // use that color
    rect(bLeft, bBottom, bWid, -bHgt);         // draw the building

    // now get a window color based on varying the generic window color
    color windowColor = color(vary(red(WindowColor), .1),
      vary(green(WindowColor), .1),
      vary(blue(WindowColor), .1));
    fill(windowColor);

    // figure out how many windows to draw, then draw each one
    int numAcross = int(random(10.0, 20.0));
    int numHigh = int(random(10.0, 20));
    float wWid = bWid / (numAcross*2.0);
    float wHgt = bHgt / (numHigh*2.0);

    float windowDensity = random(0.1, 0.7); // density of drawn windows
    for (int wx=0; wx<numAcross; wx++) {
      for (int wy=0; wy<numHigh; wy++) {
        float wLeft = (1.0/(numAcross*2.0)) + (wx*2*wWid);
        float wBottom = (1.0/(numHigh*2.0)) + (wy*2*wHgt);
        if (random(0, 1) < windowDensity) {  // draw this one?
          rect(bLeft+wLeft, bBottom-wBottom, wWid, -wHgt);
        }
      }
    }
  }

  void drawBackground() {
    // draw the sky: a radial gradient blend from the moon at (cx, cy)
    float cx = width * random(.6, .8);   // the moon is on the right-ish
    float cy = vary(Waterline, .1);      // and near the waterline
    float distToUL = dist(cx, cy, 0, 0); // distance to upper-left (0,0)
    color lighter = color(5, 60, 130);   // light color for gradient
    color darker = color(0, 15, 45);     // dark color for gradient

    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {
        float a = dist(x, y, cx, cy)/distToUL;  // distance from (x,y) to moon
        a = constrain(a, 0, 1);
        color clr = lerpColor(lighter, darker, a); // get the color here
        float ya = 1 - norm(y, 0, Waterline);      // height above waterline
        float threshold = .001 * ya;               // draw a star here?
        if (random(0, 1) < threshold) {
          // stars are dim at the waterline, and brighter as we go up.
          // The square root function creates a nice-looking blend of intensity
          a = sqrt(a);
          clr = lerpColor(clr, color(255), a);     // make this pixel bright
        }
        set(x, y, clr);  // set this pixel's colors
      }
    }

    // draw the (fake) building reflections
    color waterColor = color(10, 10, 30);      // color of the water
    for (int y=Waterline; y<height; y++) {
      for (int x=0; x<width; x++) {
        // ya is distance from Waterline
        float ya = 1-norm(y, Waterline, height-1);
        // ya2 creates a short fade right at the Waterline
        float ya2 = constrain((y-Waterline)/3.0, 0, 1);
        float wnoise = noise(x*.04, y*.01);
        wnoise = ya2 * ya * sq(wnoise);
        color clr = lerpColor(waterColor, WindowColor, wnoise);
        set(x, y, clr);
      }
    }
  }

  void drawLights() {
    int numLights = 20;
    noStroke();
    int lradius = 8;
    for (int l=0; l<numLights; l++) {
      int lx = int(random(0, width));
      int ly = int(Waterline-lradius+vary(lradius, .1));
      color lightColor = color(
        random(210, 255), random(210, 255), random(210, 255));

      // draw the light as two circles to fake a glow
      fill(red(lightColor), green(lightColor), blue(lightColor), 128);
      ellipse(lx, ly, lradius, lradius);
      fill(red(lightColor), green(lightColor), blue(lightColor), 255);
      ellipse(lx, ly, lradius/2, lradius/2);

      // draw fake reflections and add to water color
      for (int y=Waterline; y<height; y++) {
        for (int x=lx-2; x<lx+2; x++) {
          float ya = 1-norm(y, Waterline, height-1);
          float wnoise = noise(x*.04, y*.01);
          wnoise = sq(ya) * sq(wnoise);  // fade out noise
          color oldclr = get(x, y);
          color clr = lerpColor(oldclr, lightColor, wnoise);
          set(x, y, clr);
        }
      }
    }
  }

  // wiggle a number by a given percent and return the result
  float vary(float value, float percent) {
    float range = value * percent;
    value += random(-range, range);
    return(value);
  }

  @Override void mousePressed() {
    Redraw = true;
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
