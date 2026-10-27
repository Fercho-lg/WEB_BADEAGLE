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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PerfilServlet", urlPatterns = {"/PerfilServlet"})
public class PerfilServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(PerfilServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        configurarNoCache(response);

        HttpSession sesion = request.getSession(false);
        Integer idCliente = obtenerIdCliente(sesion);

        if (idCliente == null) {
            redirigir(request, response, "login.jsp?error=sesion");
            return;
        }

        String sql = "SELECT id_cliente, nombre, email, telefono, direccion "
                + "FROM cliente WHERE id_cliente = ?";

        Connection conexionBD = new conexion().getConnection();

        if (conexionBD == null) {
            mostrarPerfilConError(
                    request, response, sesion, idCliente, "conexion"
            );
            return;
        }

        try (Connection cn = conexionBD;
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    sesion.invalidate();
                    redirigir(
                            request,
                            response,
                            "login.jsp?error=sesion"
                    );
                    return;
                }

                request.setAttribute(
                        "idClientePerfil",
                        rs.getInt("id_cliente")
                );

                request.setAttribute(
                        "nombrePerfil",
                        rs.getString("nombre")
                );

                request.setAttribute(
                        "correoPerfil",
                        rs.getString("email")
                );

                request.setAttribute(
                        "telefonoPerfil",
                        rs.getString("telefono")
                );

                request.setAttribute(
                        "direccionPerfil",
                        rs.getString("direccion")
                );
            }

            request.getRequestDispatcher("/perfil.jsp")
                    .forward(request, response);

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Error al consultar los datos del perfil.",
                    e
            );

            mostrarPerfilConError(
                    request, response, sesion, idCliente, "bd"
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        configurarNoCache(response);

        HttpSession sesion = request.getSession(false);
        Integer idCliente = obtenerIdCliente(sesion);

        if (idCliente == null) {
            redirigir(request, response, "login.jsp?error=sesion");
            return;
        }

        String accion = request.getParameter("accion");

        if (!"actualizarDireccion".equals(accion)) {
            redirigir(request, response, "PerfilServlet?error=accion");
            return;
        }

        String direccion = request.getParameter("direccion");

        if (direccion == null) {
            redirigir(
                    request, response, "PerfilServlet?error=direccion"
            );
            return;
        }

        direccion = direccion.trim();

        if (direccion.isEmpty() || direccion.length() > 100) {
            redirigir(
                    request, response, "PerfilServlet?error=direccion"
            );
            return;
        }

        for (int i = 0; i < direccion.length(); i++) {
            if (Character.isISOControl(direccion.charAt(i))) {
                redirigir(
                        request, response,
                        "PerfilServlet?error=direccion"
                );
                return;
            }
        }

        Connection conexionBD = new conexion().getConnection();

        if (conexionBD == null) {
            redirigir(
                    request, response, "PerfilServlet?error=conexion"
            );
            return;
        }

        String sql = "UPDATE cliente SET direccion = ? "
                + "WHERE id_cliente = ?";

        try (Connection cn = conexionBD;
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, direccion);
            ps.setInt(2, idCliente);

            int filasActualizadas = ps.executeUpdate();

            // MySQL puede devolver cero si la dirección no cambió.
            // En ese caso comprobamos que el cliente siga existiendo.
            if (filasActualizadas == 0) {

                String comprobarSql =
                        "SELECT id_cliente FROM cliente "
                        + "WHERE id_cliente = ?";

                try (PreparedStatement comprobar =
                             cn.prepareStatement(comprobarSql)) {

                    comprobar.setInt(1, idCliente);

                    try (ResultSet rs = comprobar.executeQuery()) {

                        if (!rs.next()) {
                            sesion.invalidate();
                            redirigir(
                                    request,
                                    response,
                                    "login.jsp?error=sesion"
                            );
                            return;
                        }
                    }
                }
            }

            redirigir(
                    request,
                    response,
                    "PerfilServlet?direccion=ok"
            );

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Error al actualizar la dirección del cliente.",
                    e
            );

            redirigir(request, response, "PerfilServlet?error=bd");
        }
    }

    private Integer obtenerIdCliente(HttpSession sesion) {

        if (sesion == null) {
            return null;
        }

        Object valor = sesion.getAttribute("idCliente");

        if (valor instanceof Number) {
            return ((Number) valor).intValue();
        }

        return null;
    }

    private void mostrarPerfilConError(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession sesion,
            Integer idCliente,
            String error)
            throws ServletException, IOException {

        request.setAttribute("idClientePerfil", idCliente);
        request.setAttribute(
                "nombrePerfil",
                sesion.getAttribute("nombreUsuario")
        );
        request.setAttribute(
                "correoPerfil",
                sesion.getAttribute("correoUsuario")
        );
        request.setAttribute("telefonoPerfil", "");
        request.setAttribute("direccionPerfil", "");
        request.setAttribute("errorPerfil", error);

        request.getRequestDispatcher("/perfil.jsp")
                .forward(request, response);
    }

    private void configurarNoCache(HttpServletResponse response) {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate, max-age=0"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    private void redirigir(HttpServletRequest request,
                           HttpServletResponse response,
                           String destino) throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/" + destino
        );
    }
}
