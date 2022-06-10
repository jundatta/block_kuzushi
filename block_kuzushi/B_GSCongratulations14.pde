// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Luis Ruizさん
// 【作品名】Green Brain99099
// https://openprocessing.org/sketch/971685
//

class GameSceneCongratulations14 extends GameSceneCongratulationsBase {
  // update 20191014 tie node addition to frameRate

  Node rootNode;
  int depth;

  final ArrayList<Node> nodes = new ArrayList<Node>();
  final float rt3 = sqrt(3);

  @Override void setup() {
    colorMode(RGB, 255);
    background(0);

    rootNode = new Node(0, 0, 0, 1);
    nodes.add(rootNode);
    rootNode.addChildren(6);
  }
  @Override void draw() {
    if (1000 < nodes.size()) {
      nodes.clear();
      rootNode = new Node(0, 0, 0, 1);
      nodes.add(rootNode);
      rootNode.addChildren(6);
    }
    background(0);
    push();
    translate(width / 2, height / 2, 500);
    rotateY(frameCount*.004);
    if (frameCount % 180 == 60) rootNode.stimulate();
    rootNode.draw();
    pop();

    translate(0, +60, 0);
    logo(color(255, 0, 0));
  }

  class Node {
    PVector pos;
    int depth;
    int born;
    int lastStimulation;
    ArrayList<Node> children;

    Node(float x, float y, float z, int depth) {
      this.pos = new PVector(x, y, z);
      this.depth = depth;
      this.born = frameCount;
      this.lastStimulation = frameCount;

      this.children = new ArrayList<Node>();
    }

    PVector[] coordsArray = new PVector[]{
      new PVector(1, 0, 0),
      new PVector(1 / 2.0, rt3 / 2, 0),
      new PVector(-1 / 2.0, rt3 / 2, 0),
      new PVector(-1, 0, 0),
      new PVector(-1 / 2.0, -rt3 / 2, 0),
      new PVector(1 / 2.0, -rt3 / 2, 0),
      new PVector(0, 0, 1),
      new PVector(0, 0, -1),
    };
    void addChildren(int n) {
      for (int i = 0; i < n; i++) {
        //const coords = random([[1, 0, 0],
        //  [1 / 2, rt3 / 2, 0],
        //  [-1 / 2, rt3 / 2, 0],
        //  [-1, 0, 0],
        //  [-1 / 2, -rt3 / 2, 0],
        //  [1 / 2, -rt3 / 2, 0],
        //  [0, 0, 1],
        //  [0, 0, -1]]),
        final PVector coords = coordsArray[(int)random(coordsArray.length)];
        float x = this.pos.x + 50 * coords.x;
        float y = this.pos.y + 50 * coords.y;
        float z = this.pos.z + 50 * coords.z;

        //if (nodes.some(node => Math.pow(node.pos.x - x, 2) + Math.pow(node.pos.y - y, 2) + Math.pow(node.pos.z - z, 2) < 1)) continue;
        int ii;
        for (ii = 0; ii < nodes.size(); ii++) {
          Node node = nodes.get(ii);
          if (pow(node.pos.x - x, 2) + pow(node.pos.y - y, 2) + pow(node.pos.z - z, 2) < 1) {
            break;
          }
        }
        if (ii < nodes.size()) {
          continue;
        }

        final Node child = new Node(x, y, z, this.depth + 1);
        this.children.add(child);
        nodes.add(child);
      }
    }

    void stimulate() {
      this.lastStimulation = frameCount;
      if (random(1) < 0.5) this.addChildren(1);
    }

    void draw() {
      push();
      final int q = frameCount - this.born;
      stroke(0, q < 50 ? 200 * q / 50: 200, 0);

      final int t = frameCount - this.lastStimulation;
      if (t == 10) {
        //      for (const child of this.children) child.stimulate();
        for (Node child : children) child.stimulate();
      }

      //    for (const child of this.children) {
      for (Node child : children) {
        push();
        strokeWeight(5);
        stroke(0, 100, 0);
        line(this.pos.x, this.pos.y, this.pos.z, child.pos.x, child.pos.y, child.pos.z);
        pop();

        if (t < 10) {
          push();
          strokeWeight(1);
          fill(50, 255, 0);
          translate(this.pos.x + (child.pos.x - this.pos.x) * t / 10, this.pos.y + (child.pos.y - this.pos.y) * t / 10, this.pos.z + (child.pos.z - this.pos.z) * t / 10);
          box(1.5);
          pop();
        }

        child.draw();
      }

      fill(t < 30 ? (int)(255 * pow(1.1, -t)) : 0);
      translate(this.pos.x, this.pos.y, this.pos.z);
      strokeWeight(3);
      box(15);
      pop();
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
