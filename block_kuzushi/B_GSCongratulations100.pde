// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Senbakuさん
// 【作品名】dcc#40"Dragon's Palase"
// https://openprocessing.org/sketch/892202
//

class GameSceneCongratulations100 extends GameSceneCongratulationsBase {
  //2020-05-10 dcc#40"Dragon's Palase" @senbaku
  //Reference :Flocking "https://p5js.org/examples/simulate-flocking.html"
  //Reference : coding train / #particle train

  float start = 0.0;
  float xoff = 0.0;
  float inc = 0.0002;
  Flock flock;
  PGraphics pg;
  PGraphics mask;
  ArrayList<Particle> particles = new ArrayList();

  final int kOrgW = 400;
  final int kOrgH = 400;
  int TopX, TopY;
  PGraphics screen;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    TopX = (width - kOrgW) / 2;
    TopY = (height - kOrgH) / 2;

    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(color(#ee6c4d));
    pg.endDraw();
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.ellipse(width/2, height/2, 350, 350);
    mask.endDraw();
    pg.mask(mask);

    flock = new Flock();
    // Add an initial set of boids into the system
    for (int i = 0; i < 100; i++) {
      Boid b = new Boid(width / 2, height / 2);
      flock.addBoid(b);
    }

    screen = createGraphics(width, height);
  }
  @Override void draw() {
    screen.beginDraw();
    screen.background(color(#3d5a80));
    nami(screen);
    nami2(screen);
    screen.push();
    screen.scale(2);
    flock.run(screen);
    screen.pop();
    //how many particles do I want to add each frame
    for (int i =0; i<1; i++) {
      Particle p = new Particle();
      particles.add(p);
    }
    for (int i = particles.size() -1; i >=0; i--) {
      particles.get(i).update();
      particles.get(i).show(screen);
      if (particles.get(i).finished()) {
        //remove this particle.
        particles.remove(i);
      }
    }
    screen.endDraw();
    image(screen, 0, 0);
    image(pg, 0, 0);
    //文字----------------------
    textSize(20);
    textAlign(CENTER);

    fill(color(#f6f2f3));
    noStroke();
    text("D r a g o n ' s\nP a l a c e", TopX + 200, TopY + 330);

    logoRightLower(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
  @Override void mouseDragged() {
    flock.addBoid(new Boid(mouseX, mouseY));
  }


  // The Nature of Code
  // Daniel Shiffman
  // http://natureofcode.com

  // Flock object
  // Does very little, simply manages the array of all the boids

  class Flock {
    ArrayList<Boid> boids;

    Flock() {
      // An array for all the boids
      this.boids = new ArrayList(); // Initialize the array
    }

    void run(PGraphics p) {
      for (int i = 0; i < this.boids.size(); i++) {
        this.boids.get(i).run(p, this.boids); // Passing the entire list of boids to each boid individually
      }
    }

    void addBoid(Boid b) {
      this.boids.add(b);
    }
  }
  // The Nature of Code
  // Daniel Shiffman
  // http://natureofcode.com

  // Boid class
  // Methods for Separation, Cohesion, Alignment added

  class Boid {
    PVector acceleration;
    PVector velocity;
    PVector position;
    float r;
    float maxspeed;
    float maxforce;
    color col;

    Boid(float x, float y) {
      this.acceleration = new PVector(0, 0);
      this.velocity = new PVector(random(-1, 1), random(-1, 1));
      this.position = new PVector(x, y);
      this.r = random(3.0, 5.0);
      this.maxspeed = 3; // Maximum speed
      this.maxforce = 0.05; // Maximum steering force
      this.col = color(#e0fbfc);
    }

    void run(PGraphics p, ArrayList<Boid> boids) {
      this.flock(boids);
      this.update();
      this.borders();
      this.render(p);
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      this.acceleration.add(force);
    }

    // We accumulate a new acceleration each time based on three rules
    void flock(ArrayList<Boid> boids) {
      PVector sep = this.separate(boids); // Separation
      PVector ali = this.align(boids); // Alignment
      PVector coh = this.cohesion(boids); // Cohesion
      // Arbitrarily weight these forces
      sep.mult(1.5);
      ali.mult(1.0);
      coh.mult(1.0);
      // Add the force vectors to acceleration
      this.applyForce(sep);
      this.applyForce(ali);
      this.applyForce(coh);
    }

    // Method to update location
    void update() {
      // Update velocity
      this.velocity.add(this.acceleration);
      // Limit speed
      this.velocity.limit(this.maxspeed);
      this.position.add(this.velocity);
      // Reset accelertion to 0 each cycle
      this.acceleration.mult(0);
    }

    // A method that calculates and applies a steering force towards a target
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector target) {
      PVector desired = PVector.sub(target, this.position); // A vector pointing from the location to the target
      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(this.maxspeed);
      // Steering = Desired minus Velocity
      PVector steer = PVector.sub(desired, this.velocity);
      steer.limit(this.maxforce); // Limit to maximum steering force
      return steer;
    }

    void render(PGraphics p) {
      // Draw a triangle rotated in the direction of velocity
      float theta = this.velocity.heading() + radians(90);
      p.fill(this.col);
      p.noStroke();
      p.push();
      p.translate(this.position.x, this.position.y);
      p.rotate(theta);
      p.ellipse(0, 0, this.r * 2.5, this.r * 5);
      p.beginShape();
      p.vertex(0, this.r * 2.5);
      p.vertex(-5, this.r * 5);
      p.vertex(5, this.r * 5);
      p.endShape(CLOSE);
      p.pop();
    }

    // Wraparound
    void borders() {
      if (this.position.x < -this.r) this.position.x = width + this.r;
      if (this.position.y < -this.r) this.position.y = height + this.r;
      if (this.position.x > width + this.r) this.position.x = -this.r;
      if (this.position.y > height + this.r) this.position.y = -this.r;
    }

    // Separation
    // Method checks for nearby boids and steers away
    PVector separate(ArrayList<Boid> boids) {
      float desiredseparation = 25.0;
      PVector steer = new PVector(0, 0);
      float count = 0;
      // For every boid in the system, check if it's too close
      for (int i = 0; i < boids.size(); i++) {
        float d = PVector.dist(this.position, boids.get(i).position);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(this.position, boids.get(i).position);
          diff.normalize();
          diff.div(d); // Weight by distance
          steer.add(diff);
          count++; // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        steer.div(count);
      }

      // As long as the vector is greater than 0
      if (steer.mag() > 0) {
        // Implement Reynolds: Steering = Desired - Velocity
        steer.normalize();
        steer.mult(this.maxspeed);
        steer.sub(this.velocity);
        steer.limit(this.maxforce);
      }
      return steer;
    }

    // Alignment
    // For every nearby boid in the system, calculate the average velocity
    PVector align(ArrayList<Boid> boids) {
      float neighbordist = 50;
      PVector sum = new PVector(0, 0);
      float count = 0;
      for (int i = 0; i < boids.size(); i++) {
        float d = PVector.dist(this.position, boids.get(i).position);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(boids.get(i).velocity);
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        sum.normalize();
        sum.mult(this.maxspeed);
        PVector steer = PVector.sub(sum, this.velocity);
        steer.limit(this.maxforce);
        return steer;
      }
      return new PVector(0, 0);
    }

    // Cohesion
    // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
    PVector cohesion(ArrayList<Boid> boids) {
      float neighbordist = 50;
      PVector sum = new PVector(0, 0); // Start with empty vector to accumulate all locations
      float count = 0;
      for (int i = 0; i < boids.size(); i++) {
        float d = PVector.dist(this.position, boids.get(i).position);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(boids.get(i).position); // Add location
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        return this.seek(sum); // Steer towards the location
      }
      return new PVector(0, 0);
    }
  }


  void nami(PGraphics p) {
    p.stroke(color(#6BAEB4));
    xoff = start;
    for (float x = 0; x < kOrgW; x++) {
      float y = noise(xoff) * kOrgH;

      p.line(TopX + x, TopY + y, TopX + x, TopY + kOrgH);
      xoff += inc;
      start += inc / 100.0f;
    }
  }

  void nami2(PGraphics p) {
    p.stroke(color(#7BCEC8));
    xoff = start - 10;
    for (float x = 0; x < kOrgW; x++) {
      float y = noise(xoff) * kOrgH;
      p.line(TopX + x, TopY + y, TopX + x, TopY + kOrgH);
      xoff += inc;
      start += inc / 80;
    }
  }
  class Particle {
    float x;
    float y;
    float vx;
    float vy;
    float alpha;
    float r;

    Particle() {
      this.x = width * (200 / (float)kOrgW);
      this.y = height * (430 / (float)kOrgH);
      this.vx = random(-1, 1);
      this.vy = random(-30, -1);
      this.alpha=255;
      this.r = random(1, 16);
    }

    boolean finished() {
      return this.alpha <0;
    }
    void update() {
      this.x += this.vx;
      this.y += this.vy;
      this.alpha -=5;
    }

    void show(PGraphics p) {
      p.noFill();
      p.strokeWeight(1);
      //    stroke(220, 50-this.alpha);
      p.stroke(220, 220, 220, 50-this.alpha);
      p.ellipse(this.x, this.y, this.r, this.r);

      //    fill(220, 50-this.alpha);
      p.fill(220, 220, 220, 50-this.alpha);
      p.ellipse(this.x, this.y, this.r, this.r);
    }
  }
}
