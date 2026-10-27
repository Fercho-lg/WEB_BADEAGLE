/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author USUARIO
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada de gestionar la conexión con la base de datos
 * del sistema SIGIBE - Bad Eagle Confecciones.
 *
 * @author Fernando Ledezma
 * @version 1.0
 */
public class conexion {

    // =====================================================
    // PARÁMETROS DE CONEXIÓN
    // =====================================================

    private static final String URL =
            "jdbc:mysql://localhost:3306/badeagle";

    private static final String USER = "root";

    private static final String PASS = "Fernando-98";

    // =====================================================
    // MÉTODO DE CONEXIÓN
    // =====================================================

    /**
     * Establece la conexión con la base de datos MySQL.
     *
     * @return objeto Connection si la conexión es exitosa,
     *         null en caso contrario.
     */
    public static Connection conectar() {

        Connection con = null;

        try {

            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establecer la conexión
            con = DriverManager.getConnection(URL, USER, PASS);

            System.out.println("Conexión exitosa a la base de datos badeagle");

        } catch (ClassNotFoundException e) {

            System.out.println("Error: Driver MySQL no encontrado -> " + e.getMessage());

        } catch (SQLException e) {

            System.out.println("Conexión fallida -> " + e.getMessage());

        }

        return con;
    }

    // =====================================================
    // MÉTODO ALIAS (para compatibilidad con código previo)
    // =====================================================

    /**
     * Método alias para mantener compatibilidad con código existente
     * que llama a con.getConnection().
     *
     * @return objeto Connection
     */
    public Connection getConnection() {
        return conectar();
    }

    /**
     * Método alias para mantener compatibilidad con código existente
     * que llama a con.getConection() (versión con error ortográfico).
     *
     * @return objeto Connection
     */
    public Connection getConection() {
        return conectar();
    }
}
