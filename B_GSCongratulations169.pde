// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/930898
//

class GameSceneCongratulations169 extends GameSceneCongratulationsBase {
  // 参考文献とか参考にしたサイトなど色々

  // 作ろうと思ったきっかけはoborさんのこれ：https://www.pixiv.net/artworks/62043046
  // ケモノイラスト眺めてたらこれが・・それで歯車作ろうと思って。
  // インボリュート曲線使ってるなんて知らなかったから知らないこといっぱいで楽しかった！！
  // 参考文献：今日からモノ知りシリーズの「歯車の本」を立ち読み（日刊工業新聞社）
  // 参考にしたページ：https://ja.wikipedia.org/wiki/インボリュート歯車,
  // 各種定数はこの辺：https://www.khkgears.co.jp/gear_technology/pdf/gijutu.pdf

  ArrayList<GearGroup> gearGroupArray = new ArrayList();

  // utility.
  float f(float t, float s) {
    return cos(t) - s * sin(t);
  }
  float g(float t, float s) {
    return sin(t) + s * cos(t);
  }
  float inv(float a) {
    return tan(a) - a;
  } // インボリュート関数

  abstract class Mask {
    abstract void draw(PGraphics pg);
  }
  void drawMask(PGraphics pg, Mask m) {
    // 本当のmask()したい描画もする
    pg.push();
    pg.blendMode(REPLACE);
    pg.noStroke();
    pg.fill(0, 0);
    m.draw(pg);
    pg.pop();
  }


  // 穴作成関数群
  // 基本型
  class MaskNormalHole extends Mask {
    float r;
    MaskNormalHole(float r) {
      this.r = r;
    }
    @Override void draw(PGraphics pg) {
      pg.circle(0, 0, r * 1.6);
    }
  }
  void createNormalHole(PGraphics gr, float r, color gearColor) {
    //gr.erase();
    //gr.circle(0, 0, r * 1.6);
    //gr.noErase();

    MaskNormalHole m = new MaskNormalHole(r);
    drawMask(gr, m);

    gr.stroke(gearColor);
    gr.strokeWeight(r * 0.2);
    gr.circle(0, 0, r * 0.4);
    float angle = random(1) * 2 * PI;
    final int kNum = 3;
    for (int k = 0; k < kNum; k++) {
      gr.line(0, 0, r * 0.82 * cos(angle), r * 0.82 * sin(angle));
      angle += PI * 2 / (float)kNum;
    }
  }

  // 複数の円
  class MaskMultiCircleHole extends Mask {
    float r;
    int num;
    MaskMultiCircleHole(float r, int num) {
      this.r = r;
      this.num = num;
    }
    @Override void draw(PGraphics pg) {
      float angle = random(1) * 2 * PI;
      float diam = r * 0.5 * sin(PI / (float)num) * 1.5;
      for (int k = 0; k < num; k++) {
        pg.circle(r * 0.5 * cos(angle), r * 0.5 * sin(angle), diam);
        angle += PI * 2 / (float)num;
      }
    }
  }
  void createMultiCircleHole(PGraphics gr, float r, int num) {
    //gr.erase();
    //float angle = random(1) * 2 * PI;
    //float diam = r * 0.5 * sin(PI / (float)num) * 1.5;
    //for (int k = 0; k < num; k++) {
    //  gr.circle(r * 0.5 * cos(angle), r * 0.5 * sin(angle), diam);
    //  angle += PI * 2 / (float)num;
    //}
    MaskMultiCircleHole m = new MaskMultiCircleHole(r, num);
    drawMask(gr, m);
  }
  void createMultiCircleHole(PGraphics gr, float r) {
    createMultiCircleHole(gr, r, 3);
  }

