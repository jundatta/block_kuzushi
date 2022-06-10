// コングラチュレーション画面
//
// こちらがオリジナルです。
// 。。。すまにゃい。オリジナルを見つけきれず。。。orz
// OpenProcessingではないかも。
//

class GameSceneCongratulations52 extends GameSceneCongratulationsBase {
  PGraphics moon;

  @Override void setup() {
    imageMode(CENTER);
    
    colorMode(RGB, 255);

    generateMoon();
  }

  void generateMoon() {
    background(0);
    int r = floor(min(width, height)/2.5);

    moon = createGraphics(width, height);
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    g.noStroke();
    g.fill(255);
    //  g.ellipse(g.width/2 + 25, g.height/2 + 25, r * 2 + 50, r * 2 + 50);
    g.ellipse(g.width/2 + 0, g.height/2 + 0, r * 2 + 50, r * 2 + 50);
    g.filter(BLUR, 16);
    g.endDraw();

    moon.beginDraw();
    //moon.imageMode(CENTER);
    moon.image(g, 0, 0);

    moon.fill(255);
    moon.noStroke();
    moon.ellipse(moon.width/2, moon.height/2, r * 2, r * 2);

    moon.loadPixels();
    float d;
    for (int x = 0; x<moon.width; x++) {
      for (int y = 0; y<moon.height; y++) {
        d = dist(x, y, moon.width/2, moon.height/2);
        if (dist(x, y, moon.width/2, moon.height/2) <= r) {
          d = 1 - pow(d/r, 3);
          float f = 1 - pow(noise(frameCount + x/140f, frameCount + y/140f) * 1.3, 2);
          moon.pixels[y * moon.width + x] = color(255 - f * 255 * d, 255);
        }
      }
    }
    moon.updatePixels();
    moon.endDraw();
    //    image(moon, width/2, height/2);
  }

  @Override void draw() {
    background(0);
    image(moon, width/2, height/2);
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
