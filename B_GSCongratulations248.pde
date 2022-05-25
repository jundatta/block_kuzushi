// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1380943
//

class GameSceneCongratulations248 extends GameSceneCongratulationsBase {
  // A nice way to generate randomly distributed points on a sphere
  // Use Archimedes' theorem that says that a cylinder axially
  // projected onto a sphere preserves area

  PVector points[];
  float r;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    smooth();
    strokeWeight(2);
    frameRate(200);
    ellipseMode(RADIUS);
    points = new PVector[2000];
    r = 250;
    colorMode(HSB, 255);

    // Pre-generate a list of random points on a cylinder
    for (int i = 0; i < points.length; i++) {
      float theta = r * random(0, 2 * PI);
      float z = random(-r, r);
      float x = r * cos(theta);
      float y = r * sin(theta);
      points[i] = new PVector(x, y, z);
    }
  }
  @Override void draw() {
    push();
    translate(width/2, height/2);

    background(10);
    rotateX(frameCount * 0.01);
    rotateY(frameCount * 0.01);
    noFill();

    // Parameter for animating the transition from cylinder to sphere
    float t = sin(frameCount*0.1f);

    // Draw the points, using the animation parameter to vary them
    // between cylinder and sphere
    stroke(0);
    strokeWeight(10);
    for (int i = 0; i < points.length; i++) {
      PVector p = points[i];

      // Compute the distance from the cylinder axis (z) to the sphere
      // at a given distance along z
      float d = sqrt(r * r - p.z * p.z);

      // Express this as a fraction of the cylinder radius
      float f = d / r;

      // Animate back and forth between d and 1
      f = map(t, -1, 1, f, 1);

      // Draw the point
      stroke(i / (float)points.length * 255, 255, 255);
      point(f * p.x, f * p.y, p.z);
    }

    // Ellipses to highlight the countours of the cylinder to sphere
    stroke(75, 150, 255);
    strokeWeight(2);
    final int numEllipses = 10;
    for (int i = 0; i <= numEllipses; i++) {
      // Place the ellipse along the axis of the cylinder
      float m = 2 * r * (i / (float)numEllipses) - r;

      // Apply same animation procedure to the ellipse radius
      float d = sqrt(r * r - m * m);
      float f = d / r;
      f = map(t, -1, 1, f, 1);

      // Translate along the cylinder axis and draw the ellipse
      push();
      translate(0, 0, m);
      stroke(i * 25, 255, 255);
      ellipse(0, 0, f * r, f * r);
      pop();
    }
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
