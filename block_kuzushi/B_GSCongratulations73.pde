// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】atillaさん
// 【作品名】BLACK LIVES MATTER
// https://openprocessing.org/sketch/915474
//

class GameSceneCongratulations73 extends GameSceneCongratulationsBase {
  /******************
   Code by Vamoss
   Original code link:
   https://www.openprocessing.org/sketch/913474
   
   Author links:
   http://vamoss.com.br
   http://twitter.com/vamoss
   http://github.com/vamoss
   ******************/

  //EN
  String message = "BLACK LIVES MATTER";
  float fontSize = 28;
  float fontScaleY = 1;

  PGraphics messageCanvas;
  float size;

  PFont font;
  PShape ps;

  void P5preload() {
    font = createFont("data/73/ArchivoBlack-Regular.ttf", 50, true);
  }

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);
    P5preload();

    hint(DISABLE_DEPTH_TEST);

    textureWrap(REPEAT);
    noStroke();

    size = min(width, height) / 3.0f;

    int H = 60;
    messageCanvas = createGraphics(640, H);
    messageCanvas.beginDraw();

    messageCanvas.textSize(fontSize);
    messageCanvas.textFont(font);
    messageCanvas.textAlign(CENTER, TOP);
    messageCanvas.stroke(0);
    messageCanvas.fill(255);
    messageCanvas.scale(1, fontScaleY);
    messageCanvas.text(message, messageCanvas.width/2, 0);

    messageCanvas.endDraw();

    ps = createPipe(200, 400, 18);
    ps.setTexture(messageCanvas);
  }
  @Override void draw() {
    background(0);

    push();
    translate(width/2, height/2);

    lights();
    ambientLight(100, 100, 100);
    directionalLight(255, 255, 255, width-mouseX-width/2, height-mouseY-height/2, 1);
    push();
    // イメージと回転させる順番が逆！！
    rotateY(radians(+45));        // ②少し「左を手前に右を奥に」y軸回転
    rotateX(-millis()/5000.0f);   // ①x軸を中心に回転させる
    shape(ps);
    pop();
    pop();

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
