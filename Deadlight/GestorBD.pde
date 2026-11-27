import java.sql.*;

class GestorBD {
  Connection conn;
  String url = "jdbc:mysql://localhost:3306/deadlight_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
  String user = "root"; 
  String pass = ""; 

  GestorBD() {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(url, user, pass);
      println("¡Conectado a la Base de Datos!");
    } catch (Exception e) {
      println("ERROR DE CONEXIÓN: " + e.getMessage());
    }
  }

  void guardarPartida(String nombre, int puntos, int oleadas) {
    try {
      int idJugador = -1;
      PreparedStatement ps = conn.prepareStatement("SELECT id_jugador FROM jugadores WHERE nombre = ?");
      ps.setString(1, nombre);
      ResultSet rs = ps.executeQuery();
      
      if (rs.next()) {
        idJugador = rs.getInt("id_jugador");
      } else {
        PreparedStatement psInsert = conn.prepareStatement("INSERT INTO jugadores (nombre) VALUES (?)", java.sql.Statement.RETURN_GENERATED_KEYS);
        psInsert.setString(1, nombre);
        psInsert.executeUpdate();
        ResultSet keys = psInsert.getGeneratedKeys();
        keys.next();
        idJugador = keys.getInt(1);
      }

      PreparedStatement psPartida = conn.prepareStatement("INSERT INTO partidas (id_jugador, puntos, oleadas) VALUES (?, ?, ?)");
      psPartida.setInt(1, idJugador);
      psPartida.setInt(2, puntos);
      psPartida.setInt(3, oleadas);
      psPartida.executeUpdate();
      
      println("Partida guardada en la BD exitosamente.");
    } catch (SQLException e) {
      println("Error al guardar: " + e.getMessage());
    }
  }

  String[] obtenerRecords() {
    ArrayList<String> lista = new ArrayList<String>();
    try {
      // Línea corregida:
      java.sql.Statement st = conn.createStatement();
      ResultSet rs = st.executeQuery("SELECT * FROM vista_ranking");
      
      while (rs.next()) {
        String nombre = rs.getString("nombre");
        int pts = rs.getInt("puntos");
        lista.add(nombre + " - " + pts + " pts");
      }
    } catch (SQLException e) {
      println("Error al leer records: " + e.getMessage());
    }
    return lista.toArray(new String[0]);
  }
}
