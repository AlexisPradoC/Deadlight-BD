import gifAnimation.*;

Jugador jugador;
Linterna linterna;
ArrayList<Enemigo> enemigos;
Boss boss;
ArrayList<Bolita> bolitas;

// Variantes de bicho
final int TIPO_NORMAL = 0;
final int TIPO_VERDE = 1;   // dispara bolitas
final int TIPO_AZUL = 2;    // mas rapido

int[] objetivoSala = {0, 1000, 2000, 4000, 0};
int maxEnemigos = 4;        // bichos vivos como maximo en la sala
int contadorSpawn = 0;
int salaPreparada = 0;      // sala para la que ya se generaron los bichos
int tiempoBossMuerto = -1;  // momento en que murio el boss (-1 = sigue vivo), para mostrar el aviso

ArrayList<float[]> hitboxesSala1;
ArrayList<float[]> hitboxesSala2;
ArrayList<float[]> hitboxesSala3;
ArrayList<float[]> hitboxesSala4;
boolean mostrarHitboxes = false;

int estadoDelJuego = 0;
int escenaActual = 1;
int tiempoCambioSala = 0;

Gif menuFondo;
PImage spriteJugador;
PImage spriteEnemigo;
PImage spriteEnemigoVerde;
PImage spriteEnemigoAzul;
PImage spriteBoss;
PImage spriteBossAtaque;
PImage fondoMapa;
PImage fondoMapa2;
PImage fondoMapa3;
PImage fondoMapa4;

boolean movUp, movDown, movLeft, movRight;

// Variables de la Base de Datos y Nombre
GestorBD db;
String nombreJugadorActual = "";
boolean escribiendoNombre = true; 
boolean puntuacionGuardada = false;
int oleadasActuales = 1;

void setup() {
  size(800, 600);
  
  // Inicializar Base de Datos
  db = new GestorBD();
  
  menuFondo = new Gif(this, "menu_fondo.gif");
  menuFondo.loop();
  spriteJugador = loadImage("jugador.png");
  spriteEnemigo = loadImage("enemigo.png");
  spriteEnemigoVerde = loadImage("enemigo_verde.png");
  spriteEnemigoAzul = loadImage("enemigo_azul.png");
  spriteBoss = loadImage("boss.png");
  spriteBossAtaque = loadImage("BossFinal2.png");
  fondoMapa = loadImage("mapa.png");
  fondoMapa2 = loadImage("mapa2.png");
  fondoMapa3 = loadImage("mapa3.png");
  fondoMapa4 = loadImage("mapa4.png");

  jugador = new Jugador(width/2, height/2, spriteJugador);
  linterna = new Linterna();

  enemigos = new ArrayList<Enemigo>();
  bolitas = new ArrayList<Bolita>();

  // --- HITBOXES MAPA 1 ---
  hitboxesSala1 = new ArrayList<float[]>();
  hitboxesSala1.add(new float[]{55, 0, 180, 145});
  hitboxesSala1.add(new float[]{265, 0, 160, 115});
  hitboxesSala1.add(new float[]{510, 0, 215, 115});
  hitboxesSala1.add(new float[]{740, 135, 60, 160});
  hitboxesSala1.add(new float[]{615, 240, 65, 55});
  hitboxesSala1.add(new float[]{45, 300, 115, 55});
  hitboxesSala1.add(new float[]{105, 400, 115, 115});
  hitboxesSala1.add(new float[]{330, 440, 150, 120});

  // --- HITBOXES MAPA 2 ---
  hitboxesSala2 = new ArrayList<float[]>();
  hitboxesSala2.add(new float[]{0, 0, 260, 100});
  hitboxesSala2.add(new float[]{80, 195, 80, 130});
  hitboxesSala2.add(new float[]{260, 0, 390, 130});
  hitboxesSala2.add(new float[]{650, 0, 150, 160});
  hitboxesSala2.add(new float[]{720, 150, 80, 80});
  hitboxesSala2.add(new float[]{725, 280, 75, 70});
  hitboxesSala2.add(new float[]{725, 440, 75, 70});
  hitboxesSala2.add(new float[]{565, 500, 60, 60});
  hitboxesSala2.add(new float[]{0, 370, 140, 160});

  // --- HITBOXES MAPA 3 ---
  hitboxesSala3 = new ArrayList<float[]>();
  hitboxesSala3.add(new float[]{0, 0, 720, 110}); 
  hitboxesSala3.add(new float[]{20, 155, 65, 115}); 
  hitboxesSala3.add(new float[]{35, 260, 115, 65}); 
  hitboxesSala3.add(new float[]{625, 100, 105, 110}); 
  hitboxesSala3.add(new float[]{115, 445, 65, 115}); 
  hitboxesSala3.add(new float[]{565, 425, 155, 135}); 
  hitboxesSala3.add(new float[]{730, 380, 70, 300}); 

  // --- HITBOXES MAPA 4 (ARENA BOSS) ---
  hitboxesSala4 = new ArrayList<float[]>();
  hitboxesSala4.add(new float[]{0, 0, 365, 55});      
  hitboxesSala4.add(new float[]{475, 0, 325, 55});    
  hitboxesSala4.add(new float[]{365, 55, 110, 55});   
  hitboxesSala4.add(new float[]{0, 0, 48, 435});      
  hitboxesSala4.add(new float[]{752, 0, 48, 435});    
  hitboxesSala4.add(new float[]{45, 435, 65, 130});   
  hitboxesSala4.add(new float[]{690, 435, 65, 130});  
  hitboxesSala4.add(new float[]{180, 110, 60, 100});  
  hitboxesSala4.add(new float[]{570, 110, 60, 100});  
  hitboxesSala4.add(new float[]{180, 380, 60, 100});  
  hitboxesSala4.add(new float[]{570, 380, 60, 100});  
  hitboxesSala4.add(new float[]{110, 535, 250, 45});  
  hitboxesSala4.add(new float[]{465, 535, 225, 45});  
}