  // 星型
  class MaskStarHole extends Mask {
    float r;
    MaskStarHole(float r) {
      this.r = r;
    }
    @Override void draw(PGraphics pg) {
      final float ratio = sin(PI * 0.3) - (sqrt(5) - 1) * sin(PI * 0.2) * cos(PI * 0.3); // 0.381966くらい
      float angle = random(1) * 2 * PI;
      PVector[] points = new PVector[5 + 1];
      int k;
      for (k = 0; k < points.length-1; k++) {
        //points.push( {
        //x:
        //  r * 0.8 * cos(angle), y:
        //  r * 0.8 * sin(angle)
        //}
        //);
        points[k] = new PVector(r * 0.8 * cos(angle), r * 0.8 * sin(angle));
        angle += PI * 2 / (float)(points.length-1);
      }
      //points.push( {
      //x:
      //  -r * 0.8 * ratio * cos(angle), y:
      //  -r * 0.8 * ratio * sin(angle)
      //}
      //);
      points[k] = new PVector(-r * 0.8 * ratio * cos(angle), -r * 0.8 * ratio * sin(angle));
      pg.triangle(points[1].x, points[1].y, points[4].x, points[4].y, points[5].x, points[5].y);
      pg.quad(points[0].x, points[0].y, points[2].x, points[2].y, points[5].x, points[5].y, points[3].x, points[3].y);
    }
  }
  void createStarHole(PGraphics gr, float r) {
    // ratioは内側の頂点の内外比
    //final float ratio = sin(PI * 0.3) - (sqrt(5) - 1) * sin(PI * 0.2) * cos(PI * 0.3); // 0.381966くらい
    //gr.erase();
    //float angle = random(1) * 2 * PI;
    //PVector[] points = new PVector[5 + 1];
    //int k;
    //for (k = 0; k < points.length-1; k++) {
    //  //points.push( {
    //  //x:
    //  //  r * 0.8 * cos(angle), y:
    //  //  r * 0.8 * sin(angle)
    //  //}
    //  //);
    //  points[k] = new PVector(r * 0.8 * cos(angle), r * 0.8 * sin(angle));
    //  angle += PI * 2 / (float)(points.length-1);
    //}
    ////points.push( {
    ////x:
    ////  -r * 0.8 * ratio * cos(angle), y:
    ////  -r * 0.8 * ratio * sin(angle)
    ////}
    ////);
    //points[k] = new PVector(-r * 0.8 * ratio * cos(angle), -r * 0.8 * ratio * sin(angle));
    //gr.triangle(points[1].x, points[1].y, points[4].x, points[4].y, points[5].x, points[5].y);
    //gr.quad(points[0].x, points[0].y, points[2].x, points[2].y, points[5].x, points[5].y, points[3].x, points[3].y);
    MaskStarHole m = new MaskStarHole(r);
    drawMask(gr, m);
  }

  // 六角形っぽいイメージで
  class MaskHexaLineHole extends Mask {
    float r;
    MaskHexaLineHole(float r) {
      this.r = r;
    }
    @Override void draw(PGraphics pg) {
      pg.circle(0, 0, r * 1.6);
    }
  }
  void createHexaLineHole(PGraphics gr, float r, color gearColor) {
    //gr.erase();
    //gr.circle(0, 0, r * 1.6);
    //gr.noErase();
    MaskHexaLineHole m = new MaskHexaLineHole(r);
    drawMask(gr, m);
    gr.stroke(gearColor);
    gr.strokeWeight(r * 0.1);
    float angle = 0;
    final int kNum = 3;
    for (int k = 0; k < kNum; k++) {
      gr.line(r * 0.85 * cos(angle), r * 0.85 * sin(angle), -r * 0.85 * cos(angle), -r * 0.85 * sin(angle));
      angle += PI * 2 / (float)kNum;
    }
    gr.noFill();
    gr.arc(0, 0, r, r, 0, 2 * PI);
  }

  // 単純に穴を開ける感じ
  class MaskSimpleHole extends Mask {
    float r;
    MaskSimpleHole(float r) {
      this.r = r;
    }
    @Override void draw(PGraphics pg) {
      pg.circle(0, 0, r * 1.85);
    }
  }
  void createSimpleHole(PGraphics gr, float r) {
    //gr.erase();
    //gr.circle(0, 0, r * 1.85);
    MaskSimpleHole m = new MaskSimpleHole(r);
    drawMask(gr, m);
  }

  // 月型
  class MaskMoonHole extends Mask {
    float r;
    MaskMoonHole(float r) {
      this.r = r;
    }
    @Override void draw(PGraphics pg) {
      pg.circle(0, 0, r * 1.4);
    }
  }
  void createMoonHole(PGraphics gr, float r) {
    gr.noStroke();
    //gr.erase();
    //gr.circle(0, 0, r * 1.4);
    //gr.noErase();
    MaskMoonHole m = new MaskMoonHole(r);
    drawMask(gr, m);
    gr.circle(0, r * 0.4, r);
  }

