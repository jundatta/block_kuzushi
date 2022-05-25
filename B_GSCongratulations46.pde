// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】kosukeさん
// 【作品名】Image Puzzle
// https://openprocessing.org/sketch/1236350
//

class GameSceneCongratulations46 extends GameSceneCongratulationsBase {
  final int num=5;
  PImage img;
  int[][] locs;
  PImage[] prts;
  int w, h;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    img=loadImage("data/46/toys.jpg");
    img.resize(width, height);
    println("W:" + img.width + " H:" + img.height);

    locs = new int[num][];
    for (int j=0; j<num; j++) {
      locs[j]=new int[num];
      for (int i=0; i<num; i++) {
        locs[j][i]=num*j+i;
      }
    }
    prts=new PImage[num*num];
    w=int(img.width/num);
    h=int(img.height/num);
    for (int i=0; i<num*num; i++) {
      prts[i]=img.get(w*(i%num), h*int(i/num), w, h);
    }
    for (int i=0; i<num*num; i++) {
      swap(locs, int(random(num)), int(random(num)), int(random(num)), int(random(num)));
    }
  }
  @Override void draw() {
    background(0);
    for (int j=0; j<num; j++) {
      for (int i=0; i<num; i++) {
        image(prts[locs[j][i]], w*i, h*j, w-1, h-1);
      }
    }

    logoRightLower(color(255, 0, 0));
  }

  @Override void mouseDragged() {
    if (0<=mouseX&&mouseX<width&&0<=mouseY&&mouseY<height&&0<=pmouseX&&pmouseX<width&&0<=pmouseY&&pmouseY<height) {
      int mi=int(mouseX/w);
      int mj=int(mouseY/h);
      int pmi=int(pmouseX/w);
      int pmj=int(pmouseY/h);
      swap(locs, mi, mj, pmi, pmj);
    }
  }

  void swap(int[][] a, int i1, int j1, int i2, int j2) {
    int t=a[j1][i1];
    a[j1][i1]=a[j2][i2];
    a[j2][i2]=t;
  }

  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
