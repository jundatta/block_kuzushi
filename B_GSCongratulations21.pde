// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Rodrigo Frenkさん
// 【作品名】Arreglos/cuerpos-celestes
// https://openprocessing.org/sketch/1188777
//

class GameSceneCongratulations21 extends GameSceneCongratulationsBase {
  class CuerpoCeleste {
    float x;
    float y;
    float distancia;
    float hue;
    float velocidadX;
    float velocidadY;
    CuerpoCeleste(float _x, float _y, float _distancia,
      float _hue, float _velocidadX, float _velocidadY) {
      x = _x;
      y = _y;
      distancia = _distancia;
      hue = _hue;
      velocidadX = _velocidadX;
      velocidadY = _velocidadY;
    }
  }

  final int cuerposCelestesNumero = 200;
  CuerpoCeleste[] cuerposCelestes = new CuerpoCeleste[cuerposCelestesNumero];

  float tamannoMinimo;
  float crecimiento;
  float velocidadGeneral;

  CuerpoCeleste generarCuerpoCeleste( float numero ) {
    return new CuerpoCeleste(random(width), random(height), numero,
      map(random(1), 0, 1, 10, 60+numero),
      random(numero/50), 0);
  }

  void dibujarCuerpoCeleste( CuerpoCeleste cuerpoCeleste ) {
    float tamanno = tamannoMinimo + (cuerpoCeleste.distancia * crecimiento);
    tamanno = exp(tamanno/2);

    fill(
      cuerpoCeleste.hue,
      // hacer exponencial la saturacion para obtener mas contraste entre cercanos y lejanos
      exp(cuerpoCeleste.distancia/40),
      100,
      70
      );

    // anillos, 1 de cada 10 los tiene
    if ( cuerpoCeleste.distancia % 10 == 0 ) {
      push();
      translate(cuerpoCeleste.x, cuerpoCeleste.y);
      rotate(cuerpoCeleste.distancia);
      fill(360-cuerpoCeleste.hue, 20, 80, 50);

      ellipse( 0, 0, tamanno*2, tamanno/3 );
      pop();
    }

    // planeta
    ellipse( cuerpoCeleste.x, cuerpoCeleste.y, tamanno, tamanno );
  }

  void animarCuerpoCeleste(CuerpoCeleste cuerpoCeleste) {
    cuerpoCeleste.x += cuerpoCeleste.velocidadX * velocidadGeneral;
    cuerpoCeleste.x %= width;

    cuerpoCeleste.y += cuerpoCeleste.velocidadY * velocidadGeneral;
    cuerpoCeleste.y %= height;
  }

  @Override void setup() {
    colorMode(HSB, 360, 100, 100, 100);

    textSize( 10 );

    noStroke();
    mouseX = width / 4;
    textAlign( CENTER );

    tamannoMinimo = 2;
    crecimiento = .025;

    velocidadGeneral = 1;

    for ( int i=0; i<cuerposCelestesNumero; i++) {
      cuerposCelestes[i]=generarCuerpoCeleste(i);
    }
  }
  @Override void draw() {
    clearBackground((int)(100-velocidadGeneral*9.5));

    for ( int i=0; i<cuerposCelestes.length; i++) {
      animarCuerpoCeleste( cuerposCelestes[i] );
      dibujarCuerpoCeleste( cuerposCelestes[i] );
    }

    // obtener valor entre 0 y 10
    velocidadGeneral = map(mouseX, 0, width, 0, 10);

    logoRightLower(color(0, 100, 100));
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
