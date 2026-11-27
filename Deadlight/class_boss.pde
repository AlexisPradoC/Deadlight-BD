// Boss del mapa 4. Hereda de Enemigo, asi que la linterna lo detecta igual que a los demas.
// Todos los tiempos estan en FRAMES (60 por segundo). Asi se congelan solos cuando el juego esta en pausa.
class Boss extends Enemigo {
  // --- Estados ---
  final int REPOSO = 0;
  final int CARGANDO = 1;
  final int DISPARANDO = 2;
  final int ATURDIDO = 3;
  int estado = REPOSO;
  int contador = 0;               // frames que lleva en el estado actual

  PImage spriteAtaque;            // BossFinal2.png (sprite del ataque especial)

  // --- Valores del boss (se pueden tocar aca) ---
  float vidaMax = 600;
  float tamano = 160;             // tamaño con el que se dibuja el sprite (cuadrado)
  float distanciaCanon = 68;      // del centro del boss a la punta del cañon

  float danoRayo = 200;
  float anchoRayo = 28;
  int tiempoEspera = 150;         // 2.5 s entre disparos
  int tiempoCarga = 90;           // 1.5 s cargando el rayo
  int tiempoRayo = 20;            // el rayo queda activo ~0.3 s
  int tiempoFijarPunteria = 30;   // los ultimos 0.5 s de carga la direccion queda fija (se puede esquivar)

  int tiempoParaAturdir = 120;    // 2 s de linterna continua
  int tiempoAturdido = 180;       // 3 s aturdido
  float danoLuz = 0.5;            // vida que pierde por frame bajo la linterna
  float danoLuzAturdido = 1.5;    // idem, pero mientras esta aturdido
  int puntosAlMorir = 1000;

  int contadorLuz = 0;            // frames seguidos bajo la linterna

  Boss(float x, float y, PImage img, PImage imgAtaque) {
    super(x, y, img);
    spriteAtaque = imgAtaque;
    radio = 45;
    vida = vidaMax;
  }

  void actualizar(Linterna linterna) {
    if (!vivo) return;

    // --- Daño de la linterna y sobrecalentamiento ---
    iluminado = linterna.ilumina(this);

    if (iluminado) {
      contadorLuz++;
      if (estado == ATURDIDO) {
        vida -= danoLuzAturdido;
      } else {
        vida -= danoLuz;
      }
    } else {
      contadorLuz = 0;  // tiene que ser continua
    }

    if (vida <= 0) {
      vida = 0;
      vivo = false;
      jugador.puntos += puntosAlMorir;
      return;
    }

    contador++;

    // La luz continua lo aturde (y corta lo que estuviera haciendo)
    if (estado != ATURDIDO && contadorLuz >= tiempoParaAturdir) {
      estado = ATURDIDO;
      contador = 0;
      contadorLuz = 0;
    }

    // --- Maquina de estados ---
    if (estado == REPOSO) {
      apuntarAlJugador();
      if (contador >= tiempoEspera) {
        estado = CARGANDO;
        contador = 0;
      }
    } else if (estado == CARGANDO) {
      // Sigue al jugador y en los ultimos 0.5 s fija la direccion
      if (contador < tiempoCarga - tiempoFijarPunteria) {
        apuntarAlJugador();
      }
      if (contador >= tiempoCarga) {
        estado = DISPARANDO;
        contador = 0;
      }
    } else if (estado == DISPARANDO) {
      comprobarImpacto();
      if (contador >= tiempoRayo) {
        estado = REPOSO;
        contador = 0;
      }
    } else if (estado == ATURDIDO) {
      // Al recuperarse ataca enseguida (asi no se lo puede dejar aturdido para siempre)
      if (contador >= tiempoAturdido) {
        estado = CARGANDO;
        contador = 0;
        contadorLuz = 0;
      }
    }
  }

