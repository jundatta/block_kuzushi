// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ivan Rudnickiさん
// 【作品名】Panorama Sphere
// https://openprocessing.org/sketch/1006922
//

class GameSceneCongratulations116 extends GameSceneCongratulationsBase {
  PImage[] imgs = new PImage[3];
  int index = 0;
  float ax=0;
  float axv=0;
  float cy=0;
  float cyv=0;
  float cz=0;
  float czv=0;
  float sz=0;
  float szv=0;
  PImage sphereimage;

  PShape sphere;

  void preload() {
    imgs[0] = loadImage("data/116/panorama6.png");
    imgs[1] = loadImage("data/116/panorama7.png");
    imgs[2] = loadImage("data/116/panorama5.png");
    sphereimage = imgs[index];

    sphere = createShape(SPHERE, sphereimage.width/TWO_PI);
    sphere.setStrokeWeight(0);
    sphere.setTexture(sphereimage);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    // 球体（sphere）の分割数はいじっても効果ないにゃ！！
    // テクスチャのサイズをいじるにゃ＼(^_^)／
    //  sphereDetail(15);
    preload();
    //  angleMode(DEGREES);

    // マウスボタンが押されていない状態から始める
    mp = new PressOff();
  }

  class MousePress {
    int movedY;
    int movedX;
    MousePress monitor() {
      return null;
    }
  }
  class PressOff extends MousePress {
    @Override MousePress monitor() {
      // マウスボタンが押されていない間は常に移動量なしを返す
      movedY = 0;
      movedX = 0;
      // マウスボタンが押し込まれていなければそのまま留まる
      if (!mousePressed) {
        return this;
      }
      // マウスボタンが押し込まれているので移動量ありの監視に遷移する
      return new PressOn();
    }
  }
  class PressOn extends MousePress {
    @Override MousePress monitor() {
      // マウスボタンが押し込まれたままなら移動量を求めて返す
      if (mousePressed) {
        movedY = mouseY-pmouseY;
        movedX = mouseX-pmouseX;
        return this;
      }
      // マウスボタンが離されたので常に移動量なしを返すように遷移する
      movedY = 0;
      movedX = 0;
      return new PressOff();
    }
  }

  MousePress mp;
  @Override void draw() {
    background(0);
    push();
    camera(0, 0, sphereimage.height/5.0, 0, cy, 0, 0, 1, 1);
    translate(0, 0, sz);
    rotateZ(radians(0));
    rotateY(radians(ax));
    //  texture(sphereimage);
    sphere.setTexture(sphereimage);
    noStroke();
    //  sphere(sphereimage.width/TWO_PI);
    shape(sphere);

    // マウスボタンが押されているときだけ差を求める
    mp = mp.monitor();
    //cyv+=movedY/10.0f;
    cyv+=(mp.movedY)/10.0f;
    //axv+=movedX/30.0f;
    axv+=(mp.movedX)/30.0f;
    checkKeys();
    pop();

    logoRightLower(color(255, 0, 0));
  }

  void checkKeys() {
    if (keyCode == LEFT) axv-=0.5;
    if (keyCode == RIGHT) axv+=0.5;
    if (keyCode == UP) cyv-=1;
    if (keyCode == DOWN) cyv+=1;
    if (key == 'w') szv+=1;
    if (key == 's') szv-=1;

    // キーが入りっぱなしにならないように0を入れておく
    // （PC-8001さんのハック）
    keyCode = 0;
    key = 0;

    sz+=szv;
    if (sz>900) {
      sz-=szv;
      szv*=-1;
    }
    szv*=.95;
    ax+=axv;
    axv*=.9;
    cy+=cyv;
    cyv*=.9;
    if (abs(cy)>350) {
      cy-=cyv;
      cyv*=-0.5;
    }
  }

  @Override void mousePressed() {
    //    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == ' ') {
      index+=1;
      if (index>imgs.length-1) index = 0;
      sphereimage = imgs[index];
      // PC-8001さん曰く「ハック」
      key = 0;
      return;
    }
    // 操作のキーが入力された場合も遷移しにゃい
    if (keyCode == LEFT) return;
    if (keyCode == RIGHT) return;
    if (keyCode == UP) return;
    if (keyCode == DOWN) return;
    if (key == 'w') return;
    if (key == 's') return;

    gGameStack.change(new GameSceneTitle());
  }
}
