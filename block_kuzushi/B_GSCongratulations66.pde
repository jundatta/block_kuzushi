// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】manuさん
// 【作品名】Matrix Digital Rain
// https://openprocessing.org/sketch/959319
//

class GameSceneCongratulations66 extends GameSceneCongratulationsBase {
  ArrayList<Stream> streams = new ArrayList();
  float fadeInterval = 1.2;
  float symbolSize = 30;
  final float INTERVAL = 0.8f;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255);
    imageMode(CORNER);

    pg = createGraphics(width, height);

    float x = 0;
    for (int i = 0; i <= width / (symbolSize * INTERVAL); i++) {
      if (random(100) < 80) {
        Stream stream = new Stream();
        stream.generateSymbols(x, random(-2000, 0));
        streams.add(stream);
      }
      x += symbolSize * INTERVAL;
    }
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.textFont(gFont);
    pg.textSize(symbolSize);
    pg.background(19, 30, 41);
    for (Stream s : streams) {
      s.render();
    }
    pg.endDraw();

    scale(-1, 1);
    image(pg, -pg.width, 0);
    pop();

    logoRightUpper(color(255, 0, 0));
  }

  class Symbol {
    float x;
    float y;
    float speed;
    boolean first;
    float opacity;
    int switchInterval;
    char value;

    Symbol(float x, float y, float speed, boolean first, float opacity) {
      this.x = x;
      this.y = y;

      this.speed = speed;
      this.first = first;
      this.opacity = opacity;

      this.switchInterval = round(random(2, 25));
    }

    void setToRandomSymbol() {
      final String kSpecial = "!#$%&()*+,-./:;<=>?[]^_`{|}~";
      float charType = round(random(0, 16));
      if (frameCount % this.switchInterval == 0) {
        if (charType <= 1) {
          // set it to numeric
          this.value = (char)('0' + random(0, 10));
        } else if (2 <= charType && charType <= 5) {
          int idx = (int)random(kSpecial.length());
          char[] c = kSpecial.toCharArray();
          this.value = c[idx];
        } else {
          // set it to caps text
          this.value = (char)random(0xFF66, 0xFF9D+1);
        }
      }
    }

    void rain() {
      this.y = (this.y >= height) ? 0 : this.y + this.speed;
    }
  }

  class Stream {
    ArrayList<Symbol> symbols;
    float totalSymbols;
    float speed;
    Stream() {
      this.symbols = new ArrayList();
      this.totalSymbols = round(random(30, 70));
      this.speed = random(5, 10);
    }

    void generateSymbols(float x, float y) {
      float opacity = 255;
      boolean first = round(random(0, 4)) == 1;
      for (float i =0; i <= this.totalSymbols; i++) {
        Symbol symbol = new Symbol(
          x,
          y,
          this.speed,
          first,
          opacity
          );
        symbol.setToRandomSymbol();
        this.symbols.add(symbol);
        opacity -= (255 / this.totalSymbols) / fadeInterval;
        y -= symbolSize * INTERVAL;
        first = false;
      }
    };

    void render() {
      for (Symbol symbol : symbols) {
        if (symbol.first) {
          pg.fill(37, 218, 37, symbol.opacity);
        } else {
          //          pg.fill(37, 160, 37, symbol.opacity);
          pg.fill(50, 255, 100, symbol.opacity);
        }
        pg.text(symbol.value, symbol.x, symbol.y);
        symbol.rain();
        symbol.setToRandomSymbol();
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
