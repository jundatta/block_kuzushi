// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Adam Wolnikowskiさん
// 【作品名】Glass Ball
// https://openprocessing.org/sketch/1104382
//
// 【参考】Processing内の行列の取り出し方
// https://kougaku-navi.hatenablog.com/entry/20160104/p1
// 【公式の（旧）シェーダー説明】
// https://web.archive.org/web/20210417130804/https://processing.org/tutorials/pshader/
// 【参考】GLSLのmodelview行列のprocessing javaでの扱い
//　https://github.com/processing/processing/wiki/Advanced-OpenGL
//　　⇒デフォルトはpositionにmodelview変換が施されていて（とのことらしい？が）
//　　　modelview行列の中身は単位行列になっている
//    ⇒OpenGL本来の行列の扱いにするにはhint(DISABLE_OPTIMIZED_STROKE)を
//　　　呼び出しておく

class GameSceneCongratulations80 extends GameSceneCongratulationsBase {
  PShader projectionShader;
  PMatrix3D mMatrix = new PMatrix3D();

  PGraphics pg;
  PShader pgShader;

  PMatrix3D projMatrix;
  PMatrix3D cameraMatrix;

  void debugPMatrix3D(PMatrix3D m) {
    println(
      "[m00]:" + m.m00 + ", " +
      "[m01]:" + m.m01 + ", " +
      "[m02]:" + m.m02 + ", " +
      "[m03]:" + m.m03);

    println(
      "[m10]:" + m.m10 + ", " +
      "[m11]:" + m.m11 + ", " +
      "[m12]:" + m.m12 + ", " +
      "[m13]:" + m.m13);

    println(
      "[m20]:" + m.m20 + ", " +
      "[m21]:" + m.m21 + ", " +
      "[m22]:" + m.m22 + ", " +
      "[m23]:" + m.m23);

    println(
      "[m30]:" + m.m30 + ", " +
      "[m31]:" + m.m31 + ", " +
      "[m32]:" + m.m32 + ", " +
      "[m33]:" + m.m33);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    projectionShader = loadShader("data/80/projectionFrag.frag", "data/80/projectionVert.vert");
    // shader(projectionShader);

    pg = createGraphics(width, height, P3D);
    pgShader = loadShader("data/80/pgFrag.frag", "data/80/pgVert.vert");
    // pg.shader(pgShader);

    PMatrix3D camera = ((PGraphicsOpenGL)g).camera.get();
    camera.translate(width/2, height/2);
    camera.transpose();
    projectionShader.set("uViewMatrix", camera);

    float[] color1 = new float[]{51/255.0f, 99/255.0f, 118/255.0f};
    pgShader.set("uColor1", color1, color1.length);
    float[] color2 = new float[]{52/255.0f, 177/255.0f, 166/255.0f};
    pgShader.set("uColor2", color2, color2.length);
    float[] color3 = new float[]{55/255.0f, 220/255.0f, 204/255.0f};
    pgShader.set("uColor3", color3, color3.length);
    float[] stroke = new float[]{42/255.0f, 42/255.0f, 42/255.0f};
    pgShader.set("uStroke", stroke, stroke.length);
    pgShader.set("uSeed", random(10000, 100000));
  }
  @Override void draw() {
    push();

    hint(DISABLE_OPTIMIZED_STROKE);

    // p5.js/WEBGLの座標系に合わせる
    // 原点が画面のど真ん中
    translate(width/2, height/2, 0);

    background(255);
    pg.shader(pgShader);
    pgShader.set("uTime", millis()/10.0f);
    pg.beginDraw();
    pg.noStroke();
    pg.rect(0, 0, width, height);
    pg.endDraw();
    pg.resetShader();
    projectionShader.set("uTexture", pg);

    noStroke();
    fill(255);
    circle(0, 0, 536);  // 適当に合わせました（すまにゃい＼(^_^)／）

    shader(projectionShader);
    mMatrix.reset();
    mMatrix.rotateX(millis()/1000.0);
    mMatrix.rotateY(millis()/1000.0);
    //    mMatrix.scale(200, 200, 200);
    mMatrix.scale(0.725);  // 適当に合わせました（ゴメン）
    projectionShader.set("uModelMatrix", mMatrix);
    push();
    rotateX(millis()/1000.0);
    rotateY(millis()/500.0);
    sphere(250);
    //ambientMaterial(0, 2);
    //sphere(251);
    pop();

    mMatrix.reset();
    mMatrix.translate(0, 0, -400);
    //  mMatrix.scale(width*2, height*2, 1);
    mMatrix.scale(width/10, height/8, 1);  // 適当に合わせました（ゴメン）
    projectionShader.set("uModelMatrix", mMatrix);
    translate(0, 0, -400);
    box(width*2, height*2, 1);
    resetShader();

    hint(ENABLE_OPTIMIZED_STROKE);

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
