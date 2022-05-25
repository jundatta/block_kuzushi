// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】okazzさん
// 【作品名】時計04
// https://neort.io/art/c57g8gc3p9fe3sqpkcfg
//
import java.time.LocalDateTime;
import java.time.temporal.ChronoField;

class GameSceneCongratulations141 extends GameSceneCongratulationsBase {
  float cx, cy;
  float dia;
  float sl, ml, hl;
  float hx, hy, mx, my;
  float csz, nof;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    cx = width/2;
    cy = height/2;
    if (width < height)dia = width*0.95;
    else dia = height*0.95;

    sl = dia *0.45;
    ml = dia *0.4;
    hl = dia *0.4;

    hx = cx - dia * 0.27;
    hy = cy - dia * 0.05;
    mx = cx + dia * 0.27;
    my = cy - dia * 0.05;

    csz = dia * 0.35;
    nof = csz*0.1;

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    //float milsec = new Date().getMilliseconds();
    //float sec = second() + (milsec % 1000)/1000.0f;
    //float min = minute() + (second() % 60)/60.0f;
    //float hou = hour() + (minute() % 60)/60.0f;

    LocalDateTime  ldt  =  LocalDateTime.now( ) ;     //  2017-09-16T23:30:59.999
    int ms =  ldt.get(ChronoField.MILLI_OF_SECOND);  // 000 – 999
    float sec = second() + ms/1000.0f;
    float min = minute() + (second() % 60)/60.0f;
    float hou = hour() + (minute() % 60)/60.0f;

    float sa = map(sec, 0, 60, 0, TAU) - PI/2.0f;
    float ma = map(min, 0, 60, 0, TAU) - PI/2.0f;
    float ha = map(hou, 0, 24, 0, TAU*2) - PI/2.0f;
    int hds = int(hou%12);
    if (hds == 0)hds = 12;

    pg.beginDraw();
    pg.textAlign(CENTER, CENTER);
    pg.textFont(gTitanOne);
    pg.rectMode(CENTER);
    pg.strokeWeight(dia*0.01);

    pg.background(255);

    //hour
    pg.noFill();
    pg.stroke(0);
    pg.circle(hx, hy, csz);
    pg.noStroke();
    pg.fill(0);
    pg.circle(hx + csz * 0.25 * cos(ha), hy + csz * 0.25 * sin(ha), csz*0.5);
    pg.fill(255);
    pg.textSize(dia*0.05);
    pg.text(hds, hx - nof + csz * 0.25 * cos(ha), hy - nof + csz * 0.25 * sin(ha));

    //monute
    pg.noFill();
    pg.stroke(0);
    pg.circle(mx, my, csz);
    pg.noStroke();
    pg.fill(0);
    pg.circle(mx + csz * 0.25 * cos(ma), my + csz * 0.25 * sin(ma), csz*0.5);
    pg.fill(255);
    pg.text(int(min), mx - nof + csz * 0.25 * cos(ma), my - nof + csz * 0.25 * sin(ma));

    String ampm = "AM";
    if (hou > 12)ampm = "PM";
    pg.stroke(0);
    pg.noStroke();
    pg.fill(9);
    pg.textSize(dia*0.18);
    pg.text(ampm, cx, cy+dia*0.2);

    //sec
    pg.stroke(0);
    pg.circle(cx, cy, 10);
    pg.line(cx, cy, cx + sl*cos(sa), cy + sl*sin(sa));
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
