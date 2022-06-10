// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】MOOVO Bernardさん
// 【作品名】New Processing LOGO
// https://openprocessing.org/sketch/1246077
//

class GameSceneCongratulations112 extends GameSceneCongratulationsBase {
  /*
         BERNARD MOUVAULT
   */

  PVector Centre;
  float Rayon;
  PVector Pt_C1, Pt_C2, Pt_C3, Pt_C4;    // points d'ancrage du sketch

  float T0;                            // Début demi période
  float Periode = 15000;              // Demi période (en milli secondes)
  boolean pente = true;                  // true si BETA croissant

  float BETA;                         // Angle de déviation en radians

  O_Cluster k1;                           // Object O_Cluster

  PVector vect_h, vect_v;                // Vecteurs UNITE GRID horizontal et vertical

  float ITERATIONS_0, COLORS_0, RANDOM_LOGO_0, SPAN_LOGO_0; // Curseurs et "pente" au précédent "draw"
  boolean PENTE_0; // Curseurs et "pente" au précédent "draw"

  //float[] NB_GRID = { 1, 3, 7, 15, 31, 63, 127 };  // Nbre GRID = f(nombre d'itérations)

  final int NB_GRID_0 = 7;                    //= nb_GRID[ ITERATIONS - 1 ] / nb_GRID[ ITERATIONS ];;
  final int NB_GRID_1 = 15;                    //= nb_GRID[ ITERATIONS - 1 ] / nb_GRID[ ITERATIONS ];;

  int gNUM_GRID;                               // Numéro de GRID

  //=== Définition des GRIDs et du LOGO associé

  boolean init_GRID;

  float[] random_shape = new float[8+1];  // Initialisé de 0 à 8 dans setup()
  int[] random_color = new int[30+1];   // Initialisé de 0 à 30 dans setup()

  LinesLogo[] LINES_LOGO = new LinesLogo[NB_GRID_1];
  color[] COLOR_GRID = new color[NB_GRID_1];

  class ColorLines {
    color[] c;
    ColorLines(color c0, color c1, color c2) {
      c = new color[3];
      c[0] = c0;
      c[1] = c1;
      c[2] = c2;
    }
    color get(int i) {
      return c[i];
    }
  }
  ColorLines[] COLORS_LINES = new ColorLines[NB_GRID_1];

  float[] t0_GRID_R = new float[NB_GRID_1];
  float[] periode_GRID_R = new float[NB_GRID_1];

  //===

