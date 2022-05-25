// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1398272
//

class GameSceneCongratulations262 extends GameSceneCongratulationsBase {
  float rotValue =0;

  PShape treeBase;
  PShape treeBody;
  PShape star;

  @Override void setup() {
    treeBase = createCan(20, 80, 24);
    treeBase.setFill(color(120, 80, 0));
    treeBody = createCone(20, 850, 24);
    treeBody.setFill(color(120, 80, 0));
    star = createCan(60, 20, 6, true, true);
    star.setSpecular(color(255, 255, 0));
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);
    // よくわかりゃんがライトがひとつでは色がでにゃい
    directionalLight(96, 96, 96, 0, 0, -1);
    lightSpecular(192, 192, 192);
    directionalLight(32, 32, 32, 0, 1, -1);
    lightSpecular(32, 32, 32);

    rotValue+=radians(0.1);
    background(220);
    //lights();
    noStroke();
    translate(0, height/2, -300);
    push();
    translate(0, 50, 0);
    noStroke();
    //  cylinder(20, 80);
    shape(treeBase);
    translate(0, -466, 0);
    rotateX(PI);
    //  cone(20, 850);
    shape(treeBody);
    pop();
    for (int iter = 0; iter < 84; iter++) {
      //fill(0, 180, 0);
      specular(0, 180, 0);
      box(500-iter*5.9, 20, 20);
      translate(0, -10);
      rotateY(rotValue);
      push();
      translate(250-iter*2.85, 0, 0);
      colorMode(HSB, 255);
      //specularMaterial(iter*12%255, 255, 255);
      //fill(iter*12%255, 255, 255);
      // 難しい。。。p5.jsみたいにうまくテカらせられない。ゴメン。。。orz
      // (specular()バージョン)
      specular(iter*12%255, 255, 255);
      shininess(5.0);
      sphere(10);
      pop();
      push();
      rotateY(PI);
      translate(250-iter*2.85, 0, 0);
      colorMode(HSB, 255);
      //specularMaterial(iter*12%255, 255, 255);
      //fill(iter*12%255, 255, 255);
      // 難しい。。。p5.jsみたいにうまくテカらせられない。ゴメン。。。orz
      // （emissive()バージョン）
      emissive(iter*12%255, 255, 255);
      sphere(10);
      pop();
    }
    push();
    rotateX(PI/2);
    translate(0, 0, 30);
    //specularMaterial(255, 255, 0);
    //  cylinder(60, 20, 6, 1);
    shape(star);
    pop();
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
