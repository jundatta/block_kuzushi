// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Fibonacci Sphere 2
// https://openprocessing.org/sketch/1223745
//

class GameSceneCongratulations32 extends GameSceneCongratulationsBase {
  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/41142*@* */
  /* !do not delete the line above, required for linking your tweak if you re-upload */
  /**
   * A fast method for getting an arbitrary number of equidistant points on a sphere.
   * Draws a fibonacci spiral down from the pole, which maintains uniform surface area.
   *
   * Click to toggle point adding.
   *
   * Original with points Jim Bumgardner 10/6/2011
   * Variation with cubes Martin Prout 19/7/2013
   * OO-version with some optimisations Tim Groote 5/11/2015
   */

  float radius = 277;
  float rotationX = 0;
  float rotationY = 0;
  float velocityX = 0;
  float velocityY = 0;
  float hu = 0;


  final float PHI = (sqrt(5)+1)/2 - 1;     // golden ratio
  final float GA = PHI * TWO_PI;           // golden angle

  final int KMAX_POINTS = 1000;

  int pointCounter = 0;

  class SpherePoint
  {
    float  lat, lon;
    int index;

    SpherePoint(int idx)
    {
      this.index = idx;
      this.lat = 0;
      this.lon = 0;
    }

    SpherePoint(float lat, float lon, int idx)
    {
      this.lat = lat;
      this.lon = lon;
      this.index = idx;
    }

    void UpdateLatLon()
    {
      this.lon = ((GA*this.index) / TWO_PI);
      this.lon -= floor(this.lon);
      this.lon *= TWO_PI;
      if (this.lon > PI)
      {
        this.lon -= TWO_PI;
      }

      // Convert dome height (which is proportional to surface area) to latitude
      lat = asin(-1 + PI*(this.index)/(float)pts.size());
    }

    void draw()
    {
      float ns=noise(lat, lon, millis()/1000.0f)*30;
      UpdateLatLon();
      pushMatrix();
      rotateY(lon);
      rotateZ(-lat);
      //    fill(80, 80, 250);
      //fill(random(255), 200, 255);

      translate(radius + (ns/2.0f), 0, 0);
      box(ns, 7, 7);
      hu +=.01;
      popMatrix();
    }
  };

  ArrayList<SpherePoint> pts = new ArrayList();

  boolean addPoints = true;

  void initSphere(int num)
  {
    for (int i = 1; i <= num; ++i)
    {
      addPoint();
    }
  }

  void addPoint()
  {
    if (pointCounter >= KMAX_POINTS) return; //do not add past KMAX

    SpherePoint newPoint = new SpherePoint(pointCounter);
    pts.add(newPoint);
    pointCounter++;
  }

  @Override void setup() {
    noStroke();
    colorMode(HSB, 255);
    radius = 0.8 * height/2.0f;
    initSphere(10);
    background(0);
  }
  @Override void draw() {
    background(0);

    if (addPoints)
    {
      addPoint();
    }

    lights();
    //ambient(255, 0, 255);
    ambientLight(255, 0, 255);
    renderGlobe();

    rotationX += velocityX;
    rotationY += velocityY;
    velocityX *= 0.95;
    velocityY *= 0.95;

    // Implements mouse control (interaction will be inverse when sphere is upside down)
    if (mousePressed)
    {
      velocityX += (mouseY-pmouseY) * 0.01;
      velocityY -= (mouseX-pmouseX) * 0.01;
    }
    hu++;

    push();
    colorMode(RGB, 255, 255, 255);
    logoRightLower(color(255, 0, 0));
    pop();
  }

  void renderGlobe()
  {
    pushMatrix();
    translate(width/2.0, height/2.0, 0);
    rotateY(frameCount / 200.0f);

    float xradiusot = radians(-rotationX);
    float yradiusot = radians(270 - rotationY);
    rotateX( xradiusot );
    rotateY( yradiusot );

    for (SpherePoint pt : pts)
    {
      fill(random(255), 200, 255);

      pt.draw();
    }

    popMatrix();
  }

  void mouseClicked()
  {
    addPoints = !addPoints;
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
