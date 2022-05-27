// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Haakon Søraasさん
// 【作品名】Radarklokke
// https://openprocessing.org/sketch/1238121
//

class GameSceneCongratulations188 extends GameSceneCongratulationsBase {
  PFont klokkefont;

  //FloatList radar = new FloatList();

  float sekNa;
  float minNa;
  float timNa;

  float sekMilliNa;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    smooth();

    klokkefont = createFont("data/188/digital-7.ttf", 16);
    textFont(klokkefont);
    textSize(36);
    textAlign(CENTER, CENTER);

    sekNa = second();
    minNa = minute();
    timNa = hour();

    sekMilliNa = millis();

    background(0);
    strokeWeight(3);
  }
  @Override void draw() {
    push();
    noStroke();
    fill(0, 0, 0, 6);
    rect(0, 0, width, height);

    String datoTekst = (day() < 10 ? "0" : "") + str(day()) + " : " + (month() < 10 ? "0" : "") + month() + " : " + year();
    datoTekst += "\n" + (hour() < 10 ? "0" : "") + hour() + " : " + (minute() < 10 ? "0" : "") + minute();// + " : " + (second() < 10 ? "0" : "") + second();
    fill(255, 255, 255, 10);
    text(datoTekst, width/2, height/3);

    if (sekNa != second()) {
      sekNa = second();
      sekMilliNa = millis();
    }
    if (minNa != minute()) {
      minNa = minute();
    }
    if (timNa != hour()) {
      timNa = hour();
    }

    float sekVinkel = map(sekNa + (millis()- sekMilliNa)/1000, 0, 60, 0, TWO_PI) - PI/2;
    float minVinkel = map(minNa + ((float) second()/60), 0, 60, 0, TWO_PI) - PI/2;
    float timVinkel = map((timNa + ((float) minute()/60)) % 12, 0, 12, 0, TWO_PI) - PI/2;

    translate(width/2, height/2);
    stroke(255, 0, 0);
    line(0, 0, 200*cos(sekVinkel), 200*sin(sekVinkel));
    stroke(0);
    line(0, 0, 200*cos(sekVinkel-PI/10), 200*sin(sekVinkel-PI/10));
    stroke(255);
    line(0, 0, 170*cos(minVinkel), 170*sin(minVinkel));
    line(0, 0, 140*cos(timVinkel), 140*sin(timVinkel));

    for (int tall = 1; tall < 13; tall++) {
      float tallVinkel = map(tall, 0, 12, 0, TWO_PI) - PI/2;

      fill(500-dist(270*cos(tallVinkel), 270*sin(tallVinkel), 200*cos(sekVinkel), 200*sin(sekVinkel)), dist(270*cos(tallVinkel), 270*sin(tallVinkel), 200*cos(sekVinkel), 200*sin(sekVinkel)), 0);
      text(tall, 270*cos(tallVinkel), 270*sin(tallVinkel));
      text(tall * 5, 220*cos(tallVinkel), 220*sin(tallVinkel));

      noFill();
      arc(0, 0, 440, 440, tallVinkel+PI/20, tallVinkel+PI/10);
      arc(0, 0, 540, 540, tallVinkel+PI/20, tallVinkel+PI/10);
    }

    fill(150);
    noStroke();
    ellipse(0, 0, 20, 20);
    pop();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