  void createHole(PGraphics gr, float r, color gearColor, String typeName) {
    // grは歯車の画像で、grは既に中心が(0, 0)になっているから、普通にrの範囲で描画してOK.
    switch(typeName) {
    case "normal":
      // 中央に小さく円、3つの扇形状の穴を開ける感じね。
      createNormalHole(gr, r, gearColor);
      break;
    case "tricircle":
      // 3つの穴を開ける、最初につくったやつ。
      createMultiCircleHole(gr, r, 3);
      break;
    case "pentacircle":
      // 5つバージョン
      createMultiCircleHole(gr, r, 5);
      break;
    case "star":
      // 星型の穴
      createStarHole(gr, r);
      break;
    case "hexaline":
      // 真ん中あたりに円弧、そして棒を6本突き出す。
      createHexaLineHole(gr, r, gearColor);
      break;
    case "simple":
      // 普通に穴開けるだけ
      createSimpleHole(gr, r);
      break;
    case "moon":
      // 月
      createMoonHole(gr, r);
      break;
    }
  }

  // alpha（圧力角）はPI/9（要するに20°）が一般的ってあった。全部そうしてある。でもまあ一応変数にしておくか。
  void drawGearImage(PGraphics gr, float size, float alpha,
    float z, float m, color gearColor, String holeTypeName /* = "normal" */) {
    float r = z * m * 0.5; // ピッチ円の半径。
    float rb = r * cos(alpha); // 基礎円の半径。インボリュート曲線の根元。
    float ra = r + m; // 歯の先が描く円の半径。これでいいらしい。
    float ri = min(rb, r - 1.25 * m); // 歯底円の半径。基礎円より大きくなる場合は基礎円と同じとする。ここ雑なんですけどまあいいやって感じで。
    float beta = acos(r * cos(alpha) / ra); // 歯の先における法線と円の接点からその点までの角変位
    float psi = tan(beta); // thetaが0からpsiまで動く間に描く軌跡が側面になる
    float phi = (float)Math.PI / (float)(2 * z) + inv(alpha); // インボリュートのスタートまでの角度

    ArrayList<PVector> points = new ArrayList(); // ひとつながりにする。
    float phase, theta, radius;

    // processing [java]のbackground()はアルファ値（透明度）を
    // みてくれにゃい「仕様」っぽい
    // （p5.js [JavaScript]はみてくれる感じ）
    // ⇒私の間違いでした。。。orz

    gr.background(0, 0);  // ARGB->0x00000000

    gr.translate(size, size);
    //  gr.applyMatrix(1, 0, 0, -1, 0, 0);
    gr.fill(gearColor);
    gr.stroke(0);
    gr.strokeWeight(0.3);

    // まずphase-PI/zから初めて歯底円上をPI/2z-inv(a)だけ進み、そこから基礎円まで行き、
    // 基礎円上をinv(b)だけ進んで曲線描画、
    // 先っちょから円弧をたどって反対側、
    // また曲線描いて反対側、戻る。
    for (int k = 0; k < z; k++) {
      phase = PI * 2 * k / z;
      //points.push( {
      //x:
      //  ri * cos(phase - PI / z), y:
      //  ri * sin(phase - PI / z)
      //}
      //);
      PVector v = new PVector(ri * cos(phase - PI / z), ri * sin(phase - PI / z));
      points.add(v);
      // 歯底円上をスタートまで円弧
      int kNum = 10;
      for (int i = 0; i <= kNum; i++) {
        theta = phase - PI / z + (PI / (float)(2 * z) - inv(alpha)) * (i / (float)kNum);
        //points.push( {
        //x:
        //  ri * cos(theta), y:
        //  ri * sin(theta)
        //}
        //);
        v = new PVector(ri * cos(theta), ri * sin(theta));
        points.add(v);
      }
      // 歯底円から基礎円まで浮上
      kNum = 10;
      for (int i = 0; i <= kNum; i++) {
        radius = ri + (rb - ri) * (i / (float)kNum);
        theta = phase - PI / (float)(2 * z) - inv(alpha);
        //points.push( {
        //x:
        //  radius * cos(theta), y:
        //  radius * sin(theta)
        //}
        //);
        v = new PVector(radius * cos(theta), radius * sin(theta));
        points.add(v);
      }
      // 基礎円からインボリュートで外へ
      kNum = 40;
      for (int i = 0; i <= kNum; i++) {
        theta = psi * i / (float)kNum;
        //points.push( {
        //x:
        //  rb * f(phase - phi + theta, -theta), y:
        //  rb * g(phase - phi + theta, -theta)
        //}
        //);
        v = new PVector(rb * f(phase - phi + theta, -theta), rb * g(phase - phi + theta, -theta));
        points.add(v);
      }
      // 歯先円。
      kNum = 10;
      for (int i = 0; i <= kNum; i++) {
        theta = phase + (phi - inv(beta)) * (-1 + 0.2 * i);
        //points.push( {
        //x:
        //  ra * cos(theta), y:
        //  ra * sin(theta)
        //}
        //);
        v = new PVector(ra * cos(theta), ra * sin(theta));
        points.add(v);
      }
      // 逆インボリュートで再び基礎円へ
      kNum = 40;
      for (int i = 0; i <= kNum; i++) {
        theta = psi * (kNum - i) / (float)kNum;
        //points.push( {
        //x:
        //  rb * f(phase + phi - theta, theta), y:
        //  rb * g(phase + phi - theta, theta)
        //}
        //);
        v = new PVector(rb * f(phase + phi - theta, theta), rb * g(phase + phi - theta, theta));
        points.add(v);
      }
      // 基礎円から歯底円へ
      kNum = 10;
      for (int i = 0; i <= kNum; i++) {
        radius = ri + (rb - ri) * ((kNum - i) / (float)kNum);
        theta = phase + PI / (float)(2 * z) + inv(alpha);
        //points.push( {
        //x:
        //  radius * cos(theta), y:
        //  radius * sin(theta)
        //}
        //);
        v = new PVector(radius * cos(theta), radius * sin(theta));
      }
      // 歯底円上をふたたびたどりフィニッシュ
      kNum = 10;
      for (int i = 0; i <= kNum; i++) {
        theta = phase + PI / z - (PI / (float)(2 * z) - inv(alpha)) * ((kNum - i) / (float)kNum);
        //points.push( {
        //x:
        //  ri * cos(theta), y:
        //  ri * sin(theta)
        //}
        //);
        v = new PVector(ri * cos(theta), ri * sin(theta));
      }
    }

    // まとめてcurveVertexで描画
    gr.beginShape();
    for (PVector p : points) {
      gr.curveVertex(p.x, p.y);
      //gr.vertex(p.x, p.y);  // こっちに変えてもヒトデの足のまま変わらずだった
    }
    gr.endShape();

    // 穴を開けておめかし
    createHole(gr, ri, gearColor, holeTypeName);
  }

