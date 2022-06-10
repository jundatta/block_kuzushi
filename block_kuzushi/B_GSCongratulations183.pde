// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】KTさん
// 【作品名】 AniMapped View
// https://openprocessing.org/sketch/1287366
//

class GameSceneCongratulations183 extends GameSceneCongratulationsBase {
  int boxSideSize = 4;
  int boxesNumber = 40;
  float zNoise = 0;
  PImage shadow;
  PShape shadowShape;
  ArrayList<Location> locations = new ArrayList();
  String[] names = {
    "les Dômes du Canoît", "The Homeless Tops", "le Dôme du Coloves", "Whitronto Forest",
    "les Puys du Channe", "les Montagnes Flétries", "Blóðgarðr", "les Monts Arides", "Mærland",
    "Thick Range Woodland", "Collared Pygmy Owl Timberland", "Effingset Mountains",
    "Detailed Woodland", "le Puy de Nansart", "Groovy Maple Covert", "Battlerial Heights",
    "The Neverending Highlands", "Feigrheimr", "The Grim Hill", "Plarock Hillside",
    "le Dôme Sinistre", "Salisfell Wilds", "Corris Hills", "Vauxnigan Grove",
    "Collared Pygmy Owl Forest", "The Severed Pinnacle", "le Puy de la Champimasse",
    "le Piton de la Beaunnet", "Delisrial Woodland", "Nottingholm Bluff", "Chiboucouche Bluff",
    "le Mont Muet", "Glorious Woodland"};
  color[] colors = {
    #FA0000, #FA0000, #FA0000, #FA0000, #FA0000, #FA0000, #FA0000, #FA0000,
    #FA0000, #FA0000, #FB2A00, #FD5500, #FF8000, #FFA200, #FFC400, #FFE600,
    #AADC00, #55D200, #00C800, #00DA55, #00ECAA, #01FFFF, #00BFFF, #0080FF,
    #0040FF, #0000FF, #0000FF, #0000FF, #0000FF, #0000FF, #0000FF, #0000FF,
    #0000FF};

  int colorsLen = colors.length;
  int namesLen = names.length;
  // https://openprocessing.org/sketch/1287366

  PFont myFont;
  int waterLevel = 40;
  PImage ground;
  PShape groundShape;
  float zSpeed = 1; // 1, 0.5, 0.25...

  PImage elevation;

  void preload () {
    myFont = createFont("data/183/quicksand-book-regular.otf", 50, true);
    ground = loadImage("data/183/texture.png");
    groundShape = createShape(BOX, 1, 1, 1);
    groundShape.setTexture(ground);
    groundShape.setStroke(false);
    shadow = loadImage("data/183/shadow.png");
    shadowShape = createShape(BOX, 250, 250, 1);
    shadowShape.setTexture(shadow);
    shadowShape.setStroke(false);
    elevation = loadImage("data/183/elevation.png");
  }

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    preload();
    //let c = createCanvas(1112, 834, WEBGL);
    //glContext = c.GL;
    //cam = createCamera();
    //cam.setPosition(-125, -300, -200);
    //cam.lookAt(0, -60, 0);
    textFont(myFont);
    textSize(4);
    textAlign(CENTER, BOTTOM);
    //  colors.reverse();
    reverse(colors);
  }
  @Override void draw() {
    background(200);

    camera(-125, -300, -200, 0, -60, 0, 0, 1, 0);

    //  orbitControl(2, 2, 0);
    rotateY(frameCount * 0.002);
    scale(1.2);

    // Shadow
    noStroke();
    push();
    //  texture(shadow);
    rotateX(PI * 0.5);
    translate(0, 0, -20);
    //plane(250);
    //  box(250, 250, 1);
    shape(shadowShape);
    pop();
    //  glContext.clear(glContext.DEPTH_BUFFER_BIT);

    // Locations
    if (Math.random() * 120 > 119) {
      locations.add(new Location(names[(int)Math.floor(Math.random() * namesLen)]));
    }
    int locLen = locations.size() - 1;
    for (int i = locLen; i > -1; i -= 1) {
      locations.get(i).update();
      boolean isDelete = locations.get(i).render();
      if (isDelete) {
        //      locations.splice(i, 1);
        locations.remove(i);
      }
    }

    lightFalloff(0.9, 0.001, 0);
    ambientLight(90, 90, 90);
    pointLight(255, 255, 255, 0, -170, 0);

    int zMove = (int)(frameCount * zSpeed) % boxSideSize;
    zNoise = zMove == 0 ? zNoise + 1 : zNoise;
    for (int z = 0; z <= boxesNumber; z += 1) {
      for (int x = 0; x < boxesNumber; x += 1) {
        // The only place worth tweaking (map start/end values)
        //float noiseVal = map(
        //  noise(x * 0.1, (z + zNoise) * 0.1),
        //  0.1, 0.9, 0, 120, true);
        final float kMin = 0.1f;
        final float kMax = 0.9f;
        float n = noise(x * 0.1, (z + zNoise) * 0.1);
        if (n < kMin) {
          n = kMin;
        }
        if (kMax < n) {
          n = kMax;
        }
        float noiseVal = map(n, 0.1, 0.9, 0, 120);
        push();

        int zSizeFront = boxSideSize - zMove;
        int zSizeBack = zMove;

        fill(colors[floor(map(noiseVal, 0, 120, 0, colorsLen - 1))]);
        noiseVal = noiseVal > waterLevel ? noiseVal : waterLevel;

        if (noiseVal > waterLevel) {
          if (z == 0) {
            translate((x * boxSideSize) - (boxesNumber * 0.5) * boxSideSize,
              -noiseVal / 2.0f,
              -(boxSideSize * (boxesNumber * 0.5)) - zMove * 0.5);
            box(boxSideSize, noiseVal, zSizeFront);
            // fill(200);
            //          rectMode(CORNER);
            //          translate(-boxSideSize * 0.5, 0, zMove * 0.5 - 2.01);
            translate(0.0f, 0, zMove * 0.5 - 2.01);
            //texture(ground);
            //rect(0, -noiseVal / 2.0f, boxSideSize, noiseVal);
            scale(boxSideSize, noiseVal, 0.1f);
            shape(groundShape);

            // Side cross section
            if (x == 0) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              translate(0.1, 0, -0.1);
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, -zSizeFront - 0.1, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              //            shape(groundShape);
              pop();
            } else if (x == boxesNumber - 1) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              translate(0.1, 0, 4.01);
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, -zSizeFront - 0.1, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              //            shape(groundShape);
              pop();
            }
          } else if (z == boxesNumber) {
            translate((x * boxSideSize) - (boxesNumber * 0.5) * boxSideSize,
              -noiseVal / 2.0f,
              ((z - boxesNumber * 0.5) * boxSideSize) - (zMove * 0.5) -
              (boxSideSize * 0.5) -
              0.1);
            box(boxSideSize, noiseVal, zSizeBack);
            // fill(200);
            //rectMode(CORNER);
            //translate(-boxSideSize * 0.5, 0, zMove * 0.5 + 0.2);
            translate(0.0f, 0, zMove * 0.5 + 0.2);
            //texture(ground);
            //rect(0, -noiseVal / 2.0f, boxSideSize, noiseVal);
            scale(boxSideSize, noiseVal, 0.1f);
            //          shape(groundShape);

            // Side cross section
            if (x == 0) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              translate(0.1, 0, -0.1);
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, zSizeBack, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              //            shape(groundShape);
              pop();
            } else if (x == boxesNumber - 1) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              translate(0.1, 0, 4.01);
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, zSizeBack, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              //            shape(groundShape);
              pop();
            }
          } else {
            translate((x * boxSideSize) - (boxesNumber * 0.5) * boxSideSize,
              -noiseVal / 2.0f,
              ((z - boxesNumber * 0.5) * boxSideSize) - zMove);
            box(boxSideSize, noiseVal, boxSideSize);

            // Side cross section
            if (x == 0) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              //translate(-boxSideSize * 0.5, 0, -2.1);
              translate(0.0f, 0, -2.1);
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, boxSideSize, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              shape(groundShape);
              pop();
            } else if (x == boxesNumber - 1) {
              push();
              // fill(200);
              //rectMode(CORNER);
              rotateY(PI * 0.5);
              //translate(-boxSideSize * 0.5, 0, 2.1);
              translate(0.0f, 0, 2.1);
              // ambientMaterial(255)
              //texture(ground);
              //rect(0, -noiseVal / 2.0f, boxSideSize, noiseVal);
              scale(boxSideSize, noiseVal, 0.1f);
              shape(groundShape);
              pop();
            }
          }
        }
        pop();
      }
    }

    // if(noiseVal === waterLevel){
    push();
    translate(-boxSideSize * 0.5 + 0.5, -waterLevel * 0.5 - 0.5, -boxSideSize * 0.5);
    lightFalloff(0.1, 0.01, 0);
    //  specularMaterial(0, 50, 200, 110);
    specular(color(0, 50, 200, 110));
    fill(0, 0, 200, 150);
    int waterSize = boxSideSize * boxesNumber - 2;
    stroke(0, 200, 255);
    box(waterSize, waterLevel - boxSideSize, waterSize);
    pop();

    // Wireframe Box
    noFill();
    strokeWeight(0.5);
    stroke(100);
    push();
    translate(-boxSideSize * 0.5, -boxSideSize * boxesNumber * 0.5, -boxSideSize * 0.5);
    box(boxesNumber * boxSideSize, boxesNumber * boxSideSize, boxesNumber * boxSideSize);
    pop();

    // hint()にはpush()/pop()は効かなかった
    //  push();
    hint(DISABLE_DEPTH_TEST);
    camera();
    lights();
    float hiritsu = 400.0f / (float)elevation.width;
    image(elevation, 60, 0, elevation.width * hiritsu, elevation.height * hiritsu);
    hint(ENABLE_DEPTH_TEST);
    //  pop();

    logoRightLower(#ff0000);
  }


  class Location {
    float z, y, x;
    String name;

    Location (String pName) {
      this.z = (boxesNumber * boxSideSize) / 2.0f;
      this.y = -(boxesNumber * boxSideSize) + 30;
      this.x = random(boxesNumber * boxSideSize) - ((boxesNumber * boxSideSize) / 2.0f);
      this.name = pName;
    }

    void update () {
      this.z -= zSpeed;
      this.y += 0.1;
    }

    boolean render () {
      boolean toDelete = false;
      push();
      translate(this.x, this.y, this.z);
      noFill();
      stroke(255);
      strokeWeight(0.5);
      triangle(-2, 2, 0, -2, 2, 2);
      line(0, 2, 0, 80);
      noStroke();
      rotateY(PI);
      fill(255, 255);
      text(this.name, 0, -5);
      pop();
      if (this.z < -(boxesNumber * boxSideSize) * 0.5) {
        toDelete = true;
      }
      return toDelete;
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
