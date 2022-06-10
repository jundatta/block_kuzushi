// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Kei Matsuokaさん
// 【作品名】colorModeHSB
// https://openprocessing.org/sketch/1184465
//

class GameSceneCongratulations68 extends GameSceneCongratulationsBase {
  float boxSize = 2;    //立方体のサイズの初期値
  float distance = 28;    //縦方向の立方体同士の距離
  float halfDis;    //立方体同士の一辺の全体の距離の半分
  float radius = 4;  //x, y軸方向の立方体の距離の初期値
  float f = 10;      // this line sets spectrum linearity correction
  int boxNum = 14;    //立方体の数
  int angleX = -50;  //x軸を中心とした回転角度の初期値
  float angleZ = 0.0f;  //z軸を中心とした回転角度の初期値

  @Override void setup() {
    imageMode(CORNER);

    colorMode(HSB, 360, 100, 100);

    //立方体を縦方向に並べた際の距離の半分
    halfDis = distance*(boxNum - 1)/2;

    noStroke();
  }
  @Override void draw() {
    background(0);

    push();

    translate(width/2, height/2-50);    //基準点を画面中央に移動
    rotateX(radians(-angleX));  //x軸を中心に回転
    rotateZ(radians(-angleZ));  //z軸を中心に回転

    for (int z = 0; z < boxNum; z ++) {  //縦にも増やす
      for (int angle = 0; angle < 360; angle += 15) {  //15度ずつ移動

        //boxNumの数だけx軸方向に立方体を増やす
        for (int i = 0; i < boxNum; i ++) {

          pushMatrix();

          //円状に配置するためのxy座標の計算
          float x = i*(radius + i*1.5)*cos(radians(angle));
          float y = -i*(radius + i*1.5)*sin(radians(angle));

          float saturation = float(i)/float(boxNum - 1)*100.0;  //彩度を計算
          float brigtness = float(z)/float(boxNum - 1)*100.0;  //明度を計算

          translate(x, y, z*distance - halfDis);  //一つずつ移動させる
          rotateZ(radians(-angle));  //円状に配置

          float h = angle + f * sin(3 * angle);            // degrees
          fill(h, saturation, brigtness);  //色を指定する

          //立方体を描く
          box(boxSize + boxSize*i, boxSize + boxSize*i, boxSize + boxSize*i);

          popMatrix();
        }
      }
    }
    angleZ -= 0.3f;  //z軸を中心とした回転
    if (angleZ < -360.0f) {
      angleZ = 0.0f;
    }

    pop();

    logoRightLower(color(0, 100, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
