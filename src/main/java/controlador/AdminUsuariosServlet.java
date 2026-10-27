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

@WebServlet(name = "AdminUsuariosServlet", urlPatterns = {"/AdminUsuariosServlet"})
public class AdminUsuariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> listaUsuarios = new ArrayList<>();

        // Usamos SELECT * para que si falta alguna columna, no explote la consulta
        String sql = "SELECT * FROM cliente ORDER BY id_cliente DESC";

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, String> user = new HashMap<>();
                user.put("id", String.valueOf(rs.getInt("id_cliente")));
                user.put("nombre", rs.getString("nombre"));
                user.put("email", rs.getString("email"));
                user.put("telefono", rs.getString("telefono") != null ? rs.getString("telefono") : "-");
                
                // Validación segura por si las columnas no existen en la BD
                String rol = "cliente";
                try { rol = rs.getString("rol"); } catch (Exception e) {}
                user.put("rol", rol);

                String activo = "Activo";
                try { activo = rs.getInt("activo") == 1 ? "Activo" : "Inactivo"; } catch (Exception e) {}
                user.put("activo", activo);
                
                String fecha = "-";
                try {
                    java.sql.Timestamp fechaSql = rs.getTimestamp("fecha_registro");
                    if(fechaSql != null) fecha = fechaSql.toString().substring(0, 10);
                } catch (Exception e) {}
                user.put("fecha", fecha);
                
                listaUsuarios.add(user);
            }
        } catch (Exception e) {
            Logger.getLogger(AdminUsuariosServlet.class.getName()).log(Level.SEVERE, null, e);
        }

        request.setAttribute("listaUsuarios", listaUsuarios);
        request.getRequestDispatcher("gestion-usuarios.jsp").forward(request, response);
    }
}