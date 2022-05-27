// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】MeTHさん
// 【作品名】Ring of Fire Shader
// https://openprocessing.org/sketch/1390657
//

class GameSceneCongratulations264 extends GameSceneCongratulationsBase {
  PShader Shader;
  PGraphics coolingMap;
  PGraphics tex;

  PGraphics tmp;

  @Override void setup() {
    pixelDensity(1);
    noStroke();

    coolingMap=createGraphics(width, height, P2D);
    coolingMap.beginDraw();
    coolingMap.loadPixels();
    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {
        float n = noise(x/50.0f, y/50.0f);
        float val=pow(n, 3)*255;
        coolingMap.pixels[x+y*width] = color((int)val);
      }
    }
    coolingMap.updatePixels();
    coolingMap.endDraw();

    tex=createGraphics(width, height, P2D);

    background(0);

    Shader = loadShader("data/264/frag.glsl", "data/264/vert.glsl");
    Shader.set("uResolution", (float)width, (float)height);

    tmp=createGraphics(width, height, P2D);
  }

  int uprisingSpeed=2;
  int utime=0;

  @Override void draw() {
    shader(Shader);

    PGraphics canv = getGraphics();
    tex.beginDraw();
    tex.background(0);
    tex.image(canv, 0, -uprisingSpeed, width, height);
    tex.endDraw();

    // （自分自身にコピー。はうまくいかない？）
    // （beginDraw()をいれてもうまくいかにゃい）
    //coolingMap.image(coolingMap, 0, -uprisingSpeed, width, height);
    tmp.beginDraw();
    tmp.image(coolingMap, 0, -uprisingSpeed, width, height);
    tmp.endDraw();
    coolingMap.beginDraw();
    coolingMap.image(tmp, 0, 0);
    coolingMap.endDraw();

    coolingMap.beginDraw();
    coolingMap.loadPixels();
    if (uprisingSpeed>0) {
      for (int y=height-uprisingSpeed; y<height; y++) {
        for (int x=0; x<width; x++) {
          float n = noise(x/50.0f, (y+utime*uprisingSpeed)/50.0f);
          float val=pow(n, 3)*255;
          coolingMap.pixels[x+y*width] = color((int)val);
        }
      }
    } else if (uprisingSpeed<0) {
      for (int y=-uprisingSpeed-1; y>=0; y--) {
        for (int x=0; x<width; x++) {
          float n = noise(x/50.0f, (y+utime*uprisingSpeed)/50.0f);
          float val=pow(n, 3)*255;
          coolingMap.pixels[x+y*width] = color((int)val);
        }
      }
    }
    coolingMap.updatePixels();
    coolingMap.endDraw();

    Shader.set("tex", tex);
    Shader.set("coolingMap", coolingMap);
    rect(0, 0, width, height);
    if (uprisingSpeed!=0) {
      utime++;
    }

    resetShader();
    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
