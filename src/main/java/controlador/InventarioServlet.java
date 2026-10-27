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
 * Servlet que gestiona el inventario (entradas y salidas de stock).
 *
 * @author Fernando Ledezma
 */
@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idProducto = request.getParameter("idProducto");
        String tipoMovimiento = request.getParameter("tipo"); // "entrada" o "salida"
        String cantidad = request.getParameter("cantidad");

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            conexion con = new conexion();
            cn = con.getConnection();

            String operador = "entrada".equals(tipoMovimiento) ? "+" : "-";

            String sql = "UPDATE inventario SET stock_actual = stock_actual " + operador
                    + " ? WHERE id_producto = ?";

            ps = cn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(cantidad));
            ps.setInt(2, Integer.parseInt(idProducto));

            ps.executeUpdate();

            response.sendRedirect("gestion-productos.jsp?exito=movimiento");

        } catch (SQLException e) {
            Logger.getLogger(InventarioServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendRedirect("gestion-productos.jsp?error=movimiento");
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) { }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet que gestiona el inventario del sistema SIGIBE.";
    }
}
