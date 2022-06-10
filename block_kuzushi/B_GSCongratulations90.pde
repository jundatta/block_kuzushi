// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】かじるプログラミングさん
// 【作品名】Sokoban
// https://openprocessing.org/sketch/1235000
//

class GameSceneCongratulations90 extends GameSceneCongratulationsBase {
  final int TYPE_FLOOR = 0;
  final int TYPE_PLAYER = 1;
  final int TYPE_WALL = 2;
  final int TYPE_BLOCK = 3;

  int MAP[][] = {
    {0, 0, 0, 0, 0, 2, 2},
    {0, 2, 2, 0, 0, 0, 2},
    {0, 0, 2, 3, 0, 0, 0},
    {0, 0, 3, 1, 3, 0, 0},
    {0, 0, 0, 3, 2, 0, 0},
    {2, 0, 0, 0, 2, 2, 0},
    {2, 2, 0, 0, 0, 0, 0}
  };
  int mapType(int r, int c) {
    final int kType[] = {
      TYPE_FLOOR, TYPE_PLAYER, TYPE_WALL, TYPE_BLOCK,
    };
    return kType[MAP[r][c]];
  }

  final int[][] DIR = {
    {-1, 0}, {1, 0}, {0, -1}, {0, 1}
  };

  final int G_SIZE = 50;
  final int ROWS = MAP.length;
  final int COLS = MAP[0].length;
  final int W_BOARD = COLS * G_SIZE;
  final int H_BOARD = ROWS * G_SIZE;

  //let tiles = Array.from(new Array(ROWS), ()=>new Array(COLS).fill(null));
  Tile[][] tiles;
  ArrayList<Obj> objs = new ArrayList();
  Obj player = null;
  final String title = "= Sokoban =";
  String msg = "Press arrow key to move!!";

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    noSmooth();
    textAlign(CENTER, CENTER);
    textSize(32);

    tiles = new Tile[ROWS][];
    for (int r = 0; r < ROWS; r++) {
      tiles[r] = new Tile[COLS];
    }

    // Tiles, Player, Objs
    for (int r=0; r<ROWS; r++) {
      for (int c=0; c<COLS; c++) {
        tiles[r][c] = new Tile(r, c);// Tile
        //      let type = MAP[r][c];
        int type = mapType(r, c);
        if (type == TYPE_FLOOR) continue;
        if (type == TYPE_PLAYER) {
          player = new Obj(TYPE_PLAYER, r, c);
          continue;
        }
        if (type == TYPE_WALL || type == TYPE_BLOCK) {
          objs.add(new Obj(type, r, c));
          continue;
        }
      }
    }

    background(33);

