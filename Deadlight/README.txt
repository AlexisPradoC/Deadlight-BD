=========================================================
                    DEADLIGHT
=========================================================

DeadLight es un videojuego de terror y supervivencia en 2D
(vista top-down) desarrollado en Processing. El jugador
queda atrapado en una instalacion oscura y llena de
criaturas. Su unica herramienta de defensa es una linterna
que, ademas de iluminar el camino, es capaz de dañar y
repeler a los enemigos.


---------------------------------------------------------
                CARACTERISTICAS PRINCIPALES
---------------------------------------------------------

- Sistema de Vision (Linterna): El mapa esta oculto en la
  oscuridad. Solo puedes ver lo que ilumina el cono de luz
  de tu linterna.

- Combate y Supervivencia: Al apuntar la linterna a un
  enemigo, este recibe daño y retrocede. Si un enemigo te
  toca, perderas vida.

- Sistema de Vida: El jugador comienza con 100 puntos de
  vida. Al recibir daño, obtiene 1 segundo de
  invulnerabilidad (parpadea en rojo).

- Sistema de Puntuacion: Cada enemigo eliminado otorga
  100 puntos.

- Base de Datos Local: Al perder (Game Over), tu
  puntuacion se guarda automaticamente en un archivo de
  texto (puntuaciones_db.txt) junto con la fecha y hora.
  Puedes consultar los records en el menu principal.

- Multiples Salas: El juego cuenta con dos mapas
  conectados por puertas, cada uno con sus propios muros
  y colisiones.


---------------------------------------------------------
                        CONTROLES
---------------------------------------------------------

  W, A, S, D ........ Movimiento del jugador
                      (Arriba, Izquierda, Abajo, Derecha)

  Mouse ............. Apuntar la linterna

  P ................. Pausar / Reanudar el juego

  H ................. Mostrar/Ocultar Hitboxes (Modo Debug)

  Click Izquierdo ... Interactuar con los botones del menu


---------------------------------------------------------
                ESTRUCTURA DEL PROYECTO
---------------------------------------------------------

El codigo esta modularizado en diferentes archivos para
mantenerlo ordenado:

- Deadlight.pde:
  Archivo principal. Maneja el bucle del juego (draw),
  los estados (Menu, Jugando, Game Over, Records), la
  interfaz de usuario y la logica de la base de datos.

- class_jugador.pde:
  Define al personaje. Controla el movimiento, las
  colisiones con paredes, la vida y el sistema de daño.

- class_enemigo.pde:
  Define a los monstruos. Controla su IA (perseguir al
  jugador), su vida, el daño que reciben de la linterna
  y el daño que hacen al jugador.

- class_linterna.pde:
  Sistema de iluminacion. Utiliza mascaras graficas
  (PGraphics) para crear el efecto de oscuridad y calcula
  matematicamente si un enemigo esta dentro del cono de luz.


---------------------------------------------------------
            COMO FUNCIONA LA BASE DE DATOS
---------------------------------------------------------

No se requiere ningun motor de base de datos externo
(como MySQL). El juego utiliza un sistema de persistencia
de archivos local:

1. Cuando el jugador pierde, el juego crea (o lee) un
   archivo llamado puntuaciones_db.txt en la carpeta raiz
   del proyecto.

2. Guarda la puntuacion en una linea con el formato:
   PUNTOS;FECHA HORA
   (Ejemplo: 300;2023-10-25 15:30)

3. En la pantalla de Records, el juego lee el archivo,
   ordena los datos de mayor a menor y muestra el Top 10.

4. Si deseas borrar los records para empezar de cero,
   simplemente elimina el archivo puntuaciones_db.txt.


---------------------------------------------------------
            REQUISITOS Y COMO EJECUTARLO
---------------------------------------------------------

1. Descarga e instala Processing (Version 3 o 4) desde:
   https://processing.org/download

2. Instala la libreria gifAnimation desde el gestor de
   librerias de Processing:
   Sketch -> Import Library -> Add Library...

3. Asegurate de tener una carpeta llamada "data" dentro
   de la carpeta del proyecto con las siguientes imagenes:

       jugador.png
       enemigo.png
       mapa.png
       mapa2.png
       menu_fondo.gif

4. Abre el archivo Deadlight.pde y presiona el boton de
   Play (Ejecutar).


---------------------------------------------------------
                        CREDITOS
---------------------------------------------------------

  Desarrollo ....... Alexis P. - Leonel A.
  Motor ............ Processing (Java)
  Version .......... Beta 1.1

=========================================================