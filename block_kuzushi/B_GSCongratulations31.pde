// コングラチュレーション画面 //<>// //<>//
//
// こちらがオリジナルです。
// 【作者】ArtMouserさん
// 【作品名】Rock Pool V0.02
// https://openprocessing.org/sketch/1208299
//

import java.util.Comparator;
import java.util.Collections;

class GameSceneCongratulations31 extends GameSceneCongratulationsBase {

  Vertex edge_centre(Halfedge inhalfedge) {
    Vertex edgecentre = new Vertex();
    edgecentre.x = inhalfedge.edge.va.x - (inhalfedge.edge.va.x - inhalfedge.edge.vb.x) / 2.0f;
    edgecentre.y = inhalfedge.edge.va.y - (inhalfedge.edge.va.y - inhalfedge.edge.vb.y) / 2.0f;
    return edgecentre;
  }

  Vertex vertex_scale(Vertex a, Site b, float inscale) {
    Vertex scaledVertex = new Vertex();
    float pdist = dist2D(a.x, a.y, b.x, b.y)/offset;
    scaledVertex.x = a.x - (a.x - b.x) / pdist;
    scaledVertex.y = a.y - (a.y - b.y) / pdist;
    return scaledVertex;
  }

  float dist2D(float ix, float iy, float fx, float fy) {
    float X = (ix - fx);
    float Y = (iy - fy);
    return sqrt(X*X+Y*Y);
  }

  ArrayList<Site> setRandoms(float w, float h, float randomMinimumDist, int rnum) {
    ArrayList<Site> ran = new ArrayList();
    for (int i = 0; i < rnum; i++) {
      boolean flag;
      float nX = random_between(0, w);
      float nY = random_between(0, h);
      int triesLimit = 500;
      int tries = 0;
      if (randomMinimumDist > 0) {
        do {
          flag = false;
          nX = random_between(0, w);
          nY = random_between(0, h);
          for (int j = 0; j < ran.size(); j++) {
            if (dist2D(nX, nY, ran.get(j).x, ran.get(j).y) < randomMinimumDist) {
              flag = true;
            }
          }
          tries++;
        } while (flag == true && tries <= triesLimit);
      }
      ran.add(new Site(nX, nY));
    }
    return ran;
  }

