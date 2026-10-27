package controlador;

import modelo.conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

@WebServlet(name = "ProductoServlet", urlPatterns = {"/ProductoServlet"})
public class ProductoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> listaProductos = new ArrayList<>();
        List<Map<String, String>> listaCategorias = new ArrayList<>();

        try (Connection cn = new conexion().getConnection()) {
            
            // 1. Cargar Categorías
            try (PreparedStatement psCat = cn.prepareStatement("SELECT id_categoria, nombre FROM categorias");
                 ResultSet rsCat = psCat.executeQuery()) {
                while (rsCat.next()) {
                    Map<String, String> cat = new HashMap<>();
                    cat.put("id", String.valueOf(rsCat.getInt("id_categoria")));
                    cat.put("nombre", rsCat.getString("nombre"));
                    listaCategorias.add(cat);
                }
            }

            // 2. Cargar Productos
            String sql = "SELECT p.id_producto, p.nombre_producto, p.precio, p.stock, p.stock_minimo, p.activo, "
                       + "c.nombre AS nombre_categoria "
                       + "FROM producto p "
                       + "LEFT JOIN categorias c ON p.id_categoria = c.id_categoria "
                       + "ORDER BY p.id_producto DESC";

            try (PreparedStatement ps = cn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> prod = new HashMap<>();
                    prod.put("id", String.valueOf(rs.getInt("id_producto")));
                    prod.put("nombre", rs.getString("nombre_producto"));
                    prod.put("precio", String.valueOf(rs.getDouble("precio")));
                    prod.put("stock", String.valueOf(rs.getInt("stock")));
                    prod.put("stock_minimo", String.valueOf(rs.getInt("stock_minimo")));
                    prod.put("activo", rs.getInt("activo") == 1 ? "Activo" : "Inactivo");
                    prod.put("categoria", rs.getString("nombre_categoria") != null ? rs.getString("nombre_categoria") : "Sin categoría");
                    listaProductos.add(prod);
                }
            }
        } catch (Exception e) {
            Logger.getLogger(ProductoServlet.class.getName()).log(Level.SEVERE, null, e);
        }

        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("listaCategorias", listaCategorias);
        request.getRequestDispatcher("gestion-productos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("agregar".equals(accion)) {
            agregarProducto(request, response);
        } else if ("editar".equals(accion)) {
            editarProducto(request, response);
        } else if ("eliminar".equals(accion)) {
            eliminarProducto(request, response);
        } else if ("activar".equals(accion)) {
            activarProducto(request, response);
        } else {
            response.sendRedirect("ProductoServlet");
        }
    }

    private void agregarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nombre = request.getParameter("nombre");
        String idCategoria = request.getParameter("id_categoria");
        String precio = request.getParameter("precio");
        String stock = request.getParameter("stock");
        String stockMinimo = request.getParameter("stock_minimo");

        Connection cn = null;
        try {
            cn = new conexion().getConnection();
            cn.setAutoCommit(false);

            // Incluimos talla y color por defecto para evitar el error de la BD
            String sql = "INSERT INTO producto (id_categoria, nombre_producto, decripcion, precio, stock, stock_minimo, activo, talla, color) "
                       + "VALUES (?, ?, 'Sin descripción', ?, ?, ?, 1, 'Única', 'Negro')";
                       
            PreparedStatement ps = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, Integer.parseInt(idCategoria));
            ps.setString(2, nombre);
            ps.setDouble(3, Double.parseDouble(precio));
            ps.setInt(4, Integer.parseInt(stock));
            ps.setInt(5, Integer.parseInt(stockMinimo));
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idProducto = rs.getInt(1);
                String sqlInv = "INSERT INTO inventario (id_producto, stock_actual, stock_minimo) VALUES (?, ?, ?)";
                PreparedStatement psInv = cn.prepareStatement(sqlInv);
                psInv.setInt(1, idProducto);
                psInv.setInt(2, Integer.parseInt(stock));
                psInv.setInt(3, Integer.parseInt(stockMinimo));
                psInv.executeUpdate();
            }

            cn.commit();
            response.sendRedirect("ProductoServlet?exito=agregado");

        } catch (Exception e) {
            if (cn != null) try { cn.rollback(); } catch (SQLException ex) {}
            Logger.getLogger(ProductoServlet.class.getName()).log(Level.SEVERE, "Error al insertar", e);
            response.sendRedirect("ProductoServlet?error=1");
        } finally {
            if (cn != null) try { cn.close(); } catch (SQLException e) {}
        }
    }

    private void editarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String precio = request.getParameter("precio");
        String stock = request.getParameter("stock");

        String sql = "UPDATE producto SET nombre_producto=?, precio=?, stock=? WHERE id_producto=?";

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setDouble(2, Double.parseDouble(precio));
            ps.setInt(3, Integer.parseInt(stock));
            ps.setInt(4, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("ProductoServlet?exito=editado");
        } catch (Exception e) {
            Logger.getLogger(ProductoServlet.class.getName()).log(Level.SEVERE, "Error al editar", e);
            response.sendRedirect("ProductoServlet?error=2");
        }
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String sql = "UPDATE producto SET activo = 0 WHERE id_producto = ?";

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("ProductoServlet?exito=desactivado");
        } catch (Exception e) {
            Logger.getLogger(ProductoServlet.class.getName()).log(Level.SEVERE, "Error al desactivar", e);
            response.sendRedirect("ProductoServlet?error=3");
        }
    }

    private void activarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String sql = "UPDATE producto SET activo = 1 WHERE id_producto = ?";

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("ProductoServlet?exito=activado");
        } catch (Exception e) {
            Logger.getLogger(ProductoServlet.class.getName()).log(Level.SEVERE, "Error al activar", e);
            response.sendRedirect("ProductoServlet?error=4");
        }
    }
}