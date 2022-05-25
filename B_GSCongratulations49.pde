// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】YUYUYUYUさん
// 【作品名】Unstable System
// https://openprocessing.org/sketch/1239258
//

class GameSceneCongratulations49 extends GameSceneCongratulationsBase {
  // let colors = "f2f230-c2f261-91f291-61f2c2-30f2f2-fff".split("-").map(a=>"#"+a)
  color[] colors = {#f2f230, #c2f261, #91f291, #61f2c2, #30f2f2, #ffffff};
  PGraphics overAllTexture;
  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    background(255);
    overAllTexture=createGraphics(width, height);
    overAllTexture.beginDraw();
    // noStroke()
    for (int i=0; i<width+50; i++) {
      for (int o=0; o<height+50; o++) {
        overAllTexture.set(i, o, color(100, noise(i/3, o/3, i*o/50)*P5JSrandom(0, 40, 80)));
      }
    }
    overAllTexture.endDraw();
    midR= (width-50)/2.4;

    pg = createGraphics(width, height);
  }

  float rotateCount = 60.0f;
  float midR;

  @Override void draw() {
    pg.beginDraw();

    pg.push();
    pg.fill(0, 30, 55, 30);
    pg.rect(0, 0, width, height);
    pg.stroke(255);
    pg.translate(width/2, height/2);
    pg.stroke(255, 30);
    pg.strokeWeight(10);
    pg.noFill();
    pg.ellipse(0, 0, midR*2.0f, midR*2.0f);
    pg.strokeWeight(2);
    pg.ellipse(0, 0, midR*2*0.9, midR*2*0.9);
    pg.rotate(noise(frameCount/150.0f)*2 + mouseX/50.0f);
    for (int i=0; i<rotateCount; i+=1) {
      pg.push();
      pg.rotate(i*PI*2.0f/rotateCount);
      pg.stroke(255, 30);
      pg.strokeWeight(2);
      pg.line(50, 0, width/2-50, 0);
      pg.push();
      pg.strokeWeight(( i%5==0?5:1));
      pg.stroke(255);
      pg.rotate(cos(-frameCount/80.0f)*2.0f);
      pg.line(width/2-20, 0, width/2 +( i%5==0?10:-5), 0);
      pg.pop();

      pg.noStroke();
      float dotPos = sin(frameCount/100.0f+i + noise(frameCount/500.0f+i, i)/2.0f)*(width/2-50 )*1.4;
      color clr = colors[i%colors.length ];
      //    float sz = (cos(frameCount/20.0f+i)+0.5+1)*22 ;
      float sz = (cos(frameCount/20.0f+i)+0.5+1)*10 ;
      color fillClr = color(red(clr), green(clr), blue(clr), 200);
      //      fillClr.setAlpha(200)
      pg.strokeWeight(1);
      if ( random(1.0f)<0.85 && (  !mousePressed )&& (frameCount+i)%80>10 ) {
        pg.fill(fillClr);
      }
      pg.stroke(clr);
      pg.ellipse(width/2*1.2, 0, 5, 5);
      pg.translate(dotPos/3.0f, 0);
      pg.rotate(frameCount/100.0f);
      pg.rectMode(CENTER);
      if (i%2==0 && (random(1.0f)<0.9)) {
        pg.ellipse(0, 0, sz/2.0f, sz/2.0f);
      } else {
        pg.rect(0, 0, sz/2.0f, sz/2.0f);
      }
      pg.translate(dotPos/3.0f, 0);
      pg.rotate(-frameCount/100.0f);
      if (i%2==0) {
        pg.ellipse(0, 0, sz, sz);
      } else {
        pg.rect(0, 0, sz, sz);
      }

      pg.pop();
    }
    pg.pop();
    pg.fill(255);
    pg.textSize(20);

    pg.push();
    pg.blendMode(MULTIPLY);

    pg.image(overAllTexture, 0, 0);
    pg.pop();

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
