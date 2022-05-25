// コングラチュレーション画面
//
// こちらがオリジナルです。
// https://openprocessing.org/sketch/1361249
//

class GameSceneCongratulations198 extends GameSceneCongratulationsBase {
  int ix;
  int RW;
  int RH;
  String placename;
  int place;
  int[] termap = {4, 4, 4,
    2, 5, 3,
    2, 1, 3};
  int terw = 3;
  int terh = 3;
  color[] treebiomecol;
  color[] wallcol;
  color[] roofcol;

  float m, v, l, t;

  float treeheightdeterrent;
  float cityheightdeterrent;

  int iy;
  float nx, ny;

  PGraphics pg;

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);

    background(60);

    ix = 0;
    RW = min(width, height);
    RH = RW;

    colorMode(HSB, 255);
    color[] treebiomecolHSB = {color(80, 255, 100), color(65, 200, 85), color(110, 120, 160), color(110, 120, 100), color(80, 180, 130)};
    treebiomecol = treebiomecolHSB;
    color[] wallcolHSB = {color(0, 0, 220), color(25, 100, 200), color(40, 50, 230), color(30, 130, 170), color(40, 150, 200)};
    wallcol = wallcolHSB;
    color[] roofcolHSB = {color(0, 150, 250), color(10, 150, 250), color(20, 150, 250), //Greece
      color(10, 100, 180), color(10, 100, 150), color(10, 100, 120), //Florida
      color(10, 50, 145), color(10, 50, 130), color(10, 50, 115), //Morocco
      color(10, 50, 135), color(10, 50, 120), color(10, 50, 105), //Norway
      color(5, 200, 150), color(15, 200, 150), color(25, 200, 150)};  //Netherlands
    roofcol = roofcolHSB;

    placename = "Netherlands";
    switch (placename)
    {
    case "Greece":
      place = 1 ;
      break;
    case "Florida":
      place = 2 ;
      break;
    case "Morocco":
      place = 3 ;
      break;
    case "Norway":
      place = 4 ;
      break;
    case "Netherlands":
      place = 5 ;
      break;
    }

    pg = createGraphics(width, height);
  }

  boolean drawUpdate(PGraphics pg) {
    if (RW <= ix) {
      // 描画が終わったのでfalseを返す
      return false;
    }

    pg.beginDraw();
    // ちょっといやらしいがｗ
    if (ix == 0) {
      noiseSeed((long)random(10000)) ;
      pg.background(100);
    }

    // 適当に下へずらすにゃ
    pg.translate(0, 100);

    pg.noSmooth();

    for (var nc=0; nc<5; nc++)
    {
      for (iy=0; iy<RH; iy++)
      {
        float hot;

        //ix = rx-ry ; iy = rx+ry
        nx = ix-12+24*noise(ix/15.0f+1000, iy/15.0f+1000);
        ny = iy-12+24*noise(ix/15.0f+1000, iy/15.0f+2000);
        m = noise(nx/200.0f, ny/200.0f)+0.05;
        v = noise(nx/30.0f, ny/30.0f+1000);
        var a = noise(nx/2000.0f, ny/2000.0f+5000);
        l = noise(nx/300.0f+1000, ny/300.0f)-.5+.2*(a-.5);
        t = noise(nx/2000.0f, ny/2000.0f+3000);

        var humid = max(0, min(2, 1+6*(a-.5))) ;
        if (abs((humid%1)-.5) < .125) {
          humid += 3*(humid-floor(humid)-.5);
        } else {
          humid = round(humid);
        }
        hot = max(0, min(2, 1+6*(t-.5))) ;
        if (abs((hot % 1)-.5) < .125) {
          hot += 3*(hot-floor(hot)-.5);
        } else {
          hot = round(hot);
        }

        place = termap[round(humid)+terw*round(hot)];
        var flhumid = termap[floor(humid)+terw*round(hot)];
        var clhumid = termap[ceil(humid)+terw*round(hot)];
        var flhot = termap[round(humid)+terw*floor(hot)];
        var clhot = termap[round(humid)+terw*ceil(hot)];


        var treeheightdeterrent = 1.5 ;
        var cityheightdeterrent = 0.5;
        var snowcol = color(180, 10, 230+abs(20*sin(v*20)));

        float h;
        color col;
        if (flhumid == clhumid && flhot == clhot && flhot == flhumid)
        {
          h = get_height(flhot, 1);
          col = get_col(flhot, h+0.01*sin(h*PI*32), m);
        } else
        {
          int flfl = termap[floor(humid)+terw*floor(hot)];
          int clfl = termap[ceil(humid)+terw*floor(hot)];
          int flcl = termap[floor(humid)+terw*ceil(hot)];
          int clcl = termap[ceil(humid)+terw*ceil(hot)];
          int nhu = (int)humid % 1;
          int nho = (int)hot % 1;
          h = lerp(lerp(get_height(flfl, (1-nhu)*(1-nho)), get_height(clfl, (nhu)*(1-nho)), nhu),
            lerp(get_height(flcl, (1-nhu)*(  nho)), get_height(clcl, (nhu)*(  nho)), nhu), nho);

          var nh = h+0.01*sin(h*PI*32);
          color col1 = get_col(flfl, nh, m) ;
          color col2 = get_col(clfl, nh, m);
          color col3 = get_col(flcl, nh, m) ;
          color col4 = get_col(clcl, nh, m);
          pg.colorMode(RGB, 255) ;
          col = lerpColor(lerpColor(col1, col2, humid % 1), lerpColor(col3, col4, humid % 1), hot % 1) ;
          pg.colorMode(HSB, 255);
        }

        float forest = (-1+2*noise(nx/100+2000, ny/100+h))/10.0f;
        pg.colorMode(RGB, 255) ;
        pg.stroke(lerpColor(col, snowcol, min(.9, -t*10))) ;
        pg.colorMode(HSB, 255);

        nx = ix-75+150*noise(ix/250.0f+1000, iy/250.0f+1000); //new, lower frequency distortion
        ny = iy-75+150*noise(ix/250.0f+1000, iy/250.0f+2000);
        int houseid = floor(nx/8)*829+floor(ny/8)*1091;
        float housenoise = noise(floor(nx/8.0f)/12.0f, floor(ny/8)/12.0f+100);

        if (place == 5 && forest < 0.02 && abs(housenoise-.5) < .1 && h > 0.01 && m < .65 && h < 0.2 && nx % 48 > 2 && ny % 48 > 2)
        {
          var wheatcol = color(9*(5*floor(nx/48.0f)+3*floor(ny/48.0f)) % 95, 255, 128+random(128));
          pg.colorMode(RGB, 255);
          pg.stroke(lerpColor(col, wheatcol, .2));
          pg.colorMode(HSB, 255);
          h+=random(0.01);
        } else if (nx % 8 < 6 && ny % 8 < 6 && h > 0.01 && m < .8 && housenoise > h*cityheightdeterrent+0.5+0.4*noise(houseid))
        {
          pg.stroke((nx % 8 > 4.5 || ny % 8 > 4.5) ? wallcol[place-1] : roofcol[(place-1)*3+(houseid%3)]) ;
          h += 0.02;
        } else if ((forest+0.05*sq(random(1)))*(sq(random(1))*4) > h*treeheightdeterrent && h > 0.01) //it's a tree!
        {
          pg.stroke(lerpColor(col, t < 0 ? color(110, 1, 230) : treebiomecol[place-1], random(1))) ;
          h += random(0.05);
        }

        if (h*80 > 1)
          pg.line(width/2.0f+ix-iy, ix/2+iy/2.0f-80*h, width/2.0f+ix-iy, ix/2.0f+iy/2.0f);
        else
          pg.point(width/2.0f+ix-iy, ix/2.0f+iy/2.0f);
      }
      ix ++;
    }
    pg.endDraw();

    // まだ描画は終わっていないのでtrueを返す
    return true;
  }
  @Override void draw() {
    drawUpdate(pg);
    image(pg, 0, 0);
    logoRightLower(#ff0000);
  }

  float get_height(int p, int i) {
    float h = 0.0f;
    switch (p)
    {
    case 1:
      h = 2.5*sq(sq(m))*abs(v-.5)+0.65*(l) ;
      break;
    case 2:
      h = sq(m-.5)/2.0f+l/3.0f+2.5*sq(sq(m-.1))*abs(v-.5) ;
      h += 0.75*max(0, .1-abs(h))*(abs(sin(v*2*PI))-.5) ;
      break;
    case 3:
      h = m/5.0f+v/10.0f+l/2.0f ;
      h += max(0, min(1, h*10))*sin(ix/15.0f+iy/10.0f+m*80)/10.0f*(sq(l+.55)+v/10.0f) ;
      treeheightdeterrent += 1.5*i ;
      cityheightdeterrent += 1.5*i ;
      break;
    case 4:
      h = m/5.0f+v/10.0f+l/1.8-.1 ;
      h += abs(v-.5)*max(0, h)*m*8 ;
      cityheightdeterrent = 2 ;
      t += i*(-h-.55+noise(nx/15.0f+2000, ny/15.0f)/5.0f) ;
      break;
    case 5:
      h = sq(m-.5)/3.0f+l/4.0f+2.5*sq(sq(m-.1))*abs(v-.5) ;
      h += .06-0.1*sq(sq(sq(0.05+sin(ix/150+l*3+t*5+m*4)))) ;
      break;
    }
    return(h);
  }

  color get_col(int p, float h, float m) {
    switch(p)
    {
    case 5: //NETHERLANDS
      if (h < 0)  //water
        return(color(150-30*h-max(200*h, -15), 110-30*h+max(200*h, -30)-100*h-100*max(0, -2+3.5*noise((ix-iy)/40.0f, (ix+iy)/4.0f)), 240+h*65));
      else        //land
      return(color(70-min(20, h*100)-h*55, 200-h*600, 150+min(h*500, 30)+100*h-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)));

    case 4: //NORWAY
      if (h < 0)  //water
        return(color(150-30*h-max(200*h, -15), 130-30*h+max(200*h, -30)-100*h-100*max(0, -2+3.5*noise((ix-iy)/40.0f, (ix+iy)/4.0f)), 250));
      else        //land
      return(color(50-min(25, h*200)-h*50, 120-h*300, 150+min(h*500, 30)-100*h-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)));

    case 3: //MOROCCO
      if (h < 0)
        return(color(120-30*h-max(350*h, -50), 150-100*h, 200-max(350*h, -50)+100*h+100*max(0, -2+3.5*noise((ix-iy)/40.0f, (ix+iy)/4.0f))));
      else
        return(color(80-min(40, h*500)-h*50, 100-h*150, 150+min(h*500, 30)+150*h-5*((ix % 4) != 0 ? 0 : 1)+5*((iy % 4) != 0 ? 0 : 1)));

    case 2: //FLORIDA
      if (h < 0)
        return(color(160-30*h+10*max(0, 1+h*15), 150-100*h-150*max(0, -2.25+3.5*noise((ix-iy)/40.0f+1500, (ix+iy)/8.0f)), 255+h*500-100*max(0, 1+h*15)));
      else
        return(color(120-m*20-min(60, h*300), 150-h*200, 100+min(h*500, 30)+150*h-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)));

    case 1: //GREECE
      if (h < 0)
        return(color(120-30*h-max(350*h, -50), 150-100*h, 200-max(350*h, -50)+100*h+100*max(0, -2+3.5*noise((ix-iy)/40.0f, (ix+iy)/4.0f))));
      else if (h > 0.01)
        return(color(100-m*50-min(20, h*100), 200-h*300, 150+200*h-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)));
      else
        return(lerpColor(color(40, 100, 240-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)), color(100-m*50-min(20, h*100), 200-h*300, 150+200*h-4*((ix % 4) != 0 ? 0 : 1)+4*((iy % 4) != 0 ? 0 : 1)), h/0.01));
    }
    return color(0);
  }

  @Override void mousePressed() {
    ix = 0;
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
