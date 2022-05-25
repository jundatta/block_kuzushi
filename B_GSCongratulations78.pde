// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Neill Bogieさん
// 【作品名】Sail Through City
// https://openprocessing.org/sketch/1024013
//

//Another example implementation of this challenge:
//https://www.notion.so/neillzero/Drive-down-city-street-3d-bcb823ac7e8040628d33395439c327ee

// * Loads .obj model files for the vehicle
//   * moving pieces propeller, periscope (which need separate models)
// * Smoothly collapsing buildings behind
// * Growing buildings in front (with an out of place stop-motion look!)
// * Faked reflection from the water onto sub when it is out of water
// * Billboarded 2d particles (simple circles) (turned toward camera)
// * Faked see-through buildings - don't fill buildings that are near camera

// Small speed boost.  Comment this out if you need good error messages.
// p5.disableFriendlyErrors = true;

class GameSceneCongratulations78 extends GameSceneCongratulationsBase {
  class Settings {
    boolean shouldDrawDebug;
    boolean isHelpOn;
    boolean isBobbingOn;
    boolean areBubblesOn;

    void toggleDrawDebug() {
      shouldDrawDebug = !shouldDrawDebug;
      // addSign("Debug: " + (settings.shouldDrawDebug ? "on" : "off"));
    }
    void toggleBobbing() {
      isBobbingOn = !isBobbingOn;
      // addSign("Bobbing: " + (settings.isBobbingOn ? "on" : "off"));
    }
    void toggleBubbles() {
      areBubblesOn = !areBubblesOn;
      // addSign("Bubbles: " + (settings.areBubblesOn ? "on" : "off"));
    }
    void toggleHelp() {
      isHelpOn = !isHelpOn;
    }
  }
  Settings settings = new Settings();

  PShape subModel;
  PShape subPropModel;
  PShape subPeriscopeModel;
  PFont myFont;

  //submarine models by me (Neill) and in public domain
  void P5preload() {
    subModel = loadShape("data/78/sub.obj");
    subPropModel = loadShape("data/78/sub-prop.obj");
    subPeriscopeModel = loadShape("data/78/sub-periscope.obj");
    myFont = createFont("data/78/Goldman-Bold.ttf", 50, true);
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    P5preload();
    textFont(myFont);

    settings.shouldDrawDebug = false;
    settings.isHelpOn = true;
    settings.isBobbingOn = true;
    settings.areBubblesOn = false;

    setupWaterCycler();
    setupVehicle();
    setupBuildings();

    noStroke();
  }
  @Override void draw() {
    background(200);
    push();

    updateBubbles();
    updateSubmarine();
    updateBuildings();
    //update camera to be behind submarine
    cameraCycler.updateCurrentCamera();
    //scale(1,-1);     // invert view for saving thumbnail
    drawLightsAffectingAll();
    drawBuildings();
    drawGround();
    drawCanal();

    //this light is drawn late, to only affect submarine
    float r = red(waterLight());
    float g = green(waterLight());
    float b = blue(waterLight());
    directionalLight(r, g, b, 0.1, -1, 0.1);
    drawSubmarine();
    drawBubbles();

    noLights();
    if (settings.shouldDrawDebug) {
      push();
      translate(vehicle.pos.x, vehicle.pos.y, vehicle.pos.z);
      translate(0, -40, -100);
      textSize(40);
      fill(0xFF, 0x69, 0xB4);  // 'hotpink'

      text(int(frameRate), 0, 0);
      pop();
    }

    if (settings.isHelpOn) {
      drawSigns();
    }
    pop();
  }

  void rotateToPointAtVector(PVector v) {
    //rotate to align to the given vector
    rotateZ(-atan2(v.x, v.y));
    rotateX(-PI / 2.0f - atan2(sqrt(v.x * v.x + v.y * v.y), v.z));
  }

