package mi_cooperativa_hv;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import java.sql.Connection;

public class Mi_cooperativa_Hv {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {

            JFrame frame = new JFrame("Mi Cooperativa");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(650, 535);
            frame.setLocationRelativeTo(null); // Centrar la ventana

            Pantalla_Principal pantalla = new Pantalla_Principal();
            frame.add(pantalla);

            frame.setVisible(true);

            try {
                Connection c = Database.getConnection();
                JOptionPane.showMessageDialog(frame, "¡Conexión exitosa a Firebird!");
                c.close(); 
            } catch (Exception e) {
                JOptionPane.showMessageDialog(frame, "Error al conectar a Firebird: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        });
    }
}