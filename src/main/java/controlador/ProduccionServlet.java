/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import modelo.conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
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

@WebServlet(name = "ProduccionServlet", urlPatterns = {"/ProduccionServlet"})
public class ProduccionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> listaOrdenes = new ArrayList<>();
        List<Map<String, String>> listaProductos = new ArrayList<>();

        try (Connection cn = new conexion().getConnection()) {
            
            // 1. Cargar Productos (para el select del modal)
            try (PreparedStatement psProd = cn.prepareStatement("SELECT id_producto, nombre_producto FROM producto WHERE activo = 1");
                 ResultSet rsProd = psProd.executeQuery()) {
                while (rsProd.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", String.valueOf(rsProd.getInt("id_producto")));
                    p.put("nombre", rsProd.getString("nombre_producto"));
                    listaProductos.add(p);
                }
            }

            // 2. Cargar Órdenes de Producción
            String sql = "SELECT pr.id_produccion, pr.codigo_orden, pr.cantidad, pr.taller, pr.estado, "
                       + "pr.fecha_inicio, p.nombre_producto "
                       + "FROM produccion pr "
                       + "JOIN producto p ON pr.id_producto = p.id_producto "
                       + "ORDER BY pr.id_produccion DESC";

            try (PreparedStatement ps = cn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> orden = new HashMap<>();
                    orden.put("id", String.valueOf(rs.getInt("id_produccion")));
                    orden.put("codigo", rs.getString("codigo_orden"));
                    orden.put("producto", rs.getString("nombre_producto"));
                    orden.put("cantidad", String.valueOf(rs.getInt("cantidad")));
                    orden.put("taller", rs.getString("taller"));
                    orden.put("estado", rs.getString("estado"));
                    orden.put("fecha", String.valueOf(rs.getDate("fecha_inicio")));
                    listaOrdenes.add(orden);
                }
            }
        } catch (Exception e) {
            Logger.getLogger(ProduccionServlet.class.getName()).log(Level.SEVERE, null, e);
        }

        request.setAttribute("listaOrdenes", listaOrdenes);
        request.setAttribute("listaProductos", listaProductos);
        request.getRequestDispatcher("gestion-produccion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("agregar".equals(accion)) {
            agregarOrden(request, response);
        } else if ("cambiarEstado".equals(accion)) {
            cambiarEstado(request, response);
        } else {
            response.sendRedirect("ProduccionServlet");
        }
    }

    private void agregarOrden(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idProducto = request.getParameter("id_producto");
        String cantidad = request.getParameter("cantidad");
        String taller = request.getParameter("taller");
        String fechaInicio = request.getParameter("fecha_inicio");
        String fechaEstimada = request.getParameter("fecha_estimada");

        Connection cn = null;
        try {
            cn = new conexion().getConnection();
            
            // Generamos un código único simple (OP- + número aleatorio)
            String codigoOrden = "OP-" + (System.currentTimeMillis() % 100000);

            String sql = "INSERT INTO produccion (codigo_orden, id_producto, cantidad, taller, estado, fecha_inicio, fecha_estimada) "
                       + "VALUES (?, ?, ?, ?, 'Pendiente', ?, ?)";
                       
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, codigoOrden);
            ps.setInt(2, Integer.parseInt(idProducto));
            ps.setInt(3, Integer.parseInt(cantidad));
            ps.setString(4, taller);
            ps.setDate(5, Date.valueOf(fechaInicio));
            ps.setDate(6, Date.valueOf(fechaEstimada));
            
            ps.executeUpdate();
            response.sendRedirect("ProduccionServlet?exito=agregado");

        } catch (Exception e) {
            Logger.getLogger(ProduccionServlet.class.getName()).log(Level.SEVERE, "Error al insertar", e);
            response.sendRedirect("ProduccionServlet?error=1");
        } finally {
            if (cn != null) try { cn.close(); } catch (SQLException e) {}
        }
    }    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String nuevoEstado = request.getParameter("estado");

        String sql = "UPDATE produccion SET estado = ? WHERE id_produccion = ?";

        try (Connection cn = new conexion().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("ProduccionServlet?exito=actualizado");
        } catch (Exception e) {
            Logger.getLogger(ProduccionServlet.class.getName()).log(Level.SEVERE, "Error al actualizar", e);
            response.sendRedirect("ProduccionServlet?error=2");
        }
}
}