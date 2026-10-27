package controlador;

import modelo.conexion;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private static final int ITERACIONES = 600000;
    private static final int TIEMPO_INACTIVIDAD = 15 * 60;
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        if (estaVacio(correo) || estaVacio(password)) {
            redirigir(request, response, "login.jsp?error=campos");
            return;
        }

        correo = correo.trim().toLowerCase(Locale.ROOT);

        // Agregamos la columna 'rol' a la consulta
        String sql = "SELECT id_cliente, nombre, email, pasword, rol "
                + "FROM cliente WHERE email = ?";

        Connection conexionBD = new conexion().getConnection();

        if (conexionBD == null) {
            redirigir(request, response, "login.jsp?error=conexion");
            return;
        }

        try (Connection cn = conexionBD) {
            int idCliente;
            String nombre;
            String email;
            String hashAlmacenado;
            String rol;

            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setString(1, correo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        redirigir(request, response, "login.jsp?error=credenciales");
                        return;
                    }
                    idCliente = rs.getInt("id_cliente");
                    nombre = rs.getString("nombre");
                    email = rs.getString("email");
                    hashAlmacenado = rs.getString("pasword");
                    rol = rs.getString("rol"); // Guardamos el rol
                }
            }

            boolean esHashPBKDF2 = hashAlmacenado != null && hashAlmacenado.startsWith("pbkdf2-sha256$");
            boolean passwordValida;

            if (esHashPBKDF2) {
                passwordValida = validarPassword(password, hashAlmacenado);
            } else {
                passwordValida = hashAlmacenado != null && MessageDigest.isEqual(
                        password.getBytes(StandardCharsets.UTF_8), hashAlmacenado.getBytes(StandardCharsets.UTF_8));
            }

            if (!passwordValida) {
                redirigir(request, response, "login.jsp?error=credenciales");
                return;
            }

            if (!esHashPBKDF2) {
                try {
                    String nuevoHash = generarHash(password);
                    String sqlActualizar = "UPDATE cliente SET pasword = ? WHERE id_cliente = ?";
                    try (PreparedStatement ps = cn.prepareStatement(sqlActualizar)) {
                        ps.setString(1, nuevoHash);
                        ps.setInt(2, idCliente);
                        ps.executeUpdate();
                    }
                } catch (GeneralSecurityException | SQLException e) {
                    LOGGER.log(Level.SEVERE, "No se pudo migrar la contraseña antigua.", e);
                }
            }

            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                request.changeSessionId();
            } else {
                sesion = request.getSession(true);
            }

            sesion.setMaxInactiveInterval(TIEMPO_INACTIVIDAD);
            sesion.setAttribute("idCliente", idCliente);
            sesion.setAttribute("nombreUsuario", nombre);
            sesion.setAttribute("correoUsuario", email);
            sesion.setAttribute("rol", rol); // <--- GUARDAMOS EL ROL EN SESIÓN

            // REDIRECCIÓN INTELIGENTE
            if ("administrador".equals(rol)) {
                redirigir(request, response, "PanelControlServlet");
            } else {
                redirigir(request, response, "home.jsp");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error SQL durante el inicio de sesión.", e);
            redirigir(request, response, "login.jsp?error=bd");
        }
    }

    private boolean validarPassword(String password, String hashAlmacenado) {
        if (password == null || hashAlmacenado == null) return false;
        String[] partes = hashAlmacenado.split("\\$", -1);
        if (partes.length != 4 || !"pbkdf2-sha256".equals(partes[0])) return false;

        try {
            int iteraciones = Integer.parseInt(partes[1]);
            if (iteraciones < 100000 || iteraciones > 1000000) return false;

            byte[] sal = Base64.getDecoder().decode(partes[2]);
            byte[] hashEsperado = Base64.getDecoder().decode(partes[3]);
            if (sal.length != 16 || hashEsperado.length != 32) return false;

            PBEKeySpec especificacion = new PBEKeySpec(password.toCharArray(), sal, iteraciones, hashEsperado.length * 8);
            try {
                SecretKeyFactory fabrica = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
                byte[] hashCalculado = fabrica.generateSecret(especificacion).getEncoded();
                return MessageDigest.isEqual(hashCalculado, hashEsperado);
            } finally {
                especificacion.clearPassword();
            }
        } catch (IllegalArgumentException | GeneralSecurityException e) {
            return false;
        }
    }

    private String generarHash(String password) throws GeneralSecurityException {
        byte[] sal = new byte[16];
        RANDOM.nextBytes(sal);
        PBEKeySpec especificacion = new PBEKeySpec(password.toCharArray(), sal, ITERACIONES, 256);
        try {
            SecretKeyFactory fabrica = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = fabrica.generateSecret(especificacion).getEncoded();
            return "pbkdf2-sha256$" + ITERACIONES + "$" + Base64.getEncoder().encodeToString(sal) + "$" + Base64.getEncoder().encodeToString(hash);
        } finally {
            especificacion.clearPassword();
        }
    }

    private boolean estaVacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

    private void redirigir(HttpServletRequest request, HttpServletResponse response, String destino) throws IOException {
        response.sendRedirect(request.getContextPath() + "/" + destino);
    }
}