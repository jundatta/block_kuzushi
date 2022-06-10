// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】かじるプログラミングさん
// 【作品名】8Puzzle
// https://openprocessing.org/sketch/1017156
//

class GameSceneCongratulations89 extends GameSceneCongratulationsBase {
  final color[] T_COLOR = {
    #FFFFFF, #F44336, #E91E63, #9C27B0, #673Ab7, #3F51B5,
    #2196F3, #03A9f4, #00BCD4, #009688, #4CAF50, #8BC34A,
    #CDDC39, #FFEB3B, #FFC107, #FF9800, #FF5722, #795548};
  final color[] F_COLOR = {
    #333333, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF,
    #333333, #333333, #333333, #FFFFFF, #FFFFFF, #FFFFFF,
    #333333, #333333, #333333, #333333, #FFFFFF, #FFFFFF};

  FpzManager fMng;
  float sX, sY;
  final int GRID = 3;
  Tile[] tiles;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(0);

    float pad = 32;
    float size = 30;
    if (width < height) {
      pad = width / 5.0f;
      size = pad * 0.95;
    } else {
      pad = height / 5.0f;
      size = pad * 0.95;
    }
    float corner = size * 0.1;

    // 15Puzzle
    fMng = new FpzManager();

    sX = width / 2.0f - pad * fMng.getGrids() / 2.0f;
    sY = height / 2.0f - pad * fMng.getGrids() / 2.0f;

    // Tiles
    tiles = new Tile[fMng.getGrids() * fMng.getGrids()];
    int[][] board = fMng.getBoard();
    for (int r=0; r<fMng.getGrids(); r++) {
      for (int c=0; c<fMng.getGrids(); c++) {
        //      tiles.push(new Tile(board[r][c], r, c, pad, size, corner));
        tiles[r * fMng.getGrids() + c]
          = new Tile(board[r][c], r, c, (int)pad, (int)size, (int)corner);
      }
    }

    move = new ManualMove();
  }

  class Move {
    void draw() {
    }
  }
  Move move;

  class ManualMove extends Move {
    @Override void draw() {
      for (Tile tile : tiles) {
        tile.draw();
      }
    }
  }
  class AutoMove extends Move {
    @Override void draw() {
      History history = fMng.popHistory();
      if (history == null) {
        move = new ManualMove();
        return;
      }
      fMng.swapGrid(history.tR, history.tC, history.fR, history.fC);
      swapTiles(history.tR, history.tC, history.fR, history.fC);
      //  setTimeout(autoMove, 100);
      for (Tile tile : tiles) {
        tile.draw();
      }
    }
  }

  @Override void draw() {
    clearBackground(64);
    move.draw();

    logoRightUpper(color(255, 0, 0));
  }

  @Override void mousePressed() {
    for (Tile tile : tiles) {
      if (tile.contains(mouseX, mouseY)) {
        Position target = fMng.checkVH(tile.r(), tile.c());
        if (target.r < 0 || target.c < 0) {
          return;
        }
        fMng.pushHistory(tile.r(), tile.c(), target.r, target.c);
        swapTiles(tile.r(), tile.c(), target.r, target.c);
        return;
      }
    }
    if (mouseX < 50 && mouseY < 50) {
      //    autoMove();// Auto
      move = new AutoMove();
    }
  }

  void swapTiles(int fR, int fC, int tR, int tC) {
    int f = fR * fMng.getGrids() + fC;
    int t = tR * fMng.getGrids() + tC;
    tiles[f].change(tR, tC);
    tiles[t].change(fR, fC);
    Tile tmp = tiles[t];
    tiles[t] = tiles[f];
    tiles[f] = tmp;
  }

  class Tile {
    int _num;
    int _r;
    int _c;
    int _pad;
    int _size;
    int _corner;

    int _x;
    int _y;
    int _dX;
    int _dY;

    Tile(int num, int r, int c, int pad, int size, int corner) {
      this._num    = num;
      this._r      = r;
      this._c      = c;
      this._pad    = pad;
      this._size   = size;
      this._corner = corner;

      this._x   = int(sX + pad * c);
      this._y   = int(sY + pad * r);
      this._dX  = this._x;
      this._dY  = this._y;
    }

    int num() {
      return this._num;
    }
    int r() {
      return this._r;
    }
    int c() {
      return this._c;
    }

    void num(int n) {
      this._num = n;
    }
    void r(int n) {
      this._r = n;
    }
    void c(int n) {
      this._c = n;
    }

    void change(int r, int c) {
      this._r = r;
      this._c = c;
      this._dX = int(sX + this._pad * c);
      this._dY = int(sY + this._pad * r);
    }

    boolean contains(int x, int y) {
      if (x < this._x) return false;
      if (y < this._y) return false;
      if (this._x + this._size < x) return false;
      if (this._y + this._size < y) return false;
      return true;
    }

    void draw() {
      // Move
      if (this.calcDistance() < 4) {
        this._x = this._dX;
        this._y = this._dY;
      } else {
        this._x += (this._dX - this._x) / 2;
        this._y += (this._dY - this._y) / 2;
      }
      if (this._num == 0) return;
      int i = this._num % T_COLOR.length;
      // Background
      noStroke();
      fill(T_COLOR[i]);
      rect(this._x, this._y, this._size, this._size,
        this._corner * 5, this._corner, this._corner, this._corner);
      // Font
      fill(F_COLOR[i]);
      textSize(this._size*0.5);
      textAlign(CENTER);
      text(this._num, this._x+this._size/2, this._y+this._size*0.7);
    }

    int calcDistance() {
      int x = this._dX - this._x;
      int y = this._dY - this._y;
      return x*x+y*y;
    }
  }

  //==========
  // FpzManager

  final int D_LEFT  = 0;
  final int D_RIGHT = 1;
  final int D_UP    = 2;
  final int D_DOWN  = 3;

  class Position {
    int r;
    int c;

    Position(int r, int c) {
      this.r = r;
      this.c = c;
    }
  }
  class History {
    int fR;
    int fC;
    int tR;
    int tC;

    History(int fR, int fC, int tR, int tC) {
      this.fR = fR;
      this.fC = fC;
      this.tR = tR;
      this.tC = tC;
    }
  }
  class FpzManager {
    int _grids;
    int[][] _board= {
      { 1, 2, 3 },
      { 4, 5, 6 },
      { 7, 8, 0 }
    };
    ArrayList<History> _histories;

    FpzManager() {
      this._grids = GRID;
      this._histories = new ArrayList();
      this.wanderGrid(2, 2, -1, 30);
    }

    int getGrids() {
      return this._grids;
    }

    int[][] getBoard() {
      return this._board;
    }

    void pushHistory(int fR, int fC, int tR, int tC) {
      History history = new History(fR, fC, tR, tC);
      this._histories.add(history);
    }

    History popHistory() {
      int l = this._histories.size() - 1;
      if (l < 0) return null;
      History history = this._histories.get(l);
      this._histories.remove(l);
      return history;
    }

    Position checkVH(int r, int c) {
      if (this.checkZero(r-1, c)) return this.swapGrid(r, c, r-1, c);
      if (this.checkZero(r+1, c)) return this.swapGrid(r, c, r+1, c);
      if (this.checkZero(r, c-1)) return this.swapGrid(r, c, r, c-1);
      if (this.checkZero(r, c+1)) return this.swapGrid(r, c, r, c+1);
      return new Position(-1, -1);
    }

    boolean checkZero(int r, int c) {
      if (r < 0) return false;
      if (c < 0) return false;
      if (this._grids-1 < r) return false;
      if (this._grids-1 < c) return false;
      if (this._board[r][c] != 0) return false;
      return true;
    }

    void wanderGrid(int r, int c, int prev, int cnt) {
      if (cnt <= 0) return;
      int[] dirs = new int[4];
      for (int i=0; i<dirs.length; i++) dirs[i] = i;
      for (int i=dirs.length-1; 0<i; i--) {
        int rdm = (int)Math.floor(Math.random()*i);
        int tmp = dirs[rdm];
        dirs[rdm] = dirs[i];
        dirs[i] = tmp;
      }
      for (int i=0; i<dirs.length; i++) {
        int dir = dirs[i];
        int rev = -1;
        if (prev == D_LEFT) rev = D_RIGHT;
        if (prev == D_RIGHT) rev = D_LEFT;
        if (prev == D_UP) rev = D_DOWN;
        if (prev == D_DOWN) rev = D_UP;
        if (dir == rev) continue;
        int oR = 0;
        int oC = 0;
        if (dir == D_LEFT) {
          if (c-1<0) continue;
          oC--;
        }
        if (dir == D_RIGHT) {
          if (this._grids-1<c+1) continue;
          oC++;
        }
        if (dir == D_UP) {
          if (r-1<0) continue;
          oR--;
        }
        if (dir == D_DOWN) {
          if (this._grids-1<r+1) continue;
          oR++;
        }
        this._histories.add(new History(r, c, r+oR, c+oC));
        this.swapGrid(r, c, r+oR, c+oC);
        this.wanderGrid(r+oR, c+oC, dir, cnt-1);
        return;
      }
    }

    Position swapGrid(int fR, int fC, int tR, int tC) {
      int tmp = this._board[tR][tC];
      this._board[tR][tC] = this._board[fR][fC];
      this._board[fR][fC] = tmp;
      return new Position(tR, tC);
    }
  }

  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
