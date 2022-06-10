// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】MISEUNG PAHKさん
// 【作品名】cafe
// https://openprocessing.org/sketch/898406
//

class GameSceneCongratulations65 extends GameSceneCongratulationsBase {
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    pg = createGraphics(width, height);
    pg.beginDraw();

    pg.colorMode(RGB, 255, 255, 255, 100);

    //background
    pg.noStroke();
    pg.fill(245, 235, 211);
    pg.rect(0, 0, 800, 800);

    //window
    pg.noStroke();
    pg.fill(131, 108, 110);
    pg.rect(50, 0, 70, 400);
    pg.fill(240, 182, 148);
    pg.rect(100, 0, 30, 400);

    pg.fill(131, 108, 110);
    pg.rect(300, 0, 70, 500);
    pg.fill(240, 182, 148);
    pg.rect(350, 0, 30, 500);

    pg.fill(131, 108, 110);
    pg.rect(650, 0, 70, 800);
    pg.fill(240, 182, 148);
    pg.rect(700, 0, 30, 800);

    //table
    pg.noStroke();
    pg.fill(76, 50, 47);
    pg.triangle(0, 350, 800, 600, 0, 800);
    pg.triangle(800, 600, 800, 800, 0, 800);

    pg.stroke(0);
    pg.strokeWeight(1.5);
    pg.line(800, 750, 630, 800);
    pg.line(800, 700, 450, 800);
    pg.line(800, 650, 220, 800);

    pg.stroke(0, 0, 0, 70);
    pg.strokeWeight(1.5);
    pg.line(800, 600, 0, 800);
    pg.line(710, 575, 0, 740);
    pg.line(645, 555, 0, 690);

    pg.stroke(0, 0, 0, 45);
    pg.strokeWeight(1.4);
    pg.line(585, 535, 0, 645);
    pg.line(525, 515, 0, 610);
    pg.line(470, 500, 0, 580);

    pg.stroke(0, 0, 0, 20);
    pg.strokeWeight(1.4);
    pg.line(430, 485, 0, 555);
    pg.line(400, 470, 0, 530);
    pg.line(380, 455, 0, 505);

    pg.stroke(0, 0, 0, 15);
    pg.strokeWeight(1.2);
    pg.line(350, 435, 0, 480);
    pg.line(350, 415, 0, 455);
    pg.line(350, 395, 0, 435);

    pg.stroke(0, 0, 0, 12);
    pg.strokeWeight(1.2);
    pg.line(325, 380, 0, 415);
    pg.line(100, 385, 0, 395);


    //shadow
    pg.noStroke();
    pg.fill(66, 39, 0);
    pg.ellipse(260, 665, 400, 120);




    //cup-handle

    pg.stroke(217);
    pg.strokeWeight(100);
    pg.line(150, 480, 150, 600);

    pg.stroke(167);
    pg.strokeWeight(98);
    pg.line(170, 490, 170, 590);

    pg.stroke(76, 50, 47);
    pg.strokeWeight(90);
    pg.line(170, 490, 170, 590);

    //cup- body
    pg.noStroke();
    pg.fill(217, 217, 217);
    pg.rect(150, 400, 300, 250);
    pg.ellipse(300, 650, 300, 100);

    pg.stroke(250);
    pg.strokeWeight(10);
    pg.line(430, 420, 430, 660);

    pg.stroke(255);
    pg.strokeWeight(8);
    pg.ellipse(300, 400, 294, 85);


    //お茶 - in
    pg.noStroke();
    pg.fill(110, 122, 80);
    pg.ellipse(300, 400, 288, 80);
    pg.noStroke();
    pg.fill(179, 201, 100);
    pg.ellipse(300, 400, 270, 65);

    pg.stroke(245, 235, 211);
    pg.strokeWeight(4);
    pg.ellipse(300, 400, 220, 50);
    pg.strokeWeight(3);
    pg.ellipse(300, 400, 190, 34);
    pg.noStroke();
    pg.fill(245, 235, 211);
    pg.ellipse(300, 400, 140, 25);

    //お茶 - out
    pg.stroke(110, 122, 80);
    pg.strokeWeight(15);
    pg.line(395, 440, 395, 525);
    pg.strokeWeight(30);
    pg.line(375, 440, 375, 505);

    pg.stroke(179, 201, 100);
    pg.strokeWeight(15);
    pg.line(400, 426, 400, 520);
    pg.strokeWeight(30);
    pg.line(382, 434, 382, 500);

    pg.noStroke();
    pg.fill(110, 122, 80);
    pg.ellipse(400, 610, 10, 30);
    pg.fill(179, 201, 100);
    pg.ellipse(402, 608, 10, 30);

    //お茶- light
    pg.stroke(245);
    pg.strokeWeight(2);
    pg.line(402, 440, 402, 500);

    pg.noStroke();
    pg.fill(245);
    pg.ellipse(405, 605, 3, 9);


    //けむり
    pg.noStroke();
    pg.fill(255, 255, 255, 40);
    pg.ellipse(380, 50, 200, 200);
    pg.ellipse(450, 120, 160, 160);
    pg.ellipse(540, 80, 180, 180);
    pg.ellipse(540, 220, 120, 120);
    pg.ellipse(530, 20, 200, 200);

    pg.noStroke();
    pg.fill(255, 255, 255, 60);
    pg.ellipse(480, 240, 130, 130);
    pg.ellipse(530, 280, 100, 100);
    pg.ellipse(460, 320, 60, 60);
    pg.ellipse(410, 270, 60, 60);

    pg.noStroke();
    pg.fill(255, 255, 255, 80);
    pg.ellipse(420, 330, 45, 45);
    pg.ellipse(440, 300, 35, 35);
    pg.ellipse(420, 350, 20, 20);
    pg.ellipse(440, 350, 25, 25);

    pg.noStroke();
    pg.fill(255, 255, 255, 85);
    pg.ellipse(380, 390, 15, 15);
    pg.ellipse(410, 370, 18, 18);
    pg.ellipse(398, 350, 20, 20);
    pg.ellipse(399, 380, 25, 25);

    pg.endDraw();
  }
  @Override void draw() {
    image(pg, 0, 0, width, height);

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