void reiniciarJuego() {
  jugador.posicion.set(width/2, height/2);
  jugador.vida = 100;
  jugador.puntos = 0;
  escenaActual = 1;
  puntuacionGuardada = false;
  tiempoBossMuerto = -1;
  oleadasActuales = 1; 
  
  // Reiniciar variables para el nuevo ingreso de nombre
  nombreJugadorActual = "";
  escribiendoNombre = true;

  boss = new Boss(width/2, 260, spriteBoss, spriteBossAtaque);
  prepararSala();
}

boolean bossDerrotado() {
  return boss != null && !boss.vivo;
}

boolean debenAparecerBichos() {
  return bossDerrotado() || jugador.puntos < objetivoSala[escenaActual];
}

void prepararSala() {
  salaPreparada = escenaActual;
  enemigos.clear();
  bolitas.clear();
  contadorSpawn = 0;

  if (debenAparecerBichos()) {
    for (int i = 0; i < maxEnemigos; i++) {
      generarEnemigo();
    }
  }
}

void actualizarGeneracion() {
  contadorSpawn++;
  if (debenAparecerBichos() && enemigos.size() < maxEnemigos && contadorSpawn >= 90) {
    generarEnemigo();
    contadorSpawn = 0;
  }
}

void generarEnemigo() {
  for (int intento = 0; intento < 100; intento++) {
    float x = random(60, width - 60);
    float y = random(60, height - 60);

    if (puntoEnPared(x, y, 30) || dist(x, y, jugador.posicion.x, jugador.posicion.y) < 250) {
      continue;
    }

    float azar = random(1);
    if (azar < 0.25) {
      enemigos.add(new Enemigo(x, y, spriteEnemigoVerde, TIPO_VERDE));
    } else if (azar < 0.5) {
      enemigos.add(new Enemigo(x, y, spriteEnemigoAzul, TIPO_AZUL));
    } else {
      enemigos.add(new Enemigo(x, y, spriteEnemigo, TIPO_NORMAL));
    }
    return;
  }
}

ArrayList<float[]> hitboxesActuales() {
  if (escenaActual == 1) return hitboxesSala1;
  else if (escenaActual == 2) return hitboxesSala2;
  else if (escenaActual == 3) return hitboxesSala3;
  return hitboxesSala4;
}

boolean puntoEnPared(float x, float y, float margen) {
  for (float[] hb : hitboxesActuales()) {
    if (x + margen > hb[0] && x - margen < hb[0] + hb[2] &&
        y + margen > hb[1] && y - margen < hb[1] + hb[3]) {
      return true;
    }
  }
  return false;
}

