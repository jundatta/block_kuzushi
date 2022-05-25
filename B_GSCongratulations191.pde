// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://neort.io/art/c813uak3p9f3k6tguq7g?index=7&origin=user_profile
//

class GameSceneCongratulations191 extends GameSceneCongratulationsBase {
  PShape sh;

  class Mesh {
    PVector loc;
    color col;

    Mesh(PVector loc, color col) {
      this.loc = loc;
      this.col = col;
    }
  }
  ArrayList<Mesh> mesh = new ArrayList();
  ArrayList<Integer> index = new ArrayList();

  class Seed {
    float noise;
    color col;
    float param;

    Seed(float noise, color col, float param) {
      this.noise = noise;
      this.col = col;
      this.param = param;
    }
  }
  Seed[] seed = new Seed[12];

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(0);
    // ofBlendMode::OF_BLENDMODE_ADDはあきらめた＼(^_^)／
    //blendMode(ADD);
    blendMode(REPLACE);

    push();
    colorMode(HSB, 255, 255, 255, 255);
    for (int i = 0; i < seed.length; i++) {
      float noise = random(1000);
      color col = color(map(i, 0, 16, 0, 255), 255, 255, 0);
      seed[i] = new Seed(noise, col, 0);
    }
    pop();
  }

  void update() {
    mesh.clear();
    index.clear();

    int radius = 320;
    int span = 28;

    for (int i = 0; i < seed.length; i++) {
      for (int deg = 0; deg < 360; deg += 2) {
        var noise_location = new PVector(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD));
        var noise_deg = map(openFrameworks.ofNoise(seed[i].noise, noise_location.x * 0.0025, noise_location.y * 0.0025, seed[i].param), 0, 1, -180, 180);

        var loc = make_point(radius, radius * 0.3, noise_deg, deg);
        loc.z = 0;

        mesh.add(new Mesh(loc, seed[i].col));
      }
      seed[i].param += 0.008f;
    }

    for (int i = 0; i < mesh.size(); i++) {
      for (int k = i + 1; k < mesh.size(); k++) {
        float distance = PVector.dist(mesh.get(i).loc, mesh.get(k).loc);
        if (distance < span) {
          int alpha = distance < span * 0.25 ? 255 : (int)map(distance, span * 0.25, span, 255, 0);

          color col = mesh.get(i).col;
          //int a = (col & 0xff000000) >> 24;
          int a = (int)alpha(col);
          if (a < alpha) {
            //          this->mesh.setColor(i, ofColor(this->mesh.getColor(i), alpha));
            color c = color(mesh.get(i).col, (int)alpha);
            mesh.get(i).col = c;
          }
          col = mesh.get(k).col;
          //a = (col & 0xff000000) >> 24;
          a = (int)alpha(col);
          if (a < alpha) {
            //          this->mesh.setColor(k, ofColor(this->mesh.getColor(k), alpha));
            color c = color(mesh.get(k).col, (int)alpha);
            mesh.get(k).col = c;
          }

          index.add(i);
          index.add(k);
        }
      }
    }
  }

  @Override void draw() {
    update();

    push();
    translate(width / 2, height / 2);

    background(0);

    //  this->cam.begin();

    //  this->mesh.drawWireframe();

    //  this->cam.end();

    sh = createShape();
    sh.setFill(false);
    sh.beginShape(TRIANGLE_STRIP);
    for (Integer i : index) {
      PVector loc = mesh.get(i).loc;
      sh.vertex(loc.x, loc.y, loc.z);
      //color col = mesh.get(i).col;
      //sh.setStroke(i, col);
    }
    sh.endShape();
    for (int i = 0; i < index.size(); i++) {
      int idx = index.get(i);
      color col = mesh.get(idx).col;
      sh.setStroke(i, col);
    }
    shape(sh);

    //for (int i = 0; i < this->mesh.getNumVertices(); i++) {
    //  ofSetColor(this->mesh.getColor(i));
    //  ofDrawSphere(this->mesh.getVertex(i), 1.85);
    //}

    // ごめん。俺には無理だった...
    boolean bSumanyai = false;
    if (bSumanyai) {
      for (int i = 0; i < index.size(); i++) {
        //  ofSetColor(this->mesh.getColor(i));
        //  ofDrawSphere(this->mesh.getVertex(i), 1.85);
        int idx = index.get(i);
        color col = mesh.get(idx).col;
        fill(col);
        //push();
        PVector loc = mesh.get(idx).loc;
        // 重すぎた...orz
        //translate(loc.x, loc.y, loc.z);
        //sphere(1.85);
        circle(loc.x, loc.y, 1.85);
        //pop();
      }
    }
    pop();

    logo(#ff0000);
  }

  PVector make_point(float R, float r, float u, float v) {
    // 数学デッサン教室 描いて楽しむ数学たち　P.31

    u *= DEG_TO_RAD;
    v *= DEG_TO_RAD;

    var x = (R + r * cos(u)) * cos(v);
    var y = (R + r * cos(u)) * sin(v);
    var z = r * sin(u);

    return new PVector(x, y, z);
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
