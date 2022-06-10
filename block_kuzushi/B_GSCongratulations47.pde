// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Jason Labbeさん
// 【作品名】The uncanny trail shader
// https://openprocessing.org/sketch/1192847
// 【移植】PC-8001(TN8001)さん
// https://gist.github.com/TN8001/64276053ff6d9922ad5769f324c98194
//

class GameSceneCongratulations47 extends GameSceneCongratulationsBase {
  final int TRAIL_MAX_COUNT = 30;
  final int TRAIL_MAX_RADIUS = 120;
  final int PARTICLE_MAX_COUNT = 70;
  final float PARTICLE_PULL_FORCE = 0.0015;
  final float PARTICLE_INITIAL_SPEED = 0.15;
  final int PARTICLE_SPEED_VARIANCE = 15;
  final int PARTICLE_SPAWN_ANGLE = 25;
  final int PARTICLE_LIFE = 60;
  final float PARTICLE_MIN_AIR_DRAG = 0.9;
  final float PARTICLE_MAX_AIR_DRAG = 0.95;
  final float LERP_AMOUNT = 0.1;

  Trail trail;
  boolean shaded = true;
  float timeSteps = 1;
  float sketchTimer = 0;
  int transitionTimer = 0;
  float globalHue = int(random(255));

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    strokeWeight(5);
    trail = new Trail();
  }
  @Override void draw() {
    background(0);

    // マウスクリックシミュレート
    if (random(60 * 3) < 1) {
      globalHue = int(random(255));
      transitionTimer = 40;
    }

    if (transitionTimer == 0) {
      timeSteps = lerp(timeSteps, 1, LERP_AMOUNT);
      trail.radius = lerp(trail.radius, TRAIL_MAX_RADIUS, LERP_AMOUNT);
    } else {
      transitionTimer--;
      timeSteps = lerp(timeSteps, 4, LERP_AMOUNT);
      trail.radius = lerp(trail.radius, TRAIL_MAX_RADIUS * 0.5, LERP_AMOUNT);
    }

    trail.hue = lerp(trail.hue, globalHue, LERP_AMOUNT * 0.5);
    trail.move();

    if (shaded) trail.display();
    else trail.debugDisplay();

    sketchTimer += timeSteps;

    logoRightLower(color(255, 0, 0));
  }


  class Particle {
    final PVector pullForce = new PVector(width / 2, height / 2);
    final float airDrag = random(PARTICLE_MIN_AIR_DRAG, PARTICLE_MAX_AIR_DRAG);
    final float saturation = random(255);
    final float brightness = random(255);
    final PVector pos;
    final PVector vel;

    int life = PARTICLE_LIFE;

    Particle(float x, float y, float vx, float vy) {
      pos = new PVector(x, y);
      vel = new PVector(vx, vy);
      vel.rotate(radians(random(-PARTICLE_SPAWN_ANGLE, PARTICLE_SPAWN_ANGLE)));
    }

    void move() {
      PVector p = PVector.sub(pullForce, pos);
      p.mult(PARTICLE_PULL_FORCE);
      vel.add(p);
      vel.mult(airDrag);
      pos.add(vel);
      life--;
    }
  }


  class Trail {
    final PShader shader = loadShader("data/47/shader.frag", "data/47/shader.vert");
    final PGraphics shaderTexture = createGraphics(width, height, P3D);
    final ArrayList<PVector> positions = new ArrayList<PVector>();
    final ArrayList<Particle> particles = new ArrayList<Particle>();

    float hue = globalHue;
    float radius = TRAIL_MAX_RADIUS;
    int speed = 5;

    Trail() {
      shaderTexture.beginDraw();
      shaderTexture.endDraw();
    }

    void move() {
      PositionsUpdate();
      spawnParticles();
      moveParticles();
    }

    void display() {
      shaderTexture.shader(shader);

      shader.set("resolution", width, height);
      shader.set("trailCount", positions.size());
      shader.set("trailColor", getTrailColorVec3());
      shader.set("trail", getTrailsVec2(), 2);
      shader.set("particleCount", particles.size());
      shader.set("particles", getParticlesVec3(), 3);
      shader.set("colors", getColorsVec3(), 3);

      shaderTexture.rect(0, 0, width, height);
      image(shaderTexture, 0, 0);
    }

    void debugDisplay() {
      stroke(255, 0, 0);
      for (Particle particle : particles) {
        point(particle.pos.x, particle.pos.y);
      }

      stroke(255);
      for (PVector pos : positions) {
        point(pos.x, pos.y);
      }
    }


    void PositionsUpdate() {
      PVector currentPos = getPositionByTime(sketchTimer);
      positions.add(currentPos);

      while (positions.size() > TRAIL_MAX_COUNT) {
        positions.remove(0);
      }
    }

    void spawnParticles() {
      if (particles.size() < PARTICLE_MAX_COUNT) {
        PVector currentPos = getPositionByTime(sketchTimer);
        PVector lastPos = getPositionByTime(sketchTimer - 1);

        PVector delta = PVector.sub(lastPos, currentPos);
        delta.mult(PARTICLE_INITIAL_SPEED * random(PARTICLE_SPEED_VARIANCE));

        particles.add(new Particle(currentPos.x, currentPos.y, delta.x, delta.y));
      }
    }

    void moveParticles() {
      for (int i = particles.size() - 1; i > -1; i--) {
        particles.get(i).move();
        if (particles.get(i).life <= 0) {
          particles.remove(i);
        }
      }
    }

    PVector getPositionByTime(float time) {
      float angle = radians(time * speed);
      return new PVector(sin(angle) * radius + width / 2, cos(angle) * radius + height / 2);
    }

    float[] getTrailsVec2() {
      float[] data = new float[positions.size() * 2];

      for (int i = 0; i < positions.size(); i ++) {
        PVector pos = positions.get(i);
        data[i * 2] = map(pos.x, 0, width, 0.0, 1.0);
        data[i * 2 + 1] = map(pos.y, 0, height, 1.0, 0.0);
      }
      return data;
    }

    PVector getTrailColorVec3() {
      colorMode(HSB, 255);
      PVector data;
      color trailColor = color((hue + 125) % 255, 255, 255);
      data = new PVector(red(trailColor) / 255.0, green(trailColor) / 255.0, blue(trailColor) / 255.0);
      colorMode(RGB, 255);

      return data;
    }

    float[] getParticlesVec3() {
      float[] data = new float[particles.size() * 3];

      for (int i = 0; i < particles.size(); i ++) {
        Particle particle = particles.get(i);
        data[i * 3] = map(particle.pos.x, 0, width, 0.0, 1.0);
        data[i * 3 + 1] = map(particle.pos.y, 0, height, 1.0, 0.0);
        data[i * 3 + 2] = min(particle.life * 0.01, 0.25);
      }
      return data;
    }

    float[] getColorsVec3() {
      float[] data = new float[particles.size() * 3];

      colorMode(HSB, 255);
      for (int i = 0; i < particles.size(); i ++) {
        Particle particle = particles.get(i);
        color itsColor = color(hue, particle.saturation, particle.brightness);
        data[i * 3] = red(itsColor);
        data[i * 3 + 1] = green(itsColor);
        data[i * 3 + 2] = blue(itsColor);
      }
      colorMode(RGB, 255);

      return data;
    }
  }

  @Override void mousePressed() {
    if (mouseButton == LEFT) {
      globalHue = int(random(255));
      transitionTimer = 40;
    } else if (mouseButton == RIGHT) {
      shaded = !shaded;
    }
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
