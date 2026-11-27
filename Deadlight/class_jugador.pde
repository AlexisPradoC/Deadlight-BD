class Jugador {
  PVector posicion;
  PVector velocidad;
  float velocidadMovimiento = 3;
  float angulo = 0;
  PImage sprite;
  
  int vida = 100;
  int puntos = 0;
  int tiempoUltimoDaño = 0;

  Jugador(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    sprite = img;
  }

  void actualizar() {
    float dx = 0, dy = 0;

    if (movUp)    dy -= 1;
    if (movDown)  dy += 1;
    if (movLeft)  dx -= 1;
    if (movRight) dx += 1;

    PVector dir = new PVector(dx, dy);
    if (dir.mag() > 0) {
      dir.normalize();
      dir.mult(velocidadMovimiento);
    }

    if (!chocaConPared(posicion.x + dir.x, posicion.y)) posicion.x += dir.x;
    if (!chocaConPared(posicion.x, posicion.y + dir.y)) posicion.y += dir.y;

    posicion.x = constrain(posicion.x, 20, width - 20);
    posicion.y = constrain(posicion.y, 20, height - 20);
    
    angulo = atan2(mouseY - posicion.y, mouseX - posicion.x);
  }

  void recibirDaño(int cantidad) {
    if (millis() - tiempoUltimoDaño > 1000) {
      vida -= cantidad;
      tiempoUltimoDaño = millis();
      
      if (vida <= 0) {
        vida = 0;
        estadoDelJuego = 3;
      }
    }
  }

boolean chocaConPared(float proxX, float proxY) {
  float radioJugador = 20;
  ArrayList<float[]> listaActual;

  if (escenaActual == 1) {
    listaActual = hitboxesSala1;
  } 
  else if (escenaActual == 2) {
    listaActual = hitboxesSala2;
  } 
  else if (escenaActual == 3) {
    listaActual = hitboxesSala3;
  }
  else {
    listaActual = hitboxesSala4;
  }

  for (float[] hb : listaActual) {
    if (proxX + radioJugador > hb[0] && proxX - radioJugador < hb[0] + hb[2] &&
        proxY + radioJugador > hb[1] && proxY - radioJugador < hb[1] + hb[3]) {
      return true;
    }
  }
  return false;
}
  void mostrar() {
    pushMatrix();
    imageMode(CENTER);
    
    if (millis() - tiempoUltimoDaño < 300) {
      tint(255, 100, 100);
    }
    
    translate(posicion.x, posicion.y);
    rotate(angulo);
    image(sprite, 0, 0, 90, 90);
    
    noTint();
    popMatrix();
  }
}
