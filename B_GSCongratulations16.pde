// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Che-Yu Wuさん
// 【作品名】200607 Angry Puffer Fish
// https://openprocessing.org/sketch/913327
//

class GameSceneCongratulations16 extends GameSceneCongratulationsBase {
  // var colors = "eee-ea3737-233d4d-fe7f2d-fcca46-a1c181-619b8a".split("-").map(a=>"#"+a)
  final color[] colors = { #000eee, #ea3737, #233d4d, #fe7f2d, #fcca46, #a1c181, #619b8a };
  //var sounds=[]
  float easeOutElastic(float x) {
    final float c4 = (2 * PI) / 3.0;

    return x == 0
      ? 0
      : x == 1
      ? 1
      : pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
  }

  float easeOutExpo(float x) {
    return x == 1 ? 1 : 1 - pow(2, -10 * x);
  }

  class Fish {
    PVector p;
    PVector v;
    PVector a;
    float r;
    float id;
    float rotFreq;
    color color1;
    color color2;
    float targetR;
    float originalR;
    float activeRatio;
    float targetActiveRatio;
    float lerpSpeed;
    int ts;
    boolean colliding;
    boolean lastColliding;

    Fish(PVector p, PVector v, float r,
      color c1, color c2) {
      this.p = p;
      this.v = v;
      this.a = new PVector(0, 0);
      this.r = r;
      this.id = random(100);
      this.rotFreq = random(30, 50);
      this.color1 = c1;
      this.color2 = c2;
      this.targetR = this.r;
      this.originalR = this.r;
      this.activeRatio = 1.0;
      this.targetActiveRatio = 0.0;
      this.lerpSpeed = 0.01;
      this.ts=0;
      this.colliding=false;
      this.lastColliding=false;
    }
    void draw() {

      //drawingContext.shadowColor = color(0,80)
      //drawingContext.shadowOffsetY = 5
      //drawingContext.shadowOffsetY = 5
      push();
      translate(this.p.x, this.p.y);
      rotate( sin(this.id+frameCount/this.rotFreq)/10.0);
      scale(1, 0.95);
      if (this.v.x>0) {
        scale(-1, 1);
      }
      noStroke();
      //spikes

      push();
      fill(255);
      rotate(-this.activeRatio*PI/10.0 + sin(this.id+frameCount/this.rotFreq));

      for (int i=0; i<20; i++) {
        rotate(PI/10.0);
        float value = this.activeRatio-i/20.0;
        if (value < 0.0) {
          value = 0.0;
        } else if (2.0 < value) {
          value = 2.0;
        }
        float spikeAnimationRatio= map(value, 0.0, 2.0, 0.0, 1.0);
        triangle(this.activeRatio*this.r, -4,
          easeOutExpo(spikeAnimationRatio)*(this.r)*2, 0,
          this.activeRatio*this.r, 4);
      }
      pop();

      push();
      //body
      fill(this.color1);
      arc(0, 0, this.r*2, this.r*2, 0, PI, CHORD);
      fill(this.color2);
      arc(0, 0, this.r*2, this.r*2, PI, 2*PI, CHORD);
      fill(this.color1);
      arc(0, -1, this.r/3, this.r/3, 0, PI, CHORD);
      stroke(255, 100);
      strokeWeight(2);
      //drawingContext.shadowColor = color(0,0)
      for (int i=0; i<this.r; i+=this.r/3) {
        for (int o=0; o<3; o++) {
          stroke(255);
          push();
          translate(5+i+(o%2==0?-this.r/6:0), -o*this.r/3);
          line(0, 0, this.r/8, -this.r/8);
          line(0, 0, this.r/8, this.r/8);
          pop();
        }
      }
      pop();

      //eye
      float openEye = this.activeRatio>0.5?1:0;
      float eyeR = sqrt(this.r)*6.0/(2-openEye/8)+5.0;
      fill(255);
      arc(-this.r*0.4, -this.r*0.4,
        eyeR, eyeR, 0, PI+openEye*PI);
      //drawingContext.shadowColor = color(0,0)

      fill(0);
      arc(-this.r*0.4, -this.r*0.4,
        eyeR/2.0, eyeR/2.0, 0, PI+openEye*PI);


      //fin
      push();
      fill(255);
      rotate(sin(frameCount/8.0)/2.0 );
      triangle(0, 0,
        this.r/1.8, -this.r/2.4,
        this.r/1.8, this.r/2.4);
      pop();


      //tail
      push();
      translate(this.r*0.95, 0);
      fill(this.color1);
      rotate(sin(frameCount/4.0)/2.0 );
      triangle( 0, 0,
        this.r/3, -this.r/3,
        this.r/3, this.r/3);
      pop();

      pop();
    }
    void update() {
      this.p.add(this.v);
      this.v.add(this.a);
      this.v.mult(0.97);
      this.v.x+=noise(this.p.x/10.0)/10.0;
      this.v.y+=cos(this.p.x/10.0+1000+this.id+frameCount/100.0)/10.0;
      this.a.mult(0.95);
      this.activeRatio = lerp(this.activeRatio, this.targetActiveRatio, this.lerpSpeed );
      this.r = lerp(this.r, this.targetR, 0.05);
      this.lastColliding = this.colliding;

      if (dist(mouseX, mouseY, this.p.x, this.p.y)<this.r || this.colliding) {
        this.targetActiveRatio=1;
        this.lerpSpeed =0.2;
        this.targetR = this.originalR*1.5;
        this.ts =frameCount;
        this.a.x =(noise(this.id+frameCount/10.0, this.p.x/10.0, this.p.y/10.0)-0.5);
        this.a.y =(noise(this.id+50000+frameCount/10.0, this.p.x/10.0, this.p.y/10.0)-0.5);
      } else {
        this.targetActiveRatio=0;
        this.targetR = this.originalR*1;
        this.lerpSpeed =0.1;
      }

      if (this.p.x>width+25) {
        this.p.x = -20;
      }

      if (this.p.x<-20) {
        this.p.x = width+25;
      }

      if (this.p.y>height+25) {
        this.p.y = -20;
      }

      if (this.p.y<-20) {
        this.p.y = height+25;
      }
      // if (this.colliding){

      // }
    }
  }

  ArrayList<Fish> fishArray = new ArrayList<Fish>();
  class Bubble {
    PVector p;
    PVector v;
    float r;
    float opacity;

    Bubble(PVector p, PVector v, float r, float opacity) {
      this.p = p;
      this.v = v;
      this.r = r;
      this.opacity = opacity;
    }
  }
  ArrayList<Bubble> bubbles = new ArrayList<Bubble>();

  PGraphics overAllTexture;

  @Override void setup() {
    colorMode(RGB, 255);
    background(100);
    for (int i=0; i<10; i++) {
      IntList inventory = new IntList();
      for (int ii = 0; ii < colors.length; ii++) {
        inventory.append(colors[ii]);
      }
      inventory.shuffle();
      int c = inventory.get(0);
      //    float c2 = random(colors.filter(a=>a!=c))
      int c2 = inventory.get(1);
      Fish f = new Fish(
        new PVector(random(width), random(height)),
        PVector.random2D(),
        random(15, 55),
        c,
        c2
        );
      fishArray.add(f);
    }

    overAllTexture=createGraphics(width, height);
    overAllTexture.beginDraw();
    // noStroke()
    for (int i=0; i<width+50; i++) {
      for (int o=0; o<height+50; o++) {
        final int[] scale = {0, 30, 60};
        int scaleValue = scale[(int)random(scale.length)];
        overAllTexture.set(i, o, color(100, noise(i/3.0, o/3.0, i*o/50.0)*scaleValue));
      }
    }
    overAllTexture.endDraw();
  }

  @Override void draw() {
    fill(0);
    rect(0, 0, width, height);

    color stColor =color(59, 138, 221);
    color edColor =color(12, 28, 59);
    for (int o=-1; o<10; o++) {
      noStroke();
      color midColor = lerpColor(stColor, edColor, o/10.0);

      push();
      translate(0, o*height/10.0);
      fill(midColor);
      beginShape();
      vertex(0, 150);
      for (int i=0; i<width; i+=2) {
        vertex(i, sin(i/(float)(30.0+noise(o, frameCount/100.0)*100.0)+o+cos(o+frameCount/10.0))*30.0);
      }
      vertex(width, 150);
      endShape(CLOSE);
      pop();
    }
    //  fishArray.forEach(fish=>{
    for (Fish fish : fishArray) {
      fish.update();
      fish.draw();
      fish.colliding=false;

      if (random(1.0)<0.03) {
        bubbles.add(new Bubble(
          fish.p.copy(),
          new PVector(0, random(-0.5, -5)),
          random(1, 15),
          random(0.1, 200))
          );
      }
    }

    //  drawingContext.shadowColor = color(0,0)
    //  bubbles.forEach(b=>{
    for (Bubble b : bubbles) {
      fill(255, b.opacity);
      ellipse(b.p.x + noise(b.p.y/20.0)*b.r*2.0, b.p.y, b.r, b.r);
      b.p.y+=b.v.y;
    }
    ArrayList<Bubble> newBubbles = new ArrayList<Bubble>();
    for (Bubble b : bubbles) {
      if (-10.0 < b.p.y) {
        newBubbles.add(b);
      }
    }
    bubbles = newBubbles;

    //  fishArray.forEach(fish=>{
    for (Fish fish : fishArray) {
      //    fishArray.forEach(fish2=>{
      for (Fish fish2 : fishArray) {
        //      if (fish!==fish2){
        if (fish!=fish2) {
          if (fish.p.dist(fish2.p)<(fish.r+fish2.r)/1.0) {

            fish.colliding=true;
            fish2.colliding=true;
          }

          if (fish.p.dist(fish2.p)<(fish.r+fish2.r)/1.5) {

            PVector delta = fish2.p.copy().sub(fish.p);
            fish.v.sub(delta.mult(0.2).setMag(2));
            fish2.v.add(delta.mult(0.2).setMag(2));
          }
        }
      }
    }
    push();
    //    blendMode(MULTIPLY);
    image(overAllTexture, 0, 0);
    pop();

    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
