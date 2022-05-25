// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://junkiyoshi.com/openframeworks20220219/
//

class GameSceneCongratulations210 extends GameSceneCongratulationsBase {
  PShape ico_sphere;
  ArrayList<PVector> base_location_list;

  int number_of_sphere;

  class Param {
    color bodyColor;
    PVector location;
    float size;

    Param(color bodyColor, PVector location, float size) {
      this.bodyColor = bodyColor;
      this.location = location;
      this.size = size;
    }
  }
  ArrayList<Param> sphere_list;

  color[] color_palette;

  class Mesh {
    ArrayList<PVector> vertexList;
    ArrayList<Integer> indexList;
    ArrayList<Integer> colorList;

    Mesh() {
      vertexList = new ArrayList();
      indexList = new ArrayList();
      colorList = new ArrayList();
    }
    void clear() {
      vertexList.clear();
      indexList.clear();
      colorList.clear();
    }
    // デフォルトのOF_PRIMITIVE_TRIANGLE_STRIPの解釈で描画する
    void draw() {
      PShape sh = createShape();
      sh.setStroke(false);
      sh.beginShape(TRIANGLE_STRIP);
      for (Integer i : indexList) {
        PVector v = vertexList.get(i);
        sh.vertex(v.x, v.y, v.z);
      }
      sh.endShape();
      for (int i = 0; i < indexList.size(); i++) {
        int idx = indexList.get(i);
        color col = colorList.get(idx);
        sh.setFill(i, col);
      }
      shape(sh);
    }
    // 設定されたOF_PRIMITIVE_LINESの解釈で描画する
    void drawWireframe() {
      PShape sh = createShape();
      sh.setFill(false);
      sh.beginShape(LINES);
      for (Integer i : indexList) {
        PVector v = vertexList.get(i);
        sh.vertex(v.x, v.y, v.z);
      }
      sh.endShape();
      for (int i = 0; i < indexList.size(); i++) {
        int idx = indexList.get(i);
        color col = colorList.get(idx);
        sh.setStroke(i, col);
      }
      shape(sh);
    }
    int getNumVertices() {
      return vertexList.size();
    }
    void addVertices(PVector v) {
      vertexList.add(v);
    }
    void addVertices(ArrayList<PVector> array) {
      for (PVector v : array) {
        addVertices(v);
      }
    }
    void addIndex(int idx) {
      indexList.add(idx);
    }
    void addColor(color c) {
      colorList.add(c);
    }
  }
  Mesh face;
  Mesh frame;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(0);
    strokeWeight(3);

    //  auto ico_sphere = ofIcoSpherePrimitive(1, 5);
    ico_sphere = new Sphere(1, 5).get();
    //this->base_location_list = ico_sphere.getMesh().getVertices();
    base_location_list = new ArrayList();
    for (int i = 0; i < ico_sphere.getVertexCount(); i++) {
      PVector p = ico_sphere.getVertex(i);
      base_location_list.add(p);
    }

    sphere_list = new ArrayList();
    number_of_sphere = 50;
    while (sphere_list.size() < number_of_sphere) {
      int index = (int)random(base_location_list.size());
      PVector tmp_location = base_location_list.get(index);
      //::    tmp_location = glmnormalize(tmp_location) * ofRandom(0, 95);
      tmp_location.normalize();
      tmp_location = tmp_location.mult(random(0, 95));

      float radius = sphere_list.size() < 110 ? random(10, 50) : random(3, 20);

      boolean flag = true;
      for (int i = 0; i < sphere_list.size(); i++) {
        Param p = sphere_list.get(i);
        PVector param_location = p.location;
        float param_size = p.size;
        //if (::glmdistance(tmp_location, get<1>(this->sphere_list[i])) < get<2>(this->sphere_list[i]) + radius) {
        if (PVector.dist(tmp_location, param_location) < param_size + radius) {
          flag = false;
          break;
        }
      }

      if (flag) {
        //color.setHsb(ofRandom(255), 200, 255);
        colorMode(HSB, 255, 255, 255);
        color col = color(random(255), 200, 255);
        colorMode(RGB, 255, 255, 255);
        float size = (radius * 2) / sqrt(3);

        Param p = new Param(col, tmp_location, size);
        sphere_list.add(p);
      }
    }

    // ::  this->frame.setMode(ofPrimitiveModeOF_PRIMITIVE_LINES);

    // 配色デザイン ビビッドレッド P038
    //this->color_palette.push_back(ofColor(197, 0, 24));
    //this->color_palette.push_back(ofColor(184, 12, 65));
    //this->color_palette.push_back(ofColor(206, 97, 110));
    //this->color_palette.push_back(ofColor(204, 85, 68));
    //this->color_palette.push_back(ofColor(190, 145, 176));
    //this->color_palette.push_back(ofColor(215, 130, 63));
    //this->color_palette.push_back(ofColor(255, 241, 51));
    //this->color_palette.push_back(ofColor(107, 182, 187));

