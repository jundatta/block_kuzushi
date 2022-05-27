// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】SoRA_X7さん
// 【作品名】Swingby
// https://openprocessing.org/sketch/1400031
//

class GameSceneCongratulations257 extends GameSceneCongratulationsBase {
  final int NUM = 40;
  PVector[] vecLocations = new PVector[NUM];
  PVector[] vecVelocities = new PVector[NUM];
  float[] vecHues = new float[NUM];

  final int TRAIL_LEN = 30;
  class VecTrail {
    ArrayList<PVector> vt = new ArrayList();
  }
  VecTrail[] vecTrails = new VecTrail[NUM];

  PVector[] vecPlanets = new PVector[2];

  @Override void setup() {
    colorMode(HSB, 360, 100, 100);

    for (int i = 0; i < NUM; i++) {
      vecLocations[i] = new PVector(width / 2, height / 2);
      vecVelocities[i] = new PVector(random(-10, 10), random(-10, 10));
      vecHues[i] = random(360);
      VecTrail vecTrail = new VecTrail();
      for (int j = 0; j < TRAIL_LEN; j++) {
        vecTrail.vt.add(vecLocations[i].copy());
      }
      vecTrails[i] = vecTrail;
    }

    setPlanetsPos();
  }

  void setPlanetsPos() {
    vecPlanets[0] = new PVector(random(100, width / 2), random(100, height / 2));
    vecPlanets[1] = new PVector(random(width / 2, width - 100), random(height / 2, height -100));
  }

  @Override void draw() {
    background(0);
    noStroke();

    fill(0, 0, 100);
    for (final PVector pl : vecPlanets) {
      circle(pl.x, pl.y, 70);
    }

    for (int i = 0; i < NUM; i++) {
      final PVector loc = vecLocations[i];
      final PVector vel = vecVelocities[i];

      //vecTrails[i].shift();
      //vecTrails[i].push(loc.copy());
      VecTrail vecTrail = vecTrails[i];
      vecTrail.vt.remove(0);
      vecTrail.vt.add(loc.copy());

      fill(vecHues[i], 80, 100);
      ellipse(loc.x, loc.y, 20, 20);
      loc.add(vel);

      if (loc.x < 0 || width < loc.x) {
        vel.x *= -1;
      }
      if (loc.y < 0 || height < loc.y) {
        vel.y *= -1;
      }

      for (final PVector pl : vecPlanets) {
        final PVector dir = PVector.sub(loc, pl);
        float distance = dir.mag();
        dir.normalize();
        dir.div(max(distance, 4));
        dir.mult(-25);
        vel.add(dir);
      }

      if (vel.magSq() > 250) {
        vel.div(1.01);
      } else if (vel.magSq() < 1) {
        vel.mult(1.01);
      }


      //vecTrails[i].forEach((trail, j) => {
      //  circle(trail.x, trail.y, 12 / sqrt((TRAIL_LEN - j)));
      //}
      //)
      for (int j = 0; j < vecTrail.vt.size(); j++) {
        PVector trail = vecTrail.vt.get(j);
        circle(trail.x, trail.y, 12 / sqrt((TRAIL_LEN - j)));
      }
    }

    if (frameCount % 300 == 0) {
      setPlanetsPos();
    }

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
