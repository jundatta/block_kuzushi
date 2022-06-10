// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】KaijinQさん
// 【作品名】PlanetaryGears_4.0
// https://openprocessing.org/sketch/849653
//

class GameSceneCongratulations67 extends GameSceneCongratulationsBase {
  // PlanetaryGears_4.0

  float H = 0.99 ;
  float K = 0.05 ;

  float M[] = new float[2] ;
  float R[][] = new float[2][4] ;
  float A[][] = new float[2][4] ;
  float F[] = new float[2] ;
  float Rev[] = new float[2] ;
  int I ;
  int MD ;
  float AA ;
  float LX ;
  float RX ;
  float KA ;
  float X ;
  float Y ;
  float CX ;
  float CY ;
  float KR ;
  float LY ;
  float RY ;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    pg = createGraphics(1112, 1112);

    R[0][0] = 100 ;
    R[0][1] = 60 ;
    R[0][2] = R[0][0] + (R[0][1]*2) ;
    R[0][3] = R[0][2] + 40 ;
    R[1][0] = 100 ;
    R[1][1] = 60 ;
    R[1][2] = R[1][0] + (R[1][1]*2) ;
    R[1][3] = R[1][2] + 40 ;
    F[0] = 5 ;
    F[1] = 5 ;
    MD = 5 ;
    A[0][1] = PI ;
    M[0] = 500000 ;
    M[1] = 500000 ;
    RY = 800 ;
    LY = 550 ;
  }
  @Override void draw() {
    pg.beginDraw();

    pg.translate(100, 65);
    pg.background(200, 200, 200) ;

    LX = 450-((R[0][0]+R[1][3])/2) ;
    RX = 450+((R[0][0]+R[1][3])/2) ;

    pg.textSize(60) ;
    pg.strokeWeight(2) ;
    pg.fill(255, 255, 0) ;
    pg.stroke(0, 0, 0) ;
    CX = LX ;
    CY = 300 ;
    AA = A[0][3] ;
    pg.beginShape() ;
    GEAR(3, 0) ;

    CX = LX ;
    CY = 300 ;
    AA = A[0][2] ;
    antiGEAR(2, 0) ;
    pg.endShape(CLOSE) ;

    pg.fill(0, 220, 0) ;
    KR = R[0][0]+R[0][1] ;
    CX = KR*cos(A[0][1])+LX ;
    CY = KR*sin(A[0][1])+300 ;
    AA = A[0][1]-((A[0][1]-A[0][2])*(R[0][2]/R[0][1])) ;
    pg.beginShape() ;
    GEAR(1, 0) ;
    pg.endShape(CLOSE) ;
    pg.fill(255, 50, 50) ;
    pg.line(CX, CY, CX+(R[0][1]*cos(AA)), CY+(R[0][1]*sin(AA))) ;
    pg.strokeWeight(20) ;
    pg.stroke(255, 0, 0) ;
    pg.noFill() ;
    pg.ellipse(LX, 300, KR*2, KR*2) ;
    pg.strokeWeight(1) ;
    pg.stroke(0, 0, 0) ;
    pg.line(LX-KR-10, 300, LX-KR-10, LY) ;
    pg.beginShape() ;
    for ( I = 0; I < 100; I++ ) {
      Y = I*(800-LY)/100 + LY ;
      X = LX-KR-20 ;
      Y = Y + (10*sin(0.2*I*PI)) ;
      X = X + (10*cos(0.2*I*PI)) ;
      pg.vertex(X, Y) ;
    }
    pg.ellipse(LX-KR-10, 800, 4, 4) ;
    pg.line(LX-KR-10, 800, X, Y) ;
    pg.endShape() ;
    pg.line(LX-KR+80, 660, LX-KR+80, 710) ;
    pg.line(LX-KR+80, 710, LX-KR+60, 690) ;
    pg.line(LX-KR+80, 710, LX-KR+100, 690) ;
    pg.strokeWeight(2) ;
    pg.ellipse(LX, 300, KR*2+20, KR*2+20) ;
    pg.ellipse(LX, 300, KR*2-20, KR*2-20) ;
    pg.fill(0, 0, 0) ;
    pg.text(nf(2*F[0], 2, 2), LX-KR, 650) ;
    pg.fill(255, 0, 0) ;
    pg.ellipse(CX, CY, 10, 10) ;

    pg.fill(100, 100, 255) ;
    CX = LX ;
    CY = 300 ;
    AA = A[0][0] ;
    pg.beginShape() ;
    GEAR(0, 0) ;
    pg.endShape(CLOSE) ;
    X = (sqrt(M[0])/10*cos(A[0][0])) ;
    Y = (sqrt(M[0])/10*sin(A[0][0])) ;
    pg.line(CX+X, CY+Y, CX-X, CY-Y) ;
    pg.ellipse(CX, CY, 20, 20) ;
    pg.fill(100, 100, 100) ;
    pg.ellipse(CX+X, CY+Y, 40, 40) ;
    pg.ellipse(CX-X, CY-Y, 40, 40) ;

    pg.fill(255, 255, 0) ;
    CX = RX ;
    CY = 300 ;
    AA = A[1][3] ;
    pg.beginShape() ;
    GEAR(3, 1) ;

    CX = RX ;
    CY = 300 ;
    AA = A[1][2] ;
    antiGEAR(2, 1) ;
    pg.endShape(CLOSE) ;

    pg.fill(0, 220, 0) ;
    KR = R[1][0]+R[1][1] ;
    CX = (R[1][0]+R[1][1])*cos(A[1][1])+RX ;
    CY = (R[1][0]+R[1][1])*sin(A[1][1])+300 ;
    AA = A[1][1]-((A[1][1]-A[1][2])*(R[1][2]/R[1][1])) ;
    pg.beginShape() ;
    GEAR(1, 1) ;
    pg.endShape(CLOSE) ;
    pg.fill(255, 50, 50) ;
    pg.line(CX, CY, CX+(R[1][1]*cos(AA)), CY+(R[1][1]*sin(AA))) ;
    pg.strokeWeight(20) ;
    pg.stroke(255, 0, 0) ;
    pg.noFill() ;
    pg.ellipse(RX, 300, KR*2, KR*2) ;
    pg.strokeWeight(1) ;
    pg.stroke(0, 0, 0) ;
    pg.fill(0, 0, 0) ;
    pg.line(RX-KR-10, 300, RX-KR-10, RY) ;
    pg.line(RX-KR-10, RY, RX-KR-30, RY-20) ;
    pg.line(RX-KR-10, RY, RX-KR+10, RY-20) ;
    pg.text(nf(2*F[1], 2, 2), RX-KR-100, RY+40) ;
    pg.strokeWeight(2) ;
    pg.noFill() ;
    pg.ellipse(RX, 300, KR*2+20, KR*2+20) ;
    pg.ellipse(RX, 300, KR*2-20, KR*2-20) ;
    pg.fill(255, 0, 0) ;
    pg.ellipse(CX, CY, 10, 10) ;

    pg.fill(100, 100, 255) ;
    CX = RX ;
    CY = 300 ;
    AA = A[1][0] ;
    pg.beginShape() ;
    GEAR(0, 1) ;
    pg.endShape(CLOSE) ;
    X = (sqrt(M[1])/10*cos(A[1][0])) ;
    Y = (sqrt(M[1])/10*sin(A[1][0])) ;
    pg.line(CX+X, CY+Y, CX-X, CY-Y) ;
    pg.ellipse(CX, CY, 20, 20) ;
    pg.fill(100, 100, 100) ;
    pg.ellipse(CX+X, CY+Y, 40, 40) ;
    pg.ellipse(CX-X, CY-Y, 40, 40) ;

    pg.noFill() ;
    pg.strokeWeight(4) ;
    pg.stroke(0, 0, 0) ;
    pg.rect(0, 0, 900, 900) ;
    pg.ellipse(650, 680, 80, 80) ;
    pg.ellipse(650, 780, 80, 80) ;
    pg.ellipse(750, 680, 80, 80) ;
    pg.ellipse(750, 780, 80, 80) ;
    pg.ellipse(850, 680, 80, 80) ;
    pg.ellipse(850, 780, 80, 80) ;
    pg.line(620, 680, 680, 680) ;
    pg.line(650, 650, 650, 710) ;
    pg.line(620, 780, 680, 780) ;
    pg.line(720, 680, 780, 680) ;
    pg.line(720, 680, 730, 670) ;
    pg.line(720, 680, 730, 690) ;
    pg.line(780, 680, 770, 670) ;
    pg.line(780, 680, 770, 690) ;
    pg.line(720, 780, 745, 780) ;
    pg.line(780, 780, 755, 780) ;
    pg.line(745, 780, 735, 770) ;
    pg.line(745, 780, 735, 790) ;
    pg.line(755, 780, 765, 770) ;
    pg.line(755, 780, 765, 790) ;
    pg.arc(850, 670, 40, 20, -PI, PI/2) ;
    pg.line(850, 680, 850, 690) ;
    pg.fill(0, 0, 0) ;
    pg.ellipse(850, 700, 6, 6) ;
    pg.rect(835, 765, 10, 30) ;
    pg.rect(855, 765, 10, 30) ;
    pg.stroke(255, 0, 0) ;
    pg.noFill() ;
    pg.arc(RX, 850, 30, 30, -PI, +PI/2) ;
    pg.line(RX-15, 850, RX-15, 855) ;
    pg.line(RX-15, 855, RX-20, 850) ;
    pg.line(RX-15, 855, RX-10, 850) ;
    pg.arc(LX, 850, 30, 30, -PI, +PI/2) ;
    pg.line(LX-15, 850, LX-15, 855) ;
    pg.line(LX-15, 855, LX-20, 850) ;
    pg.line(LX-15, 855, LX-10, 850) ;
    pg.stroke(100, 100, 255) ;
    pg.arc(RX-180, 850, 30, 30, -PI, +PI/2) ;
    pg.line(RX-195, 850, RX-195, 855) ;
    pg.line(RX-195, 855, RX-200, 850) ;
    pg.line(RX-195, 855, RX-190, 850) ;
    pg.arc(LX-180, 850, 30, 30, -PI, +PI/2) ;
    pg.line(LX-195, 850, LX-195, 855) ;
    pg.line(LX-195, 855, LX-200, 850) ;
    pg.line(LX-195, 855, LX-190, 850) ;

    pg.textSize(30) ;
    pg.fill(100, 100, 255) ;
    Rev[0] = ( ((F[1]*R[1][2]*R[0][0]/R[1][3])-(F[0]*R[0][0]))/M[0] + Rev[0] ) * H ;
    Rev[1] = ( ((F[0]*R[0][2]*R[1][0]/R[0][3])-(F[1]*R[1][0]))/M[1] + Rev[1] ) * H ;
    pg.text(-Rev[0], LX-160, 870) ;
    pg.text(-Rev[1], RX-160, 870) ;
    A[0][0] = A[0][0]+Rev[0] ;
    A[1][0] = A[1][0]+Rev[1] ;
    A[0][3] = -A[1][0]*(R[1][0]/R[0][3]) ;
    A[1][3] = -A[0][0]*(R[0][0]/R[1][3]) ;
    A[0][2] = A[0][3] ;
    A[1][2] = A[1][3] ;
    pg.fill(255, 0, 0) ;
    KA = (A[0][0]*(R[0][0]/(R[0][0]+R[0][2]))) + (A[0][2]*(R[0][2]/(R[0][0]+R[0][2]))) + PI ;
    LY = LY + ((R[0][0]+R[0][1]+10)*(A[0][1]-KA)) ;
    F[0] = (700-LY)*K ;
    pg.text(-KA+A[0][1], LX+20, 870) ;
    A[0][1] = KA ;
    KA = (A[1][0]*(R[1][0]/(R[1][0]+R[1][2]))) + (A[1][2]*(R[1][2]/(R[1][0]+R[1][2]))) ;
    RY = RY + ((R[1][0]+R[1][1]+10)*(A[1][1]-KA)) ;
    if ( RY > 800 ) {
      RY = 650 ;
    }
    if ( RY < 650 ) {
      RY = 800 ;
    }
    pg.text(-KA+A[1][1], RX+20, 870) ;
    A[1][1] = KA ;
    pg.fill(0, 0, 0) ;
    pg.textSize(20) ;
    pg.text("(rad/step)", 780, 870) ;

    pg.endDraw();
    image(pg, 0, 0, width, height);

    translate(0, height * 0.4125f);
    logo(color(255, 0, 0));
  }

  void GEAR(int II, int III) {

    for ( I = 0; I < int(R[III][II]/MD); I++ ) {
      X = (R[III][II]-(MD*1.5))*cos(2*PI*(I+0.1)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]-(MD*1.5))*sin(2*PI*(I+0.1)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]-(MD*1.5))*cos(2*PI*(I+0.4)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]-(MD*1.5))*sin(2*PI*(I+0.4)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]+(MD*1.5))*cos(2*PI*(I+0.6)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]+(MD*1.5))*sin(2*PI*(I+0.6)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]+(MD*1.5))*cos(2*PI*(I+0.9)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]+(MD*1.5))*sin(2*PI*(I+0.9)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]-(MD*1.5))*cos(2*PI*(I+1.1)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]-(MD*1.5))*sin(2*PI*(I+1.1)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
    }
  } // GEAR()

  void antiGEAR(int II, int III) {

    for ( I = int(R[III][II]/MD); I > 0; I-- ) {
      X = (R[III][II]+(MD*1.5))*cos(2*PI*(I-0.1)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]+(MD*1.5))*sin(2*PI*(I-0.1)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]+(MD*1.5))*cos(2*PI*(I-0.4)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]+(MD*1.5))*sin(2*PI*(I-0.4)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]-(MD*1.5))*cos(2*PI*(I-0.6)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]-(MD*1.5))*sin(2*PI*(I-0.6)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]-(MD*1.5))*cos(2*PI*(I-0.9)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]-(MD*1.5))*sin(2*PI*(I-0.9)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
      X = (R[III][II]+(MD*1.5))*cos(2*PI*(I-1.1)/(R[III][II]/MD)+AA) ;
      Y = (R[III][II]+(MD*1.5))*sin(2*PI*(I-1.1)/(R[III][II]/MD)+AA) ;
      pg.vertex(X+CX, Y+CY) ;
    }
  } // antiGEAR()

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
