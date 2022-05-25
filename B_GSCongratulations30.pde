// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】mobbarleyさん
// 【作品名】Diamonds
// https://openprocessing.org/sketch/1214636
//

class GameSceneCongratulations30 extends GameSceneCongratulationsBase {
  Diamond diamondCircle;
  float outerRadius = 600;
  float innerRadius = outerRadius / 20;
  float t = 0;

  @Override void setup() {
    colorMode(RGB, 255);
    colorMode(HSB, 255);
    background(0);
    diamondCircle = new Diamond(innerRadius, outerRadius);
  }
  @Override void draw() {
    background(0);
    for (int i = 0; i < diamondCircle.cornersCount; i++) {
      diamondCircle.corners.get(i).update();
    }
    translate(width/2, height/2);
    diamondCircle.connect();
    diamondCircle.draw();
    fill(0);
    ellipse(0, 0, innerRadius * 2, innerRadius * 2);
    t += 0.001;

    logo(color(255, 0, 0));
  }


  class Diamond {
    float x;
    float y;
    float innerRadius;
    float outerRadius;
    float cornersCount;
    ArrayList<Corner> corners;
    ArrayList<IntList> connections;
    Diamond(float innerRadius, float outerRadius) {
      this.x = 0;
      this.y = 0;
      this.innerRadius = innerRadius;
      this.outerRadius = outerRadius;
      this.cornersCount = 400;
      this.corners = new ArrayList();
      for (int i = 0; i < this.cornersCount; i++) {
        this.corners.add(new Corner(this.innerRadius, this.outerRadius));
      }
      this.connections = new ArrayList();
      for (int i = 0; i < this.cornersCount; i++) {
        this.connections.add(new IntList());
      }
    }

    void connect() {
      this.connections = new ArrayList();
      for (int i = 0; i < this.cornersCount; i++) {
        this.connections.add(new IntList());
      }
      for (int i = 0; i < this.cornersCount; i++ ) {
        IntList foundOnes = new IntList();
        foundOnes.push(i);
        for (int n = 0; n < this.corners.get(i).nbConnections; n++) {
          float minDist = 9999;
          int closestCorner = 9999;
          for (int j = 0; j < this.corners.size(); j++ ) {
            float currentDist = distance(this.corners.get(i).x, this.corners.get(i).y, this.corners.get(j).x, this.corners.get(j).y);
            if (currentDist < minDist) {
              if (!foundOnes.hasValue(j)) {
                minDist = currentDist;
                closestCorner = j;
              }
            }
          }
          foundOnes.push(closestCorner);
          this.connections.get(i).push(closestCorner);
        }
      }
    }

    void draw() {
      for (int i = 0; i < this.cornersCount; i++) {
        for (int n = 0; n < this.corners.get(i).nbConnections; n++) {
          stroke(i%255, 255, 255);
          strokeWeight(2);
          int idx = this.connections.get(i).get(n);
          line(this.corners.get(i).x, this.corners.get(i).y, this.corners.get(idx).x, this.corners.get(idx).y);
        }
      }
    }
  }

  class Corner {
    float distMax;
    float distMin;
    float dist;
    float theta;
    float x;
    float y;
    int nbConnections;
    Corner(float distMin, float distMax) {
      this.distMax = distMax;
      this.distMin = distMin;
      this.dist = random(this.distMin, this.distMax);
      this.theta = random(0, TWO_PI);
      this.x = this.dist * sin(this.theta);
      this.y = this.dist * cos(this.theta);
      this.nbConnections = int(random(3, 4));
    }

    void update() {
      this.dist -= (-Math.log(this.dist - this.distMin +1) + 10)/5;
      this.x = this.dist * sin(this.theta);
      this.y = this.dist * cos(this.theta);
      if (this.dist > this.distMax || this.dist < this.distMin) {
        this.dist = random(this.distMin, this.distMax);
        this.theta = random(0, TWO_PI);
        this.x = this.dist * sin(this.theta);
        this.y = this.dist * cos(this.theta);
      }
    }
  }

  float distance(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
