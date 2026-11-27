// Bolita que disparan los bichos verdes
class Bolita {
  PVector posicion;
  PVector velocidad;
  float radio = 8;
  int dano = 10;
  boolean activa = true;

  Bolita(float x, float y, float angulo) {
    posicion = new PVector(x, y);
    velocidad = new PVector(cos(angulo) * 4, sin(angulo) * 4);
  }

  void actualizar() {
    posicion.add(velocidad);

    // Desaparece al salir de la pantalla o al chocar con una pared
    if (posicion.x < 0 || posicion.x > width || posicion.y < 0 || posicion.y > height || puntoEnPared(posicion.x, posicion.y, 0)) {
      activa = false;
      return;
    }

    // Si toca al jugador le saca vida y desaparece
    if (PVector.dist(posicion, jugador.posicion) < radio + 20) {
      jugador.recibirDaño(dano);
      activa = false;
    }
  }

  void mostrar() {
    noStroke();
    fill(80, 255, 80, 90);
    ellipse(posicion.x, posicion.y, radio * 3, radio * 3);   // brillo
    fill(150, 255, 150);
    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);
  }
}
