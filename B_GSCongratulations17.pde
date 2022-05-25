// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】sayoさん
// 【作品名】Planetary Gears
// https://openprocessing.org/sketch/1198178
//

class GameSceneCongratulations17 extends GameSceneCongratulationsBase {
  float theta = 0.0f;  // 太陽歯車の回転
  float t = 0.0f;  // 時間
  float h = 10;  // 全歯たけ
  float m;  // モジュール
  float z_in = 60;  // 内歯車の歯数（12の倍数）
  float z_sun = 24;  // 太陽歯車の歯数（12の倍数）
  float z_pl;  // 遊星歯車の歯数
  float d_in;  // 内歯車の直径
  float d_sun = 160;  // 太陽歯車の直径
  float d_pl;  // 遊星歯車の直径

  color bg =  #ffffff;  // 背景色
  color inner = #00eeee;  // 内歯車の色
  color sun = #00ee00;  // 太陽歯車の色
  color pl = #ff0000;  // 遊星歯車の色
  color car = #5555ff;

  PGraphics pg;

  float colorScale;  // "Congratulations"の色をいい感じにする

  @Override void setup() {
    colorMode(RGB, 255);

    // 計算
    m = d_sun / z_sun;
    z_pl = (z_in - z_sun) / 2;
    d_in = (int)(m * z_in);
    d_pl = (int)(m * z_pl);

    // P3DのときstrokeWeight()にDISABLE_DEPTH_TESTは効いてにゃい？！
    //  hint(DISABLE_DEPTH_TEST);

    imageMode(CORNER);
    pg = createGraphics(width, height);
  }
  @Override void draw() {
    drawPlanetaryGears();
    image(pg, 0, 0);

    logo(color(255, 255 * colorScale, 0));
  }

  // 歯車を描く（x座標, y座標, 回転の角度, 歯数, ピッチ円半径, 全歯たけ）
  void gear(float x, float y, float angle, float z, float r, float h) {
    pg.push();
    pg.translate(x, y);
    pg.rotate(angle);
    pg.beginShape();
    for (int i=0; i<z; i++) {
      pg.vertex((r-h/2)*cos(TWO_PI*i/z-(PI/z)/2), (r-h/2)*sin(TWO_PI*i/z-(PI/z)/2));
      pg.vertex((r+h/2)*cos(TWO_PI*i/z-(PI/z)/4), (r+h/2)*sin(TWO_PI*i/z-(PI/z)/4));
      pg.vertex((r+h/2)*cos(TWO_PI*i/z+(PI/z)/4), (r+h/2)*sin(TWO_PI*i/z+(PI/z)/4));
      pg.vertex((r-h/2)*cos(TWO_PI*i/z+(PI/z)/2), (r-h/2)*sin(TWO_PI*i/z+(PI/z)/2));
    }
    pg.endShape(CLOSE);
    pg.pop();
  }
  void drawPlanetaryGears() {
    pg.beginDraw();
    pg.translate(width / 2 - 375, height / 2 - 580);
    pg.scale(1.5);
    pg.background(bg);
    pg.noStroke();

    // 内歯車
    pg.fill(inner);
    pg.ellipse(width/2, height/2, d_in*1.2, d_in*1.2);
    pg.fill(bg);
    gear(width/2, height/2, 0, z_in, d_in/2, -h);

    // 遊星歯車
    pg.stroke(car);
    pg.strokeWeight(50);
    pg.line(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)),
      width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI/3));
    pg.line(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)),
      width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3));
    pg.line(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI/3),
      width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3));
    pg.noStroke();
    pg.fill(pl);
    gear(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)), PI/z_pl+theta*(1-d_in/d_pl)*(d_sun/(d_sun+d_in)), z_pl, d_pl/2, h);
    //fill(p2);
    gear(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI/3), PI/z_pl+theta*(1-d_in/d_pl)*(d_sun/(d_sun+d_in)), z_pl, d_pl/2, h);
    //fill(p3);
    gear(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), PI/z_pl+theta*(1-d_in/d_pl)*(d_sun/(d_sun+d_in)), z_pl, d_pl/2, h);
    pg.fill(200);
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.ellipse(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)), d_pl*0.4, d_pl*0.4);
    pg.ellipse(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI/3), d_pl*0.4, d_pl*0.4);
    pg.ellipse(width/2+(d_sun/2+d_pl/2)*cos(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), height/2+(d_sun/2+d_pl/2)*sin(theta*d_sun/(d_sun+d_in)+TWO_PI*2/3), d_pl*0.4, d_pl*0.4);

    // 太陽歯車を回転させる
    // 太陽歯車
    pg.fill(sun);
    pg.stroke(0);
    pg.strokeWeight(1);
    gear(width/2, height/2, theta, z_sun, d_sun/2, h);
    pg.fill(200);
    pg.ellipse(width/2, height/2, d_sun*0.4, d_sun*0.4);
    pg.fill(car);
    pg.ellipse(width/2, height/2, d_sun*0.2, d_sun*0.2);

    theta += sin(t)*0.1;
    colorScale = map(sin(theta*d_sun/(d_sun+d_in)), -1.0f, +1.0f, 0.0f, 1.0f);
    t += 0.004;
    pg.endDraw();
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