void draw() {
  if (estadoDelJuego == 0 || estadoDelJuego == 4 || estadoDelJuego == 5 || estadoDelJuego == 6) {
    imageMode(CORNER);
    image(menuFondo, 0, 0, width, height);
  } else {
    imageMode(CORNER);
    if (escenaActual == 1) image(fondoMapa, 0, 0, width, height);
    else if (escenaActual == 2) image(fondoMapa2, 0, 0, width, height);
    else if (escenaActual == 3) image(fondoMapa3, 0, 0, width, height);
    else if (escenaActual == 4) image(fondoMapa4, 0, 0, width, height);

    fill(0, 100);
    noStroke();
    rect(0, 0, width, height);
  }

  if (estadoDelJuego == 0) mostrarMenu();
  else if (estadoDelJuego == 1) jugar();
  else if (estadoDelJuego == 2) { jugar(); mostrarPausa(); }
  else if (estadoDelJuego == 3) mostrarGameOver();
  else if (estadoDelJuego == 4) mostrarOpciones();
  else if (estadoDelJuego == 5) mostrarCreditos();
  else if (estadoDelJuego == 6) mostrarBaseDeDatos();

  if (mostrarHitboxes && estadoDelJuego == 1) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    for (float[] hb : hitboxesActuales()) {
      rect(hb[0], hb[1], hb[2], hb[3]);
    }
    noStroke();
  }
}

void jugar() {
  if (estadoDelJuego == 1) {
    jugador.actualizar();

    if (millis() - tiempoCambioSala > 500) {
      // MAPA 1 -> MAPA 2
      if (escenaActual == 1 && jugador.posicion.x >= width - 20 && jugador.posicion.y > 250 && jugador.posicion.y < 430) {
        if (jugador.puntos >= 1000) {
          escenaActual = 2;
          jugador.posicion.x = 40;
          jugador.posicion.y = 340;
          tiempoCambioSala = millis();
          oleadasActuales++;
        }
      }
      // MAPA 2 -> MAPA 1
      if (escenaActual == 2 && jugador.posicion.x <= 20 && jugador.posicion.y > 250 && jugador.posicion.y < 430) {
        escenaActual = 1;
        jugador.posicion.x = width - 40;
        jugador.posicion.y = 340;
        tiempoCambioSala = millis();
      }

      // MAPA 1 -> MAPA 3
      if (escenaActual == 1 && jugador.posicion.x <= 25 && jugador.posicion.y > 170 && jugador.posicion.y < 270) {
        if (jugador.puntos >= 2000) {
          escenaActual = 3;
          jugador.posicion.x = width - 45;
          jugador.posicion.y = 210;
          tiempoCambioSala = millis();
          oleadasActuales++;
        }
      }
      // MAPA 3 -> MAPA 1
      else if (escenaActual == 3 && jugador.posicion.x >= width - 25 && jugador.posicion.y > 170 && jugador.posicion.y < 270) {
        escenaActual = 1;
        jugador.posicion.x = 45;
        jugador.posicion.y = 210;
        tiempoCambioSala = millis();
      }

      // MAPA 3 -> MAPA 4 (Entrada inferior derecha/centro)
      if (escenaActual == 3 && jugador.posicion.x > 480 && jugador.posicion.x < 620 && jugador.posicion.y >= height - 30) {
        if (jugador.puntos >= 4000) {
          escenaActual = 4;
          jugador.posicion.x = width / 2;
          jugador.posicion.y = height - 60;
          tiempoCambioSala = millis();
          oleadasActuales++;
        }
      }
      // MAPA 4 -> MAPA 3 (Salida inferior)
      else if (escenaActual == 4 && jugador.posicion.x > 365 && jugador.posicion.x < 460 && jugador.posicion.y >= height - 40) {
        escenaActual = 3;
        jugador.posicion.x = 500;
        jugador.posicion.y = 520;
        tiempoCambioSala = millis();
      }
    }

    if (salaPreparada != escenaActual) prepararSala();

    linterna.actualizar(jugador.posicion, jugador.angulo);

    for (int i = enemigos.size() - 1; i >= 0; i--) {
      Enemigo e = enemigos.get(i);
      e.actualizar(linterna);
      if (!e.vivo) enemigos.remove(i);
    }

    if (escenaActual == 4 && boss.vivo) {
      boss.actualizar(linterna);
      if (!boss.vivo) {
        tiempoBossMuerto = millis();
        contadorSpawn = 90;
      }
    }

    for (int i = bolitas.size() - 1; i >= 0; i--) {
      Bolita b = bolitas.get(i);
      b.actualizar();
      if (!b.activa) bolitas.remove(i);
    }

    actualizarGeneracion();
  }

  linterna.mostrar();
  jugador.mostrar();

  for (Enemigo enemigo : enemigos) enemigo.mostrar();
  for (Bolita bolita : bolitas) bolita.mostrar();

  if (escenaActual == 4 && boss.vivo) boss.mostrar();

  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text("VIDA: " + jugador.vida, 20, 20);
  if (!bossDerrotado() && objetivoSala[escenaActual] > 0) {
    text("PUNTOS: " + jugador.puntos + " / " + objetivoSala[escenaActual], 20, 50);
  } else {
    text("PUNTOS: " + jugador.puntos, 20, 50);
  }
  text("Enemigos: " + enemigos.size(), 20, 80);
  text("Oleada: " + oleadasActuales, 20, 110);

  if (tiempoBossMuerto >= 0 && millis() - tiempoBossMuerto < 4000) {
    fill(255, 220, 80);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("BOSS DERROTADO", width/2, 70);
    textSize(16);
    text("Salí por la puerta de abajo. Los bichos ya no paran de aparecer.", width/2, 100);
  }
}