    color[] palette = {
      color(197, 0, 24),
      color(184, 12, 65),
      color(206, 97, 110),
      color(204, 85, 68),
      color(190, 145, 176),
      color(215, 130, 63),
      color(255, 241, 51),
      color(107, 182, 187),
    };
    color_palette = palette;

    face = new Mesh();
    frame = new Mesh();
  }

  void update() {
    randomSeed(39);
  }

  @Override void draw() {
    update();

    camera(width/2.0, height/2.0,
      (height/2.0) / tan(PI*30.0 / 180.0) * 0.3f,
      width/2.0, height/2.0, 0, 0, 1, 0);
    translate(width / 2, height / 2);
    background(0);

    rotateY(radians(frameCount * 0.3333333333333333333));

    for (int i = 0; i < sphere_list.size(); i++) {
      Param p = sphere_list.get(i);
      PVector location = p.location;
      float size = p.size;

      push();
      translate(location.x, location.y, location.z);

      rotateZ(radians(random(360)));
      rotateY(radians(random(360)));
      rotateX(radians(random(360)));

      int sphere_color_index = (int)random(color_palette.length);
      int face_color_index = (sphere_color_index + 1) % color_palette.length;
      int frame_color_index = (face_color_index + 1) % color_palette.length;

      noStroke();
      fill(color_palette[sphere_color_index]);
      //    sphere(size * 0.45);
      sphere(size * 0.45);

      ofAppsetRingToMesh(face, frame, location, size * 0.5, size * 0.2, color_palette[face_color_index], color_palette[frame_color_index]);

      pop();

      face.draw();
      frame.drawWireframe();
    }

    logoRightLower(#ff0000);
  }

  //--------------------------------------------------------------
  void ofAppsetRingToMesh(Mesh face_target, Mesh frame_target, PVector location, float radius, float height, color face_color, color frame_color) {
    face.clear();
    frame.clear();

    for (int deg = 0; deg < 360; deg += 10) {
      ArrayList<PVector> vertices = new ArrayList();
      vertices.add(new PVector(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector(radius * cos((deg + 10) * DEG_TO_RAD), radius * sin((deg + 10) * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector(radius * cos((deg + 10) * DEG_TO_RAD), radius * sin((deg + 10) * DEG_TO_RAD), height * 0.5));
      vertices.add(new PVector(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD), height * 0.5));

      for (PVector vertex : vertices) {
        float noise_value_x = openFrameworks.ofNoise(
          location.x, radius * 0.0008 + frameCount * 0.005);
        float noise_value_y = openFrameworks.ofNoise(
          location.y, radius * 0.0008 + frameCount * 0.005);
        float noise_value_z = openFrameworks.ofNoise(
          location.z, radius * 0.0008 + frameCount * 0.005);

        //auto rotation_x = glmrotate(glmmat4(), ofMap(noise_value_x, 0, 1, -PI * 2.5, PI * 2.5)::, glmvec3(1, 0, 0));
        //auto rotation_y = glmrotate(glmmat4(), ofMap(noise_value_y, 0, 1, -PI * 2.5, PI * 2.5)::, glmvec3(0, 1, 0));
        //auto rotation_z = glmrotate(glmmat4(), ofMap(noise_value_z, 0, 1, -PI * 2.5, PI * 2.5)::, glmvec3(0, 0, 1));
        PMatrix3D rotation_x = new PMatrix3D();
        rotation_x.reset();
        rotation_x.rotateX(map(noise_value_x, 0, 1, -PI * 2.5, PI * 2.5));
        PMatrix3D rotation_y = new PMatrix3D();
        rotation_y.reset();
        rotation_y.rotateY(map(noise_value_y, 0, 1, -PI * 2.5, PI * 2.5));
        PMatrix3D rotation_z = new PMatrix3D();
        rotation_z.reset();
        rotation_z.rotateY(map(noise_value_z, 0, 1, -PI * 2.5, PI * 2.5));


        //::      vertex = glmvec4(vertex, 0):: * rotation_y * rotation_x + glmvec4(location, 0);
        rotation_y.mult(vertex, vertex);
        rotation_x.mult(vertex, vertex);
        vertex.add(location);
      }

      int face_index = face_target.getNumVertices();
      face_target.addVertices(vertices);

      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 1);
      face_target.addIndex(face_index + 2);
      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 2);
      face_target.addIndex(face_index + 3);

      int frame_index = frame_target.getNumVertices();
      frame_target.addVertices(vertices);

      frame_target.addIndex(frame_index + 0);
      frame_target.addIndex(frame_index + 1);
      frame_target.addIndex(frame_index + 2);
      frame_target.addIndex(frame_index + 3);

      for (int i = 0; i < vertices.size(); i++) {
        face_target.addColor(face_color);
        frame_target.addColor(frame_color);
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
