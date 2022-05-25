// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Sayamaさん
// 【作品名】SpaceClock
// https://openprocessing.org/sketch/805636
//

class GameSceneCongratulations38 extends GameSceneCongratulationsBase {
  ArrayList<Particle> p = new ArrayList();
  final float num = 300;//max 500くらい?●

  float diagonal;
  float rotation = 0;
  float senkaiR = 0.05;//旋回の大きさ●
  float senkaiSpeed = 0.1;//旋回のスピード●


  class Particle {
    float alpha;
    float n;
    float rotate;
    float o;
    float type;
    float speed;
    float sizeMulti;
    color c;

    Particle() {
      this.alpha = 1;
      this.n = random(1, width/2.0f);
      this.rotate = random(0, TWO_PI);//rotation Offset
      this.o = random(1, random(1, width/this.n));
      this.type = (float)Math.floor(random(3));
      this.speed = 0.07;//●speed
      this.sizeMulti = 0.25;//●size
      this.c = color(255, 255, 255);//●color
    }

    void draw() {
      this.alpha++;
      push();
      rotate(this.rotate);
      translate(0, this.drawDist(width));
      fill(red(this.c), green(this.c), blue(this.c), min(this.alpha, 255));
      float size = width/this.o*this.sizeMulti;

      if (this.type == 0) {
        drawDottypo(0, 0, size, second(), 0);//drawMode●
      } else if (this.type == 1) {
        drawDottypo(0, 0, size, minute(), 1);//drawMode●
      } else {
        drawDottypo(0, 0, size, hour(), 2);//drawMode●
      }
      pop();
      this.o-=this.speed;
    }

    float drawDist(int w) {
      return atan(this.n/this.o)/HALF_PI*w;
    }
  }

  final int widDotNum = 3;//●
  final int heiDotNum = 5;//●

  //●
  final int[][][] typosData = new int[][][]{
    {//0
      {1, 1, 1},
      {1, 0, 1},
      {1, 0, 1},
      {1, 0, 1},
      {1, 1, 1},
    },
    {//1
      {1, 1, 0},
      {0, 1, 0},
      {0, 1, 0},
      {0, 1, 0},
      {1, 1, 1},
    },
    {//2
      {1, 1, 1},
      {0, 0, 1},
      {1, 1, 1},
      {1, 0, 0},
      {1, 1, 1},
    },
    {//3
      {1, 1, 1},
      {0, 0, 1},
      {1, 1, 1},
      {0, 0, 1},
      {1, 1, 1},
    },
    {//4
      {1, 0, 1},
      {1, 0, 1},
      {1, 1, 1},
      {0, 0, 1},
      {0, 0, 1},
    },
    {//5
      {1, 1, 1},
      {1, 0, 0},
      {1, 1, 1},
      {0, 0, 1},
      {1, 1, 1},
    },
    {//6
      {1, 1, 1},
      {1, 0, 0},
      {1, 1, 1},
      {1, 0, 1},
      {1, 1, 1},
    },
    {//7
      {1, 1, 1},
      {1, 0, 1},
      {0, 0, 1},
      {0, 0, 1},
      {0, 0, 1},
    },
    {//8
      {1, 1, 1},
      {1, 0, 1},
      {1, 1, 1},
      {1, 0, 1},
      {1, 1, 1},
    },
    {//9
      {1, 1, 1},
      {1, 0, 1},
      {1, 1, 1},
      {0, 0, 1},
      {1, 1, 1},
    },
  };

  void drawDottypo(float tx, float ty, float size, int num, float mode) {
    ellipseMode(CENTER);
    rectMode(CENTER);
    noStroke();
    ArrayList<IntList> typeData = getNumtypoArray(num);//描画する文字の配列
    float unitSize = size/widDotNum;//1ドットのサイズ
    float startPosX = tx - unitSize*(typeData.get(0).size()/2.0f) + unitSize*0.5;  //描画開始位置
    float startPosY = ty - unitSize*(typeData.size()/2.0f) + unitSize*0.5;  //描画開始位置

    for (int y = 0; y < typeData.size(); y ++) {
      for (int x = 0; x < typeData.get(y).size(); x ++) {
        if (typeData.get(y).get(x) == 1) {
          if (mode == 0) {//custom drawMode●
            ellipse(startPosX + unitSize*x, startPosY + unitSize*y, unitSize*0.8, unitSize*0.8);
          } else if (mode == 1) {//custom drawMode●
            rect(startPosX + unitSize*x, startPosY + unitSize*y, unitSize*0.9, unitSize*0.9);
          } else if (mode == 2) {//custom drawMode●
            quad(startPosX + unitSize*x + unitSize*0.5, startPosY + unitSize*y,
              startPosX + unitSize*x, startPosY + unitSize*y + unitSize*0.5,
              startPosX + unitSize*x + unitSize*0.5, startPosY + unitSize*y + unitSize,
              startPosX + unitSize*x + unitSize, startPosY + unitSize*y + unitSize*0.5
              );
          } else if (mode == 3) {//custom drawMode●
            ellipse(startPosX + unitSize*x, startPosY + unitSize*y, unitSize*0.2, unitSize*0.2);
          }
        }
      }
    }
  }

  ArrayList<IntList> getNumtypoArray(int num) {
    String numStr = str(num);
    ArrayList<IntList> array = new ArrayList();
    for (int i = 0; i < heiDotNum; i++) {
      array.add(new IntList());
    }

    for (int i = 0; i < numStr.length(); i++) {
      int n = int(str(numStr.charAt(i)));
      for (int j = 0; j < array.size(); j ++) {
        //      Array.prototype.push.apply(array[j], typosData[n][j]);
        array.get(j).append(typosData[n][j]);
        if (i < numStr.length()-1) {
          array.get(j).append(0);//space
        }
      }
    }
    return array;
  }

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    diagonal = (float)Math.floor(sqrt(width * width + height * height)/2.0f);
    //init particle
    for (int i = 0; i<num; i++) {
      p.add(new Particle());
      p.get(i).o = random(1, random(1, width/p.get(i).n));
    }

    background(0);
    noStroke();
  }
  @Override void draw() {
    background(0, 220);//color●

    push();
    //旋回
    float r = map(frameCount*senkaiSpeed%30, 0, 30, HALF_PI*-1, HALF_PI*3);
    float rad = width*senkaiR*sin(frameCount/100.0f);
    translate(width/2.0f+cos(r)*rad, height/2.0f + sin(r)*rad);

    rotation-=0.002;//●回転スピード
    rotate(rotation);

    for (int i = 0; i<p.size(); i++) {
      p.get(i).draw();
      //reset particle
      if (diagonal*1.5 < p.get(i).drawDist(height)) {
        p.set(i, new Particle());
      }
    }
    pop();

    logoRightLower(color(0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
