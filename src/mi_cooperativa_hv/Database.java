package mi_cooperativa_hv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Database {
    public static Connection getConnection() throws Exception {

        String url = "jdbc:firebirdsql://localhost:3051//firebird/data/mydatabase.fdb"; // Ajusta la ruta y el puerto
        String user = "SYSDBA"; 
        String password = "masterkey"; 

        
        Class.forName("org.firebirdsql.jdbc.FBDriver");

       
        return DriverManager.getConnection(url, user, password);
    }
    
public static int validarUsuario(String us, String pass) {
    String sql = "SELECT * FROM Usuario WHERE ID_USUARIO = ? AND CONTRASENA = ?";
    try (Connection connection = getConnection();
         PreparedStatement statement = connection.prepareStatement(sql)) {
        statement.setString(1, us);
        statement.setString(2, pass);

        try (ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                String rol = resultSet.getString("ROL");
                if (rol.equals("ADMIN")) {
                    return 1; 
                } else if (rol.equals("AFILIADO")) {
                    return 2; 
                }
            }
            return 0; 
        }
    } catch (Exception e) {
        e.printStackTrace();
        return 0; 
    }

}
public static boolean agregarAfiliado(String primerNombre, String segundoNombre, String primerApellido, String segundoApellido,
                            String calle, String avenida, String numCasa, String ciudad, String departamento,
                            String referencia, String correoPrimario, String correoSecundario, Date fechaNacimiento, List<String> telefonos, String User_creador) {

    String sqlAfiliado = "INSERT INTO AFILIADO (PRIMER_NOMBRE, SEGUNDO_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, " +
                         "CALLE, AVENIDA, NUM_CASA, CIUDAD, DEPARTAMENTO, REFERENCIA, CORREO_PRIMARIO, CORREO_SECUNDARIO, FECHA_NACIMIENTO, USUARIO_CREADOR) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    String sqlTelefono = "INSERT INTO TELEFONOS_AFILIADO (TELEFONO, AFILIADO_CODIGO) VALUES (?, ?)";

    try (Connection connection = Database.getConnection();
         PreparedStatement stmtAfiliado = connection.prepareStatement(sqlAfiliado, PreparedStatement.RETURN_GENERATED_KEYS)) {

        stmtAfiliado.setString(1, primerNombre);
        stmtAfiliado.setString(2, segundoNombre);
        stmtAfiliado.setString(3, primerApellido);
        stmtAfiliado.setString(4, segundoApellido);
        stmtAfiliado.setString(5, calle);
        stmtAfiliado.setString(6, avenida);
        stmtAfiliado.setString(7, numCasa);
        stmtAfiliado.setString(8, ciudad);
        stmtAfiliado.setString(9, departamento);
        stmtAfiliado.setString(10, referencia);
        stmtAfiliado.setString(11, correoPrimario);
        stmtAfiliado.setString(12, correoSecundario);
        stmtAfiliado.setDate(13, new java.sql.Date(fechaNacimiento.getTime()));
        stmtAfiliado.setString(14, User_creador);

        stmtAfiliado.executeUpdate();

        ResultSet generatedKeys = stmtAfiliado.getGeneratedKeys();
        String codigoAfiliado = null;
        if (generatedKeys.next()) {
            codigoAfiliado = generatedKeys.getString(1); 
        }

        if (codigoAfiliado != null) {
            for (String telefono : telefonos) {
                try (PreparedStatement stmtTelefono = connection.prepareStatement(sqlTelefono)) {
                    stmtTelefono.setString(1, telefono);
                    stmtTelefono.setString(2, codigoAfiliado);
                    stmtTelefono.executeUpdate();
                }
            }
        }

        return true;
        
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    @SuppressWarnings("CallToPrintStackTrace")
    public static List<Afiliados_obj> obtenerAfliados() throws Exception{
   List<Afiliados_obj> afiliados = new ArrayList<>();
   String sql = "SELECT CODIGO, PRIMER_NOMBRE, PRIMER_APELLIDO FROM AFILIADO";
   
            try (Connection connection = Database.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String codigo = rs.getString("CODIGO");
                String primerNombre = rs.getString("PRIMER_NOMBRE");
                String primerApellido = rs.getString("PRIMER_APELLIDO");

                Afiliados_obj afiliado = new Afiliados_obj(codigo, primerNombre, primerApellido);
                afiliados.add(afiliado);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return afiliados;
}
}