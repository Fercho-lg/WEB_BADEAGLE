/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import modelo.conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que procesa el formulario de contacto / PQR.
 * Inserta los datos en la tabla `pqr` de la base de datos.
 *
 * @author Fernando Ledezma
 */
@WebServlet(name = "ContactoServlet", urlPatterns = {"/ContactoServlet"})
public class ContactoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. Recibir los datos
        String tipo = request.getParameter("solicitud");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String mensaje = request.getParameter("mensaje");

        // 2. Validaciones básicas
        if (nombre == null || nombre.trim().isEmpty()
                || correo == null || correo.trim().isEmpty()
                || mensaje == null || mensaje.trim().isEmpty()) {
            response.sendRedirect("contacto.jsp?error=campos");
            return;
        }

        // 3. Conectar a la base de datos e insertar
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            conexion con = new conexion();
            cn = con.getConnection();

            String sql = "INSERT INTO pqr (tipo, nombre, correo, mensaje) "
                    + "VALUES (?, ?, ?, ?)";

            ps = cn.prepareStatement(sql);
            ps.setString(1, tipo);
            ps.setString(2, nombre);
            ps.setString(3, correo);
            ps.setString(4, mensaje);

            int filasInsertadas = ps.executeUpdate();

            if (filasInsertadas > 0) {
                response.sendRedirect("contacto.jsp?envio=ok");
            } else {
                response.sendRedirect("contacto.jsp?error=bd");
            }

        } catch (SQLException e) {
            Logger.getLogger(ContactoServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendRedirect("contacto.jsp?error=bd");
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                Logger.getLogger(ContactoServlet.class.getName()).log(Level.SEVERE, null, e);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet que gestiona las solicitudes PQR del sistema SIGIBE.";
    }
}