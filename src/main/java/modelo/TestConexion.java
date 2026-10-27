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

/**
 * Clase de prueba para verificar la conexión con la base de datos
 * badeagle del proyecto SIGIBE - Bad Eagle Confecciones.
 *
 * @author Fernando Ledezma
 * @version 1.0
 */
public class TestConexion {

    public static void main(String[] args) {

        // Intentar la conexión
        Connection con = conexion.conectar();

        // Verificar si la conexión fue exitosa
        if (con != null) {

            System.out.println("========================================");
            System.out.println("   ¡CONECTADO CORRECTAMENTE!");
            System.out.println("   Base de datos: badeagle");
            System.out.println("   Proyecto: SIGIBE");
            System.out.println("========================================");

        } else {

            System.out.println("========================================");
            System.out.println("   NO SE PUDO CONECTAR");
            System.out.println("   Revisa la configuración del servidor");
            System.out.println("========================================");

        }
    }
}
