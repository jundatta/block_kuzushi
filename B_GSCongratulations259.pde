// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Rouxさん
// 【作品名】Sapin de Noël 2
// https://openprocessing.org/sketch/1400423
//

class GameSceneCongratulations259 extends GameSceneCongratulationsBase {
  // Roux Jean-Bernard 2019
  float niveau;
  float hauteurEcran;
  float largeurEcran;
  float h15;
  float depart_x, depart_y;
  float arrivee_x, arrivee_y;
  float pi = 3.1415692;
  float pointEmbranch, pointEmbranchd;
  float angleEmbranch, angleEmbranchd;
  float tailleBranche, tailleBranched;
  float bdn;
  color vert, vertf, brun;

  @Override void setup() {
    largeurEcran = width;
    hauteurEcran = height;
    h15 = hauteurEcran / 5.0;
    depart_x = largeurEcran / 2.0;
    depart_y = 0;
    arrivee_x = largeurEcran / 2;
    arrivee_y = hauteurEcran;
    niveau = 4;
    pointEmbranch = 0.27;
    angleEmbranch = 123.0;
    tailleBranche = 0.6;
    pointEmbranchd = 0.0;
    angleEmbranchd = 0.0;
    tailleBranched = 0.0;
    bdn = 0.02;
    //angleMode(DEGREES);
    ellipseMode(CENTER);
  }
  boolean bRedraw = true;
  @Override void draw() {
    if (!bRedraw) {
      return;
    }
    background(0);
    fractal(depart_x, depart_y, arrivee_x, arrivee_y, niveau);
    bRedraw = false;

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == '+') {
      bdn+=0.02;
      bRedraw = true;
    }
    if (key == '-') {
      bdn-=0.02;
      bRedraw = true;
    }
    if (key == 'a') {
      angleEmbranch+=12;
      bRedraw = true;
    }
    if (key == 'b') {
      angleEmbranch-=12;
      bRedraw = true;
    }
    if (key == 'n') {
      niveau+=1;
      bRedraw = true;
    }
    if (key == 'm') {
      niveau-=1;
      bRedraw = true;
    }
    if (key == 'c') {
      pointEmbranch+=0.02;
      bRedraw = true;
    }
    if (key == 'd') {
      pointEmbranch-=0.02;
      bRedraw = true;
    }
    if (key == 'e') {
      tailleBranche+=0.1;
      bRedraw = true;
    }
    if (key == 'f') {
      tailleBranche-=0.1;
      bRedraw = true;
    }

    //gGameStack.change(new GameSceneTitle());
  }

  void fractal(float depart_x, float depart_y,
    float arrivee_x, float arrivee_y, float niveau) {

    // on calcule la longueur
    var longueur = floor(sqrt(pow(arrivee_y-depart_y, 2)+pow(arrivee_x-depart_x, 2)));
    // on dessine
    // choix des couleurs
    vert = color(0, 128, 0);
    vertf = color(0, 255, 0);
    brun = color(255, 128, 0);
    if (longueur<3) {
      stroke(vertf);
    } else if (longueur<h15) {
      stroke(vert);
    } else {
      stroke(brun);
    }

    line(int(depart_x), int(hauteurEcran-depart_y), int(arrivee_x), int(hauteurEcran-arrivee_y));

    // dessin des boules
    if (random(1)<bdn) {
      var t = int(floor(random(1)*16));
      var nouv = color(int (floor(random(1)*255)), int(floor(random(1)*255)), int(floor(random(1)*255)));
      fill(nouv);
      noStroke();
      ellipse(int((depart_x+arrivee_x)/2), int(hauteurEcran-(depart_y+arrivee_y)/2), t, t);
    }
    var fin = false;
    while ((niveau>0)&&(longueur>1)&&!fin) {
      var pe=random(pointEmbranchd);
      var departN_x = depart_x+(pointEmbranch+pe)*(arrivee_x-depart_x);
      var departN_y = depart_y+(pointEmbranch+pe)*(arrivee_y-depart_y);
      var arriveeN_x = arrivee_x;
      var arriveeN_y = arrivee_y;
      var longueurN = floor(sqrt(pow(arriveeN_y-departN_y, 2)+pow(arriveeN_x-departN_x, 2)));

      if (abs(longueurN-longueur)<1) {
        fin=true;
      }
      var departg_x=departN_x;
      var departg_y=departN_y;
      var arriveeg_x=arrivee_x;
      var arriveeg_y=arrivee_y;
      var departd_x=departN_x;
      var departd_y=departN_y;
      var arriveed_x=arrivee_x;
      var arriveed_y=arrivee_y;
      var ae=random(angleEmbranchd);
      var ag=2*pi-angleEmbranch-ae;
      var ad=angleEmbranch+ae;
      var xg=arriveeg_x-departg_x;
      var yg=arriveeg_y-departg_y;
      var xd=arriveed_x-departd_x;
      var yd=arriveed_y-departd_y;
      var xi=xg*cos(radians(ag))+yg*sin(radians(ag));
      var yi=-xg*sin(radians(ag))+yg*cos(radians(ag));
      xg=xi+departg_x;
      yg=yi+departg_y;
      xi=xd*cos(radians(ad))+yd*sin(radians(ad));
      yi=-xd*sin(radians(ad))+yd*cos(radians(ad));
      xd=xi+departd_x;
      yd=yi+departd_y;
      var tb=random(tailleBranched);
      arriveeg_x=departg_x+(tailleBranche+tb)*(xg-departg_x);
      arriveeg_y=departg_y+(tailleBranche+tb)*(yg-departg_y);
      arriveed_x=departd_x+(tailleBranche+tb)*(xd-departd_x);
      arriveed_y=departd_y+(tailleBranche+tb)*(yd-departd_y);
      depart_x= departN_x;
      depart_y= departN_y;
      arrivee_x= arriveeN_x;
      arrivee_y= arriveeN_y;
      longueur = floor(sqrt(pow(arrivee_y-depart_y, 2)+pow(arrivee_x-depart_x, 2)));
      fractal((departg_x), (departg_y), (arriveeg_x), (arriveeg_y), niveau-1);
      fractal((departd_x), (departd_y), (arriveed_x), (arriveed_y), niveau-1);
    }
  }
}
