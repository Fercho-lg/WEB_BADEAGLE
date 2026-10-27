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
import java.sql.Statement;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PedidoServlet", urlPatterns = {"/PedidoServlet"})
public class PedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Verificar sesión (si no, mandar a login)
        if (session == null || session.getAttribute("idCliente") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion");
            return;
        }

        int idCliente = (Integer) session.getAttribute("idCliente");
        List<String> carrito = (List<String>) session.getAttribute("carrito");

        if (carrito == null || carrito.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/carrito.jsp?error=vacio");
            return;
        }

        try (Connection cn = new conexion().getConnection()) {
            cn.setAutoCommit(false); // Iniciar transacción

            // 2. Calcular Total
            double total = 0;
            for (String item : carrito) {
                total += Double.parseDouble(item.split("\\|")[2]);
            }

            // 3. Insertar Pedido
            String sqlPedido = "INSERT INTO pedido (id_cliente, estado, total) VALUES (?, 'pendiente', ?)";
            PreparedStatement psPedido = cn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS);
            psPedido.setInt(1, idCliente);
            psPedido.setDouble(2, total);
            psPedido.executeUpdate();

            ResultSet rs = psPedido.getGeneratedKeys();
            int idPedido = 0;
            if (rs.next()) idPedido = rs.getInt(1);

            // 4. Insertar Detalles (item_pedido)
            String sqlItem = "INSERT INTO item_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (?, ?, 1, ?)";
            PreparedStatement psItem = cn.prepareStatement(sqlItem);
            
            for (String item : carrito) {
                String[] datos = item.split("\\|");
                psItem.setInt(1, idPedido);
                psItem.setInt(2, Integer.parseInt(datos[0]));
                psItem.setDouble(3, Double.parseDouble(datos[2]));
                psItem.executeUpdate();
            }

            // 5. Insertar Factura
            String sqlFactura = "INSERT INTO factura (id_pedido, sub_total, iva, total) VALUES (?, ?, 0, ?)";
            PreparedStatement psFactura = cn.prepareStatement(sqlFactura);
            psFactura.setInt(1, idPedido);
            psFactura.setDouble(2, total);
            psFactura.setDouble(3, total);
            psFactura.executeUpdate();

            // 6. Confirmar y limpiar carrito
            cn.commit();
            session.removeAttribute("carrito"); // Vaciar carrito

            // Redirigir a éxito
            response.sendRedirect(request.getContextPath() + "/confirmacion.jsp?id=" + idPedido);

        } catch (Exception e) {
            Logger.getLogger(PedidoServlet.class.getName()).log(Level.SEVERE, "Error en pedido", e);
            response.sendRedirect(request.getContextPath() + "/carrito.jsp?error=bd");
        }
    }
}
