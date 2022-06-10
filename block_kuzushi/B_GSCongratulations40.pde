// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】legoushqueさん
// 【作品名】Dancing DNA
// https://openprocessing.org/sketch/1225974
//

class GameSceneCongratulations40 extends GameSceneCongratulationsBase {
  float time = 0;
  float n = 20;
  IntList seq = new IntList();
  // window.base = ['YellowGreen', 'Peru', 'Plum', 'LightSteelBlue'];
  color[] base = {#9ACD32, #CD853F, #DDA0DD, #B0C4DE};

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    seq.append(1);
    seq.append(2);
    for (float t = 0; t <= 2*n; t++) {
      seq.append(P5JSrandom(0, 1, 2, 3));
    }

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    pg.background(255);

    pg.translate(width/2, height/2);

    pg.scale(1, -1);
    float dis = 100;
    PVector center1, center2;
    float diam1, diam2, i, k, f, b;
    float dens = 75;
    float stdiam = 45;
    float cg = 5;

    for (float j = -30; j <= 30; j++) {
      pg.push();
      pg.strokeWeight(3);
      pg.stroke(220);
      f = j*40;
      pg.line(f, height, f, -height);
      pg.line(width, f, -width, f);
      pg.pop();
    }

    pg.rotate(-HALF_PI/2.0f);
    for (float j = -n; j <= n; j++) {
      b = seq.get(int(n + j));
      i = j/1.5;
      k = (j+1)/1.5;
      center1 = new PVector(sin(time + i)*dis, dens*i);
      diam1 = stdiam + cg*(sin(HALF_PI+(time + i)));

      center2 = new PVector(sin(PI + time + i)*dis, dens*i);
      diam2 = stdiam + cg*(sin(PI + HALF_PI+(time + i)));

      pg.strokeWeight(6);
      pg.stroke(100);
      pg.line(center1.x, center1.y, sin(time + k)*dis, dens*(k));
      pg.line(center2.x, center2.y, sin(time + k + PI)*dis, dens*(k));
      pg.line(center1.x, center1.y, center2.x, center2.y);
      if (diam1 < stdiam) {
        pg.fill(base[int(b)]);
        pg.circle(center1.x, center1.y, diam1);
        pg.fill(base[int((b+2)%4)]);
        pg.circle(center2.x, center2.y, diam2);
      } else {
        pg.fill(base[int((b+2)%4)]);
        pg.circle(center2.x, center2.y, diam2);
        pg.fill(base[int(b)]);
        pg.circle(center1.x, center1.y, diam1);
      }
    }
    time += 0.01*PI;
    pg.endDraw();
    image(pg, 0, 0);

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