  float snap(float v, float inc) {
    return round(v / inc) * inc;
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == 'w') {
      cycleWaterColour();
    }
    if (key == 'c') {
      cameraCycler.cycle();
    }
    if (key == 'd') {
      settings.toggleDrawDebug();
    }
    if (key == 'b') {
      settings.toggleBobbing();
    }
    if (key == 'u') {
      settings.toggleBubbles();
    }
    if (key == '?') {
      settings.toggleHelp();
    }
  }

  class Bubble {
    PVector pos;
    PVector vel;
    float diameter;
    float hue;
  }
  ArrayList<Bubble> bubbles = new ArrayList();

  void updateBubbles() {
    for (Bubble b : bubbles) {
      updateBubble(b);
    }
    if (settings.areBubblesOn) {
      bubbles.add(createBubble(vehicle.pos.copy().add(0, 0, 0)));
      //    bubbles = bubbles.slice(-100);
      while (100 < bubbles.size()) {
        bubbles.remove(0);
      }
    } else {
      bubbles = new ArrayList();
    }
  }

  Bubble createBubble(PVector pos) {
    Bubble b = new Bubble();
    b.pos = new PVector(pos.x, pos.y, pos.z);
    b.vel = PVector.random3D().setMag(1);
    b.diameter = random(3, 10);
    b.hue = (frameCount + random(0, 80)) % 360;
    return b;
  }

  void drawBubbles() {
    for (Bubble b : bubbles) {
      drawBubble(b);
    }
  }

  void drawBubble(Bubble b) {
    final PVector camPos = cameraCycler.getCameraPosition();
    push();
    translate(b.pos.x, b.pos.y, b.pos.z);
    // fill(255, 100);
    noFill();
    strokeWeight(1);
    colorMode(HSB, 360, 100, 100);
    // stroke(b.hue, 50, 100);
    float h = hue(water());
    float s = 10;
    float br = 100;
    stroke(h, s, br);
    //"billboard" - rotate to face current camera position
    rotateToPointAtVector(PVector.sub(b.pos, camPos));
    rotateX(PI / 2);
    circle(0, 0, b.diameter);
    final float offset = b.diameter * 0.2;
    circle(offset, offset, b.diameter * 0.1);
    pop();
  }

  void updateBubble(Bubble b) {
    b.pos.add(b.vel);
  }

  class BuildingDimension {
    float width;
    float height;
    float depth;
  }
  class Building {
    PVector pos;
    color colour;
    BuildingDimension dim;
  }
  ArrayList<Building> buildings = new ArrayList();

  float randomGlitchAngle() {
    return P5JSrandom(PI / 8.0f, PI / 4.0f, PI / 6.0f, PI / 2.1) * P5JSrandom(-1, +1);
  }

  void drawBuildings() {
    for (Building building : buildings) {
      float h = building.dim.height;

      float glitchAngleX = 0;
      float glitchAngleY = 0;
      //if the building is still in a growing zone, grow it in blocky increments
      final float growPoint = vehicle.pos.z - 1000;

      if (building.pos.z < growPoint) {
        h = h * P5JS.map(snap((building.pos.z - growPoint), 20), 0, -200, 1, 0, true);

        //glitch occasionally to strange angle
        if (random(1) < 0.1) {
          // [glitchAngleX, glitchAngleY] = [randomGlitchAngle(), randomGlitchAngle()];
        }
      }

      push();
      translate(building.pos.x, building.pos.y, building.pos.z);
      translate(0, -h / 2.0f, 0);
      rotateZ(glitchAngleX);
      rotateY(glitchAngleY);
      if (isInWayOfCamera(building.pos)) {
        stroke(building.colour);
        strokeWeight(2);
        noFill();
      } else {
        fill(building.colour);
        noStroke();
      }

      box(building.dim.width, h, building.dim.depth);
      pop();
    }
  }

  void updateBuildings() {
    push();
    colorMode(HSB, 360, 100, 100);
    for (Building b : buildings) {
      final float myHue = (frameCount * 2 + random(0, 60)) % 360;
      //if building is behind the camera - move it 1000 world units forward of the camera

      if (b.pos.z > vehicle.pos.z + 200) {
        b.pos.z -= 1300;
        b.dim = randomBuildingDimensions();
        b.colour = color(myHue, 40, 100);
      }

      //buildings about to be destroyed get their heights squished a little each frame prior to that
      if (b.pos.z > vehicle.pos.z + 100) {
        b.dim.height *= 0.9;
      }
    }
    pop();
  }

  BuildingDimension randomBuildingDimensions() {
    BuildingDimension bd = new BuildingDimension();
    bd.width = random(10, 50);
    bd.height = random(10, 150);
    bd.depth = random(10, 40);
    return bd;
  }

  void setupBuildings() {
    for (int i = 0; i < 100; i++) {
      Building b = new Building();
      b.pos = new PVector(random(75, 150) * P5JSrandom(-1, 1), 0, random(-1000, 200));
      b.colour = color(random(100, 200));
      b.dim = randomBuildingDimensions();
      buildings.add(b);
    }
  }
  boolean isInWayOfCamera(PVector pos) {

    //TODO: cheaper to render everything in stacked(?) index colours to an offscreen and see what pixel colour(s) are in centre?
    return pos.dist(cameraCycler.getCameraPosition()) < 150;
  }

  class CameraCycler {
    int ixAngleCamera = 0;
    PVector eyeAngleCamera = new PVector();
    AngleCamera[] angleCycler = new AngleCamera[] {
      new AngleCameraChase(),
      new AngleCameraOrbiting(),
      new AngleCameraAerial(),
      new AngleCameraAngle(),
      new AngleCameraLead(),
    };

    void cycle() {
      ixAngleCamera = (ixAngleCamera + 1) % angleCycler.length;
    }
    PVector getCameraPosition() {
      return eyeAngleCamera;
    }
    void updateCurrentCamera() {
      AngleCamera ac = angleCycler[ixAngleCamera];
      eyeAngleCamera = ac.updateCamera();
    }
  }
  CameraCycler cameraCycler = new CameraCycler();

  class AngleCamera {
    PVector updateCamera() {
      return new PVector();
    }
  }

  class AngleCameraChase extends AngleCamera {
    @Override PVector updateCamera() {
      //cam.setPosition(0, -40, 200 + vehicle.pos.z)
      //  cam.lookAt(0, 0, vehicle.pos.z);
      PVector eye = new PVector(0, -40, 200 + vehicle.pos.z);
      camera(eye.x, eye.y, eye.z,
        0, 0, vehicle.pos.z,
        0, 1, 0);
      return eye;
    }
  }
  class AngleCameraOrbiting extends AngleCamera {
    @Override PVector updateCamera() {
      final float orbitRadius = 200;
      final float angle = frameCount / 40.0f;
      final float x = orbitRadius * sin(angle);
      final float y = -30;
      final float z = vehicle.pos.z + orbitRadius * cos(angle);
      //cam.setPosition(x, y, z)
      //  cam.lookAt(0, 0, vehicle.pos.z);
      PVector eye = new PVector(x, y, z);
      camera(eye.x, eye.y, eye.z,
        0, 0, vehicle.pos.z,
        0, 1, 0);
      return eye;
    }
  }
  class AngleCameraAerial extends AngleCamera {
    @Override PVector updateCamera() {
      //cam.setPosition(0, -200, 0.01 + vehicle.pos.z)
      //  cam.lookAt(0, 0, vehicle.pos.z);
      PVector eye = new PVector(0, -200, 0.01 + vehicle.pos.z);
      camera(eye.x, eye.y, eye.z,
        0, 0, vehicle.pos.z,
        0, 1, 0);
      return eye;
    }
  }
  class AngleCameraAngle extends AngleCamera {
    @Override PVector updateCamera() {
      final float amp = 4;
      final float x = amp * sin(frameCount / 20.0f) + 50;
      final float y = -70;
      final float z = vehicle.pos.z + 200;
      //cam.setPosition(x, y, z)
      //  cam.lookAt(0, -30, vehicle.pos.z - 300);
      PVector eye = new PVector(x, y, z);
      camera(eye.x, eye.y, eye.z,
        0, -30, vehicle.pos.z - 300,
        0, 1, 0);
      return eye;
    }
  }
  class AngleCameraLead extends AngleCamera {
    @Override PVector updateCamera() {
      //cam.setPosition(0, -40, -200 + vehicle.pos.z)
      //  cam.lookAt(0, 0, vehicle.pos.z);
      PVector eye = new PVector(0, -40, -200 + vehicle.pos.z);
      camera(eye.x, eye.y, eye.z,
        0, 0, vehicle.pos.z,
        0, 1, 0);
      return eye;
    }
  }

  int ixWaterColour = 0;
  class WaterColour {
    color water;
    color waterLight;
    WaterColour(color water, color waterLight) {
      this.water = water;
      this.waterLight = waterLight;
    }
  }
  WaterColour[] waterCycler;
  void setupWaterCycler() {
    waterCycler = new WaterColour[] {
      new WaterColour(color(0x4B, 0xC1, 0xFF, 255*0.8), color(0x00, 0x00, 0xff)), // color("blue")
      new WaterColour(color(0x86, 0xFF, 0x4B, 255*0.8), color(0x00, 0x80, 0x00)), // color("green")
      new WaterColour(color(0xFF, 0x98, 0xDB, 255*0.8), color(0xff, 0xc0, 0xcb)), // color("pink")
      new WaterColour(color(0xFF, 0x55, 0x00, 255*0.8), color(0xff, 0x00, 0x00)), // color("red")
    };
  }

  void cycleWaterColour() {
    ixWaterColour = (ixWaterColour + 1) % waterCycler.length;
  }

  color water() {
    return waterCycler[ixWaterColour].water;
  }
  color waterLight() {
    return waterCycler[ixWaterColour].waterLight;
  }

  void drawGround() {
    fill(200);
    push();
    translate(0, 0, vehicle.pos.z);

    push();
    translate(-499.99, 50, 0);
    box(900, 100, 2000);
    pop();
    push();
    translate(499.99, 50, 0);
    box(900, 100, 2000);
    pop();

    pop();
  }

  void drawCanal() {
    push();
    translate(0, 10, vehicle.pos.z);
    fill(water());
    //fill(100,200,230, 80);
    box(100, 0.1, 2000);
    pop();
  }

  void drawLightsAffectingAll() {
    directionalLight(255, 255, 255, -1, -0.5, 0.2);
    directionalLight(255, 255, 255, 0.5, 0.5, -0.2);
    ambientLight(90, 75, 75);
    //  ambientMaterial(color(200));
  }

  void drawSigns() {
    drawInitialHelpSigns();
  }

  void drawInitialHelpSigns() {
    colorMode(RGB, 255, 255, 255);
    if (vehicle.pos.z < -25000) {
      return;
    }
    final String[] messages = {
      "c: camera",
      "mouse: steer",
      "?: help on/off",
      "w: water",
      "b: bobbing",
      "u: bubbles",
      "s: save image"
    };
    for (int ix = 0; ix < messages.length; ix++) {
      final float z = -2000 - ix * 2500;
      if (z > vehicle.pos.z + 200) {
        continue;
      }
      String msg = messages[ix];
      //    drawSign(new PVector(0, -20, z), msg, color(ix % 2 == 0 ? #ffc0cb : #ffff00), 20);
      color c;
      if (ix % 2 == 0) {
        c = color(0xff, 0xc0, 0xcb);
      } else {
        c = color(0xff, 0xff, 0x00);
      }
      drawSign(new PVector(0, -20, z), msg, c, 20);
    }
  }

  void drawSign(PVector pos, String words, color colour, float size) {
    push();
    translate(pos.x, pos.y, pos.z);
    fill(colour);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(size);
    text(words, 0, 0);
    pop();
  }

  class Vehicle {
    PVector pos;
    PVector vel;
    color colour;
    float turnStrength;
  }
  Vehicle vehicle = new Vehicle();

  void setupVehicle() {
    vehicle.pos = new PVector(0, 6, 0);
    vehicle.vel = new PVector(0, 0, -4);
    vehicle.colour = color(0xff, 0xff, 0x00);  // "yellow"
    vehicle.turnStrength = 0;
  }

  void drawSubmarine() {
    push();

    translate(vehicle.pos.x, vehicle.pos.y, vehicle.pos.z);

    if (settings.isBobbingOn) {
      final float bobAmp = 20;
      final float jumpFreq = 0.05;
      //lags pitching by 90 degrees
      final float bobY = bobAmp * sin(PI / 2.0f + frameCount * jumpFreq);
      translate(0, bobY, 0);
      //orient the model(s)
      rotateX(PI);
      rotateY(PI);

      translate(0, 0, 20);
      final float pitchingFreq = jumpFreq;
      final float pitchingAmp = 5;
      //leads bobbing by 90 degrees
      final float pitchAngle = radians(pitchingAmp * sin(frameCount * pitchingFreq));
      rotateX(pitchAngle);
      translate(0, 0, -20);
    } else {
      //orient the model(s)
      rotateX(PI);
      rotateY(PI);
    }
    //turn a little in the direction we're currently moving
    rotateY(vehicle.turnStrength / 200.0f);

    noStroke();
    scale(12);
    //  ambientMaterial(vehicle.colour);
    subModel.setFill(vehicle.colour);
    shape(subModel);

    //periscope - rotating
    push();
    //move to pivot point of periscope, rotate around it, move back again
    final float periscopeOffset = 0.625636;
    translate(0, 0, periscopeOffset);
    final float periRotation = P5JS.map(mouseX, 0, width, -PI, PI, true);
    rotateY(periRotation);
    translate(0, 0, -periscopeOffset);

    subPeriscopeModel.setFill(vehicle.colour);
    shape(subPeriscopeModel);
    pop();

    //propeller - rotating, and different colour
    push();
    rotateZ(frameCount / 5.0f);
    //  fill(0xff, 0xc0, 0xcb);
    subPropModel.setFill(color(0xff, 0xc0, 0xcb));
    shape(subPropModel);
    pop();
    pop();
  }

  void updateSubmarine() {
    vehicle.pos.add(vehicle.vel);

    final float desiredX = P5JS.map(mouseX, 0, width, -30, 30, true);
    vehicle.pos.x = lerp(vehicle.pos.x, desiredX, 0.02);
    vehicle.turnStrength = desiredX - vehicle.pos.x;

    final float desiredY = settings.isBobbingOn ? 0 : P5JS.map(mouseY, 0, height, -100, 50, true);
    vehicle.pos.y = lerp(vehicle.pos.y, desiredY, 0.02);
  }
}