void keyPressed() {
  // --- Lógica para escribir el nombre en Game Over ---
  if (estadoDelJuego == 3 && escribiendoNombre) {
    if (key == ENTER || key == RETURN) {
      if (nombreJugadorActual.trim().length() > 0) { // Si no está vacío
        db.guardarPartida(nombreJugadorActual, jugador.puntos, oleadasActuales);
        escribiendoNombre = false; // Pasa a mostrar los records
      }
    } else if (key == BACKSPACE) {
      if (nombreJugadorActual.length() > 0) {
        nombreJugadorActual = nombreJugadorActual.substring(0, nombreJugadorActual.length() - 1);
      }
    } else if (key != CODED && key != ENTER && key != RETURN && nombreJugadorActual.length() < 15) {
      nombreJugadorActual += key; // Agrega la letra
    }
    return; // Evita que se muevan los personajes mientras escribe
  }
  // ---------------------------------------------------

  if (key == 'w' || key == 'W') movUp = true;
  if (key == 's' || key == 'S') movDown = true;
  if (key == 'a' || key == 'A') movLeft = true;
  if (key == 'd' || key == 'D') movRight = true;

  if (key == 'h' || key == 'H') mostrarHitboxes = !mostrarHitboxes;

  if (estadoDelJuego == 1 && (key == 'p' || key == 'P')) estadoDelJuego = 2;
  else if (estadoDelJuego == 2 && (key == 'p' || key == 'P')) estadoDelJuego = 1;
}

void keyReleased() {
  if (key == 'w' || key == 'W') movUp = false;
  if (key == 's' || key == 'S') movDown = false;
  if (key == 'a' || key == 'A') movLeft = false;
  if (key == 'd' || key == 'D') movRight = false;
}

void mostrarMenu() {
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(60);
  text("DeadLight", 63, 100);

  crearBoton(80, 200, 220, 50, "JUGAR", LEFT);
  crearBoton(80, 270, 220, 50, "RÉCORDS", LEFT);
  crearBoton(80, 340, 220, 50, "OPCIONES", LEFT);
  crearBoton(80, 410, 220, 50, "CREDITOS", LEFT);
  crearBoton(80, 480, 220, 50, "SALIR", LEFT);
}

void mostrarBaseDeDatos() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("MEJORES PUNTUACIONES", width/2, 80);

  textSize(18);
  String[] records = db.obtenerRecords();
  int limite = min(10, records.length);

  for (int i = 0; i < limite; i++) {
    text((i+1) + ". " + records[i], width/2, 150 + (i * 30));
  }

  crearBoton(width/2 - 100, 520, 200, 50, "VOLVER", CENTER);
}

void mostrarOpciones() {
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(40);
  text("OPCIONES", 80, 120);
  textSize(20);
  text("Controles:\n- WASD: Moverse\n- Mouse: Apuntar linterna\n- Tecla P: Pausa\n- Tecla H: Hitboxes (Debug)", 80, 240);
  crearBoton(80, 430, 220, 50, "VOLVER", LEFT);
}