    // RandomWalk
    //objs.get(6).move(1, 3);
    //objs.get(7).move(3, 1);
    //objs.get(9).move(3, 5);
    //objs.get(10).move(5, 3);
    for (int i=0; i<1000; i++) {
      int rdm = (int)Math.floor(Math.random() * DIR.length);
      player.move(DIR[rdm][0], DIR[rdm][1], true);
    }
    // Reset
    for (Obj obj : objs) {
      if (obj.type() != TYPE_BLOCK) continue;
      tiles[obj.r()][obj.c()].goalSet();
      obj.reset();
    }
    player.reset();
  }
  @Override void draw() {
    background(33);
    fill(200);

    push();
    rectMode(CENTER);
    // Tiles, Player, Objects
    for (int r=0; r<ROWS; r++) {
      for (int c=0; c<COLS; c++) {
        tiles[r][c].draw();
      }
    }
    player.draw();
    for (Obj obj : objs) obj.draw();

    // Message
    fill(255);
    text(title, width/2, height/2-(ROWS+1)*G_SIZE/2);
    text(msg, width/2, height/2+(ROWS+1)*G_SIZE/2);
    pop();

    logoRightUpper(color(255, 0, 0));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (isCleared()) {
      gGameStack.change(new GameSceneTitle());
      return;
    }

    if (keyCode == LEFT) player.move(0, -1);
    if (keyCode == RIGHT) player.move(0, 1);
    if (keyCode == UP) player.move(-1, 0);
    if (keyCode == DOWN) player.move(1, 0);
    if (!isCleared()) return;
    //setTimeout(()=> {
    //  msg = "Game Clear!!"
    //    noLoop();
    //}
    //, 400);
    msg = "Game Clear!!";
  }

  boolean isInside(int r, int c) {
    if (r < 0 || ROWS-1 < r) return false;
    if (c < 0 || COLS-1 < c) return false;
    return true;
  }

  Obj searchObjs(int r, int c) {
    for (Obj obj : objs) {
      if (obj.r() != r) continue;
      if (obj.c() != c) continue;
      return obj;
    }
    return null;
  }

  boolean isCleared() {
    for (Obj obj : objs) {
      if (obj.type() != TYPE_BLOCK) continue;
      if (!tiles[obj.r()][obj.c()].goal()) return false;
    }
    return true;
  }

  class Tile {
    int _r;
    int _c;
    int _x;
    int _y;
    boolean _goal;

    Tile(int r, int c) {
      this._r = r;
      this._c = c;
      this._x = width/2 - W_BOARD/2 + c*G_SIZE + G_SIZE/2;
      this._y = height/2 - H_BOARD/2 + r*G_SIZE + G_SIZE/2;
      this._goal = false;
    }

    int x() {
      return this._x;
    }
    int y() {
      return this._y;
    }
    boolean goal() {
      return this._goal;
    }
    void goalSet() {
      this._goal = true;
    }

    void draw() {
      stroke(33);
      strokeWeight(1);
      fill(200);
      square(this._x, this._y, G_SIZE);
      noStroke();
      fill(33, 99, 33);
      if (this._goal) square(this._x, this._y, G_SIZE*0.2);
    }
  }

  class Obj {
    int _type;
    int _r;
    int _c;
    int _defR;
    int _defC;
    int _x;
    int _y;
    int _toX;
    int _toY;

    Obj(int type, int r, int c) {
      this._type = type;
      this._r = r;
      this._c = c;
      this._defR = r;
      this._defC = c;
      this._x = tiles[r][c].x();
      this._y = tiles[r][c].y();
      this._toX = this._x;
      this._toY = this._y;
    }

    int type() {
      return this._type;
    }
    int r() {
      return this._r;
    }
    int c() {
      return this._c;
    }
    int x() {
      return this._x;
    }
    int y() {
      return this._y;
    }

    void reset() {
      this._r = this._defR;
      this._c = this._defC;
      this._x = tiles[this._r][this._c].x();
      this._y = tiles[this._r][this._c].y();
      this._toX = this._x;
      this._toY = this._y;
    }

    void draw() {
      // Move
      int dX = this._toX - this._x;
      if (2 < abs(dX)) {
        this._x += dX / 2;
      } else {
        this._x = this._toX;
      }
      int dY = this._toY - this._y;
      if (2 < abs(dY)) {
        this._y += dY / 2;
      } else {
        this._y = this._toY;
      }
      // Draw
      noStroke();
      if (this._type == TYPE_WALL)   fill(11, 11, 99);
      if (this._type == TYPE_BLOCK)  fill(11, 99, 11);
      if (this._type == TYPE_PLAYER) fill(99, 11, 11);
      square(this._x, this._y, G_SIZE*0.8);
    }

    void move(int oR, int oC) {
      move(oR, oC, false);
    }
    void move(int oR, int oC, boolean skip) {
      int r = this._r + oR;
      int c = this._c + oC;
      Obj tgt = searchObjs(r, c);
      if (tgt == null) {
        this.moveTo(r, c, skip);
        return;
      }
      if (tgt.type() != TYPE_BLOCK) return;
      if (!isInside(tgt.r()+oR, tgt.c()+oC)) return;
      if (searchObjs(tgt.r()+oR, tgt.c()+oC) != null) return;
      tgt.moveTo(tgt.r()+oR, tgt.c()+oC, skip);
      this.moveTo(r, c, skip);
    }

    boolean moveTo(int r, int c) {
      return moveTo(r, c, false);
    }
    boolean moveTo(int r, int c, boolean skip) {
      if (this._toX != this._x) return false;
      if (this._toY != this._y) return false;
      if (!isInside(r, c)) return false;
      this._r = r;
      this._c = c;
      this._toX = tiles[r][c].x();
      this._toY = tiles[r][c].y();
      if (skip) {
        this._x = this._toX;
        this._y = this._toY;
      }
      return true;
    }
  }
}