  // 歯車クラス
  class Gear {
    int size;
    PGraphics img;
    PVector position;
    float alpha;
    float teethNum;
    float module;
    color gearColor;
    double angularVelocity;
    float radius;
    float initialPhase;
    double phase;
    Gear(float x, float y, float alpha, float z, float m, color gearColor, String holeTypeName /* = "normal" */, float angularVelocity, float initialPhase /* = 0 */) {
      this.size = int((z + 1) * m); // 2倍が(z+2)*mより小さくなるように取った。キャンバスサイズの半分。
      // ⇒P3Dを指定したら戻って来なくなった（激重？ハングアップ？）
      this.img = createGraphics((int)this.size * 2, (int)this.size * 2);
      this.img.beginDraw();
      drawGearImage(this.img, this.size, alpha, z, m, gearColor, holeTypeName); // 歯車画像の貼り付け
      this.img.endDraw();
      this.position = new PVector(x, y); // 中心位置
      this.alpha = alpha; // 圧力角
      this.teethNum = z; // 歯の数
      this.module = m; // モジュール、要は歯の大きさ
      this.gearColor = gearColor; // 歯車のボディカラー
      this.angularVelocity = angularVelocity; // 回転速度。かみ合う方の歯車はこれを元に自動的に決まる。
      this.radius = z * m * 0.5; // ピッチ円の半径はかみ合わせる際の配置で使う
      this.initialPhase = initialPhase; // 初期位相。かみ合わせる際に参照される。
      this.phase = initialPhase; // 位相。0のとき一つの歯の先っぽがまっすぐ右を向く感じ。その先っぽが向いている方向。
    }
    void update() {
      // 回転させる
      this.phase += this.angularVelocity;
    }
    void draw() {
      // GearGroupの方でtranslateして中心がもう(0, 0)になっているのでその上でrotateして回転を表現する感じですね。
      // push/popを多用したくないのでそこは工夫してやってます。
      rotate((float)this.phase);
      image(this.img, -this.size, -this.size);
      rotate((float)-this.phase);
    }
  }

