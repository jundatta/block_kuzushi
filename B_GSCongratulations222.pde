// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Pierre Bailさん
// 【作品名】Colored Ying Yang
// https://openprocessing.org/sketch/1392548
//

class GameSceneCongratulations222 extends GameSceneCongratulationsBase {
  // PBa
  // 2021-12-10
  // YinYangCol_Ed1
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  float xc, yc;
  float side;
  PVector CT;
  float r1, r2, rc1, rc2, rc3;
  float sp;
  PVector[] A = new PVector[4];
  float rot, drot;

  color cred;
  color cgreen;
  color cblue;
  color cyellow;
  color cwhite;
  color cblack;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    cred=color(255, 0, 0);
    cgreen=color(0, 255, 0);
    cblue=color(0, 0, 255);
    cyellow=color(254, 255, 23);
    cwhite=color(255, 255, 255);
    cblack=color(0, 0, 0);
    xc=width/2;
    yc=height/2;
    CT=new PVector(xc, yc);
    side=250;
    for (int j=0; j<A.length; j++)
    {
      A[j]=new PVector(0, 0);
    }
    sp=10;
    r1=(side/2.0f)-sp;
    r2=(side/2.0f)+sp;
    rc1=(side/sqrt(2))+r1;
    rc2=rc1+2*sp;
    rc3=rc2+2*sp;
    rot=0;
    drot=0.01;
    //  frameRate(1000);
  }
  @Override void draw() {
    background(255);

    for (int j=0; j<A.length; j++)
    {
      A[j].x=xc+(side/sqrt(2))*cos(3*PI/4.0f -j*PI/2.0f-rot);
      A[j].y=yc+(side/sqrt(2))*sin(3*PI/4.0f -j*PI/2.0f-rot);
    }
    noStroke();
    fill(cblack);
    pCircle(CT, rc3);

    fill(cwhite);
    pCircle(CT, rc2);
    fill(cred);
    arc(CT.x, CT.y, 2*rc1, 2*rc1, PI/4.0f, 3*PI/4.0f);
    pCircle(CT, rc1);

    fill(cblue);
    arc(CT.x, CT.y, 2*rc1, 2*rc1, -3*PI/4.0f-rot, PI/4.0f-rot);
    fill(cwhite);
    arc(A[1].x, A[1].y, 2*r2, 2*r2, PI/4.0f-rot, 3*PI/2.0f-rot);
    fill(cblue);
    pCircle(A[1], r1);

    fill(cgreen);
    arc(CT.x, CT.y, 2*rc1, 2*rc1, -3*PI/4.0f-rot, -PI/4.0f-rot);
    fill(cwhite);
    arc(A[2].x, A[2].y, 2*r2, 2*r2, -PI/4.0f-rot, PI-rot);
    fill(cgreen);
    pCircle(A[2], r1);

    fill(cyellow);
    arc(CT.x, CT.y, 2*rc1, 2*rc1, 3*PI/4.0f-rot, 5*PI/4.0f-rot);
    fill(cwhite);
    arc(A[3].x, A[3].y, 2*r2, 2*r2, -3*PI/4.0f-rot, PI/2.0f-rot);
    fill(cyellow);
    pCircle(A[3], r1);

    fill(cwhite);
    arc(A[0].x, A[0].y, 2*r2, 2*r2, -5*PI/4.0f-rot, 0-rot);
    fill(cred);
    pCircle(A[0], r1);

    rot=rot+drot;

    logoRightLower(#ff0000);
  }

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void pCircle(PVector C, float ray)
  {
    circle(C.x, C.y, 2*ray);
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
