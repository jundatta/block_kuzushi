// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ilyas Shafiginさん
// 【作品名】Medusa
// https://openprocessing.org/sketch/442727
//

class GameSceneCongratulations111 extends GameSceneCongratulationsBase {
  final color backgroundColor = #0E2646;

  Scene scene;
  Paper paper;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    colorMode(HSB, 100, 100, 100, 100);
    ellipseMode(RADIUS);

    scene = new Scene();
    paper = new Paper();
    paper.randomizePaper(width, height, 10);

    scene.randomScene(width, height);

    long currentSeed = ceil(millis());
    randomSeed(currentSeed);
    noiseSeed(currentSeed);

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    scene.animate(1000.0 / 60.0, frameCount);

    pg.beginDraw();
    pg.colorMode(HSB, 100, 100, 100, 100);
    pg.ellipseMode(RADIUS);
    pg.clear();
    pg.background(backgroundColor);
    pg.blendMode(ADD);
    pg.colorMode(HSB, 100, 100, 100, 100);
    pg.ellipseMode(RADIUS);
    scene.display(pg);

    paper.display(pg, 0, 0);
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(0, 100, 100));
  }
  class Bubble {
    float x;
    float y;
    float radius;
    float boundWidth;
    float boundHeight;
    float speed;
    float frequency;
    color fillColor;
    float _x;

    Bubble(float w, float h) {
      this.x = random(0, w);
      this.y = random(0, h);
      this.boundWidth = w;
      this.boundHeight = h;

      this._x = x;
    }

    void randomRadius(float minRadius, float maxRadius) {
      radius = random(minRadius, maxRadius);
    }

    void randomColor(color bubbleColor, float minAlpha, float maxAlpha) {
      fillColor = color(hue(bubbleColor), saturation(bubbleColor), brightness(bubbleColor), random(minAlpha, maxAlpha));
    }

    void randomSpeed(float minSpeed, float maxSpeed) {
      speed = random(minSpeed, maxSpeed);
    }

    void randomFrequency(float minFreq, float maxFreq) {
      frequency = random(minFreq, maxFreq);
    }

    void display(PGraphics pg) {
      pg.noStroke();
      pg.fill(fillColor);
      pg.ellipse(x, y, radius, radius);
    }

    void animate(float deltaTime, float currentTime) {
      y -= speed * deltaTime;
      if (y < -radius) {
        y = boundHeight + radius;
        x = random(0, boundWidth);
        _x = x;
      }
      x = _x + radius * sin(currentTime * frequency);
    }
  }
  /**
   * Flow Field
   * base on FlowField3DNoise by Daniel Shiffman (The Nature of Code, http://natureofcode.com)
   */
  class FlowField {
    ArrayList<ArrayList<PVector>> field = new ArrayList();
    int cols;
    int rows;
    float resolution;
    float stepZOffset;

    float zOffset;
    float angleOffset;
    float angleDeviation;

    FlowField copy() {
      FlowField flow = new FlowField();
      flow.cols = this.cols;
      flow.rows = this.rows;
      flow.resolution = this.resolution;
      flow.stepZOffset = this.stepZOffset;
      flow.zOffset = this.zOffset;
      flow.angleOffset = this.angleOffset;
      flow.angleDeviation = this.angleDeviation;

      flow.field = new ArrayList();
      for (int i = 0; i < this.cols; i++) {
        //      flow.field[i] = [];
        ArrayList<PVector> fields = new ArrayList();
        ArrayList<PVector> srcFields = this.field.get(i);
        for (int j = 0; j < this.rows; j++) {
          //        flow.field[i][j] = this.field[i][j].copy();
          PVector srcField = srcFields.get(j);
          PVector field = srcField.copy();
          fields.add(field);
        }
        flow.field.add(fields);
      }
      return flow;
    }

    void randomSize(int r, int w, int h) {
      this.resolution = r;
      this.cols = w / r;
      this.rows = h / r;
      this.field = new ArrayList();
      for (int i = 0; i < this.cols; i++) {
        //      this.field[i] = [];
        ArrayList<PVector> fields = new ArrayList();
        for (int j = 0; j < this.rows; j++) {
          //        this.field[i][j] = new p5.Vector();
          PVector f = new PVector();
          fields.add(f);
        }
        this.field.add(fields);
      }
    }

    void randomField(float offsetAngle, float angleDeviation, float maxZ) {
      this.zOffset = random(maxZ);
      this.angleOffset = offsetAngle;
      this.angleDeviation = angleDeviation;

      var xoff = 0;
      for (int i = 0; i < this.cols; i++) {
        ArrayList<PVector> fields = this.field.get(i);
        float yoff = 0;
        for (int j = 0; j < this.rows; j++) {
          //        this.field[i][j].set(p5.Vector.fromAngle(offsetAngle + angleDeviation * map(noise(xoff, yoff, this.zOffset), 0, 0.5, -1, 1)));
          float ratio = map(noise(xoff, yoff, this.zOffset), 0, 0.5, -1, 1);
          PVector f = PVector.fromAngle(offsetAngle + angleDeviation * ratio);
          fields.set(j, f);
          yoff += 1.0 / this.resolution;
        }
        xoff += 1.0 / this.resolution;
      }
    }

    void randomAnimation(float stepZ) {
      this.stepZOffset = stepZ;
    }

    PVector lookup(PVector lookup) {
      int column = int(constrain(lookup.x / this.resolution, 0, this.cols - 1));
      int row = int(constrain(lookup.y / this.resolution, 0, this.rows - 1));
      //    return this.field[column][row].copy();
      ArrayList<PVector> fields = this.field.get(column);
      PVector f = fields.get(row);
      return f.copy();
    }

    void animate(float deltaTime, float currentTime) {
      this.zOffset += this.stepZOffset * deltaTime;
      float xoff = 0;
      for (int i = 0; i < this.cols; i++) {
        ArrayList<PVector> fields = this.field.get(i);
        float yoff = 0;
        for (int j = 0; j < this.rows; j++) {
          //        this.field[i][j].set(p5.Vector.fromAngle(this.angleOffset + this.angleDeviation * map(noise(xoff, yoff, this.zOffset), 0, 0.5, -1, 1)));
          float ratio = map(noise(xoff, yoff, this.zOffset), 0, 0.5, -1, 1);
          PVector f = PVector.fromAngle(this.angleOffset + this.angleDeviation * ratio);
          fields.set(j, f);
          yoff += 1.0 / this.resolution;
        }
        xoff += 1.0 / this.resolution;
      }
    }
  }
  class Head {
    PVector location;
    float largeRadius;
    float smallRadius;
    float angle;
    float relativeHeight;
    color fillColor;

    PVector _location;
    float _largeRadius;
    float _smallRadius;
    float _angle;

    Head copy() {
      Head head = new Head();
      head.location = this.location.copy();
      head._location = this.location.copy();
      head.largeRadius = this.largeRadius;
      head._largeRadius = this.largeRadius;
      head.smallRadius = this.smallRadius;
      head._smallRadius = this.smallRadius;
      head.angle = this.angle;
      head._angle = this.angle;
      head.relativeHeight = this.relativeHeight;
      head.fillColor = this.fillColor;
      return head;
    }

    void randomLocation(float centerX, float centerY, float xDeviation, float yDeviation) {
      this.location = new PVector(centerX, centerY);
      this.location.add(xDeviation * random(-1, 1), yDeviation * random(-1, 1));
      this._location = this.location.copy();
    }

    void randomRadius(float minSmallRadius, float maxSmallRadius, float minLargeRadius, float maxLargeRadius) {
      this.smallRadius = random(minSmallRadius, maxSmallRadius);
      this.largeRadius = random(minLargeRadius, maxLargeRadius);
      this._smallRadius = this.smallRadius;
      this._largeRadius = this.largeRadius;
    }

    void randomAngle(float minAngle, float maxAngle) {
      this.angle = random(minAngle, maxAngle);
      this._angle = this.angle;
    }

    void optimalLocation(float centerX, float centerY, float xDeviation, float yDeviation) {
      this.location = new PVector(centerX, centerY);
      this.location.add(xDeviation * cos(this.angle), yDeviation * sin(this.angle));
      this._location = this.location.copy();
    }

    void randomColor(Pallete pallete, float alpha) {
      this.fillColor = pallete.getRandomColor(alpha);
    }

    void randomHeight(float minHeight, float maxHeight) {
      this.relativeHeight = random(minHeight, maxHeight);
    }

    PVector getFirstPointOfBase() {
      float deltaAngle = -this.getDeltaAngle();
      PVector point = PVector.fromAngle(deltaAngle);
      point.mult(this.largeRadius);
      return point;
    }

    PVector getLastPointOfBase() {
      float deltaAngle = this.getDeltaAngle();
      PVector point = PVector.fromAngle(deltaAngle);
      point.mult(this.largeRadius);
      return point;
    }

    float getDeltaAngle() {
      if (this.relativeHeight < 1.0) {
        return asin(sqrt(this.relativeHeight));
      } else {
        return asin(sqrt(this.relativeHeight - 1)) + HALF_PI;
      }
    }

    void display(PGraphics pg) {
      float deltaAngle = this.getDeltaAngle();
      //    applyMatrix();
      pg.pushMatrix();
      pg.translate(this.location.x, this.location.y);
      pg.rotate(this.angle);
      pg.noStroke();
      pg.fill(this.fillColor);
      pg.arc((this.smallRadius - this.largeRadius) / 2, 0, this.smallRadius, this.largeRadius, -deltaAngle, deltaAngle, CHORD);
      //    resetMatrix();
      pg.popMatrix();
    }

    void animate(float deltaTime, float currentTime) {
      this.angle = this._angle + PI/10 * sin(currentTime * 0.01);
      this.smallRadius = this._smallRadius + 20 * (0.5 + sin(currentTime * 0.02));
      this.largeRadius = this._largeRadius + 20 * (0.5 + sin(currentTime * 0.02 + PI/2));
    }
  }
  class Meduze {
    int layerCount = 0;
    ArrayList<FlowField> flowLayers = new ArrayList();
    ArrayList<Head> headLayers = new ArrayList();
    ArrayList<ArrayList<Tentacle>> tentacleLayers = new ArrayList();

    void addLayer(FlowField flow, Head head, ArrayList<Tentacle> tentacles) {
      layerCount++;
      flowLayers.add(flow);
      headLayers.add(head);
      tentacleLayers.add(tentacles);
    }

    void display(PGraphics pg) {
      for (int i = 0; i < layerCount; i++) {
        Head head = headLayers.get(i);
        head.display(pg);

        ArrayList<Tentacle> tentacles = tentacleLayers.get(i);
        for (Tentacle tentacle : tentacles) {
          tentacle.display(pg);
        }
      }
    }

    void animate(float deltaTime, float currentTime) {
      for (int i = 0; i < layerCount; i++) {
        FlowField flow = flowLayers.get(i);
        flow.animate(deltaTime, currentTime);

        Head head = headLayers.get(i);
        head.animate(deltaTime, currentTime);
      }
    }
  }
  class Pallete {
    final int COLOR_COUNT = 5;
    float[] colorPalleteH = new float[COLOR_COUNT];
    float[] colorPalleteS = new float[COLOR_COUNT];
    float[] colorPalleteB = new float[COLOR_COUNT];

    void randomPallete() {
      float h = random(0, 100);
      float s = random(30, 100);
      float b = 100;
      float d = 15;
      for (int i = 0; i < COLOR_COUNT; i++) {
        float ch = (i - COLOR_COUNT * 0.5) * d + h;
        if (ch < 0) ch += 100;
        if (ch > 100) ch -= 100;
        colorPalleteH[i] = ch;
        colorPalleteS[i] = s;
        colorPalleteB[i] = b;
      }
    }

    color getRandomColor(float alpha) {
      int i = round(random(COLOR_COUNT - 1) + 0.5);
      return color(colorPalleteH[i], colorPalleteS[i], colorPalleteB[i], alpha);
    }
  }
  class Paper {
    PGraphics canvas;

    void randomizePaper(int paperWidth, int paperHeight, int arg) {
      canvas = createGraphics(paperWidth, paperHeight);
      canvas.beginDraw();
      canvas.colorMode(HSB, 100, 100, 100);
      canvas.noStroke();
      for (var i = 0; i < paperWidth - 1; i += 2) {
        for (var j = 0; j < paperHeight - 1; j += 2) {
          canvas.fill(color(random(75, 95), arg));
          canvas.rect(i, j, 2, 2);
        }
      }
      canvas.endDraw();
    }

    void display(PGraphics pg, float x, float y) {
      pg.image(canvas, x, y);
    }
  }
  class Scene {
    Meduze meduze;
    ArrayList<Bubble> bubbles = new ArrayList();

    void randomScene(int sceneWidth, int sceneHeight) {
      meduze = createMeduze(sceneWidth, sceneHeight);
      bubbles = createBubbles(sceneWidth, sceneHeight);
    }

    void display(PGraphics pg) {
      meduze.display(pg);
      for (Bubble bubble : bubbles) {
        bubble.display(pg);
      }
    }

    void animate(float deltaTime, float currentTime) {
      meduze.animate(deltaTime, currentTime);
      for (Bubble bubble : bubbles) {
        bubble.animate(deltaTime, currentTime);
      }
    }

    Meduze createMeduze(int w, int h) {
      Meduze meduze = new Meduze();

      float size = min(w, h);

      Pallete pallete = new Pallete();
      pallete.randomPallete();

      FlowField defaultFlow = new FlowField();
      defaultFlow.randomSize(10, w, h);
      defaultFlow.randomAnimation(0.0001);

      Head defaultHead = new Head();
      defaultHead.randomAngle(PI, TWO_PI);
      defaultHead.optimalLocation(w * 0.5, h * 0.5, size * 0.2, size * 0.2);

      int layerCount = round(random(2, 4) + 0.5);
      for (int layer = 0; layer < layerCount; layer++) {
        float layerRadiusFactor = map(layer, 0, layerCount, 1, 0.75);
        float layerSegmentFactor = map(layer, 0, layerCount, 1, 0.3);

        Head head = defaultHead.copy();
        head.randomRadius(size * 0.1 * layerRadiusFactor, size * 0.15 * layerRadiusFactor, size * 0.15 * layerRadiusFactor, size * 0.2 * layerRadiusFactor);
        head.randomColor(pallete, map(layer, 0, layerCount, 30, 40));
        head.randomHeight(1.2, 1.5);

        FlowField flow = defaultFlow.copy();
        flow.randomField(head.angle + PI, PI * 0.3, 100);

        Tentacle defaultTentacle = new Tentacle(flow, head);
        defaultTentacle.randomType();
        defaultTentacle.randomColor(pallete, map(layer, 0, layerCount, 10, 50));
        defaultTentacle.randomForce(0.5, 1);
        defaultTentacle.randomSpeed(10, 15);
        defaultTentacle.randomRelativeWaveLength(3, 5);

        ArrayList<Tentacle> tentacles = new ArrayList();
        int tentaclesCount = round(random(10, 20));
        for (int i = 0; i <= tentaclesCount; i++) {
          float position = random(0, 1);
          float positionFactor = sin(position * PI) + 1;
          Tentacle tentacle = defaultTentacle.copy();
          tentacle.setStartPosition(position);
          tentacle.randomSegmentCount(ceil(25 * positionFactor * layerSegmentFactor), ceil(50 * positionFactor * layerSegmentFactor));
          tentacle.randomWeight(3 * positionFactor, 15 * positionFactor);
          tentacle.randomPath();

          tentacles.add(tentacle);
        }
        meduze.addLayer(flow, head, tentacles);
      }
      return meduze;
    }

    ArrayList<Bubble> createBubbles(float w, float h) {
      ArrayList<Bubble> list = new ArrayList();
      int count = round(random(3, 10) + 0.5);
      for (int i = 0; i < count; i++) {
        Bubble bubble = new Bubble(w, h);
        bubble.randomColor(color(#0B90AA), 1, 10);
        bubble.randomRadius(10, 50);
        bubble.randomSpeed(0.05, 0.5);
        bubble.randomFrequency(0.01, 0.05);
        list.add(bubble);
      }
      return list;
    }
  }
  class Tentacle {
    final int TYPE_COUNT = 5;
    final int CIRCLE_TYPE = 0;
    final int TRIANGLE_TYPE = 1;
    final int STROKE_TYPE = 2;
    final int WAVE_TYPE = 3;
    final int POINT_TYPE = 4;

    ArrayList<PVector> points = new ArrayList();
    int pointCount;
    color fillColor;
    float speed;
    float force;
    float weight;
    int type;
    float relativeWaveLength;

    FlowField flow;
    Head head;
    float startPosition;

    Tentacle(FlowField flow, Head head) {
      this.flow = flow;
      this.head = head;
    }

    Tentacle copy() {
      Tentacle tentacle = new Tentacle(flow, head);
      tentacle.pointCount = this.pointCount;
      tentacle.fillColor = this.fillColor;
      tentacle.speed = this.speed;
      tentacle.force = this.force;
      tentacle.weight = this.weight;
      tentacle.type = this.type;
      tentacle.relativeWaveLength = this.relativeWaveLength;
      tentacle.startPosition = this.startPosition;
      for (PVector point : this.points) {
        tentacle.points.add(point.copy());
      }
      return tentacle;
    }

    void setStartPosition(float startPosition) {
      this.startPosition = startPosition;
    }

    void randomType() {
      this.type = round(random(TYPE_COUNT - 1) + 0.5);
    }

    void randomWeight(float minWeight, float maxWeight) {
      this.weight = random(minWeight, maxWeight);
    }

    void randomSegmentCount(float minCount, float maxCount) {
      this.pointCount = round(random(minCount, maxCount));
    }

    void randomSpeed(float minSpeed, float maxSpeed) {
      this.speed = random(minSpeed, maxSpeed);
    }

    void randomForce(float minForce, float maxForce) {
      this.force = random(minForce, maxForce);
    }

    void randomColor(Pallete pallete, float alpha) {
      this.fillColor = pallete.getRandomColor(alpha);
    }

    void randomRelativeWaveLength(float minLength, float maxLength) {
      this.relativeWaveLength = random(minLength, maxLength);
    }

    void randomPath() {
      float offsetAngle = head.angle;
      PVector firstPosition = head.getFirstPointOfBase();
      PVector lastPosition = head.getLastPointOfBase();
      PVector location = PVector.lerp(firstPosition, lastPosition, this.startPosition);
      location.rotate(offsetAngle);
      location.add(head.location);
      PVector velocity = PVector.fromAngle(offsetAngle + PI);
      velocity.mult(this.speed * 0.5);
      PVector acceleration = new PVector();

      for (int i = 0; i < this.pointCount; i++) {
        this.points.add(location.copy());

        PVector desired = flow.lookup(location);
        desired.mult(this.speed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(this.force);
        acceleration.add(steer);

        velocity.add(acceleration);
        velocity.limit(this.speed);
        location.add(velocity);
        acceleration.mult(0);
      }
    }

    void display(PGraphics pg) {
      float offsetAngle = head.angle;
      PVector firstPosition = head.getFirstPointOfBase();
      PVector lastPosition = head.getLastPointOfBase();
      PVector location = PVector.lerp(firstPosition, lastPosition, this.startPosition);
      location.rotate(offsetAngle);
      location.add(head.location);
      PVector velocity = PVector.fromAngle(offsetAngle + PI);
      velocity.mult(this.speed * 0.5);
      PVector acceleration = new PVector();

      for (int i = 0; i < this.pointCount; i++) {
        float smooth = 0.05;
        PVector point = this.points.get(i);
        point.add((location.x - point.x) * smooth, (location.y - point.y) * smooth);

        PVector desired = flow.lookup(location);
        desired.mult(this.speed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(this.force);
        acceleration.add(steer);

        velocity.add(acceleration);
        velocity.limit(this.speed);
        location.add(velocity);
        acceleration.mult(0);
      }
      float waveLength = this.weight * this.relativeWaveLength;
      switch (this.type) {
      case CIRCLE_TYPE:
        {
          pg.noStroke();
          pg.fill(this.fillColor);
          float sumDist = 0;
          for (int i = 0; i < this.points.size(); i++) {
            PVector point = this.points.get(i);
            if (i > 0) {
              PVector prevPoint = this.points.get(i - 1);
              PVector delta = PVector.sub(point, prevPoint);
              sumDist += delta.mag();
              float circleRadius = this.weight * 0.25 * (sin(sumDist / waveLength * PI) + 1);
              pg.ellipse(point.x, point.y, circleRadius, circleRadius);
            }
          }
          break;
        }
      case TRIANGLE_TYPE:
        {
          pg.noStroke();
          pg.fill(this.fillColor);
          float sumDist = 0;
          for (int i = 0; i < this.points.size(); i++) {
            PVector point = this.points.get(i);
            if (i > 0) {
              PVector prevPoint = this.points.get(i - 1);
              PVector delta = PVector.sub(point, prevPoint);
              sumDist += delta.mag();
              delta.normalize();
              delta.mult(this.weight * 0.25 * (sin(sumDist / waveLength * PI) + 1));
              pg.triangle(point.x, point.y, prevPoint.x - delta.y, prevPoint.y + delta.x, prevPoint.x + delta.y, prevPoint.y - delta.x);
            }
          }
          break;
        }
      case STROKE_TYPE:
        {
          pg.noFill();
          pg.stroke(this.fillColor);
          pg.strokeWeight(this.weight);
          pg.beginShape();
          for (int i = 0; i < this.points.size(); i++) {
            PVector point = this.points.get(i);
            pg.curveVertex(point.x, point.y);
          }
          pg.endShape();
          break;
        }
      case WAVE_TYPE:
        {
          pg.noFill();
          pg.stroke(this.fillColor);
          float sumDist = 0;
          for (int i = 0; i < this.points.size(); i++) {
            PVector point = this.points.get(i);
            if (i > 0) {
              PVector prevPoint = this.points.get(i - 1);
              PVector delta = PVector.sub(point, prevPoint);
              sumDist += delta.mag();
              pg.strokeWeight(this.weight * 0.5 * (sin(sumDist / waveLength * PI) + 1));
              pg.line(prevPoint.x, prevPoint.y, point.x, point.y);
            }
          }
          break;
        }
      case POINT_TYPE:
        {
          pg.noFill();
          pg.stroke(this.fillColor);
          pg.strokeWeight(this.weight / 5);
          pg.beginShape();
          for (int i = 0; i < this.points.size(); i++) {
            PVector point = this.points.get(i);
            if (i == 0 || i == this.points.size()) {
              pg.vertex(point.x, point.y);
            } else {
              pg.curveVertex(point.x, point.y);
            }
          }
          pg.endShape();
          PVector lastPoint = this.points.get(this.points.size() - 1);
          pg.noStroke();
          pg.fill(this.fillColor);
          pg.ellipse(lastPoint.x, lastPoint.y, this.weight * 0.5, this.weight * 0.5);
          break;
        }
      default:
        break;
      }
    }
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
