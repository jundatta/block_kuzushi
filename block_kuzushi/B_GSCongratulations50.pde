// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】EliKさん
// 【作品名】Exploding Duck Timer
// https://openprocessing.org/sketch/1240439
//

class GameSceneCongratulations50 extends GameSceneCongratulationsBase {
  float timer = 1; // This is the minutes of the timer
  Par[] pars= new Par[500];
  float once = 0;

  PImage duckImg;

  float timeF = 100;
  float home = 0;
  float secs=50;
  float oSec=0;
  float off=0;

  void P5preload() {
    //  boom=loadSound("intervention_420.mp3");
    mMA.entry("芸術は爆発だ！！", "data/50/intervention_420.mp3");
    duckImg=loadImage("data/50/duck.png");
  }

  @Override void setup() {
    colorMode(RGB, 255);
    P5preload();
    imageMode(CENTER);
    background(0);
    duckImg.resize(250*2, 0);
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.image(duckImg, width/2, height/2);
    pg.endDraw();
    for (int i=0; i<500; i++) {
      int xx=(int)random(width);
      int yy=(int)random(height);
      while (blue(pg.get(xx, yy))>240) {
        xx=(int)random(width);
        yy=(int)random(height);
      }
      //    pars.push(new Par(xx, yy));
      pars[i] = new Par(xx, yy);
    }
    off=second();
  }
  @Override void draw() {
    background(0);

    if (home==0) {
      if (second()!=oSec) {
        secs++;
      }
      oSec=second();
      imageMode(CENTER);
      duckImg.resize(250, 0);
      image(duckImg, width/2, height/2);
      textAlign(CENTER, CENTER);
      textSize(150);
      if (secs/60.0f>=timer) {
        home=1;
        resetCount();
      }
      fill(255, 0, 0);
      noStroke();
      if ((round(((-secs/60.0f)+timer)*60)%60)>=10) {
        text(round((-secs/60.0f)+timer-0.5)+":"+(round(((-secs/60.0f)+timer)*60)%60), width/2, 100);
      } else {
        text(round((-secs/60.0f)+timer-0.5)+":0"+(round(((-secs/60.0f)+timer)*60)%60), width/2, 100);
      }
    }
    if (home==1) {
      imageMode(CENTER);
      noStroke();
      for (int i=0; i<pars.length; i++) {
        pars[i].move();
      }
      if (getCount()<timeF) {
        duckImg.resize(250, 0);
        push();
        translate(width/2, height/2);
        scale((map(round(getCount()), 0, timeF, 1, 2)));
        image(duckImg, 0, 0);
        pop();
      }
    }

    translate(0, height * 0.3125f);
    logo(color(255, 0, 0));
  }

  class Par {
    int x;
    int y;
    float xVel;
    float yVel;
    float ran;
    Par(int x, int y) {
      this.x=x;
      this.y=y;
      this.xVel=0;
      this.yVel=0;
      this.ran=1;//round(random(1))
    }

    void move() {
      if (getCount()>timeF) {
        this.yVel+=0.1;
      }
      if (this.ran==1) {
        fill(245, 215, 0);
      } else {
        fill(255, 0, 0);
      }
      if (getCount()>=timeF) {
        ellipse(this.x, this.y, 5, 5);
        if (once == 0) {
          mMA.playAndRewind("芸術は爆発だ！！");
          once++;
        }
      }

      if (this.x>width||this.x<0) {
        this.xVel*=-0.1;
        this.x+=this.xVel;
      }
      if (this.y>height||this.y<0) {
        this.yVel*=-0.1;
        this.y+=this.yVel;
      }
      this.y+=this.yVel;
      this.x+=this.xVel;
      if (getCount()==timeF) {
        if (this.ran==1) {
          this.xVel=random(-5*10, 5*10);
          this.yVel=random(-5*10, 5*10);
        } else {
          this.xVel=random(-5*10, 5*10);
          this.yVel=random(-5*10, 5*10);
        }
      }
    }
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