  // 互いにかみ合う歯車の集合体。一つ用意して、あとはそれと、それにかみ合うものにかみ合わせていく。
  class GearGroup {
    ArrayList<Gear> gearArray;
    GearGroup(float x, float y, float alpha, float z, float m, color gearColor, String holeTypeName /* = "normal" */, float angularVelocity) {
      this.gearArray = new ArrayList();
      //const {
      //  x, y, alpha, z, m, gearColor, holeTypeName, angularVelocity
      //}
      //= initialGearData;
      final Gear initialGear = new Gear(x, y, alpha, z, m, gearColor, holeTypeName, angularVelocity, 0);
      this.gearArray.add(initialGear);
    }
    void connectGear(int index, float z, color gearColor, String holeTypeName /* = "normal" */, float direction) {
      // 新しい歯車のalpha(圧力角)とモジュールは同じだし速度も決まってしまう（かみ合い前提）ので歯の数と色だけが問題。
      // あとはどの歯車にくっつくか（これはindexで決める）と方向(0～2*PI)があれば追加できるようになる。
      // 位置も半径と方向から決まってしまうからあらかじめ決めておく必要ない。
      // 最後にinitialPhaseの計算、これも一次方程式を解くだけ。簡単です。
      //const {
      //  index, z, gearColor, holeTypeName, direction
      //}
      //= additionalGearData;
      // index:どの歯車に付くか。z:歯の数。gearColor:色。direction:歯車のくっつく方向。
      // やるべきこと：x, y, alpha, m, angularVelocity, initialPhaseを計算し新しい歯車を追加する。
      final Gear target = this.gearArray.get(index); // ターゲットギア。
      final float alpha = target.alpha;
      final float m = target.module;
      final float r = z * m * 0.5; // くっつける歯車の基礎円の半径. これとtarget.radiusの和が中心間の距離になる。そこからx, yを割り出す。
      final float x = target.position.x + (target.radius + r) * cos(direction);
      final float y = target.position.y + (target.radius + r) * sin(direction);
      final float angV = (float)(target.angularVelocity * (target.teethNum / z)); // 角速度は歯の数に反比例する。かみ合うとはそういうこと。
      // initialPhaseの計算。
      // 何をしているかというとtargetGearがdirection方向に歯の先を向けるタイミングとadditionalGearがマイナスのdirection方向に
      // 歯の間を向けるタイミングを等置して一次方程式を作りそれを解くことでフェイズを算出している。
      // その際任意整数が出てくるがどれかひとつのタイミングで合えばいいので（それで残り全部一致する）勝手に決めて構わない。
      // 回転方向が互逆なのでそれを考慮しないといけないところが難しい。
      final float k = (float)((double)(direction - target.initialPhase) / target.angularVelocity - Math.PI / (double)(z * angV));
      final float iniP = direction + PI + angV * k;
      final Gear additionalGear = new Gear(x, y, alpha, z, m, gearColor, holeTypeName, -angV, iniP); // angVを逆にしないとかみ合わないので要注意
      // 接続、というかグループに追加するだけ。これのインデックスを使えばさらにくっつけてくっつけて・・といくらでも。
      this.gearArray.add(additionalGear);
    }
    void update() {
      for (Gear _gear : this.gearArray) {
        _gear.update();
      }
    }
    void draw() {
      push();
      // それぞれのかみあいはもう考慮済みなのでtranslateで引き算しながら次々描画していくだけ。
      float prevX = 0;
      float prevY = 0;
      for (Gear _gear : this.gearArray) {
        translate(_gear.position.x - prevX, _gear.position.y - prevY);
        _gear.draw();
        prevX = _gear.position.x;
        prevY = _gear.position.y;
      }
      pop();
    }
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    colorMode(HSB, 100);
    textSize(24);

    // 一応、歯の数はすべて素数を採用している。

    //let gg1 = new GearGroup( {
    //x:
    //160, y:
    //130, alpha:
    //PI/9, z:
    //37, m:
    //10, gearColor:
    //  color(78, 40, 40), angularVelocity:
    //  0.01
    //}
    //);
    GearGroup gg1 = new GearGroup(160, 130, PI/9.0f, 37, 10, color(78, 40, 40), "normal", 0.01);
    //gg1.connectGear( {
    //index:
    //0, z:
    //41, gearColor:
    //  color(78, 40, 40), direction:
    //  atan(0.75)
    //}
    //);
    gg1.connectGear(0, 41, color(78, 40, 40), "normal", atan(0.75));
    gearGroupArray.add(gg1);

