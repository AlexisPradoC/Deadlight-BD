MANUAL DE USUARIO Y GUÍA DE INSTALACIÓN
Proyecto: DeadLight (Beta 1.1)
PARTE 1: MANUAL DE USUARIO
1. Introducción
DeadLight es un videojuego de terror y supervivencia en 2D con vista top-down (cenital) y mecánicas Roguelike. Inspirado en la tensión de Lethal Company y la jugabilidad por oleadas de Megabonk, el jugador queda atrapado en una instalación oscura. Su única arma es una linterna que, además de iluminar el camino, es capaz de dañar y repeler a las criaturas que acechan en la oscuridad. El objetivo es sobrevivir a la mayor cantidad de oleadas posible, acumular puntos y derrotar al jefe final.

2. Requisitos del Sistema
Sistema Operativo: Windows 7 o superior / macOS / Linux.

Software: Processing (Versión 3 o 4) y MySQL (vía XAMPP).

Conexión a Internet: No requerida (el juego es totalmente offline, salvo la base de datos local).

3. Controles del Juego
W, A, S, D: Movimiento del personaje (Arriba, Izquierda, Abajo, Derecha).

Mouse: Apuntar la linterna hacia una dirección.

Click Izquierdo: (En los menús) Seleccionar opciones y botones.

Tecla P: Pausar / Reanudar el juego.

Tecla H: Activar / Desactivar el modo Debug (Muestra las hitboxes de las paredes y objetos).

4. Mecánicas Principales
Supervivencia: El jugador comienza con 100 puntos de vida. Si un enemigo lo toca, pierde vida y obtiene 1 segundo de invulnerabilidad (parpadea en rojo).

Combate (Linterna): Al enfocar el haz de luz sobre un enemigo, este retrocede y recibe daño con el tiempo. Si mantienes la luz sobre el Jefe Final (Boss), este se sobrecalentará y quedará aturdido.

Enemigos:
Normal: Persigue al jugador lentamente.

Verde: Se detiene a distancia y dispara proyectiles (bolitas) de energía.

Azul: Se mueve mucho más rápido que los demás.

Progresión (Oleadas y Salas): El juego cuenta con 4 salas. Para avanzar a la siguiente sala, debes acumular cierta cantidad de puntos eliminando enemigos. La sala 4 es la arena del Jefe Final.

Sistema de Puntuación y Récords: Cada enemigo derrotado otorga puntos. Al perder (Game Over), el jugador puede ingresar su nombre y su puntuación se guardará en la base de datos MySQL, mostrándose en el Top 10 global.







GUÍA DE INSTALACIÓN
Para que el juego funcione correctamente, es fundamental configurar el entorno de base de datos (MySQL) antes de ejecutar el código en Processing.

Paso 1: Instalar XAMPP y MySQL
Descarga e instala XAMPP desde su página oficial.

Abre el Panel de Control de XAMPP.

Haz clic en el botón "Start" al lado del módulo MySQL. Asegúrate de que se ponga en color verde.

Paso 2: Importar la Base de Datos
En el panel de XAMPP, haz clic en el botón "Admin" al lado de MySQL (esto abrirá phpMyAdmin en tu navegador web).

Haz clic en la pestaña "SQL" en la parte superior.

Copia el script de creación de la base de datos (incluido en los archivos del proyecto como database.sql), pégalo en el cuadro de texto y haz clic en "Continuar".

Nota: Asegúrate de que se hayan creado las tablas jugadores y partidas, y la vista vista_ranking.

Paso 3: Configurar Processing
Descarga e instala Processing (Versión 3 o 4) desde su página oficial.

Abre el proyecto Deadlight.pde en Processing.

Instalar la librería GIF: Ve a Sketch -> Import Library -> Add Library..., busca "GifAnimation" e instálala.

Instalar el conector de MySQL:

Descarga MySQL Connector/J (el archivo .zip que dice "Platform Independent").

Descomprímelo y busca el archivo .jar (ej. mysql-connector-j-8.0.33.jar).

En la carpeta de tu proyecto Processing, crea una carpeta llamada code y arrastra el archivo .jar dentro.

Paso 4: Ejecutar el Juego
Asegúrate de tener la carpeta data en el proyecto con todas las imágenes (sprites de enemigos, jugador, mapas, etc.) y el fondo animado menu_fondo.gif.

Verifica que XAMPP (MySQL) siga encendido.

En Processing, presiona el botón Play (Ejecutar).

Mira la consola inferior: debe aparecer el mensaje "¡Conectado a la Base de Datos!".

¡El juego está listo para jugar!

Anexo: Solución de Problemas Frecuentes
"The type Statement is ambiguous" en Processing: Soluciona esto usando java.sql.Statement en lugar de solo Statement en el archivo GestorBD.pde.

"Error de conexión" en la consola de Processing: Verifica que MySQL esté en verde en XAMPP. Revisa que el usuario sea root, la contraseña esté vacía ("") y la base de datos se llame exactamente deadlight_db.

No se ven los récords: Asegúrate de haber creado la vista vista_ranking correctamente en phpMyAdmin.

Créditos:
Desarrollado por: Alexis Prado Castillo y Leonel Apaza.
Motor: Processing (Java) / MySQL.