  void apuntarAlJugador() {
    angulo = atan2(jugador.posicion.y - posicion.y, jugador.posicion.x - posicion.x);
  }

  // Punta del cañon: de aca sale el rayo
  PVector origenRayo() {
    return new PVector(posicion.x + cos(angulo) * distanciaCanon, posicion.y + sin(angulo) * distanciaCanon);
  }

  // El rayo es una linea recta: el jugador recibe daño si esta cerca de esa linea y por delante del cañon
  void comprobarImpacto() {
    PVector origen = origenRayo();
    float relX = jugador.posicion.x - origen.x;
    float relY = jugador.posicion.y - origen.y;

    float adelante = relX * cos(angulo) + relY * sin(angulo);
    float lado = abs(-relX * sin(angulo) + relY * cos(angulo));

    if (adelante > 0 && lado < anchoRayo / 2 + 20) {
      jugador.recibirDaño((int) danoRayo);
    }
  }

  void mostrar() {
    if (!vivo) return;

    // --- Sprite ---
    pushMatrix();
    translate(posicion.x, posicion.y);
    imageMode(CENTER);

    if (estado == ATURDIDO) {
      tint(120, 140, 255);
    } else if (iluminado) {
      tint(255, 150, 150);
    }

    if (estado == CARGANDO || estado == DISPARANDO) {
      rotate(angulo);                                  // el cañon apunta al jugador
      image(spriteAtaque, 0, 0, tamano, tamano);
    } else {
      image(sprite, 0, 0, tamano, tamano);
    }

    noTint();
    popMatrix();

    // --- Efectos del ataque ---
    if (estado == CARGANDO) dibujarAviso();
    if (estado == DISPARANDO) dibujarRayo();

    // --- Indicadores ---
    if (estado == ATURDIDO) {
      fill(120, 140, 255);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("ATURDIDO", posicion.x, posicion.y - tamano / 2 - 5);
    } else if (contadorLuz > 0) {
      // Barra de sobrecalentamiento del nucleo
      float progreso = (float) contadorLuz / tiempoParaAturdir;
      noStroke();
      fill(0, 150);
      rect(posicion.x - 40, posicion.y + 80, 80, 8);
      fill(255, 150, 0);
      rect(posicion.x - 40, posicion.y + 80, 80 * progreso, 8);
    }

    mostrarBarraVida();
  }

  // Linea de aviso + bola de energia que crece mientras carga
  void dibujarAviso() {
    PVector o = origenRayo();
    float progreso = (float) contador / tiempoCarga;
    boolean fijado = contador >= tiempoCarga - tiempoFijarPunteria;

    if (fijado) {
      stroke(255, 60, 60, 220);
      strokeWeight(3);
    } else {
      stroke(80, 200, 255, 90 + progreso * 100);
      strokeWeight(1.5);
    }
    line(o.x, o.y, o.x + cos(angulo) * 1200, o.y + sin(angulo) * 1200);

    noStroke();
    fill(150, 230, 255, 200);
    ellipse(o.x, o.y, 8 + progreso * 30, 8 + progreso * 30);
  }

  void dibujarRayo() {
    PVector o = origenRayo();
    float fx = o.x + cos(angulo) * 1200;
    float fy = o.y + sin(angulo) * 1200;

    stroke(80, 200, 255, 170);
    strokeWeight(anchoRayo);
    line(o.x, o.y, fx, fy);

    stroke(255);
    strokeWeight(anchoRayo * 0.4);
    line(o.x, o.y, fx, fy);

    noStroke();
  }

  void mostrarBarraVida() {
    float anchoBarra = 400;
    float x = width / 2 - anchoBarra / 2;

    noStroke();
    fill(0, 180);
    rect(x - 2, 18, anchoBarra + 4, 20);
    fill(200, 40, 40);
    rect(x, 20, anchoBarra * vida / vidaMax, 16);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("BOSS", width / 2, 28);
  }
}
