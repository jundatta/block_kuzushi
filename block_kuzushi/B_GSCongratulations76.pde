// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Loudspeaker
// https://openprocessing.org/sketch/860999
//

class GameSceneCongratulations76 extends GameSceneCongratulationsBase {
  float C=0;
  PGraphics T;
  //Segoe UI Historic には入ってた

  PShape cone;
  PShape cylinder;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    hint(DISABLE_DEPTH_TEST);

    noStroke();
    PFont font = createFont("Segoe UI Historic", 12);
    T=createGraphics(640, 640);
    T.beginDraw();
    T.textFont(font);
    T.colorMode(HSB, 255);
    T.scale(3);
    for (int i=0; i<1e3; i++) {
      T.fill(i/4, 180, 255);
      //     T.text(String.fromCodePoint(0x13100+i), i%40*6, ~~(i/40)*10);
      // ねこすずさんにご教示いただきました！！
      String s = new StringBuilder().appendCodePoint(0x13100+i).toString();
      // PC-8001さんにご教示いただきました！！
      //    String s = new String(Character.toChars(0x13100+i));    //T.text((char)(0x13100+i), i%40*6, ~~(i/40)*10);
      T.text(s, i%40*6, ~~(i/40)*10);
    }
    T.endDraw();
    //  texture(T);

    cone = createCone(300, 400, 24);
    cone.setTexture(T);

    cylinder = createCan(100, 100, 24);
    cylinder.setTexture(T);
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    background(0);
    rotateX(C+=.01);
    rotateY(C);
    //  cone(300, 400, 24, 1, 0);
    shape(cone);
    translate(0, 100, 0);
    //  cylinder(100, 100);
    shape(cylinder);
    pop();

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
