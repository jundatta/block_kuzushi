// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Naoki Tsutaeさん
// 【作品名】SameGame
// https://openprocessing.org/sketch/1150078
//

class GameSceneCongratulations87 extends GameSceneCongratulationsBase {
  float t=0;
  float w;
  int stage;
  float boxSize;
  float txtSize;

  final int CELL = 18;
  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    w=min(width, height);
    boxSize=w/float(CELL);
    txtSize=w/float(CELL)*.6;
    colorMode(HSB, 6);
    stage=0;
  }
  boolean[] _field;
  int[] field;
  boolean mFlg;
  float score;
  boolean perfect;

  void init() {
    field = new int[CELL * CELL];
    mFlg=false;
    score=0;
    perfect=false;

    int x, y;
    for (y=CELL; 0 < y--; ) {
      int n = -1;
      for (x=CELL; 0 < x--; ) {
        //      if (!x|!y|x==17|y==17) {
        if (x == 0 || y == 0 || x==(CELL-1) || y==(CELL-1)) {
          n=-1;
        } else {
          switch(stage) {
          case 1:
            n=(x/2^x+y/2)%5;
            break;
          case 2:
            //        n=(x/1.3^y/1.3)%4
            n=(int(x/1.3f)^int(y/1.3f))%4;
            break;
          case 3:
            //          n=random(4)|0;
            n=int(random(4));
            break;
          }
        }
        sets(x, y, n);
      }
    }
  }

  class LAYOUT {
    float x;
    String title;
    LAYOUT(float x, String title) {
      this.x = x;
      this.title = title;
    }
  }
  void menu() {
    push();

    translate(width/2, height/2);
    rectMode(CENTER);

    fill(0, 0, 0);
    textAlign(CENTER);
    textSize(boxSize*2);
    text("SAMEGAME", 0, -w/2.95);
    textSize(boxSize*.7);

    int mx=mouseX-width/2;
    int my=mouseY-height/2;

    int choice=0;
    float[] array = {
      -w/3.0f, 0.0f, w/3.0f
    };
    LAYOUT[] layout = new LAYOUT[]{
      new LAYOUT(-w/3.0f, "STAGE1"),
      new LAYOUT(0.0f, "STAGE2"),
      new LAYOUT(w/3.0f, "RANDOM"),
    };
    for (int i=array.length; 0 < i--; ) {
      //    x=[-w/3, 0, w/3][i]
      float x=layout[i].x;
      push();
      if (abs(mx-x)+abs(my+w/9.0f)<w/3.0f/2.0f*1.1) {
        fill(0, 0, 4);
        choice=i+1;
      } else {
        fill(0, 0, 6);
      }
      rect(x, -w/9.0f, w/3.0f-1, w/3.0f-1);
      pop();
      //    text(["STAGE1", "STAGE2", "RANDOM"][i], x, -w/4.3)
      text(layout[i].title, x, -w/4.3);

      float s=w/750.0f*12;
      for (int Y=(CELL-1); (Y--) > 1; ) {
        for (int X=(CELL-1); (X--) > 1; ) {
          push();
          if (i==0) {
            fill((X/2^Y/2)%5, 6, 6);
          } else if (i==1) {
            fill((int(X/1.3f)^int(Y/1.3f))%4, 6, 6);
          } else if (i==2) {
            fill(int(random(4)), 6, 6);
          }
          rect(x+(X-7.5)*s-s, Y*s-w/4.8-s, s, s);
          pop();
        }
      }
    }

    textSize(boxSize*.7);
    text("You can choose connected boxes,\nclick and erase them.", 0, w/8.0f);
    text("You'll get high scores the more boxes\nyou erase at the same time.", 0, w/4.0f);
    text("If you vanish all boxes\nyou'll acquire 1,000 bonus points.", 0, w/8.0f*3);

    if (mousePressed) {
      if (choice != 0) {
        stage=choice;
      }
    }
    pop();
  }

  @Override void draw() {
    background(0, 0, 6);

    push();
    translate(+320, 0);
    scale(0.4f);
    translate(0, -350);
    logo(color(0, 6, 6));
    pop();

    if (stage==0) {
      menu();
      init();
      return;
    }

    if (keyPressed && key==' ') {
      stage=0;
      return;
    }

    t++;
    translate((width-w)/2, (height-w)/2);

    _text("score:"+score, boxSize, boxSize/3.0f*2);
    _text("Push space key to menu", w/2, w-boxSize/3.0f);

    // count the rest of boxes
    int left;
    int x, y;
    for (left=0, y=(CELL-1); y-->1; ) {
      for (x=(CELL-1); x-->1; ) {
        //      gets(x, y)+1&&left++;
        if (gets(x, y) != -1) {
          left++;
        }
      }
    }

    _text(left+" left", boxSize, w-boxSize/3.0f);

    if (left==0) {
      push();
      textSize(64);
      textAlign(CENTER);
      fill(pow(sin(t/60.0f), 2)*6, 6, 6);
      text("Perfect\n+1000pts", width/2, height/2);
      pop();
      if (!perfect) {
        score+=1000;
        perfect=true;
      }
      return;
    }

    // ↓↓↓↓↓↓↓↓
    boolean flg=false;
    for (y=(CELL-1) - 1; (y--) > 1; ) {
      for (x=(CELL-1); (x--) > 1; ) {
        if (gets(x, y)!=-1 && gets(x, y+1)==-1) {
          sets(x, y+1, gets(x, y));
          sets(x, y, -1);
          flg=true;
        }
      }
    }

    disp();
    if (flg) {
      return;
    }

    // ←←←←
    for (x=(CELL-1); x-->1; ) {
      flg=false;
      for (y=CELL; 0 < y--; ) {
        //      gets(x, y)+1&&(flg=1);
        if (gets(x, y) != -1) {
          flg = true;
        }
      }
      if (!flg) {
        for (y=CELL; 0 < y--; ) {
          sets(x, y, gets(x+1, y));
          sets(x+1, y, -1);
        }
      }
    }

    // get mouse position
    int mx=int((mouseX-(width-w)/2.0f)/boxSize);
    if (mx < 0 || CELL <= mx) {
      return;
    }
    int my=int((mouseY-(height-w)/2.0f)/boxSize);
    if (my < 0 || CELL <= my) {
      return;
    }
    int col=gets(mx, my);
    if (col==-1) {
      return;
    }

    // seek connecting boxes
    //  _field=Array(CELL*CELL).fill(false);
    _field=new boolean[CELL*CELL];
    for (int i = 0; i < _field.length; i++) {
      _field[i] = false;
    }
    _sets(mx, my, true);

    for (flg=true; flg; ) {
      flg=false;
      for (y=CELL; 0 < y--; ) {
        for (x=CELL; 0 < x--; ) {
          if (!_gets(x, y)
            && gets(x, y)==col
            && (_gets(x-1, y)
            || _gets(x+1, y)
            || _gets(x, y-1)
            || _gets(x, y+1))) {
            _sets(x, y, true);
            flg=true;
          }
        }
      }
    }

    int sum;
    for (sum=0, y=(CELL-1); (y--) > 1; ) {
      for (x=(CELL-1); (x--) > 1; ) {
        if (_gets(x, y)) {
          // add to the score
          sum++;
          // blink current boxes
          push();
          strokeWeight(abs(sin(t/4.0f-x-y)*9));
          stroke(0, 0, 6);
          fill(gets(x, y), 6, 6);
          rect(x*boxSize, y*boxSize, boxSize, boxSize);
          pop();
        }
      }
    }
    if (sum<2) {
      return;
    }
    _text("connecting:"+sum+" (+"+pow((sum-2), 2)+")", w/2, boxSize/3.0f*2);

    if (mousePressed) {
      //no keep reacting to mousePress
      if (mFlg) {
        mFlg=false;
        for (y=CELL; 0 < y--; ) {
          for (x=CELL; 0 < x--; ) {
            if (_gets(x, y)) {
              sets(x, y, -1);
            }
          }
        }
        score+=pow((sum-2), 2);
      }
    } else {
      mFlg=true;
    }
  }

  boolean _gets(int x, int y) {
    if (x < 0 || CELL <= x) {
      return false;
    }
    if (y < 0 || CELL <= y) {
      return false;
    }
    return _field[y*CELL+x];
  }
  void _sets(int x, int y, boolean c) {
    _field[y*CELL+x]=c;
  }

  int gets(int x, int y) {
    return field[y*CELL+x];
  }
  void sets(int x, int y, int c) {
    field[y*CELL+x]=c;
  }

  void disp() {
    for (int y=CELL; 0 < y--; ) {
      for (int x=CELL; 0 < x--; ) {
        int c=gets(x, y);
        if (c!=-1) {
          fill(c, 6, 6);
          rect(x*boxSize, y*boxSize, boxSize, boxSize, boxSize/10.0f);
        }
      }
    }
  }

  void _text(String str, float x, float y) {
    textSize(txtSize);
    //stroke(0, 0, 0);
    //noFill();
    fill(0, 0, 0);
    text(str, x, y);
  }

  @Override void mousePressed() {
    //    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    // メニュー画面でないときはブロック崩しのタイトル画面に戻らないようにする
    if (stage != 0) {
      return;
    }
    gGameStack.change(new GameSceneTitle());
  }
}
