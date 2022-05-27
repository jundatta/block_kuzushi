// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Pierre Bail
// 【作品名】Conformal Mapping
// https://openprocessing.org/sketch/1368520
//
import java.util.function.BiConsumer;

class GameSceneCongratulations244 extends GameSceneCongratulationsBase {
  // JavaScriptで変数の宣言（let）を強制する
  // 'use strict';

  // PBa
  // 2021-11-25
  // Ed1
  // Conformal Mapping of Polygon
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  float fact;
  float dbeta;
  float tx, ty;
  PVector[] tabp = new PVector[50];
  float np, ns;
  float rc;
  ArrayList<Button> button;

  color cred = #ff0000;
  color cgreen = #00ff00;
  color cblue = #0000ff;
  color cyellow = #feff17;
  color corange = #ead61c;
  color cblack = #000000;

  // PC-8001（TN8001）さんにご教示頂きました
  BiConsumer<Float, Float> trans = this::transformMap4; // メソッド参照

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    fact=100;
    rc=1.5;
    dbeta=0.1;

    final int OrgX = 10;
    final int OrgY = -50;
    button = new ArrayList();
    button.add(new Button("Map z*z", OrgX+30, OrgY+100, 120, 20, cred, this::actBz2));
    button.add(new Button("Map z*z*z", OrgX+30, OrgY+125, 120, 20, cgreen, this::actBz3));
    button.add(new Button("Map sin(z)", OrgX+30, OrgY+150, 120, 20, corange, this::actBsinz));
    button.add(new Button("Map ((z-1)/(z+1))", OrgX+30, OrgY+175, 120, 20, cyellow, this::actBmobz));