    //let gg2 = new GearGroup( {
    //x:
    //120, y:
    //360, alpha:
    //PI/9, z:
    //43, m:
    //8, gearColor:
    //  color(67, 60, 60), holeTypeName:
    //"hexaline", angularVelocity:
    //  0.02
    //}
    //);
    GearGroup gg2 = new GearGroup(120, 360, PI/9.0f, 43, 8, color(67, 60, 60), "hexaline", 0.02);
    //gg2.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(67, 60, 60), holeTypeName:
    //"hexaline", direction:
    //  -PI/4
    //}
    //);
    gg2.connectGear(0, 31, color(67, 60, 60), "hexaline", -PI/4.0f);
    //gg2.connectGear( {
    //index:
    //1, z:
    //23, gearColor:
    //  color(67, 60, 60), holeTypeName:
    //"hexaline", direction:
    //  PI/4
    //}
    //);
    gg2.connectGear(1, 23, color(67, 60, 60), "hexaline", PI/4.0f);
    gearGroupArray.add(gg2);

    //let gg3 = new GearGroup( {
    //x:
    //320, y:
    //240, alpha:
    //PI/9, z:
    //59, m:
    //6, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"simple", angularVelocity:
    //  0.01
    //}
    //);
    GearGroup gg3 = new GearGroup(320, 240, PI/9.0f, 59, 6, color(55, 80, 80), "simple", 0.01);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  PI / 6
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", PI/6.0f);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  PI * 7 / 6
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", PI * 7/6.0f);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  -PI / 6
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", -PI/6.0f);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  -PI * 7 / 6
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", -PI * 7/6.0f);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  PI / 2
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", PI / 2.0f);
    //gg3.connectGear( {
    //index:
    //0, z:
    //31, gearColor:
    //  color(55, 80, 80), holeTypeName:
    //"star", direction:
    //  -PI / 2
    //}
    //);
    gg3.connectGear(0, 31, color(55, 80, 80), "star", -PI / 2.0f);
    gearGroupArray.add(gg3);

    //let gg4 = new GearGroup( {
    //x:
    //-160, y:
    //560, alpha:
    //PI/9, z:
    //113, m:
    //6, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"simple", angularVelocity:
    //  0.005
    //}
    //);
    GearGroup gg4 = new GearGroup(-160, 560, PI/9.0f, 113, 6, color(45, 100, 100), "simple", 0.005);
    //gg4.connectGear( {
    //index:
    //0, z:
    //41, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"tricircle", direction:
    //  -PI/4
    //}
    //);
    gg4.connectGear(0, 41, color(45, 100, 100), "tricircle", -PI/4.0f);
    //gg4.connectGear( {
    //index:
    //1, z:
    //31, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"pentacircle", direction:
    //  PI/4
    //}
    //);
    gg4.connectGear(1, 31, color(45, 100, 100), "pentacircle", PI/4.0f);
    //gg4.connectGear( {
    //index:
    //2, z:
    //17, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"simple", direction:
    //  -PI/4
    //}
    //);
    gg4.connectGear(2, 17, color(45, 100, 100), "simple", -PI/4.0f);
    //gg4.connectGear( {
    //index:
    //3, z:
    //29, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"hexaline", direction:
    //  PI/7
    //}
    //);
    gg4.connectGear(3, 29, color(45, 100, 100), "hexaline", PI/7.0f);
    //gg4.connectGear( {
    //index:
    //3, z:
    //53, gearColor:
    //  color(45, 100, 100), direction:
    //  -PI/2
    //}
    //);
    gg4.connectGear(3, 53, color(45, 100, 100), "normal", -PI/2.0f);
    //gg4.connectGear( {
    //index:
    //1, z:
    //89, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"simple", direction:
    //  -PI * 3 / 4
    //}
    //);
    gg4.connectGear(1, 89, color(45, 100, 100), "simple", -PI * 3 / 4.0f);
    //gg4.connectGear( {
    //index:
    //2, z:
    //11, gearColor:
    //  color(45, 100, 100), holeTypeName:
    //"star", direction:
    //  PI/4
    //}
    //);
    gg4.connectGear(2, 11, color(45, 100, 100), "star", PI/4.0f);
    gearGroupArray.add(gg4);
  }

  // 描画部分はこれだけ。
  @Override void draw() {
    // 作者様ベタで塗られたみないなのでいいっすかねw
    // 。。。（背景工夫しようと思ったけど思いつかなかった。とのことでした）
    //  image(bg, 0, 0);
    background(#404040);
    for (GearGroup gg : gearGroupArray) {
      gg.update();
    }
    push();
    // 高さを480から800に伸ばしているので気持ち下にずらしています
    translate(0, 150);
    for (GearGroup gg : gearGroupArray) {
      gg.draw();
    }
    pop();
    text(frameRate, 10, 20);

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