  final color[] PALETTE_0 = {#ffffff, #000000, #1e32aa, #82afff, #0564ff};

  final color[][] PALETTES = {
    {#e9dbce, #fceade, #ea526f, #e2c290, #6b2d5c},
    {#223843, #e9dbce, #eff1f3, #dbd3d8, #d8b4a0},
    {#e29578, #ffffff, #006d77, #83c5be, #ffddd2},
    {#e9dbce, #ffffff, #cc3528, #028090, #00a896},
    {#e9dbce, #f8f7c1, #f46902, #da506a, #fae402},
    {#e42268, #fb8075, #761871, #5b7d9c, #a38cb4},
    {#f9b4ab, #fdebd3, #264e70, #679186, #bbd4ce},
    {#1f306e, #553772, #8f3b76, #c7417b, #f5487f},
    {#e0f0ea, #95adbe, #574f7d, #503a65, #3c2a4d},
    {#413e4a, #73626e, #b38184, #f0b49e, #f7e4be},
    {#ff4e50, #fc913a, #f9d423, #ede574, #e1f5c4},
    {#99b898, #fecea8, #ff847c, #e84a5f, #2a363b},
    {#69d2e7, #a7dbd8, #e0e4cc, #f38630, #fa6900},
    {#fe4365, #fc9d9a, #f9cdad, #c8c8a9, #83af9b},
    {#ecd078, #d95b43, #c02942, #542437, #53777a},
    {#556270, #4ecdc4, #c7f464, #ff6b6b, #c44d58},
    {#774f38, #e08e79, #f1d4af, #ece5ce, #c5e0dc},
    {#e8ddcb, #cdb380, #036564, #033649, #031634},
    {#490a3d, #bd1550, #e97f02, #f8ca00, #8a9b0f},
    {#594f4f, #547980, #45ada8, #9de0ad, #e5fcc2},
    {#00a0b0, #6a4a3c, #cc333f, #eb6841, #edc951},
    {#5bc0eb, #fde74c, #9bc53d, #e55934, #fa7921},
    {#ed6a5a, #f4f1bb, #9bc1bc, #5ca4a9, #e6ebe0},
    {#ef476f, #ffd166, #06d6a0, #118ab2, #073b4c},
    {#22223b, #4a4e69, #9a8c98, #c9ada7, #f2e9e4},
    {#114b5f, #1a936f, #88d498, #c6dabf, #f3e9d2},
    {#ff9f1c, #ffbf69, #ffffff, #cbf3f0, #2ec4b6},
    {#3d5a80, #98c1d9, #e0fbfc, #ee6c4d, #293241},
    {#06aed5, #086788, #f0c808, #fff1d0, #dd1c1a},
    {#540d6e, #ee4266, #ffd23f, #3bceac, #0ead69},
    {#c9cba3, #ffe1a8, #e26d5c, #723d46, #472d30} };

  final float  ITERATIONS = 3;
  final float  COLORS = 1;
  final float  RANDOM_LOGO = 1;
  final float  SPAN_LOGO = 9;

  final float[] LINE1_0 = { 4, 2, 1, 6};
  final float[] LINE2_0 = { 1, 3, 2, 5 };
  final float[] LINE3_0 = { 4, 1, 7, 1, 7, 5, 4, 5 };

  final float[] LINE1_1 = { 6, 4, 2, 1};
  final float[] LINE2_1 = { 5, 1, 3, 2 };
  final float[] LINE3_1 = { 7, 4, 7, 7, 3, 7, 3, 4 };

  class LinesLogo {
    FloatList[] lines = new FloatList[3];
    LinesLogo(float[] line0, float[] line1, float[] line2) {
      FloatList fl = new FloatList();
      for (int i = 0; i < line0.length; i++) {
        fl.push(line0[i]);
      }
      lines[0] = fl;

      fl = new FloatList();
      for (int i = 0; i < line1.length; i++) {
        fl.push(line1[i]);
      }
      lines[1] = fl;

      fl = new FloatList();
      for (int i = 0; i < line2.length; i++) {
        fl.push(line2[i]);
      }
      lines[2] = fl;
    }
    FloatList get(int i) {
      return lines[i];
    }
  }
  //LINES_LOGO_0 = [ LINE1_0, LINE2_0, LINE3_0 ];    // Rotation en C3
  LinesLogo LINES_LOGO_0 = new LinesLogo(LINE1_0, LINE2_0, LINE3_0);
  //LINES_LOGO_1 = [ LINE1_1, LINE2_1, LINE3_1 ];    // Rotation en C4
  LinesLogo LINES_LOGO_1 = new LinesLogo(LINE1_1, LINE2_1, LINE3_1);

  //float* LINES_LOGO_0[] = {
  //  &LINE1_0[0], &LINE2_0[0], &LINE3_0[0]  // 長さの話はあるけども♪
  //};
  //float* LINES_LOGO_1[] = {
  //  &LINE1_1[0], &LINE2_1[0], &LINE3_1[0]  // 長さの話はあるけども♪
  //};

  PGraphics pg;

  //====================================================
  //==== SETUP, SETUP, SETUP, .........
  //====================================================

  @Override void setup() {
    colorMode(RGB, 255, 255, 255, 255);
    imageMode(CORNER);


    // === Points d'ancrage du sketch

    Centre = new PVector((width / 2) * 1.0, (height / 2) * 1.0);
    Rayon = width * 0.75 / 2.0f;

    //== Points Haut-Gauche (C2) et Bas-Droit (C4) du carré de base

    Pt_C1 = new PVector(Rayon, -Rayon);
    Pt_C1.add(Centre);

    Pt_C2 = new PVector(- Rayon, -Rayon);
    Pt_C2.add(Centre);

    Pt_C3 = new PVector(- Rayon, Rayon);
    Pt_C3.add(Centre);

    Pt_C4 = new PVector(Rayon, Rayon);
    Pt_C4.add(Centre);

    //=== Init du tableau des indices pour random_color

    for (int j = 0; j < random_color.length; j++) {
      random_color[j] = j;
    }

    //==== Initialisation des LOGOs aléatoires sur tous les GRIDs

    init_GRID = true;

    ITERATIONS_0 = -1;
    COLORS_0 = 1;
    RANDOM_LOGO_0 = 1;
    SPAN_LOGO_0 = 9;

    //=== LOGO "OFFICIEL" - COULEURS et COURBES DANS 2 REPERES DIFFERENTS

    COLOR_GRID[0]    = PALETTE_0[0];
    //  COLORS_LINES[0] = { PALETTE_0[2], PALETTE_0[3], PALETTE_0[4] };
    COLORS_LINES[0] = new ColorLines(PALETTE_0[2], PALETTE_0[3], PALETTE_0[4]);

    //===

    //var LINE1_0 = [ 4, 2, 1, 6];
    //var LINE2_0 = [ 1, 3, 2, 5 ];
    //var LINE3_0 = [ 4, 1, 7, 1, 7, 5, 4, 5 ];

    //var LINE1_1 = [ 6, 4, 2, 1];
    //var LINE2_1 = [ 5, 1, 3, 2 ];
    //var LINE3_1 = [ 7, 4, 7, 7, 3, 7, 3, 4 ];

    //LINES_LOGO_0 = [ LINE1_0, LINE2_0, LINE3_0 ];    // Rotation en C3
    //LINES_LOGO_1 = [ LINE1_1, LINE2_1, LINE3_1 ];    // Rotation en C4

    // === Animation - Début de demi période

    T0 = millis();

    // Creation d'un objet O_Cluster

    k1 = new O_Cluster();

    pg = createGraphics(width, height);
  }

  //====================================================
  //==== DRAW, DRAW, DRAW, .........
  //====================================================

  @Override void draw() {
    pg.beginDraw();
    pg.colorMode(HSB, 360, 100, 100);
    pg.background(200, 72, 47);

    pg.smooth();
    pg.strokeCap(SQUARE);

    //===

    //NB_GRID_1 = NB_GRID[ ITERATIONS ];        // NB GRIDs après la dernière itération
    //NB_GRID_0 = NB_GRID[ ITERATIONS - 1 ];    // NB GRIDs  après l'avant dernière itération

    //=== Init des points utilisables sur GRID (SPAN_LOGO réduit or SPAN_LOGO full)

    //  random_shape.length = 0;

    for (int j = 0; j < 9; j++) {
      random_shape[j] = j;
    }

    //=== Création aléatoire de la BDD des LOGOs

    gNUM_GRID = 0;            // # GRID

    if (ITERATIONS == ITERATIONS_0) {
    } else {
      init_GRID = true;
      ITERATIONS_0 = ITERATIONS;
    }
    if (COLORS == COLORS_0) {
    } else {
      init_GRID = true;
      COLORS_0 = COLORS;
    }
    if (RANDOM_LOGO == RANDOM_LOGO_0) {
    } else {
      init_GRID = true;
      RANDOM_LOGO_0 = RANDOM_LOGO;
    }
    if (SPAN_LOGO == SPAN_LOGO_0) {
    } else {
      init_GRID = true;
      SPAN_LOGO_0 = SPAN_LOGO;
    }
    if (pente == PENTE_0) {
    } else {
      init_GRID = true;
      PENTE_0 = pente;
    }

    FUNCTION_RANDOM_LOGO();              //  Creation aléatoire d'un LOGO pour chaque GRID (carré)

    init_GRID = false;

    // Pilotage de l'angle BETA déplaçant le point M (par exemple sur l'arc
    // de cercle de centre C3 et passant par C2 et C4 )

    float delta_t = millis() - T0;

    if ( delta_t >= Periode ) {
      T0 = millis();
      pente = !pente;
    }

    if (pente) {
      BETA = -HALF_PI * map(delta_t, 0.0, Periode, 0.0, 1.0);
      k1.carre_de_base(Pt_C2, Pt_C4);
    } else {
      BETA = -HALF_PI * map(delta_t, 0.0, Periode, 1.0, 0.0);
      k1.carre_de_base(Pt_C3, Pt_C1);
    }

    // === Creation du carré de base, Iterate et Display

    k1.Squares.get(0).display(pg);

    //=

    for (float i = 0; i < ITERATIONS; i++) {

      k1.iterate();

      for (int j = 0; j < k1.Squares.size(); j++) {
        k1.Squares.get(j).display(pg);
      }
    }

    pg.endDraw();
    image(pg, 0, 0);

    logoRightLower(color(255, 0, 0));
  }

  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  //
  //  CREATION ALEATOIRE DE LOGOs ( 2 + 2 + 4 = 8 couples de points X-Y
  //  et 3 couleurs pour chaque LOGO )
  //

  void FUNCTION_RANDOM_LOGO () {

    for (int i = 0; i < NB_GRID_1; i++) {

      //=== Traitement des 2 LOGOs de base qui n'évoluent pas
      //=== (couleurs figées pour : 2 lignes + 1 bézier (officiel)

      if (i == 0 ) {

        //=== Coordonnées des 8 points du LOGO officiel dans
        //     2 repères différents (rotation en C3 puis C4)

        if (pente) {
          LINES_LOGO[0] = LINES_LOGO_0;
        }  // Rotation en C3
        else {
          LINES_LOGO[0] = LINES_LOGO_1;
        }  // Rotation en C4
      } else if ( i == NB_GRID_0 ) {

        COLOR_GRID[i]    = COLOR_GRID[0];
        COLORS_LINES[i] = COLORS_LINES[0];

        //=== Coordonnées des 8 points du LOGO officiel dans
        //     2 repères différents (rotation en C3 puis C4)

        LINES_LOGO[i] = LINES_LOGO[0];
      }

      //=== Traitement des GRIDs et LOGOs animés

      else {

        if ( init_GRID || (millis() - t0_GRID_R[i]) > periode_GRID_R[i] ) {

          t0_GRID_R[i] = millis();
          periode_GRID_R[i] = random(1500, 5000);

          //===

          color[] palette_R = PALETTES[P5JSrandom(random_color)];

          COLOR_GRID[i]    = palette_R[0];
          //          COLORS_LINES[i] = [ palette_R[2], palette_R[3], palette_R[4] ];
          COLORS_LINES[i] = new ColorLines(palette_R[2], palette_R[3], palette_R[4]);

          //===  Création de 3 lignes au hazard (droite ou bézier => 4 ou 8 points)

          int P_F, NB_PTS;

          P_F = int(random(0.0, 2.0));

          //console.log(P_F);

          //        if (P_F << 1) {
          if (P_F != 0) {
            NB_PTS = 4;
          } else {
            NB_PTS = 8;
          }
          float[] L1 = new float[NB_PTS];

          for (int k1 = 0; k1 <NB_PTS; k1++) {
            L1[k1] = P5JSrandom(random_shape);
          }

          //=

          P_F = int(random(0.0, 2.0));

          //        if (P_F << 1) {
          if (P_F != 0) {
            NB_PTS = 4;
          } else {
            NB_PTS = 8;
          }
          float[] L2 = new float[NB_PTS];

          for (int k2 = 0; k2 <NB_PTS; k2++) {
            L2[k2] = P5JSrandom(random_shape);
          }

          //=

          P_F = int(random(0.0, 2.0));

          //        if (P_F << 1) {
          if (P_F != 0) {
            NB_PTS = 4;
          } else {
            NB_PTS = 8;
          }
          float[] L3 = new float[NB_PTS];

          for (var k3 = 0; k3 <NB_PTS; k3++) {
            L3[k3] = P5JSrandom(random_shape);
          }

          //====

          LINES_LOGO[i] = new LinesLogo(L1, L2, L3);
        }
      }  // <= End boucle sur les GRIDs et LOGOS animés
    }      // <= End GRID figées ou animées
  }        // <= End function

  /////////////////////////////////////////////////

  class O_Carre {

    // Paramètres transmis à la class O_Carre => 2 sommets de la diagonale
    // d'un carré (Coin_HG et Coin_BD)
    //
    // "constructor" détermine le milieu de la diagonale et les
    // 2 autres sommets du carré
    //
    // La méthode "display" traite l'habillage d'un carré
    //

    PVector Coin_HG;
    PVector Coin_BD;
    PVector P_CG;
    PVector Coin_HD;
    PVector Coin_BG;
    int NUM_GRID;

    O_Carre(PVector Coin_HG, PVector Coin_BD) {

      this.Coin_HG = Coin_HG.copy();
      this.Coin_BD = Coin_BD.copy();

      this.P_CG = PVector.sub(this.Coin_BD, this.Coin_HG); // Centre du carré
      this.P_CG.mult(0.5);
      this.P_CG.add(this.Coin_HG); // Centre de Gravité

      this.Coin_HD = PVector.sub(this.Coin_BD, this.P_CG);
      this.Coin_HD.rotate(- HALF_PI);
      this.Coin_HD.add(this.P_CG);

      this.Coin_BG = PVector.sub(this.P_CG, this.Coin_HD);
      this.Coin_BG.add(this.P_CG);

      this.NUM_GRID = gNUM_GRID;
      gNUM_GRID++;
    }

    /////////////////////////////////////////////////
    // Méthodes d'habillage et d'affiche des carrés
    /////////////////////////////////////////////////

    void display(PGraphics pg) {
      //=== Vecteurs UNITE GRID horizontal et vertical

      vect_h = PVector.sub(this.Coin_HD, this.Coin_HG);
      vect_h.div(8);

      vect_v = PVector.sub(this.Coin_BG, this.Coin_HG);
      vect_v.div(8);

      //////////////////////////////////////
      //=== GRID
      //////////////////////////////////////

      int GRID_number = this.NUM_GRID;

      pg.fill(COLOR_GRID[GRID_number]);
      pg.noStroke();
      pg.quad(this.Coin_HG.x, this.Coin_HG.y, this.Coin_HD.x, this.Coin_HD.y, this.Coin_BD.x, this.Coin_BD.y, this.Coin_BG.x, this.Coin_BG.y);

      //=== GRID lignes horizontales et verticales

      PVector pt_H = this.Coin_HG.copy();
      PVector pt_B = this.Coin_BG.copy();

      PVector pt_G = this.Coin_HG.copy();
      PVector pt_D = this.Coin_HD.copy();

      pg.stroke(0);

      for (int n_l = 0; n_l < 9; n_l++) {

        if (n_l == 0 || n_l == 8) {
          pg.strokeWeight(2.5);
        } else {
          pg.strokeWeight(1.0);
        }

        pg.line(pt_H.x, pt_H.y, pt_B.x, pt_B.y);
        pg.line(pt_G.x, pt_G.y, pt_D.x, pt_D.y);

        pt_H.add(vect_h);
        pt_B.add(vect_h);
        pt_G.add(vect_v);
        pt_D.add(vect_v);
      }

      //////////////////////////////////////
      //=== NEW LOGO ( 1 Bezier + 2 lines )
      //////////////////////////////////////

      pg.strokeWeight(PVector.dist(this.Coin_HG, this.Coin_HD) * 1.5 / 8.0f);     // strokeWeight du LOGO;

      //===

      pg.push();

      pg.translate(this.Coin_HG.x, this.Coin_HG.y);

      PVector Point1, Point2, Point3, Point4;

      LinesLogo LINES_G = LINES_LOGO[GRID_number];
      ColorLines COLORS_G = COLORS_LINES[GRID_number];

      for ( int i = 0; i < 3; i++ ) {
        FloatList LINE_i = LINES_G.get(i);

        int LONG = LINE_i.size();

        if (LONG == 4) {

          Point1 = vect_h.copy();
          Point1.mult(LINE_i.get(0));              // <= X1
          PVector u = vect_v.copy();
          u.mult(LINE_i.get(1));                  // <= Y1
          Point1.add(u);

          Point2 = vect_h.copy();
          Point2.mult(LINE_i.get(2));              // <= X2
          u = vect_v.copy();
          u.mult(LINE_i.get(3));                  // <= Y2
          Point2.add(u);

          pg.stroke(COLORS_G.get(i) );
          pg.line(Point1.x, Point1.y, Point2.x, Point2.y);
        } else if (LONG == 8) {

          Point1 = vect_h.copy();
          Point1.mult(LINE_i.get(0));              // <= X1
          PVector u = vect_v.copy();
          u.mult(LINE_i.get(1));                  // <= Y1
          Point1.add(u);

          Point2 = vect_h.copy();
          Point2.mult(LINE_i.get(2));              // <= X2
          u = vect_v.copy();
          u.mult(LINE_i.get(3));                  // <= Y2
          Point2.add(u);

          Point3 = vect_h.copy();
          Point3.mult(LINE_i.get(4));              // <= X3
          u = vect_v.copy();
          u.mult(LINE_i.get(5));                  // <= Y3
          Point3.add(u);

          Point4 = vect_h.copy();
          Point4.mult(LINE_i.get(6));              // <= X4
          u = vect_v.copy();
          u.mult(LINE_i.get(7));                  // <= Y4
          Point4.add(u);

          pg.noFill();
          pg.stroke(COLORS_G.get(i) );
          pg.bezier(Point1.x, Point1.y, Point2.x, Point2.y, Point3.x, Point3.y, Point4.x, Point4.y);
        }
      }

      //===

      pg.pop();
    }          // <= End display
  }                  // <= End class O_Carre

  /////////////////////////////////////////////////
  /////////////////////////////////////////////////

  class O_Cluster {
    ArrayList<O_Carre> Squares;
    PVector start;
    PVector end;

    O_Cluster() {
      this.Squares = new ArrayList();
    }


    // Init du carré de base de la liste this.Squares

    void carre_de_base (PVector start, PVector end) {
      this.start = start.copy();
      this.end = end.copy();

      //    this.Squares.length = 0; // Vidage du tableau
      this.Squares.clear(); // Vidage du tableau

      this.Squares.add(new O_Carre(this.start, this.end));
    }

    ////  Itération sur les carrés: 1 carré => 2 carrés enfants

    void iterate() {
      ArrayList<O_Carre> now = new ArrayList();

      for (int Num_in_iter = 0; Num_in_iter < this.Squares.size(); Num_in_iter++) {

        O_Carre O_C_i = this.Squares.get(Num_in_iter);

        //  Méthode de détermination du point M mobile sur le 1/4
        //  de cercle de centre Coin_BG et passant par "Coin_HG" et "Coin_BD"

        PVector MM = PVector.sub(O_C_i.Coin_BD, O_C_i.Coin_BG);
        MM.rotate(BETA);
        MM.add(O_C_i.Coin_BG);

        PVector S = O_C_i.Coin_HG;
        PVector E = O_C_i.Coin_BD;

        now.add(new O_Carre(S, MM));
        now.add(new O_Carre(MM, E));
      }

      this.Squares = now; //return now ;
    }

    //===
  }

  /////////////////////////////////////////////////
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
