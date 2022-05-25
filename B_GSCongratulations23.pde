// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】BO-YE RUANさん
// 【作品名】Wave Circuit V2
// https://openprocessing.org/sketch/1185899
//

class GameSceneCongratulations23 extends GameSceneCongratulationsBase {
  class Pin {
    PVector start;
    PVector end;
    String type;
    float freq;
    color lineColor;
    String label;
    float amp;
    float activeMod;

    Pin(PVector _start, PVector _end, String _type, float _freq,
      color _lineColor, String _label, float _amp, float _activeMod) {
      start = _start;
      end = _end;
      type = _type;
      freq = _freq;
      lineColor = _lineColor;
      label = _label;
      amp = _amp;
      activeMod = _activeMod;
    }
  }
  Pin[] links = new Pin[50];

  float ww, hh;
  // let colors = "fff-437f97-849324-ffb30f-fd151b".split("-").map(a=>"#"+a)
  final color[] colors = { #000fff, #437f97, #849324, #ffb30f, #fd151b };

  // 設定材質，在全域的位子
  PGraphics overAllTexture;

  PVector getPos(PVector gridIndex) {
    return new PVector(gridIndex.x*50, gridIndex.y*50);
  }

  @Override void setup() {
    colorMode(RGB, 255);
    background(100);

    textSize(20);

    ww = int(width/50);
    hh = int(height/50);

    for (int i = 0; i < links.length; i++) {
      PVector start = new PVector(int(random(ww)), int(random(hh)));
      float randomDelta = P5JSrandom(-2, 2, -5, 5, -10, 10);
      PVector end = new PVector(start.x + random(randomDelta), start.y + random(randomDelta));
      String type = P5JSrandom("sin", "sin", "sin", "squar");
      Pin link = new Pin(start, end, type,
        random(1, 50), P5JSrandom(colors),
        type + " #" + i, random(1, 3)*random(1), random(50, 100));
      links[i] = link;
    }
  }

  void xyz(Pin link, float linkId) {
    // 使線條有光暈
    //    drawingContext.shadowColor = color(link.color);
    //    drawingContext.shadowBlur = 30;

    stroke(link.lineColor);
    PVector st = getPos(link.start);
    PVector ed = getPos(link.end);

    // 特透過一條條短短的區段去畫線
    float rr = st.dist(ed);
    //    float ang = ed.copy().sub(st).heading();
    PVector tmp = new PVector();
    tmp.x = ed.x - st.x;
    tmp.y = ed.y - st.y;
    float ang = tmp.heading();

    // add start point and end point
    strokeWeight(5);
    ellipse(st.x, st.y, 20, 20);
    ellipse(ed.x, ed.y, 20, 20);

    // 因為每一次都必須要 translate 到畫線的起點，所以這裡我們要用 Push()/Pop() 包起來
    push();
    translate(st.x, st.y);

    // line text
    push();
    rotate(PI/8);
    rect(20, -5, 2, 2);
    noStroke();
    fill(255, 180);
    text(link.label, 15, 10);
    pop();

    rotate(ang);

    if ((frameCount+linkId*30)%100<link.activeMod && random(1)>0.01) {
      beginShape();
      for (int i=0; i<rr; i+=2) {
        float ratio = 5*(rr/2-abs(i-rr/2))/rr;
        float yy = sin((i+frameCount + mouseX)/link.freq);
        if (link.type.equals("square")) {
          yy=(i+frameCount + mouseY)%100<50?1:-1;
        }
        yy*=link.amp;
        vertex(i, yy*5*ratio);
      }
      endShape();
    }
    pop();
  }

  @Override void draw() {
    push();
    //黑底
    fill(0);
    rectMode(CORNER);
    rect(0, 0, width, height);

    stroke(255);
    strokeWeight(3);
    rectMode(CENTER);

    // 網格
    for (int i=0; i<ww; i++) {
      if (i%5==0) {
        push();
        strokeWeight(1);
        stroke(255, 100);
        noFill();
        line(0, i*50, (ww-1)*50, i*50);
        pop();
      }
      for (int o=0; o<hh; o++) {
        push();
        translate(i*50, o*50);
        // 跟 ww 的概念一樣，判定同時垂直與水平都是5倍數的點才是 isGridPoint
        boolean isGridPoint = (i%5==0 && o%5==0);
        // 這裡透過去看看是不是五的倍數後，也去更動了 rect 的參數數值
        float ww = (i%5==0 && o%5==0) ? 10 : 3;
        // 是 isGridPoint 的話，顏色會比較深，反之其餘會比較淡
        stroke(isGridPoint?255:100);

        // 在 isGridPoint 新增座標
        if (isGridPoint) {
          push();
          noStroke();
          fill(255);
          //        textStyle(BOLD);
          textSize(15);
          text("("+i+","+o+")", 15, 10);
          pop();
        }

        // 是 isGridPoint 的話，旋轉
        if (isGridPoint) rotate(PI/4);
        square(0, 0, ww);

        // 是 isGridPoint 的話，旋轉
        if (isGridPoint) {
          noFill();
          stroke(255, 100);
          strokeWeight(1);
          square(0, 0, ww*(3+sin(frameCount/10.0f + i + o)));
        }
        pop();

        if (i==0 && o%5==0) {
          push();
          strokeWeight(1);
          stroke(255, 100);
          line(o*50, 0, o*50, (hh-1)*50);
          pop();
        }
      }
    }

    stroke(255);
    strokeWeight(5);

    for (int i = 0; i < links.length; i++) {
      xyz(links[i], i);
    }
    pop();

    translate(0, 0, +1);
    logoLeftLower(color(255));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
