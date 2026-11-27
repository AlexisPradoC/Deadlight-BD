class Enemigo {
  PVector posicion;
  float radio = 20;
  boolean iluminado = false;
  
  PImage sprite;
  float angulo = 0;
  
  float vida = 100;
  boolean vivo = true;

  // Variante: TIPO_NORMAL, TIPO_VERDE (dispara bolitas) o TIPO_AZUL (mas rapido)
  int tipo = TIPO_NORMAL;
  float velocidad = 1.0;
  int puntos = 100;            // puntos que da al morir
  int contadorDisparo = 0;     // frames desde el ultimo disparo (solo el verde)

  // Constructor simple (lo usa el Boss)
  Enemigo(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    sprite = img;
  }

  // Constructor con variante
  Enemigo(float x, float y, PImage img, int tipoEnemigo) {
    this(x, y, img);
    tipo = tipoEnemigo;

    if (tipo == TIPO_NORMAL) {
      radio = 26;                                // un poco mas grande que las variantes
    } else if (tipo == TIPO_VERDE) {
      velocidad = 0.8;
      puntos = 150;
      contadorDisparo = (int) random(0, 60);     // para que no disparen todos a la vez
    } else if (tipo == TIPO_AZUL) {
      velocidad = 2.0;
      puntos = 150;
    }
  }

  void actualizar(Linterna linterna) {
    if (!vivo) return;

    iluminado = linterna.ilumina(this);
    
    if (iluminado) {
      vida -= 2.0;
      if (vida <= 0) {
        vivo = false;
        jugador.puntos += puntos;
      }
    }
    
    PVector direccion = PVector.sub(jugador.posicion, posicion);
    float distancia = direccion.mag();
    
    if (distancia > 0) {
      angulo = atan2(direccion.y, direccion.x);
      
      direccion.normalize();
      if (iluminado) {
        direccion.mult(-1);                      // la luz lo hace retroceder
      } else if (tipo == TIPO_VERDE && distancia < 220) {
        direccion.mult(0);                       // el verde se frena a distancia y dispara
      }
      posicion.add(PVector.mult(direccion, velocidad));

      // El verde dispara una bolita cada 2 segundos si el jugador esta a tiro
      if (tipo == TIPO_VERDE) {
        contadorDisparo++;
        if (contadorDisparo >= 120 && distancia < 400) {
          bolitas.add(new Bolita(posicion.x, posicion.y, angulo));
          contadorDisparo = 0;
        }
      }
      
      float distanciaJugador = PVector.dist(posicion, jugador.posicion);
      if (distanciaJugador < (radio + 25)) {
        jugador.recibirDaño(15);
      }
    }
  }

  void mostrar() {
    if (!vivo) return;

    pushMatrix();
    translate(posicion.x, posicion.y);
    rotate(angulo); 
    
    imageMode(CENTER);

    PImage imagen = sprite;
    if (iluminado) {
      tint(255, 50, 50);          // al iluminarlo se pone rojo (todas las variantes usan el sprite original)
      imagen = spriteEnemigo;
    } else if (tipo == TIPO_VERDE) {
      tint(150, 200, 150);
    } else if (tipo == TIPO_AZUL) {
      tint(150, 170, 255);
    } else {
      tint(100, 150, 150);
    }
  
    image(imagen, 0, 0, radio * 2.5, radio * 2.5);

    noTint(); 
    popMatrix();
  }
}