    for (int jj=0; jj<tabp.length; jj++)
    {
      tabp[jj] = new PVector(0, 0);
    }
    actBmobz();
  }
  @Override void draw() {
    float dalpha=TAU/np;
    for (int n=0; n<np+1; n++)
    {
      float xs=rc*cos(n*dalpha + dbeta);
      float ys=rc*sin(n*dalpha + dbeta);
      tabp[n].x=xs;
      tabp[n].y=ys;
    }

    background(250, 250, 250);

    push();
    rectMode(CENTER);
    textSize(28);
    fill(cblue);
    text("CONFORMAL MAPPING", 180, 50);
    stroke(cblack);
    textSize(17);
    strokeWeight(1);
    text("Click to change mapping", 600, 100);
    translate(width / 2, height / 2);
    fill(cyellow);
    circle(0, 0, 2*rc*fact);
    stroke(cblack);
    strokeWeight(2);
    line(-330, 0, 330, 0);              // Axes
    line(0, -330, 0, 330);
    noFill();
    for (int i=-3; i<4; i++)
    {
      fill(cblack);
      strokeWeight(1);
      affstring(str(i), i*fact, 0, 5, 5);
      affstring(str(i), 0, -i*fact, 5, 5);
    }
    stroke(cgreen);
    strokeWeight(2);
    for (int n=0; n<np+1; n++)
    {
      circle(tabp[n].x*fact, tabp[n].y*fact, 12);
    }
    for (int n=(int)ns; n<np+1; n++)
    {
      linepv(tabp[n], tabp[n-(int)ns]);
      trlinepv(tabp[n], tabp[n-(int)ns]);
    }
    dbeta=dbeta-0.01;
    pop();

    // P3Dの呪いに対抗するためZ軸方向に適当な値で浮かせた
    // （PGraphics pgで対抗する気力がにゃかったにゃ＼(^_^)／）
    push();
    translate(0, 0, 1.0f);
    for (Button b : button) {
      b.draw(mouseX, mouseY);
    }
    pop();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    for (Button b : button) {
      b.pressed(mouseX, mouseY);
    }
  }
  @Override void mouseReleased() {
    for (Button b : button) {
      b.released(mouseX, mouseY);
    }
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }


  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void actBz2()
  {
    np=12;
    ns=5;
    dbeta=0.1;
    trans = this::transformMap1;
  }

  void actBz3()
  {
    np=12;
    ns=4;
    dbeta=0.1;
    trans = this::transformMap2;
  }

  void actBsinz()
  {
    np=14;
    ns=7;
    dbeta=0.1;
    trans = this::transformMap3;
  }

  void actBmobz()
  {
    np=15;
    ns=8;
    dbeta=0.1;
    trans = this::transformMap4;
  }

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void linepv(PVector p, PVector q)
  {
    stroke(cgreen);
    line(p.x*fact, p.y*fact, q.x*fact, q.y*fact);
  }

  void transformMap1(float nx, float ny) {
    tx=nx*nx-ny*ny;                              // Transform = z*z
    ty=2*nx*ny;
  }
  void transformMap2(float nx, float ny) {
    tx=nx*nx*nx-3*nx*ny*ny;                      // Transform= z*z*z
    ty=3*nx*nx*ny - ny*ny*ny;
  }
  void transformMap3(float nx, float ny) {
    tx=sin(1.2*nx)*cosh(1.2*ny);                 // Transform=sin(z)
    ty=-cos(1.2*nx)*sinh(1.2*ny);
  }
  void transformMap4(float nx, float ny) {
    nx=nx/1.5;
    ny=ny/1.5;
    tx=(sq(nx)+sq(ny)-1)/(sq(nx+1)+sq(ny));
    ty=(2*ny)/(sq(nx+1)+sq(ny));
  }

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void trlinepv(PVector p, PVector q)                                // Conformal transformation
  {
    stroke(cblue);
    fill(cred);
    float k=(q.y-p.y)/(q.x-p.x);
    int count = 100;
    for (int j=0; j<count; j++)
    {
      float nx=p.x+j*(q.x-p.x)/(float)count;
      float ny=p.y+k*(nx-p.x);

      trans.accept(nx, ny);

      stroke(cblue);
      fill(cred);
      circle(tx*fact, ty*fact, 8);
      stroke(cred);
      fill(cblue);
      circle(-tx*fact, ty*fact, 8);
    }
  }

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  float cosh(float a)
  {
    float res=(exp(a) +exp(-a))/2.0f;
    return(res);
  }

  float sinh(float a)
  {
    float res=(exp(a) -exp(-a))/2.0f;
    return(res);
  }

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void affstring(String str, float x, float y, float dx, float dy)
  {
    float xs=x+dx;
    float ys=y+dy;
    text(str, xs, ys);
  }

  class Button {
    boolean bOn;

    String title;
    int x, y, w, h;
    color bkColor, lightColor, darkColor;
    int weight;
    int fontSize;
    Runnable r;

    Button(String title, int x, int y, int w, int h, color bkColor, Runnable r) {
      this.bOn = false;

      this.title = title;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.bkColor = bkColor;
      this.lightColor = #E3E3E3;
      this.darkColor = #797979;
      this.weight = 3;
      this.fontSize = 15;

      this.r = r;
    }
    void draw(int mX, int mY) {
      color topLeftColor = lightColor;
      color bottomRightColor = darkColor;
      int textOffset = 0;
      if (bOn && isHit(mX, mY)) {
        topLeftColor = darkColor;
        bottomRightColor = lightColor;
        textOffset = weight;
      }

      push();
      rectMode(CORNER);
      noStroke();
      fill(bkColor);
      rect(x, y, w, h);

      for (int i = 0; i < weight; i++) {
        stroke(topLeftColor);
        line(x+i, y+i, x+w-1-i, y+i);
        line(x+i, y+i, x+i, y+h-1-i);
        stroke(bottomRightColor);
        line(x+i, y+h-1-i, x+w-i, y+h-1-i);
        line(x+w-1-i, y+i, x+w-1-i, y+h-i);
      }
      fill(0);
      textSize(fontSize);
      textAlign(CENTER, CENTER);
      text(title, x-5+textOffset, y-5+textOffset, w, h);
      pop();
    }
    boolean isHit(int mX, int mY) {
      return (x <= mX && mX < x+w) && (y <= mY && mY < y+h);
    }
    void pressed(int mX, int mY) {
      if (isHit(mX, mY)) {
        bOn = true;
        return;
      }
    }
    void released(int mX, int mY) {
      bOn = false;
      // ボタンの中で離されたらコールバックを呼ぶ
      if (isHit(mX, mY)) {
        r.run();
      }
    }
  }
}
