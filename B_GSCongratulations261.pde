// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】akitchさん
// 【作品名】.
// https://neort.io/art/c7trlas3p9fclnoe02ag
//

class GameSceneCongratulations261 extends GameSceneCongratulationsBase {
  int array_num = 100; //配列の要素数とfor文の処理回数を制御するための関数
  float[] random_num = new float[array_num];
  float[] random_num_st = new float[array_num];//random_num保存用配列
  float[] plusx1 = new float[array_num];
  float array_plus1 = 0;//配列のx座標指定に加算していくやつ
  float flag_sin = 0;

  PGraphics pg;

  @Override void setup() {
    for (var step = 0; step < array_num; step++) {//ギザギザを斜めにするやつ
      plusx1[step] = array_plus1;
      array_plus1 += 1.1;//徐々にプラスしていく
    }

    for (var step = 0; step < array_num; step++) {
      flag_sin = sin(radians(map(step, 0, array_num, 0, 1080)));
      if (flag_sin > 0.82) {
        random_num[step] = random(-250, 100);
        random_num_st[step] = random_num[step];
      } else {
        random_num[step] = random(-5, 50);
        random_num_st[step] = random_num[step];
      }
    }

    pg = createGraphics(width, height, P2D);
  }
  @Override void draw() {
    float shaft_pattern = random(0, 1);
    for (var step = 0; step < array_num; step++) {
      flag_sin = sin(radians(map(step, 0, array_num, 0, 1080)));
      if (frameCount % 5 == 0) {
        if ((flag_sin > random(1) - shaft_pattern) && (flag_sin < 1 - shaft_pattern)) {//大きいびりびり制御場所
          random_num[step] = random(-100, 200) * cos(frameCount * 0.02) * cos(frameCount * 0.04) * 1.1;
          random_num_st[step] = random_num[step];
        } else {
          random_num[step] = random(-10, 10) * sin(frameCount * 0.02) * sin(frameCount * 0.04) * 1.05;
          random_num_st[step] = random_num[step];
        }
      }
    }
    var win_x = width;//画面のインナーサイズの取得

    pg.beginDraw();
    pg.background(27);
    noise_(pg, win_x);
    pg.endDraw();
    image(pg, 0, 0, width, height*(1.0f/0.7f));

    logoRightLower(#ff0000);
  }

  //innerWidth インナーの表示幅で図形を固定する
  void noise_(PGraphics pg, float wx) {
    pg.noFill();
    pg.strokeWeight(0.5);
    pg.stroke(#FFFFFF);
    pg.beginShape();
    for (var step = 0; step < array_num; step++) {
      pg.vertex(-50 + wx / 2 + random_num_st[step] + plusx1[step], step *6- random_num_st[step] / 4);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] - plusx1[step]+wx*2/60, step *7- random_num_st[step] / 4+600);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] + plusx1[step]+wx*2/100-80, step *4  - random_num_st[step] / 4+1300);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] - plusx1[step]+wx*14.3/100-130, step * 5 - random_num_st[step] /4+1700);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] - plusx1[step]-wx*2.29/150+10, step *4 - random_num_st[step] /4+2200);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] + plusx1[step]-wx*2.29/100-100, step *5 - random_num_st[step] /4+2600);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] - plusx1[step]-wx*2.29/150, step *4 - random_num_st[step] /4+3100);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] + plusx1[step]-wx*2.29/150-100, step *5 - random_num_st[step] /4+3500);
    }
    for (var step = 0; step < array_num; step++) {
      pg.vertex(wx / 2 + random_num_st[step] + plusx1[step]-wx*2.29/150, step *5 - random_num_st[step] /4+3995);
    }
    pg.endShape();
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
