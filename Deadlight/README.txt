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
