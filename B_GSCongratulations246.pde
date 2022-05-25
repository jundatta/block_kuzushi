// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/582909
//

class GameSceneCongratulations246 extends GameSceneCongratulationsBase {
  int ix;
  float RW, RH;

  final float OrgY = 0;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);


    ix = 0;
    RW = max(width, height);
    RH = RW;

    pg = createGraphics(width, height);
  }
  @Override void draw() {
    pg.beginDraw();
    if (ix == 0) {
      pg.background(100);
    }
    pg.push();
    pg.colorMode(HSB, 255);
    pg.noSmooth();

    if (ix < RW) {
      for (var nc=0; nc<5; nc++)
      {
        for (var iy=0; iy<RH; iy++)
        {
          float nx = ix-12+24*noise(ix/15.0f+1000, iy/15.0f+1000);
          float ny = iy-12+24*noise(ix/15.0f+1000, iy/15.0f+2000);
          float m = noise(nx/200.0f, ny/200.0f)+0.05;
          float h = 2.5*sq(sq(m))*abs(noise(nx/30.0f, ny/30.0f+1000)-.5)+0.65*(noise(nx/300.0f+1000, ny/300.0f)-.5);

          float forest = (-1+2*noise(nx/100.0f+2000, ny/100.0f+h))/10.0f;

          color col = get_col(pg, h+0.01*sin(h*PI*32), m, iy);
          pg.stroke(col);

          if ((forest+0.05*sq(random(1)))*(sq(random(1))*4) > h*1.5 && h > 0.01) //it's a tree!
          {
            pg.stroke(pg.lerpColor(col, pg.color(80, 255, 100), random(1))) ;
            h += random(0.05);
          }

          if (h*80 > 1)
            pg.line(width/2+ix-iy, OrgY+ix/2+iy/2-80*h, width/2+ix-iy, OrgY+ix/2+iy/2);
          else
            pg.point(width/2+ix-iy, OrgY+ix/2+iy/2);
        }
        ix ++;
      }
    }
    pg.pop();
    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(#ff0000);
  }

  color get_col(PGraphics pg, float h, float m, int iy) {
    if (h < 0)
      return(pg.color(120-30*h-max(350*h, -50), 150-100*h, 200-max(350*h, -50)+100*h+100*max(0, -2.25+3.5*noise((ix-iy)/40.0f, (ix+iy)/4.0f))));
    else if (h > 0.01)
      return(pg.color(100-m*50-min(20, h*100), 200-h*300, 150+200*h-4*(ix % 4 != 0 ? 0 : 1)+4*(iy % 4 != 0 ? 0 : 1)));
    else
      return(pg.lerpColor(pg.color(40, 100, 240-4*(ix % 4 != 0 ? 0 : 1)+4*(iy % 4 != 0 ? 0 : 1)), pg.color(100-m*50-min(20, h*100), 200-h*300, 150+200*h-4*(ix % 4 != 0 ? 0 : 1)+4*(iy % 4 != 0 ? 0 : 1)), h/0.01));
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    if (key == ' ') {
      ix = 0;
      noiseSeed((int)random(10000));
    }
  }
}
