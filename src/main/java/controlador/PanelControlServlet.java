/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import modelo.conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PanelControlServlet", urlPatterns = {"/PanelControlServlet"})
public class PanelControlServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Variables para guardar los totales
        double totalVentas = 0;
        int totalInventario = 0;
        int totalPedidos = 0;
        int totalUsuarios = 0;

        try (Connection cn = new conexion().getConnection()) {
            
            // 1. Calcular Ventas Totales (Sumando el total de la tabla pedido o factura)
            // NOTA: Ajusta "total" si en tu tabla "pedido" se llama diferente.
            try (PreparedStatement ps = cn.prepareStatement("SELECT SUM(total) AS total_ventas FROM pedido");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalVentas = rs.getDouble("total_ventas");
                }
            } catch (Exception e) {
                // Si la tabla pedido no tiene columna 'total', no rompemos la página.
                Logger.getLogger(PanelControlServlet.class.getName()).log(Level.WARNING, "No se pudo calcular ventas", e);
            }

            // 2. Calcular Inventario (Sumando el stock de todos los productos)
            try (PreparedStatement ps = cn.prepareStatement("SELECT SUM(stock) AS total_stock FROM producto");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalInventario = rs.getInt("total_stock");
                }
            }

            // 3. Contar Pedidos Totales
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) AS cant_pedidos FROM pedido");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalPedidos = rs.getInt("cant_pedidos");
                }
            }

            // 4. Contar Usuarios Totales
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) AS cant_usuarios FROM cliente");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalUsuarios = rs.getInt("cant_usuarios");
                }
            }

        } catch (Exception e) {
            Logger.getLogger(PanelControlServlet.class.getName()).log(Level.SEVERE, "Error de conexión o SQL", e);
        }

        // Enviamos los datos al JSP
        request.setAttribute("ventas", totalVentas);
        request.setAttribute("inventario", totalInventario);
        request.setAttribute("pedidos", totalPedidos);
        request.setAttribute("usuarios", totalUsuarios);

        // Redirigimos al JSP
        request.getRequestDispatcher("panel-control.jsp").forward(request, response);
    }
}