// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1406859
//

class GameSceneCongratulations256 extends GameSceneCongratulationsBase {
  class cmplx {
    float a, b;

    cmplx(float ax, float by) {
      this.a = ax;
      this.b = by;
    }

    cmplx add(cmplx other) {
      return new cmplx(this.a+other.a, this.b+other.b);
    }

    cmplx mul(cmplx other) {
      return new cmplx( this.a*other.a - this.b*other.b, this.a*other.b + this.b*other.a);
    }

    cmplx raise(cmplx other) {
      float r = log( sqrt( this.a*this.a + this.b*this.b ) );
      float ang = angle(this.a, this.b);
      float real = exp(r*other.a - ang*other.b);
      float imag = r*other.b + ang*other.a;
      return new cmplx( real*cos(imag), real*sin(imag) );
    }

    float mag() {
      return sqrt(this.a*this.a+this.b*this.b);
    }
  }

  float angle(float a, float b) {
    if (a==0.0) {
      return b > 0.0 ? PI/2 : -PI/2;
    } else {
      return atan(b/a);
    }
  }

  class particle {
    float r, i;
    float size;

    particle(float x, float y, float s) {
      this.r = x;
      this.i = y;
      this.size = s;
    }
    void move(float timestep) {
      var c = new cmplx(this.r, this.i);
      float t = dateNow()-start;
      float r = 8*sin(t*0.0004);
      float i = 0;//20*sin(t*0.000001);
      c = c.raise(new cmplx(r, i));
      this.r += c.a*timestep;
      this.i += c.b*timestep;
    }
    void draw() {
      fill(255, 255, 255);
      stroke(this.r*200+128, this.i*200+128, 255-this.i*this.i+this.r*this.r);
      ellipse(cx+0.5*radius*this.r, cy+0.5*radius*this.i, this.size, this.size);
    }
  }

  float dateNow() {
    // 厳密にはDate.now()ではありますが。。。(^^;
    // （たぶん大丈夫じゃないっすかね～）
    return millis();
  }

  float cx;
  float cy;
  float radius = 500;
  float pSize = 3;
  float tStep = 0.001;
  particle[] parts = new particle[200];
  float start;

  @Override void setup() {
    cx = width/2;
    cy = height/2;
    background(0);
    start = dateNow();
    noFill();

    for (int i = 0; i < parts.length; i++) {
      parts[i] = new particle(random(1)-0.5, random(1)-0.5, pSize);
    }
  }
  @Override void draw() {
    noStroke();
    fill(0, 0, 0, 20);
    rect(0, 0, width, height);

    for (particle p : parts) {
      if (random(1)<0.002) {
        float rad = 2*random(1);
        float angle = random(1)*3.14159*2.0;
        p.r = cos(angle)*rad;
        p.i = sin(angle)*rad;
      }
      p.move(tStep);
      p.draw();
    }

    noFill();
    stroke(255, 255, 255);
    ellipse(cx, cy, radius, radius);
    
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
