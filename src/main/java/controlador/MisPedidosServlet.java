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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MisPedidosServlet", urlPatterns = {"/MisPedidosServlet"})
public class MisPedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idCliente") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion");
            return;
        }

        int idCliente = (Integer) session.getAttribute("idCliente");
        List<Map<String, String>> pedidos = new ArrayList<>();

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement("SELECT * FROM pedido WHERE id_cliente = ? ORDER BY id_pedido DESC")) {
            
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("id", String.valueOf(rs.getInt("id_pedido")));
                p.put("estado", rs.getString("estado"));
                p.put("total", String.format("%,.0f", rs.getDouble("total")));
                pedidos.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("listaPedidos", pedidos);
        request.getRequestDispatcher("pedidos.jsp").forward(request, response);
    }
}
    
