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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CatalogoServlet", urlPatterns = {"/CatalogoServlet"})
public class CatalogoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> productos = new ArrayList<>();
        
        // LA MAGIA ESTÁ AQUÍ: WHERE activo = 1 AND stock > 0
        String sql = "SELECT id_producto, nombre_producto, precio, decripcion "
                   + "FROM producto "
                   + "WHERE activo = 1 AND stock > 0 "
                   + "ORDER BY id_producto DESC";
        
        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, String> prod = new HashMap<>();
                prod.put("id", String.valueOf(rs.getInt("id_producto")));
                prod.put("nombre", rs.getString("nombre_producto"));
                prod.put("precio", String.valueOf(rs.getDouble("precio")));
                prod.put("descripcion", rs.getString("decripcion"));
                productos.add(prod);
            }
        } catch (Exception e) {
            Logger.getLogger(CatalogoServlet.class.getName()).log(Level.SEVERE, null, e);
        }
        
        request.setAttribute("listaProductos", productos);
        request.getRequestDispatcher("catalogo.jsp").forward(request, response);
    }
}