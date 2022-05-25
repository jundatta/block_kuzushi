// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】naoさん
// 【作品名】Spiralator
// https://openprocessing.org/sketch/817143
//

class GameSceneCongratulations69 extends GameSceneCongratulationsBase {
  float hu = 0;

  // ----- bullet class -----
  class Bullet {
    PVector _position;
    PVector _velocity;
    float _angle;
    Bullet() {
      this._position = new PVector();
      this._velocity = new PVector();
      this._angle = 0;
    }

    boolean update() {
      this._position.add(this._velocity);
      this._draw();
      return this._collisionField();
    }

    void _draw() {
    }

    boolean _collisionField() {
      return !(this._position.x > 0 &&
        this._position.x < width &&
        this._position.y > 0 &&
        this._position.y < height);
    }

    void setPosition(PVector postion) {
      this._position = postion;
    }

    void setVelocity(PVector velocity) {
      this._velocity = velocity;
      this._angle = this._velocity.heading();
    }
  }

  class Bullet01 extends Bullet {

    Bullet01() {
      super();
    }

    void _draw() {
      noStroke();
      push();
      translate(this._position.x, this._position.y);
      push();
      rotate(this._angle);
      hu=.5 * dist(this._position.x, this._position.y, width/2, height/2);
      fill(hu%255, 255, 255);
      ellipse(5, 5, 10, 10);
      pop();
      pop();
    }
  }

  // ----- danmaku class -----
  class Danmaku {
    ArrayList<Bullet01> _bullets;
    Danmaku() {
      this._bullets = new ArrayList();
    }

    void update() {
      this._updateBullets();
    }

    void _updateBullets() {
      //    this._bullets = this._bullets.filter(bullet => !bullet.update());
      ArrayList<Bullet01> works = new ArrayList();
      for (Bullet01 bullet : this._bullets) {
        if (!bullet.update()) {
          works.add(bullet);
        }
      }
      this._bullets = works;
    }
  }

  class Danmaku05 extends Danmaku {

    Danmaku05() {
      super();
    }

    void update() {
      super.update();

      if (frameCount % 8 < 7) {
        for (float i = 0; i < 6; i++) {
          // let bullet = new Bullet02(color(64 + 191.0 / 15 * (frameCount% 30) ))
          Bullet01 bullet = new Bullet01();
          bullet.setPosition(new PVector(width / 2, height / 2));
          bullet.setVelocity(new PVector(1, 0).rotate(frameCount/12.0 + TWO_PI / 6 * i).mult((frameCount % 30) /10.0 + 4.0));
          this._bullets.add(bullet);
        }
      }
    }
  }

  // ----- p5 main process -----

  Danmaku05 danmaku;

  @Override void setup() {
    imageMode(CORNER);

    colorMode(HSB, 255);
    danmaku = new Danmaku05();
  }
  @Override void draw() {
    background(0);
    danmaku.update();

    logoRightLower(color(0, 255, 255));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