void mostrarCreditos() {
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(40);
  text("CREDITOS", 80, 120);
  textSize(20);
  text("Desarrollado por: Alexis P. - Leonel A.\nJuego en Processing Beta 1.1", 80, 240);
  crearBoton(80, 430, 220, 50, "VOLVER", LEFT);
}

void mostrarPausa() {
  fill(0, 0, 0, 160);
  rect(0, 0, width, height);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("PAUSA", width/2, 180);
  crearBoton(width/2 - 100, 260, 200, 50, "REANUDAR", CENTER);
  crearBoton(width/2 - 100, 330, 200, 50, "SALIR AL MENU", CENTER);
}

void mostrarGameOver() {
  fill(0, 200);
  rect(0, 0, width, height);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("GAME OVER", width/2, 80);

  textSize(30);
  text("Tu puntaje: " + jugador.puntos, width/2, 150);

  if (escribiendoNombre) {
    // Pantalla para escribir el nombre
    textSize(22);
    text("Ingresa tu nombre y presiona ENTER:", width/2, 250);
    
    // Dibujar el cuadro de texto
    stroke(255);
    fill(40);
    rect(width/2 - 150, 280, 300, 50, 10);
    fill(255);
    textSize(24);
    text(nombreJugadorActual + (frameCount / 30 % 2 == 0 ? "|" : ""), width/2, 305); 
    noStroke();
    
  } else {
    // Ya se guardó, mostrar los records
    textSize(25);
    text("TUS MEJORES PUNTUACIONES:", width/2, 200);
    textSize(18);
    
    String[] records = db.obtenerRecords();
    int limite = min(5, records.length);
    for (int i = 0; i < limite; i++) {
      text((i+1) + ". " + records[i], width/2, 240 + (i * 25));
    }

    crearBoton(width/2 - 100, 420, 200, 50, "REINTENTAR", CENTER);
    crearBoton(width/2 - 100, 490, 200, 50, "MENU PRINCIPAL", CENTER);
  }
}

boolean sobreBoton(float x, float y, float ancho, float alto) {
  return mouseX >= x && mouseX <= x + ancho && mouseY >= y && mouseY <= y + alto;
}

void crearBoton(float x, float y, float ancho, float alto, String texto, int alineacion) {
  boolean sobre = sobreBoton(x, y, ancho, alto);
  rectMode(CORNER);
  stroke(255);
  strokeWeight(2);
  fill(sobre ? color(255, 255, 180, 220) : color(40, 40, 40, 200));
  rect(x, y, ancho, alto, 10);
  fill(sobre ? 0 : 255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(texto, x + ancho/2, y + alto/2);
}

void mouseClicked() {
  if (estadoDelJuego == 0) {
    if (sobreBoton(80, 200, 220, 50)) {
      reiniciarJuego();
      estadoDelJuego = 1;
    } else if (sobreBoton(80, 270, 220, 50)) estadoDelJuego = 6;
    else if (sobreBoton(80, 340, 220, 50)) estadoDelJuego = 4;
    else if (sobreBoton(80, 410, 220, 50)) estadoDelJuego = 5;
    else if (sobreBoton(80, 480, 220, 50)) exit();
  } else if (estadoDelJuego == 2) {
    if (sobreBoton(width/2 - 100, 260, 200, 50)) estadoDelJuego = 1;
    else if (sobreBoton(width/2 - 100, 330, 200, 50)) estadoDelJuego = 0;
  } else if (estadoDelJuego == 3 && !escribiendoNombre) {
    // Los botones solo funcionan si ya terminó de escribir el nombre
    if (sobreBoton(width/2 - 100, 420, 200, 50)) {
      reiniciarJuego();
      estadoDelJuego = 1;
    } else if (sobreBoton(width/2 - 100, 490, 200, 50)) estadoDelJuego = 0;
  } else if (estadoDelJuego == 4 || estadoDelJuego == 5) {
    if (sobreBoton(80, 430, 220, 50)) estadoDelJuego = 0;
  } else if (estadoDelJuego == 6) {
    if (sobreBoton(width/2 - 100, 520, 200, 50)) estadoDelJuego = 0;
  }
}