  void castVoronoi(int i, PGraphics pg) {
    for (int j = 0; j < vcells.get(i).halfedges.size(); j++) {
      if (dist2D(vcells.get(i).halfedges.get(j).edge.va.x, vcells.get(i).halfedges.get(j).edge.va.y, vcells.get(i).halfedges.get(j).edge.vb.x, vcells.get(i).halfedges.get(j).edge.vb.y) < canvasSize/20.0f) {
        continue;
      }
      if (dist2D(vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size()).edge.va.x, vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size()).edge.va.y, vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size()).edge.vb.x, vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size()).edge.vb.y) > canvasSize/20.0f) {
        pg.vertex(vertex_scale(edge_centre(vcells.get(i).halfedges.get(j)), cursite, cellscale).x, vertex_scale(edge_centre(vcells.get(i).halfedges.get(j)), cursite, cellscale).y * cor);
        pg.quadraticVertex(vertex_scale(curvert.get(j), cursite, cellscale).x, vertex_scale(curvert.get(j), cursite, cellscale).y * cor, vertex_scale(edge_centre(vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size())), cursite, cellscale).x, vertex_scale(edge_centre(vcells.get(i).halfedges.get((j+1)%vcells.get(i).halfedges.size())), cursite, cellscale).y * cor);
      } else {
        int nskip = 0;
        while (dist2D(vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size()).edge.va.x, vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size()).edge.va.y, vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size()).edge.vb.x, vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size()).edge.vb.y) <= canvasSize/20.0f) {
          nskip += 1;
        }
        pg.vertex(vertex_scale(edge_centre(vcells.get(i).halfedges.get(j)), cursite, cellscale).x, vertex_scale(edge_centre(vcells.get(i).halfedges.get(j)), cursite, cellscale).y * cor);
        pg.quadraticVertex(vertex_scale(curvert.get((j+nskip)%vcells.get(i).halfedges.size()), cursite, cellscale).x, vertex_scale(curvert.get((j+nskip)%vcells.get(i).halfedges.size()), cursite, cellscale).y * cor, vertex_scale(edge_centre(vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size())), cursite, cellscale).x, vertex_scale(edge_centre(vcells.get(i).halfedges.get((j+nskip+1)%vcells.get(i).halfedges.size())), cursite, cellscale).y * cor);
      }
    }
  }

  void castVertexes(int i) {
    Vertex check = new Vertex(
      vcells.get(i).halfedges.get(vcells.get(i).halfedges.size() - 1).edge.va.x,
      vcells.get(i).halfedges.get(vcells.get(i).halfedges.size() - 1).edge.vb.x);
    cursite = vcells.get(i).site;
    curvert = new ArrayList();
    for (int j = 0; j < vcells.get(i).halfedges.size(); j++) {
      vert = new Vertex();
      if (vcells.get(i).halfedges.get(j).edge.va.x != check.x && vcells.get(i).halfedges.get(j).edge.va.x != check.y) {
        check.x = vcells.get(i).halfedges.get(j).edge.va.x;
        check.y = vcells.get(i).halfedges.get(j).edge.va.y;
        vert.x = vcells.get(i).halfedges.get(j).edge.va.x;
        vert.y = vcells.get(i).halfedges.get(j).edge.va.y;
      } else {
        check.x = vcells.get(i).halfedges.get(j).edge.vb.x;
        check.y = vcells.get(i).halfedges.get(j).edge.vb.y;
        vert.x = vcells.get(i).halfedges.get(j).edge.vb.x;
        vert.y = vcells.get(i).halfedges.get(j).edge.vb.y;
      }
      curvert.add(vert);
    }
  }

  void frame(PGraphics pg) {
    //  erase();
    pg.beginShape();
    pg.noStroke();
    pg.vertex(0, 0);
    pg.vertex(canvasSize, 0);
    pg.vertex(canvasSize, canvasSize);
    pg.vertex(0, canvasSize);
    pg.beginContour();
    pg.vertex(canvasSize/2.0f, canvasSize/100.0f);
    pg.quadraticVertex(framecor, framecor, canvasSize/100.0f, canvasSize/2.0f);
    pg.quadraticVertex(framecor, canvasSize - framecor, canvasSize/2.0f, canvasSize-canvasSize/100.0f);
    pg.quadraticVertex(canvasSize - framecor, canvasSize - framecor, canvasSize-canvasSize/100.0f, canvasSize/2.0f);
    pg.quadraticVertex(canvasSize - framecor, framecor, canvasSize/2.0f, canvasSize/100.0f);
    pg.endContour();
    pg.endShape(CLOSE);
    //  noErase();
  }

  // FixedRandom fR = null;

  float random_between(float min, float max) {
    return random(min, max);

    //float r = fR.loadRandom();
    //return min + (max - min) * r;
  }

  float canvasSize = 800.0f;
  float canvOffset;
  float fieldSize;
  float cor;
  float framecor;

  int numcells;
  float vertexMinimumDist;
  float offset;

  Voronoi voronoi;
  BBox bbox;
  ArrayList<Site> sites;
  float coloption;


  Diagram diagram;
  ArrayList<Edge> vedges;
  ArrayList<Cell> vcells;
  Site cursite;
  ArrayList<Vertex> curvert;
  Vertex vert;
  Vertex check;
  float cellscale;
  PImage sky;
  PImage bottom;
  float t1;
  float t2;
  float coloffset;

  float pninc;
  float vinc;
  float vscale;
  int vcols, vrows;
  float zoff;
  FloatList speedcoef;
  float fishgroups;
  FloatList fishcount;
  FloatList delay;
  FloatList sinlen;
  FloatList sinadd;
  FloatList magnit;
  FloatList groupCoef;
  FloatList groupColor;
  FloatList pnvalue;
  ArrayList<PVector> v;
  IntList c;
  FloatList shadow;

  ArrayList<ArrayList<Particle>> particles;
  ArrayList<ArrayList<PVector>> flowfield;

  void initialize() {
    canvOffset = canvasSize/10.0f;
    fieldSize = canvasSize + canvOffset * 2;
    cor = canvasSize / (canvasSize + canvasSize/2.0f);
    framecor = canvasSize/100.0f;

    numcells = 50;
    vertexMinimumDist = canvasSize / 15.0f;
    offset = canvasSize / 80.0f;

    voronoi = new Voronoi();
    bbox = new BBox(0, canvasSize, 0, canvasSize + canvasSize/2.0f);
    sites = setRandoms(canvasSize, canvasSize + canvasSize/2.0f, vertexMinimumDist, numcells);
    coloption = random_between(0, 50) - 30;


    diagram = voronoi.compute(sites, bbox);
    vedges = diagram.edges;
    vcells = diagram.cells;
    cellscale = 0.8;
    coloffset = 0.9;

    pninc = 0.05;
    vinc = 0.0003;
    vscale = 25;
    zoff = 0;
    speedcoef = new FloatList();
    fishgroups = random_between(1, 4);
    fishcount = new FloatList();
    delay = new FloatList();
    sinlen = new FloatList();
    sinadd = new FloatList();
    magnit = new FloatList();
    groupCoef = new FloatList();
    groupColor = new FloatList();
    pnvalue = new FloatList();
    v = new ArrayList();
    c = new IntList();
    shadow = new FloatList();

    particles = new ArrayList();
    flowfield = new ArrayList();
  }

  @Override void setup() {
    // P3Dを指定するとquadraticVertex()で吹っ飛ぶのでP3Dなしのオフスクリーンに描画した
    // pg自体は使わない。描画結果は捨てる
    PGraphics pg = createGraphics((int)canvasSize, (int)canvasSize);
    pg.beginDraw();

    initialize();

    for (int g = 0; g < fishgroups; g++) {
      fishcount.append(random_between(80 / fishgroups, 200 / fishgroups));
      sinlen.append(random_between(500, 1000));
      sinadd.append(random_between(1.5, 2));
      magnit.append(random_between(1, 1.8));
      //magnit.append(random_between(1, 1.2f + (g * 0.3f)));
      groupCoef.append(random_between(0.8, 1.2) + g / fishgroups / 2.0f);
      groupColor.append(random_between(0, 1));
      delay.append(g * 1000);
      particles.add(new ArrayList());
      speedcoef.append(0);
      shadow.append(canvasSize/60.0f * groupCoef.get(g));
    }

    groupCoef.sort();
    shadow.sort();

    colorMode(HSB, 360, 100, 100);
    color c1 = color(186 + coloption, 90, 59);
    color c2 = color(224 + coloption, 100, 19);
    colorMode(RGB, 255, 255, 255);

    color c3 = color(160);
    color c4 = color(0);

    PImage img2 = createImage((int)canvasSize, (int)canvasSize, RGB);
    for (int i = 0; i < canvasSize; i++) {
      for (int j = 0; j < canvasSize; j++) {
        color col = color(red(c3) + (red(c4) - red(c3))*j/canvasSize);
        img2.set(i, j, col);
      }
    }
    pg.image(img2, 0, 0);

    pg.fill(c4);
    offset = canvasSize / 30.0f;
    for (int i = 0; i < vcells.size(); i++) {
      castVertexes(i);
      pg.beginShape();
      castVoronoi(i, pg);
      pg.endShape(CLOSE);
    }
    sky = pg.get();
    sky.filter(BLUR, 10);

    PImage img1 = createImage((int)canvasSize, (int)canvasSize, RGB);
    for (int i = 0; i < (int)canvasSize; i++) {
      for (int j = 0; j < (int)canvasSize; j++) {
        color col;
        if (j < canvasSize * coloffset) {
          col = color(red(c1) + (red(c2) - red(c1))*j/canvasSize/coloffset,
            green(c1) + (green(c2) - green(c1))*j/canvasSize/coloffset,
            blue(c1) + (blue(c2) - blue(c1))*j/canvasSize/coloffset);
        } else {
          col = color(c2);
        }
        img1.set(i, j, col);
      }
    }
    pg.image(img1, 0, 0);

    pg.fill(c2);
    offset = canvasSize / 80.0f;
    pg.noStroke();
    pg.beginShape();
    pg.vertex(0, 0);
    pg.vertex(canvasSize, 0);
    pg.vertex(canvasSize, canvasSize);
    pg.vertex(0, canvasSize);
    for (int i = 0; i < vedges.size(); i++) {
      pg.line(vedges.get(i).va.x, vedges.get(i).va.y, vedges.get(i).vb.x, vedges.get(i).vb.y);
    }

    for (int i = 0; i < vcells.size(); i++) {
      castVertexes(i);
      pg.beginContour();
      castVoronoi(i, pg);
      pg.endContour();
    }
    pg.endShape(CLOSE);
    bottom = pg.get();

    colorMode(HSB, 360, 100, 100);
    color fc1 = color(206 + coloption, 27, 82);
    color fc2 = color(200 + coloption, 70, 65);
    colorMode(RGB, 255, 255, 255);
    vcols = floor(fieldSize / vscale);
    vrows = floor(fieldSize / vscale);
    for (int g = 0; g < fishgroups; g++) {
      ArrayList<PVector> ffElement = new ArrayList();
      for (int i = 0; i < vcols * vrows; i++) {
        ffElement.add(new PVector(0, 0));
      }
      flowfield.add(g, ffElement);
      c.append(color((((red(fc2) - red(fc1)) * groupColor.get(g) + red(fc1)) - red(c2)) * (groupCoef.get(g) - 0.3) + red(c2),
        (((green(fc2) - green(fc1)) * groupColor.get(g) + green(fc1)) - green(c2)) * (groupCoef.get(g) - 0.3) + green(c2),
        (((blue(fc2) - blue(fc1)) * groupColor.get(g) + blue(fc1)) - blue(c2)) * (groupCoef.get(g) - 0.3) + blue(c2)));
      for (int i = 0; i < fishcount.get(g); i++) {
        particles.get(g).add(new Particle());
        pnvalue.append(0);
        v.add(new PVector(0, 0));
      }
    }

    pg.endDraw();

    gPg = createGraphics((int)canvasSize, (int)canvasSize);
  }

  PGraphics gPg;
  void drawRockPool(PGraphics pg) {
    pg.beginDraw();

    pg.fill(#46b3e6);

    push();
    colorMode(HSB, 360, 100, 100);
    color c2 = color(224 + coloption, 100, 19);
    colorMode(RGB, 255, 255, 255);
    pop();
    t1 = 200 + ((float)Math.sin(millis()/8000.0f) + 1) * 200;
    t2 = 200 + ((float)Math.sin(millis()/1000.0f) + 1) * 10;
    pg.blendMode(BLEND);
    pg.image(bottom, 0, 0);

    noiseDetail(4, 0.2);
    for (int g = 0; g < fishgroups; g++) {
      float s = (noise((millis()/500)+ delay.get(g)) + 0.2) * 3 * ((float)Math.sin((millis()+delay.get(g))/sinlen.get(g))+sinadd.get(g));
      speedcoef.set(g, s);
    }
    noiseSeed(0);
    float yoff = 0;
    for (int y = 0; y < vrows; y++) {
      float xoff = 0;
      for (int x = 0; x < vcols; x++) {
        int index = x + y * vcols;
        for (int g = 0; g < fishgroups; g++) {
          float value = noise(xoff + delay.get(g), yoff + delay.get(g), zoff + delay.get(g)) * TWO_PI * 4;
          pnvalue.set(g, value);
          PVector vector = PVector.fromAngle(pnvalue.get(g));
          vector.setMag(magnit.get(g));
          v.set(g, vector);
          flowfield.get(g).set(index, vector);
        }
        xoff += pninc;
      }
      yoff += pninc;
      zoff += vinc;
    }

    for (int g = 0; g < fishgroups; g++) {
      for (int i = 0; i < particles.get(g).size(); i++) {
        pg.strokeWeight(canvasSize/200.0f * groupCoef.get(g));
        particles.get(g).get(i).follow(flowfield.get(g), i * 2);
        particles.get(g).get(i).update(speedcoef.get(g));
        particles.get(g).get(i).castShadow(pg, groupCoef.get(g), shadow.get(g), c2);
        particles.get(g).get(i).edges();
      }
    }

    for (int g = 0; g < fishgroups; g++) {
      for (int i = 0; i < particles.get(g).size(); i++) {
        pg.strokeWeight(canvasSize/200.0f * groupCoef.get(g));
        particles.get(g).get(i).show(pg, groupCoef.get(g), c.get(g));
      }
    }

    pg.push();
    pg.rotate(radians(-45));
    pg.scale(2.5, 0.5);
    pg.blendMode(SCREEN);
    pg.image(sky, -t1, t2);
    pg.pop();
    frame(pg);

    pg.endDraw();
  }

  @Override void draw() {
    imageMode(CORNER);

    drawRockPool(gPg);
    image(gPg, 0, 0, 500, height);

    logo(color(255, 0, 0));
  }

  class BBox {
    float xl;
    float xr;
    float yt;
    float yb;
    BBox(float left, float right, float top, float bottom) {
      xl = left;
      xr = right;
      yt = top;
      yb = bottom;
    }
  }

  class Beachsection extends RBTree {
    CircleEvent circleEvent;
    Edge edge;
  }

  // ---------------------------------------------------------------------------
  // Cell methods

  class Cell {
    Site site;
    ArrayList<Halfedge> halfedges;
    boolean closeMe;
    Cell(Site site) {
      this.site = site;
      this.halfedges = new ArrayList();
      this.closeMe = false;
    }

    Cell init(Site site) {
      this.site = site;
      this.halfedges = new ArrayList();
      this.closeMe = false;
      return this;
    }

    int prepareHalfedges() {
      ArrayList<Halfedge> halfedges = this.halfedges;
      int iHalfedge = halfedges.size();
      Edge edge;
      // get rid of unused halfedges
      // rhill 2011-05-27: Keep it simple, no point here in trying
      // to be fancy: dangling edges are a typically a minority.
      while (iHalfedge-- != 0) {
        edge = halfedges.get(iHalfedge).edge;
        if (edge.vb == null || edge.va == null) {
          halfedges.remove(iHalfedge);
        }
      }

      // rhill 2011-05-26: I tried to use a binary search at insertion
      // time to keep the array sorted on-the-fly (in Cell.addHalfedge()).
      // There was no real benefits in doing so, performance on
      // Firefox 3.6 was improved marginally, while performance on
      // Opera 11 was penalized marginally.
      Collections.sort(halfedges, new HalfedgeComparator());
      return halfedges.size();
    }

    public class HalfedgeComparator implements Comparator<Halfedge> {
      @Override public int compare(Halfedge a, Halfedge b) {
        float angle = b.angle-a.angle;
        if (angle < 0) {
          return -1;
        }
        if (0 < angle) {
          return 1;
        }
        return 0;
      }
    }
  }

  class CircleEvent extends RBTree {
    Beachsection arc;
    float x;
    float y;
    float ycenter;

    CircleEvent() {
      // rhill 2013-10-12: it helps to state exactly what we are at ctor time.
      this.arc = null;
      this.rbLeft = null;
      this.rbNext = null;
      this.rbParent = null;
      this.rbPrevious = null;
      this.rbRed = false;
      this.rbRight = null;
      this.site = null;
      this.x = this.y = this.ycenter = 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Diagram methods

  class Diagram {
    ArrayList<Cell> cells = null;
    ArrayList<Edge> edges = null;
    ArrayList<Vertex> vertices;
    Site site = null;
    Diagram() {
    }
    Diagram(Site site) {
      this.site = site;
    };
  }

  class Edge {
    Site lSite;
    Site rSite;
    Vertex va;
    Vertex vb;
    Edge(Site lSite, Site rSite) {
      this.lSite = lSite;
      this.rSite = rSite;
      this.va = this.vb = null;
    }
  }

  class Halfedge {
    float angle;
    Edge edge;
    Site site;
    Halfedge(Edge edge, Site lSite, Site rSite) {
      this.site = lSite;
      this.edge = edge;
      // 'angle' is a value to be used for properly sorting the
      // halfsegments counterclockwise. By convention, we will
      // use the angle of the line defined by the 'site to the left'
      // to the 'site to the right'.
      // However, border edges have no 'site to the right': thus we
      // use the angle of line perpendicular to the halfsegment (the
      // edge should have both end points defined in such case.)
      if (rSite != null) {
        this.angle = atan2(rSite.y-lSite.y, rSite.x-lSite.x);
      } else {
        Vertex va = edge.va;
        Vertex vb = edge.vb;
        // rhill 2011-05-31: used to call getStartpoint()/getEndpoint(),
        // but for performance purpose, these are expanded in place here.
        this.angle = edge.lSite == lSite ?
          atan2(vb.x-va.x, va.y-vb.y) :
          atan2(va.x-vb.x, vb.y-va.y);
      }
    }

    Vertex getStartpoint() {
      return this.edge.lSite == this.site ? this.edge.va : this.edge.vb;
    }

    Vertex getEndpoint() {
      return this.edge.lSite == this.site ? this.edge.vb : this.edge.va;
    }
  }

  class Particle {
    PVector pos = new PVector(random(canvasSize), random(canvasSize));
    PVector privpos = new PVector(0, 0);
    PVector vel = new PVector(0, 0);
    PVector acc = new PVector(0, 0);
    float maxspeed = canvasSize / 400.0f;
    PVector body = new PVector(0, 0);
    PVector bodyl = new PVector(0, 0);
    PVector bodyr = new PVector(0, 0);

    void update(float speedcoef) {
      this.vel.add(this.acc);
      this.vel.limit(this.maxspeed * speedcoef);
      this.pos.add(this.vel);
      this.acc.mult(0);
    }

    void applyForce(PVector force, float vcoef) {
      this.acc.add(force);
      this.acc.rotate(radians(vcoef));
    }

    void show(PGraphics pg, float sizecoef, color bcolor) {
      this.body.mult(0);
      this.body.add(new PVector(this.privpos.x - this.pos.x, this.privpos.y - this.pos.y));
      this.bodyl.mult(0);
      this.bodyr.mult(0);
      this.body.normalize();
      this.bodyl.add(this.body);
      this.bodyl.rotate(radians(90));
      this.bodyr.add(this.body);
      this.bodyr.rotate(radians(-90));
      this.body.mult(canvasSize/80.0f * sizecoef);
      this.bodyl.mult(canvasSize/400.0f * sizecoef);
      this.bodyr.mult(canvasSize/400.0f * sizecoef);
      pg.stroke(bcolor);
      pg.push();
      pg.strokeWeight(canvasSize/300.0f * sizecoef);
      pg.translate(this.pos.x, this.pos.y);
      pg.line(this.bodyl.x, this.bodyl.y, this.body.x, this.body.y);
      pg.line(this.bodyr.x, this.bodyr.y, this.body.x, this.body.y);
      pg.pop();
      pg.push();
      pg.fill(bcolor);
      pg.circle(this.pos.x, this.pos.y, canvasSize/400.0f * sizecoef);
      pg.pop();
    }

    void castShadow(PGraphics pg, float sizecoef, float slen, color scolor) {
      float corx = 0;
      float cory = 0;
      if (this.pos.x + slen > fieldSize - canvOffset) corx = -fieldSize;
      if (this.pos.y + slen > fieldSize - canvOffset) cory = -fieldSize;
      pg.stroke(scolor);
      pg.push();
      pg.strokeWeight(canvasSize/300.0f * sizecoef);
      pg.translate(this.pos.x, this.pos.y);
      pg.line(this.bodyl.x + slen + corx, this.bodyl.y + slen + cory, this.body.x + slen + corx, this.body.y + slen + cory);
      pg.line(this.bodyr.x + slen + corx, this.bodyr.y + slen + cory, this.body.x + slen + corx, this.body.y + slen + cory);
      pg.pop();
      pg.push();
      pg.fill(scolor);
      pg.circle(this.pos.x + slen + corx, this.pos.y + slen + cory, canvasSize/400.0f);
      pg.pop();
    }

    void edges() {
      if (this.pos.x > fieldSize - canvOffset) this.pos.x = -canvOffset;
      if (this.pos.x < -canvOffset) this.pos.x = fieldSize -canvOffset;
      if (this.pos.y > fieldSize - canvOffset) this.pos.y = -canvOffset;
      if (this.pos.y < -canvOffset) this.pos.y = fieldSize -canvOffset;
    }

    void follow(ArrayList<PVector> vectors, float vcoef) {
      float x = floor((this.pos.x + canvOffset) / vscale);
      if (vcols <= x) {
        x = vcols - 1;
      }
      float y = floor((this.pos.y + canvOffset) / vscale);
      if (vrows <= y) {
        y = vrows - 1;
      }
      int index = int(x + y * vcols);
      this.privpos.mult(0);
      this.privpos.add(this.pos);
      PVector force = vectors.get(index);
      this.applyForce(force, vcoef);
    }
  }

  // ---------------------------------------------------------------------------
  // Red-Black tree code (based on C version of "rbtree" by Franck Bui-Huu
  // https://github.com/fbuihuu/libtree/blob/master/rb.c

  class RBTree {
    RBTree root;
    RBTree rbLeft;
    RBTree rbRight;
    RBTree rbNext;
    RBTree rbParent;
    RBTree rbPrevious;
    boolean rbRed;
    Site site;
    RBTree() {
      this.root = null;
      this.rbLeft = null;
      this.rbRight = null;
      this.rbNext = null;
      this.rbParent = null;
      this.rbPrevious = null;
      this.rbRed = false;
      this.site = null;
    }

    void rbInsertSuccessor(RBTree node, RBTree successor) {
      RBTree parent;
      if (node != null) {
        // >>> rhill 2011-05-27: Performance: cache previous/next nodes
        successor.rbPrevious = node;
        successor.rbNext = node.rbNext;
        if (node.rbNext != null) {
          node.rbNext.rbPrevious = successor;
        }
        node.rbNext = successor;
        // <<<
        if (node.rbRight != null) {
          // in-place expansion of node.rbRight.getFirst();
          node = node.rbRight;
          while (node.rbLeft != null) {
            node = node.rbLeft;
          }
          node.rbLeft = successor;
        } else {
          node.rbRight = successor;
        }
        parent = node;
      }
      // rhill 2011-06-07: if node is null, successor must be inserted
      // to the left-most part of the tree
      else if (this.root != null) {
        node = this.getFirst(this.root);
        // >>> Performance: cache previous/next nodes
        successor.rbPrevious = null;
        successor.rbNext = node;
        node.rbPrevious = successor;
        // <<<
        node.rbLeft = successor;
        parent = node;
      } else {
        // >>> Performance: cache previous/next nodes
        successor.rbPrevious = successor.rbNext = null;
        // <<<
        this.root = successor;
        parent = null;
      }
      successor.rbLeft = successor.rbRight = null;
      successor.rbParent = parent;
      successor.rbRed = true;
      // Fixup the modified tree by recoloring nodes and performing
      // rotations (2 at most) hence the red-black tree properties are
      // preserved.
      RBTree grandpa, uncle;
      node = successor;
      while (parent != null && parent.rbRed) {
        grandpa = parent.rbParent;
        if (parent == grandpa.rbLeft) {
          uncle = grandpa.rbRight;
          if (uncle != null && uncle.rbRed) {
            parent.rbRed = uncle.rbRed = false;
            grandpa.rbRed = true;
            node = grandpa;
          } else {
            if (node == parent.rbRight) {
              this.rbRotateLeft(parent);
              node = parent;
              parent = node.rbParent;
            }
            parent.rbRed = false;
            grandpa.rbRed = true;
            this.rbRotateRight(grandpa);
          }
        } else {
          uncle = grandpa.rbLeft;
          if (uncle != null && uncle.rbRed) {
            parent.rbRed = uncle.rbRed = false;
            grandpa.rbRed = true;
            node = grandpa;
          } else {
            if (node == parent.rbLeft) {
              this.rbRotateRight(parent);
              node = parent;
              parent = node.rbParent;
            }
            parent.rbRed = false;
            grandpa.rbRed = true;
            this.rbRotateLeft(grandpa);
          }
        }
        parent = node.rbParent;
      }
      this.root.rbRed = false;
    }

    void rbRemoveNode(RBTree node) {
      // >>> rhill 2011-05-27: Performance: cache previous/next nodes
      if (node.rbNext != null) {
        node.rbNext.rbPrevious = node.rbPrevious;
      }
      if (node.rbPrevious != null) {
        node.rbPrevious.rbNext = node.rbNext;
      }
      node.rbNext = node.rbPrevious = null;
      // <<<
      RBTree parent = node.rbParent,
        left = node.rbLeft,
        right = node.rbRight,
        next;
      if (left == null) {
        next = right;
      } else if (right == null) {
        next = left;
      } else {
        next = this.getFirst(right);
      }
      if (parent != null) {
        if (parent.rbLeft == node) {
          parent.rbLeft = next;
        } else {
          parent.rbRight = next;
        }
      } else {
        this.root = next;
      }
      // enforce red-black rules
      boolean isRed;
      if (left != null && right != null) {
        isRed = next.rbRed;
        next.rbRed = node.rbRed;
        next.rbLeft = left;
        left.rbParent = next;
        if (next != right) {
          parent = next.rbParent;
          next.rbParent = node.rbParent;
          node = next.rbRight;
          parent.rbLeft = node;
          next.rbRight = right;
          right.rbParent = next;
        } else {
          next.rbParent = parent;
          parent = next;
          node = next.rbRight;
        }
      } else {
        isRed = node.rbRed;
        node = next;
      }
      // 'node' is now the sole successor's child and 'parent' its
      // new parent (since the successor can have been moved)
      if (node != null) {
        node.rbParent = parent;
      }
      // the 'easy' cases
      if (isRed) {
        return;
      }
      if (node != null && node.rbRed) {
        node.rbRed = false;
        return;
      }
      // the other cases
      RBTree sibling;
      do {
        if (node == this.root) {
          break;
        }
        if (node == parent.rbLeft) {
          sibling = parent.rbRight;
          if (sibling.rbRed) {
            sibling.rbRed = false;
            parent.rbRed = true;
            this.rbRotateLeft(parent);
            sibling = parent.rbRight;
          }
          if ((sibling.rbLeft != null && sibling.rbLeft.rbRed)
            || (sibling.rbRight != null && sibling.rbRight.rbRed)) {
            if (sibling.rbRight == null || !sibling.rbRight.rbRed) {
              sibling.rbLeft.rbRed = false;
              sibling.rbRed = true;
              this.rbRotateRight(sibling);
              sibling = parent.rbRight;
            }
            sibling.rbRed = parent.rbRed;
            parent.rbRed = sibling.rbRight.rbRed = false;
            this.rbRotateLeft(parent);
            node = this.root;
            break;
          }
        } else {
          sibling = parent.rbLeft;
          if (sibling.rbRed) {
            sibling.rbRed = false;
            parent.rbRed = true;
            this.rbRotateRight(parent);
            sibling = parent.rbLeft;
          }
          if ((sibling.rbLeft != null && sibling.rbLeft.rbRed)
            || (sibling.rbRight != null && sibling.rbRight.rbRed)) {
            if (sibling.rbLeft == null || !sibling.rbLeft.rbRed) {
              sibling.rbRight.rbRed = false;
              sibling.rbRed = true;
              this.rbRotateLeft(sibling);
              sibling = parent.rbLeft;
            }
            sibling.rbRed = parent.rbRed;
            parent.rbRed = sibling.rbLeft.rbRed = false;
            this.rbRotateRight(parent);
            node = this.root;
            break;
          }
        }
        sibling.rbRed = true;
        node = parent;
        parent = parent.rbParent;
      } while (!node.rbRed);
      if (node != null) {
        node.rbRed = false;
      }
    }

    RBTree getFirst(RBTree node) {
      while (node.rbLeft != null) {
        node = node.rbLeft;
      }
      return node;
    }

    RBTree getLast(RBTree node) {
      while (node.rbRight != null) {
        node = node.rbRight;
      }
      return node;
    };

    void rbRotateLeft(RBTree node) {
      RBTree p = node,
        q = node.rbRight, // can't be null
        parent = p.rbParent;
      if (parent != null) {
        if (parent.rbLeft == p) {
          parent.rbLeft = q;
        } else {
          parent.rbRight = q;
        }
      } else {
        this.root = q;
      }
      q.rbParent = parent;
      p.rbParent = q;
      p.rbRight = q.rbLeft;
      if (p.rbRight != null) {
        p.rbRight.rbParent = p;
      }
      q.rbLeft = p;
    }

    void rbRotateRight(RBTree node) {
      RBTree p = node,
        q = node.rbLeft, // can't be null
        parent = p.rbParent;
      if (parent != null) {
        if (parent.rbLeft == p) {
          parent.rbLeft = q;
        } else {
          parent.rbRight = q;
        }
      } else {
        this.root = q;
      }
      q.rbParent = parent;
      p.rbParent = q;
      p.rbLeft = q.rbRight;
      if (p.rbLeft != null) {
        p.rbLeft.rbParent = p;
      }
      q.rbRight = p;
    }
  }

  class Site {
    int voronoiId = 0;
    float x;
    float y;
    Site(float x, float y) {
      this.x = x;
      this.y = y;
    }
  }

  class Vertex {
    float x;
    float y;
    Vertex() {
    }
    Vertex(float x, float y) {
      this.x = x;
      this.y = y;
    }
  }

  final float FLT_EPSILON = 1.192092896e-07F;

  class Voronoi {
    ArrayList<Vertex> vertices;
    ArrayList<Edge> edges;
    ArrayList<Cell> cells;
    RBTree beachline;
    RBTree circleEvents;
    CircleEvent firstCircleEvent;
    Voronoi() {
      this.vertices = null;
      this.edges = null;
      this.cells = null;
      this.beachline = null;
      this.circleEvents = null;
      this.firstCircleEvent = null;
    }

    void reset() {
      if (this.beachline == null) {
        this.beachline = new RBTree();
      }
      this.beachline.root = null;
      if (this.circleEvents == null) {
        this.circleEvents = new RBTree();
      }
      this.circleEvents.root = this.firstCircleEvent = null;
      this.vertices = new ArrayList();
      this.edges = new ArrayList();
      this.cells = new ArrayList();
    }

    float epsilon = FLT_EPSILON;
    boolean equalWithEpsilon(float a, float b) {
      return abs(a-b)<FLT_EPSILON;
    }
    boolean equalWithEpsilonSegment(float a, float b) {
      return equalWithEpsilon(a, b);
      //    return abs(a-b)<(FLT_EPSILON * 10.0f);
    }
    boolean greaterThanWithEpsilon(float a, float b) {
      return a-b>FLT_EPSILON;
    }
    boolean greaterThanOrEqualWithEpsilon(float a, float b) {
      return b-a<FLT_EPSILON;
    }
    boolean lessThanWithEpsilon(float a, float b) {
      return b-a>FLT_EPSILON;
    }
    boolean lessThanOrEqualWithEpsilon(float a, float b) {
      return a-b<FLT_EPSILON;
    }

    Cell createCell(Site site) {
      return new Cell(site);
    }

    Halfedge createHalfedge(Edge edge, Site lSite, Site rSite) {
      return new Halfedge(edge, lSite, rSite);
    }

    Vertex createVertex(float x, float y) {
      Vertex v = new Vertex(x, y);
      this.vertices.add(v);
      return v;
    }

    Edge createEdge(Site lSite, Site rSite, Vertex va, Vertex vb) {
      Edge edge = new Edge(lSite, rSite);
      this.edges.add(edge);
      if (va != null) {
        this.setEdgeStartpoint(edge, lSite, rSite, va);
      }
      if (vb != null) {
        this.setEdgeEndpoint(edge, lSite, rSite, vb);
      }
      this.cells.get(lSite.voronoiId).halfedges.add(this.createHalfedge(edge, lSite, rSite));
      this.cells.get(rSite.voronoiId).halfedges.add(this.createHalfedge(edge, rSite, lSite));
      return edge;
    }

    Edge createEdge(Site lSite, Site rSite) {
      return createEdge(lSite, rSite, null, null);
    }

    Edge createBorderEdge(Site lSite, Vertex va, Vertex vb) {
      Edge edge = new Edge(lSite, null);
      edge.va = va;
      edge.vb = vb;
      this.edges.add(edge);
      return edge;
    }

    void setEdgeStartpoint(Edge edge, Site lSite, Site rSite, Vertex vertex) {
      if (edge.va == null && edge.vb == null) {
        edge.va = vertex;
        edge.lSite = lSite;
        edge.rSite = rSite;
      } else if (edge.lSite == rSite) {
        edge.vb = vertex;
      } else {
        edge.va = vertex;
      }
    }

    void setEdgeEndpoint(Edge edge, Site lSite, Site rSite, Vertex vertex) {
      this.setEdgeStartpoint(edge, rSite, lSite, vertex);
    }

    Beachsection createBeachsection(Site site) {
      Beachsection beachsection = new Beachsection();
      beachsection.site = site;
      return beachsection;
    }
    float leftBreakPoint(RBTree arc, float directrix) {
      Site site = arc.site;
      float rfocx = site.x;
      float rfocy = site.y;
      float pby2 = rfocy-directrix;
      // parabola in degenerate case where focus is on directrix
      if (pby2 == 0.0f) {
        return rfocx;
      }
      RBTree lArc = arc.rbPrevious;
      if (lArc == null) {
        return Float.NEGATIVE_INFINITY;
      }
      site = lArc.site;
      float lfocx = site.x;
      float lfocy = site.y;
      float plby2 = lfocy-directrix;
      // parabola in degenerate case where focus is on directrix
      if (plby2 == 0.0f) {
        return lfocx;
      }
      float hl = lfocx-rfocx;
      float aby2 = 1/pby2-1/plby2;
      float b = hl/plby2;
      if (aby2 != 0.0f) {
        return (-b+sqrt(b*b-2*aby2*(hl*hl/(-2*plby2)-lfocy+plby2/2+rfocy-pby2/2)))/aby2+rfocx;
      }
      // both parabolas have same distance to directrix, thus break point is midway
      return (rfocx+lfocx)/2.0f;
    }

    float rightBreakPoint(Beachsection arc, float directrix) {
      RBTree rArc = arc.rbNext;
      if (rArc != null) {
        return this.leftBreakPoint(rArc, directrix);
      }
      Site site = arc.site;
      return site.y == directrix ? site.x : Float.POSITIVE_INFINITY;
    }

    void detachBeachsection(Beachsection beachsection) {
      this.detachCircleEvent(beachsection); // detach potentially attached circle event
      this.beachline.rbRemoveNode(beachsection); // remove from RB-tree
    }

    void removeBeachsection(Beachsection beachsection) {
      CircleEvent circle = beachsection.circleEvent;
      float x = circle.x;
      float y = circle.ycenter;
      Vertex vertex = this.createVertex(x, y);
      Beachsection previous = (Beachsection)beachsection.rbPrevious;
      Beachsection next = (Beachsection)beachsection.rbNext;
      ArrayList<Beachsection> disappearingTransitions = new ArrayList();
      disappearingTransitions.add(beachsection);

      // remove collapsed beachsection from beachline
      this.detachBeachsection(beachsection);

      // there could be more than one empty arc at the deletion point, this
      // happens when more than two edges are linked by the same vertex,
      // so we will collect all those edges by looking up both sides of
      // the deletion point.
      // by the way, there is *always* a predecessor/successor to any collapsed
      // beach section, it's just impossible to have a collapsing first/last
      // beach sections on the beachline, since they obviously are unconstrained
      // on their left/right side.

      // look left
      Beachsection lArc = (Beachsection)previous;
      while (lArc.circleEvent != null && abs(x-lArc.circleEvent.x)<FLT_EPSILON && abs(y-lArc.circleEvent.ycenter)<FLT_EPSILON) {
        previous = (Beachsection)lArc.rbPrevious;
        disappearingTransitions.add(0, lArc);
        this.detachBeachsection(lArc); // mark for reuse
        lArc = previous;
      }
      // even though it is not disappearing, I will also add the beach section
      // immediately to the left of the left-most collapsed beach section, for
      // convenience, since we need to refer to it later as this beach section
      // is the 'left' site of an edge for which a start point is set.
      disappearingTransitions.add(0, lArc);
      this.detachCircleEvent(lArc);

      // look right
      Beachsection rArc = next;
      while (rArc.circleEvent != null && abs(x-rArc.circleEvent.x)<FLT_EPSILON && abs(y-rArc.circleEvent.ycenter)<FLT_EPSILON) {
        next = (Beachsection)rArc.rbNext;
        disappearingTransitions.add(rArc);
        this.detachBeachsection(rArc); // mark for reuse
        rArc = next;
      }
      // we also have to add the beach section immediately to the right of the
      // right-most collapsed beach section, since there is also a disappearing
      // transition representing an edge's start point on its left.
      disappearingTransitions.add(rArc);
      this.detachCircleEvent(rArc);

      // walk through all the disappearing transitions between beach sections and
      // set the start point of their (implied) edge.
      int nArcs = disappearingTransitions.size();
      int iArc;
      for (iArc=1; iArc<nArcs; iArc++) {
        rArc = disappearingTransitions.get(iArc);
        lArc = disappearingTransitions.get(iArc-1);
        this.setEdgeStartpoint(rArc.edge, lArc.site, rArc.site, vertex);
      }

      // create a new edge as we have now a new transition between
      // two beach sections which were previously not adjacent.
      // since this edge appears as a new vertex is defined, the vertex
      // actually define an end point of the edge (relative to the site
      // on the left)
      lArc = disappearingTransitions.get(0);
      rArc = disappearingTransitions.get(nArcs-1);
      rArc.edge = this.createEdge(lArc.site, rArc.site, null, vertex);

      // create circle events if any for beach sections left in the beachline
      // adjacent to collapsed sections
      this.attachCircleEvent(lArc);
      this.attachCircleEvent(rArc);
    }

    void addBeachsection(Site site) {
      float x = site.x,
        directrix = site.y;

      // find the left and right beach sections which will surround the newly
      // created beach section.
      // rhill 2011-06-01: This loop is one of the most often executed,
      // hence we expand in-place the comparison-against-epsilon calls.
      Beachsection lArc = null;
      Beachsection rArc = null;
      float dxl, dxr;
      Beachsection node = (Beachsection)this.beachline.root;

      while (node != null) {
        dxl = this.leftBreakPoint(node, directrix)-x;
        // x lessThanWithEpsilon xl => falls somewhere before the left edge of the beachsection
        if (dxl > FLT_EPSILON) {
          // this case should never happen
          // if (!node.rbLeft) {
          //    rArc = node.rbLeft;
          //    break;
          //    }
          node = (Beachsection)node.rbLeft;
        } else {
          dxr = x-this.rightBreakPoint(node, directrix);
          // x greaterThanWithEpsilon xr => falls somewhere after the right edge of the beachsection
          if (dxr > FLT_EPSILON) {
            if (node.rbRight == null) {
              lArc = node;
              break;
            }
            node = (Beachsection)node.rbRight;
          } else {
            // x equalWithEpsilon xl => falls exactly on the left edge of the beachsection
            if (dxl > -FLT_EPSILON) {
              lArc = (Beachsection)node.rbPrevious;
              rArc = node;
            }
            // x equalWithEpsilon xr => falls exactly on the right edge of the beachsection
            else if (dxr > -FLT_EPSILON) {
              lArc = node;
              rArc = (Beachsection)node.rbNext;
            }
            // falls exactly somewhere in the middle of the beachsection
            else {
              lArc = rArc = node;
            }
            break;
          }
        }
      }
      // at this point, keep in mind that lArc and/or rArc could be
      // undefined or null.

      // create a new beach section object for the site and add it to RB-tree
      Beachsection newArc = this.createBeachsection(site);
      this.beachline.rbInsertSuccessor(lArc, newArc);

      // cases:
      //

      // [null,null]
      // least likely case: new beach section is the first beach section on the
      // beachline.
      // This case means:
      //   no new transition appears
      //   no collapsing beach section
      //   new beachsection become root of the RB-tree
      if (lArc == null && rArc == null) {
        return;
      }

      // [lArc,rArc] where lArc == rArc
      // most likely case: new beach section split an existing beach
      // section.
      // This case means:
      //   one new transition appears
      //   the left and right beach section might be collapsing as a result
      //   two new nodes added to the RB-tree
      if (lArc == rArc) {
        // invalidate circle event of split beach section
        this.detachCircleEvent(lArc);

        // split the beach section into two separate beach sections
        rArc = this.createBeachsection(lArc.site);
        this.beachline.rbInsertSuccessor(newArc, rArc);

        // since we have a new transition between two beach sections,
        // a new edge is born
        newArc.edge = rArc.edge = this.createEdge(lArc.site, newArc.site);

        // check whether the left and right beach sections are collapsing
        // and if so create circle events, to be notified when the point of
        // collapse is reached.
        this.attachCircleEvent(lArc);
        this.attachCircleEvent(rArc);
        return;
      }

      // [lArc,null]
      // even less likely case: new beach section is the *last* beach section
      // on the beachline -- this can happen *only* if *all* the previous beach
      // sections currently on the beachline share the same y value as
      // the new beach section.
      // This case means:
      //   one new transition appears
      //   no collapsing beach section as a result
      //   new beach section become right-most node of the RB-tree
      if (lArc != null && rArc == null) {
        newArc.edge = this.createEdge(lArc.site, newArc.site);
        return;
      }

      // [null,rArc]
      // impossible case: because sites are strictly processed from top to bottom,
      // and left to right, which guarantees that there will always be a beach section
      // on the left -- except of course when there are no beach section at all on
      // the beach line, which case was handled above.
      // rhill 2011-06-02: No point testing in non-debug version
      //if (!lArc && rArc) {
      //    throw "Voronoi.addBeachsection(): What is this I don't even";
      //    }

      // [lArc,rArc] where lArc != rArc
      // somewhat less likely case: new beach section falls *exactly* in between two
      // existing beach sections
      // This case means:
      //   one transition disappears
      //   two new transitions appear
      //   the left and right beach section might be collapsing as a result
      //   only one new node added to the RB-tree
      if (lArc != rArc) {
        // invalidate circle events of left and right sites
        this.detachCircleEvent(lArc);
        this.detachCircleEvent(rArc);

        // an existing transition disappears, meaning a vertex is defined at
        // the disappearance point.
        // since the disappearance is caused by the new beachsection, the
        // vertex is at the center of the circumscribed circle of the left,
        // new and right beachsections.
        // http://mathforum.org/library/drmath/view/55002.html
        // Except that I bring the origin at A to simplify
        // calculation
        Site lSite = lArc.site;
        float ax = lSite.x;
        float ay = lSite.y;
        float bx=site.x-ax;
        float by=site.y-ay;
        Site rSite = rArc.site;
        float cx=rSite.x-ax;
        float cy=rSite.y-ay;
        float d=2*(bx*cy-by*cx);
        float hb=bx*bx+by*by;
        float hc=cx*cx+cy*cy;
        Vertex vertex = this.createVertex((cy*hb-by*hc)/d+ax, (bx*hc-cx*hb)/d+ay);

        // one transition disappear
        this.setEdgeStartpoint(rArc.edge, lSite, rSite, vertex);

        // two new transitions appear at the new vertex location
        newArc.edge = this.createEdge(lSite, site, null, vertex);
        rArc.edge = this.createEdge(site, rSite, null, vertex);

        // check whether the left and right beach sections are collapsing
        // and if so create circle events, to handle the point of collapse.
        this.attachCircleEvent(lArc);
        this.attachCircleEvent(rArc);
        return;
      }
    }

    void attachCircleEvent(Beachsection arc) {
      Beachsection lArc = (Beachsection)arc.rbPrevious;
      Beachsection rArc = (Beachsection)arc.rbNext;
      if (lArc == null || rArc == null) {
        return;
      } // does that ever happen?
      Site lSite = lArc.site;
      Site cSite = arc.site;
      Site rSite = rArc.site;

      // If site of left beachsection is same as site of
      // right beachsection, there can't be convergence
      if (lSite==rSite) {
        return;
      }

      // Find the circumscribed circle for the three sites associated
      // with the beachsection triplet.
      // rhill 2011-05-26: It is more efficient to calculate in-place
      // rather than getting the resulting circumscribed circle from an
      // object returned by calling Voronoi.circumcircle()
      // http://mathforum.org/library/drmath/view/55002.html
      // Except that I bring the origin at cSite to simplify calculations.
      // The bottom-most part of the circumcircle is our Fortune 'circle
      // event', and its center is a vertex potentially part of the final
      // Voronoi diagram.
      float bx = cSite.x;
      float by = cSite.y;
      float ax = lSite.x-bx;
      float ay = lSite.y-by;
      float cx = rSite.x-bx;
      float cy = rSite.y-by;

      // If points l->c->r are clockwise, then center beach section does not
      // collapse, hence it can't end up as a vertex (we reuse 'd' here, which
      // sign is reverse of the orientation, hence we reverse the test.
      // http://en.wikipedia.org/wiki/Curve_orientation#Orientation_of_a_simple_polygon
      // rhill 2011-05-21: Nasty finite precision error which caused circumcircle() to
      // return infinites: 1e-12 seems to fix the problem.
      float d = 2*(ax*cy-ay*cx);
      if (d >= -2e-12) {
        return;
      }

      float ha = ax*ax+ay*ay;
      float hc = cx*cx+cy*cy;
      float x = (cy*ha-ay*hc)/d;
      float y = (ax*hc-cx*ha)/d;
      float ycenter = y+by;

      // Important: ybottom should always be under or at sweep, so no need
      // to waste CPU cycles by checking

      // recycle circle event object if possible
      CircleEvent circleEvent = new CircleEvent();
      circleEvent.arc = arc;
      circleEvent.site = cSite;
      circleEvent.x = x+bx;
      circleEvent.y = ycenter+sqrt(x*x+y*y); // y bottom
      circleEvent.ycenter = ycenter;
      arc.circleEvent = circleEvent;

      // find insertion point in RB-tree: circle events are ordered from
      // smallest to largest
      CircleEvent predecessor = null;
      CircleEvent node = (CircleEvent)this.circleEvents.root;
      while (node != null) {
        if (circleEvent.y < node.y || (circleEvent.y == node.y && circleEvent.x <= node.x)) {
          if (node.rbLeft != null) {
            node = (CircleEvent)node.rbLeft;
          } else {
            predecessor = (CircleEvent)node.rbPrevious;
            break;
          }
        } else {
          if (node.rbRight != null) {
            node = (CircleEvent)node.rbRight;
          } else {
            predecessor = node;
            break;
          }
        }
      }
      this.circleEvents.rbInsertSuccessor(predecessor, circleEvent);
      if (predecessor == null) {
        this.firstCircleEvent = circleEvent;
      }
    }

    void detachCircleEvent(Beachsection arc) {
      CircleEvent circleEvent = arc.circleEvent;
      if (circleEvent != null) {
        if (circleEvent.rbPrevious == null) {
          this.firstCircleEvent = (CircleEvent)circleEvent.rbNext;
        }
        this.circleEvents.rbRemoveNode(circleEvent); // remove from RB-tree
        arc.circleEvent = null;
      }
    }

    boolean connectEdge(Edge edge, BBox bbox) {
      // skip if end point already connected
      Vertex vb = edge.vb;
      if (vb != null) {
        return true;
      }

      // make local copy for performance purpose
      Vertex va = edge.va;
      float xl = bbox.xl;
      float xr = bbox.xr;
      float yt = bbox.yt;
      float yb = bbox.yb;
      Site lSite = edge.lSite;
      Site rSite = edge.rSite;
      float lx = lSite.x;
      float ly = lSite.y;
      float rx = rSite.x;
      float ry = rSite.y;
      float fx = (lx+rx)/2.0f;
      float fy = (ly+ry)/2.0f;
      float fm = Float.MAX_VALUE;
      float fb = Float.MIN_VALUE;

      // if we reach here, this means cells which use this edge will need
      // to be closed, whether because the edge was removed, or because it
      // was connected to the bounding box.
      this.cells.get(lSite.voronoiId).closeMe = true;
      this.cells.get(rSite.voronoiId).closeMe = true;

      // get the line equation of the bisector if line is not vertical
      if (ry != ly) {
        fm = (lx-rx)/(ry-ly);
        fb = fy-fm*fx;
      }
      if (ry == ly) {
        // special case: vertical line
        // doesn't intersect with viewport
        if (fx < xl || fx >= xr) {
          return false;
        }
        // downward
        if (lx > rx) {
          if (va == null || va.y < yt) {
            va = this.createVertex(fx, yt);
          } else if (va.y >= yb) {
            return false;
          }
          vb = this.createVertex(fx, yb);
        }
        // upward
        else {
          if (va == null || va.y > yb) {
            va = this.createVertex(fx, yb);
          } else if (va.y < yt) {
            return false;
          }
          vb = this.createVertex(fx, yt);
        }
      }
      // closer to vertical than horizontal, connect start point to the
      // top or bottom side of the bounding box
      else if (fm < -1 || fm > 1) {
        // downward
        if (lx > rx) {
          if (va == null || va.y < yt) {
            va = this.createVertex((yt-fb)/fm, yt);
          } else if (va.y >= yb) {
            return false;
          }
          vb = this.createVertex((yb-fb)/fm, yb);
        }
        // upward
        else {
          if (va == null || va.y > yb) {
            va = this.createVertex((yb-fb)/fm, yb);
          } else if (va.y < yt) {
            return false;
          }
          vb = this.createVertex((yt-fb)/fm, yt);
        }
      }
      // closer to horizontal than vertical, connect start point to the
      // left or right side of the bounding box
      else {
        // rightward
        if (ly < ry) {
          if (va == null || va.x < xl) {
            va = this.createVertex(xl, fm*xl+fb);
          } else if (va.x >= xr) {
            return false;
          }
          vb = this.createVertex(xr, fm*xr+fb);
        }
        // leftward
        else {
          if (va == null || va.x > xr) {
            va = this.createVertex(xr, fm*xr+fb);
          } else if (va.x < xl) {
            return false;
          }
          vb = this.createVertex(xl, fm*xl+fb);
        }
      }
      edge.va = va;
      edge.vb = vb;

      return true;
    }

    boolean clipEdge(Edge edge, BBox bbox) {
      float ax = edge.va.x;
      float ay = edge.va.y;
      float bx = edge.vb.x;
      float by = edge.vb.y;
      float t0 = 0;
      float t1 = 1;
      float dx = bx-ax;
      float dy = by-ay;
      // left
      float q = ax-bbox.xl;
      if (dx==0 && q<0) {
        return false;
      }
      float r = -q/dx;
      if (dx<0) {
        if (r<t0) {
          return false;
        }
        if (r<t1) {
          t1=r;
        }
      } else if (dx>0) {
        if (r>t1) {
          return false;
        }
        if (r>t0) {
          t0=r;
        }
      }
      // right
      q = bbox.xr-ax;
      if (dx==0 && q<0) {
        return false;
      }
      r = q/dx;
      if (dx<0) {
        if (r>t1) {
          return false;
        }
        if (r>t0) {
          t0=r;
        }
      } else if (dx>0) {
        if (r<t0) {
          return false;
        }
        if (r<t1) {
          t1=r;
        }
      }
      // top
      q = ay-bbox.yt;
      if (dy==0 && q<0) {
        return false;
      }
      r = -q/dy;
      if (dy<0) {
        if (r<t0) {
          return false;
        }
        if (r<t1) {
          t1=r;
        }
      } else if (dy>0) {
        if (r>t1) {
          return false;
        }
        if (r>t0) {
          t0=r;
        }
      }
      // bottom
      q = bbox.yb-ay;
      if (dy==0 && q<0) {
        return false;
      }
      r = q/dy;
      if (dy<0) {
        if (r>t1) {
          return false;
        }
        if (r>t0) {
          t0=r;
        }
      } else if (dy>0) {
        if (r<t0) {
          return false;
        }
        if (r<t1) {
          t1=r;
        }
      }

      // if we reach this point, Voronoi edge is within bbox

      // if t0 > 0, va needs to change
      // rhill 2011-06-03: we need to create a new vertex rather
      // than modifying the existing one, since the existing
      // one is likely shared with at least another edge
      if (t0 > 0) {
        edge.va = this.createVertex(ax+t0*dx, ay+t0*dy);
      }

      // if t1 < 1, vb needs to change
      // rhill 2011-06-03: we need to create a new vertex rather
      // than modifying the existing one, since the existing
      // one is likely shared with at least another edge
      if (t1 < 1) {
        edge.vb = this.createVertex(ax+t1*dx, ay+t1*dy);
      }

      // va and/or vb were clipped, thus we will need to close
      // cells which use this edge.
      if ( t0 > 0 || t1 < 1 ) {
        this.cells.get(edge.lSite.voronoiId).closeMe = true;
        this.cells.get(edge.rSite.voronoiId).closeMe = true;
      }

      return true;
    }

    // Connect/cut edges at bounding box
    void clipEdges(BBox bbox) {
      // connect all dangling edges to bounding box
      // or get rid of them if it can't be done
      ArrayList<Edge> edges = this.edges;
      int iEdge = edges.size();
      Edge edge;

      // iterate backward so we can splice safely
      while (iEdge-- != 0) {
        edge = edges.get(iEdge);
        // edge is removed if:
        //   it is wholly outside the bounding box
        //   it is looking more like a point than a line
        if (!this.connectEdge(edge, bbox) ||
          !this.clipEdge(edge, bbox) ||
          (abs(edge.va.x-edge.vb.x)<FLT_EPSILON && abs(edge.va.y-edge.vb.y)<FLT_EPSILON)) {
          edge.va = edge.vb = null;
          edges.remove(iEdge);
        }
      }
    }

    void debugCell(Cell cell) {
      println(cell.closeMe);
      println(cell.halfedges.size());
      for (int i = 0; i < cell.halfedges.size(); i++) {
        Halfedge h = cell.halfedges.get(i);
        println("    [" + i + "] " + "angle=" + h.angle);
        Edge e = h.edge;
        println("        [" + i + "] " + "edge.lSite=" + e.lSite.x + " : " + e.lSite.y);
        println("        [" + i + "] " + "edge.rSite=" + e.rSite.x + " : " + e.rSite.y);
        if (e.va != null) {
          println("            [" + i + "] " + "edge.va=" + e.va.x + " : " + e.va.y);
        }
        if (e.vb != null) {
          println("            [" + i + "] " + "edge.vb=" + e.vb.x + " : " + e.vb.y);
        } else {
          println("            [" + i + "] " + "edge.vb=[null]");
        }
        println("    [" + i + "] " + "site="
          + h.site.x + " : " + h.site.y + " : " + h.site.voronoiId);
      }
      println(cell.site.x + " : " + cell.site.y + " : " + cell.site.voronoiId);
    }
    void clipAndAdjust(Vertex az, BBox bbox) {
      // バウンディングボックスに1[ピクセル]分下駄を履かせた内側にする
      // 左
      if ((az.x - 1) < bbox.xl) {
        az.x = bbox.xl;
      }
      // 右
      if (bbox.xr < (az.x + 1)) {
        az.x = bbox.xr;
      }
      // 上
      if ((az.y - 1) < bbox.yt) {
        az.y = bbox.yt;
      }
      // 下
      if (bbox.yb < (az.y + 1)) {
        az.y = bbox.yb;
      }
    }
    void closeCells(BBox bbox) {
      float xl = bbox.xl;
      float xr = bbox.xr;
      float yt = bbox.yt;
      float yb = bbox.yb;
      ArrayList<Cell> cells = this.cells;
      int iCell = cells.size();
      Cell cell;
      int iLeft;
      ArrayList<Halfedge> halfedges;
      int nHalfedges;
      Edge edge;
      Vertex va;
      Vertex vb;
      Vertex vz;
      boolean lastBorderSegment;

      while (iCell-- != 0) {
        cell = cells.get(iCell);
        // prune, order halfedges counterclockwise, then add missing ones
        // required to close cells
        if (cell.prepareHalfedges() == 0) {
          continue;
        }
        if (!cell.closeMe) {
          continue;
        }
        // find first 'unclosed' point.
        // an 'unclosed' point will be the end point of a halfedge which
        // does not match the start point of the following halfedge
        halfedges = cell.halfedges;
        nHalfedges = halfedges.size();
        // special case: only one site, in which case, the viewport is the cell
        // ...
        // all other cases
        iLeft = 0;
        while (iLeft < nHalfedges) {
          va = halfedges.get(iLeft).getEndpoint();
          clipAndAdjust(va, bbox);
          vz = halfedges.get((iLeft+1) % nHalfedges).getStartpoint();
          clipAndAdjust(vz, bbox);
          // if end point is not equal to start point, we need to add the missing
          // halfedge(s) up to vz
          if (abs(va.x-vz.x)>=FLT_EPSILON || abs(va.y-vz.y)>=FLT_EPSILON) {
            // rhill 2013-12-02:
            // "Holes" in the halfedges are not necessarily always adjacent.
            // https://github.com/gorhill/Javascript-Voronoi/issues/16

            // find entry point:
            while (true) {
              // walk downward along left side
              // 左側を下に向かって歩く
              if (this.equalWithEpsilon(va.x, xl) && this.lessThanWithEpsilon(va.y, yb)) {
                lastBorderSegment = this.equalWithEpsilonSegment(vz.x, xl);
                vb = this.createVertex(xl, lastBorderSegment ? vz.y : yb);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through
              }
              if (this.equalWithEpsilon(va.y, yb) && this.lessThanWithEpsilon(va.x, xr)) {
                // walk rightward along bottom side
                // 底面に沿って右回りに歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.y, yb);
                vb = this.createVertex(lastBorderSegment ? vz.x : xr, yb);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through
              }
              if (this.equalWithEpsilon(va.x, xr) && this.greaterThanWithEpsilon(va.y, yt)) {
                // walk upward along right side
                // 右側を上に向かって歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.x, xr);
                vb = this.createVertex(xr, lastBorderSegment ? vz.y : yt);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through
              }
              if (this.equalWithEpsilon(va.y, yt) && this.greaterThanWithEpsilon(va.x, xl)) {
                // walk leftward along top side
                // 上面に沿って左方向に歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.y, yt);
                vb = this.createVertex(lastBorderSegment ? vz.x : xl, yt);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through

                // walk downward along left side
                // 左側を下に向かって歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.x, xl);
                vb = this.createVertex(xl, lastBorderSegment ? vz.y : yb);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through

                // walk rightward along bottom side
                // 底面に沿って右回りに歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.y, yb);
                vb = this.createVertex(lastBorderSegment ? vz.x : xr, yb);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                va = vb;
                // fall through

                // walk upward along right side
                // 右側を上に向かって歩く
                lastBorderSegment = this.equalWithEpsilonSegment(vz.x, xr);
                vb = this.createVertex(xr, lastBorderSegment ? vz.y : yt);
                edge = this.createBorderEdge(cell.site, va, vb);
                iLeft++;
                halfedges.add(iLeft, this.createHalfedge(edge, cell.site, null));
                nHalfedges++;
                if ( lastBorderSegment ) {
                  break;
                }
                // fall through
              }
              println("※va.x:" + va.x + " va.y:" + va.y);
            assert false :
              "Voronoi.closeCells() > this makes no sense!";
              break;
            }
          }
          iLeft++;
        }
        cell.closeMe = false;
      }
    }

    Diagram compute(ArrayList<Site> sites, BBox bbox) {
      // to measure execution time

      // init internal state
      this.reset();

      // Initialize site event queue
      ArrayList<Site> siteEvents = new ArrayList(sites);
      Collections.sort(siteEvents, new SiteComparator());

      // process queue
      Site site = null;
      if (0 < siteEvents.size()) {
        site = siteEvents.remove(siteEvents.size() - 1);
      }
      int siteid = 0;
      float xsitex = Float.NaN; // to avoid duplicate sites
      float xsitey = Float.NaN;
      ArrayList<Cell> cells = this.cells;
      CircleEvent circle;

      // main loop
      for (;; ) {
        // we need to figure whether we handle a site or circle event
        // for this we find out if there is a site event and it is
        // 'earlier' than the circle event
        circle = this.firstCircleEvent;

        // add beach section
        if (site != null && (circle == null || site.y < circle.y || (site.y == circle.y && site.x < circle.x))) {
          // only if site is not a duplicate
          if (site.x != xsitex || site.y != xsitey) {
            // first create cell for new site
            cells.add(siteid, this.createCell(site));
            site.voronoiId = siteid++;
            // then create a beachsection for that site
            this.addBeachsection(site);
            // remember last site coords to detect duplicate
            xsitey = site.y;
            xsitex = site.x;
          }
          if (0 < siteEvents.size()) {
            site = siteEvents.remove(siteEvents.size() - 1);
          } else {
            site = null;
          }
        }

        // remove beach section
        else if (circle != null) {
          this.removeBeachsection(circle.arc);
        }

        // all done, quit
        else {
          break;
        }
      }

      // wrapping-up:
      //   connect dangling edges to bounding box
      //   cut edges as per bounding box
      //   discard edges completely outside bounding box
      //   discard edges which are point-like
      this.clipEdges(bbox);

      //   add missing edges in order to close opened cells
      this.closeCells(bbox);

      // to measure execution time

      // prepare return values
      Diagram diagram = new Diagram();
      diagram.cells = this.cells;
      diagram.edges = this.edges;
      diagram.vertices = this.vertices;

      // clean up
      this.reset();

      return diagram;
    }
    public class SiteComparator implements Comparator<Site> {
      @Override public int compare(Site a, Site b) {
        float r = b.y - a.y;
        if (r < 0) {
          return -1;
        }
        if (0 < r) {
          return 1;
        }
        r = b.x - a.x;
        if (r < 0) {
          return -1;
        }
        if (0 < r) {
          return 1;
        }
        return 0;
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
