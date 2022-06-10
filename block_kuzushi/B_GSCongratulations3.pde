// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】たーせるさん
// 【記事の名前】Processingで光の粒を飛ばしてみた
// http://tercel-sakuragaoka.blogspot.com/2011/06/processing_16.html
//

class GameSceneCongratulations3 extends GameSceneCongratulationsBase {
  int counter;    // カウンタ
  PImage[]  tex;  // テクスチャ配列
  PVector[] pos;  // パーティクル位置ベクトル
  PVector[] vel;  // パーティクル速度ベクトル

  final int   NUM_PARTICLES  = 360;  // パーティクル数
  final float ACCELERATION_Y = 0.1;  // 加速度

  @Override void setup() {
    tex = new PImage[NUM_PARTICLES];
    pos = new PVector[NUM_PARTICLES];
    vel = new PVector[NUM_PARTICLES];
    counter = 0;

    imageMode(CENTER);

    // パーティクルのテクスチャを配列に格納
    colorMode(HSB, NUM_PARTICLES, 100, 100);
    for (int i = 0; i < tex.length; i++) {
      tex[i] = getParticleTexture(color(i, 80, 50));
      pos[i] = new PVector(0, height * 2);
      vel[i] = new PVector();
    }
    mMA.entry("しゃわしゃわ。。。", "data/3/keiryu.mp3");  // "渓流.mp3"
    mMA.loop("しゃわしゃわ。。。");
  }
  @Override void draw() {
    noStroke();
    fill(0, 30);
    rect(0, 0, width, height);

    image(gMoon, 0, 0, gMoon.width, gMoon.height);

    // カウンタ更新
    if (++counter >= NUM_PARTICLES) counter = 0;

    // ずれ量（初期位置にノイズを加える）
    float noiseAmount = tex[counter].width/4.0;

    // 初期位置の設定
    pos[counter].x = width/2 + random(-noiseAmount, noiseAmount);
    pos[counter].y = height * 9/10 + random(-noiseAmount, noiseAmount);

    // 初速度の設定
    vel[counter].x =  random(-2, 2);
    //    vel[counter].y = -random(3, 7);
    vel[counter].y = -random(3, 11);
    vel[counter].y += abs(vel[counter].x);

    // パーティクルの更新
    for (int i = 0; i < NUM_PARTICLES; i++) {
      if (pos[i].y < height+tex[i].height && pos[i].y>-tex[i].height) {
        // パーティクル描画 加算合成にするのがポイント
        blend(tex[i], 0, 0,
          tex[i].width, tex[i].height,
          (int)pos[i].x, (int)pos[i].y,
          tex[i].width, tex[i].height, ADD);
      }
      // 位置・速度更新
      pos[i].x += vel[i].x;
      pos[i].y += vel[i].y;
      vel[i].y += ACCELERATION_Y;
    }

    logoRightLower(color(counter, 80, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }

  // ==============================================
  // 指定した色のパーティクル用テクスチャを生成する
  // 引数 c : パーティクルの色
  // ==============================================
  PImage getParticleTexture(color c) {
    // 画像サイズとパーティクルの半径
    final int   IMG_SIZE        = 15;
    final float PARTICLE_RADIUS = 0.5f * IMG_SIZE - 2;

    // colorMode(RGB, 255, 255, 255);
    // 画像を作成
    PImage img = createImage(IMG_SIZE, IMG_SIZE, RGB);
    //  img.loadPixels();
    for (int i = (int)PARTICLE_RADIUS; i > 0; i--) {
      // グラデーション作成
      int a = (int)(0xFF*(float)(PARTICLE_RADIUS-i)/PARTICLE_RADIUS);
      int fg = c;
      int fR = (0x00FF0000 & fg) >>> 16;
      int fG = (0x0000FF00 & fg) >>> 8;
      int fB =  0x000000FF & fg;
      int rR = (fR * a) >>> 8;
      int rG = (fG * a) >>> 8;
      int rB = (fB * a) >>> 8;
      fg = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      // パーティクル用テクスチャ作成
      for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
          float yDistance = (y-img.height/2.0)*(y-img.height/2.0);
          float xDistance = (x-img.width/2.0)*(x-img.width/2.0);
          if (yDistance + xDistance <= i*i) {
            img.pixels[y * img.width + x] = fg;
          }
        }
      }
    }
    //  img.updatePixels();
    img.filter(BLUR);
    return img;
  }
}
