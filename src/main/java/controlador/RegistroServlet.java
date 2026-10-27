
package controlador;

import modelo.conexion;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Base64;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Controlador encargado del registro de usuarios de BAD EAGLE.
 *
 * Recibe los datos del formulario registro.jsp, realiza validaciones
 * en el servidor y almacena los datos en la tabla cliente.
 */
@WebServlet(name = "RegistroServlet",
            urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(RegistroServlet.class.getName());

    private static final int ITERACIONES_PBKDF2 = 600000;

    private static final SecureRandom RANDOM = new SecureRandom();

    private static final Pattern PATRON_EMAIL =
            Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    private static final Pattern PATRON_TELEFONO =
            Pattern.compile("[0-9+() -]{7,20}");

    /**
     * Procesa el envío del formulario mediante POST.
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar la codificación antes de leer los parámetros.
        request.setCharacterEncoding("UTF-8");

        // 1. Recibir los datos del formulario.
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String fechaNacimiento =
                request.getParameter("fechaNacimiento");

        String password = request.getParameter("password");
        String confirmarPassword =
                request.getParameter("confirmarPassword");

        String terminos = request.getParameter("terminos");

        // 2. Comprobar que se hayan enviado los datos obligatorios.
        if (estaVacio(nombre)
                || estaVacio(correo)
                || estaVacio(telefono)
                || estaVacio(fechaNacimiento)
                || estaVacio(password)
                || estaVacio(confirmarPassword)) {

            redirigir(request, response, "registro.jsp?error=campos");
            return;
        }

        // 3. Limpiar los campos de texto.
        nombre = nombre.trim();
        correo = correo.trim().toLowerCase(Locale.ROOT);
        telefono = telefono.trim();

        // 4. Validar las longitudes permitidas por la base de datos.
        if (nombre.length() > 100
                || correo.length() > 100
                || telefono.length() > 20
                || password.length() > 128
                || confirmarPassword.length() > 128) {

            redirigir(request, response, "registro.jsp?error=longitud");
            return;
        }

        // 5. Validar la estructura básica del correo electrónico.
        if (!PATRON_EMAIL.matcher(correo).matches()) {

            redirigir(request, response, "registro.jsp?error=email");
            return;
        }

        // 6. Validar el teléfono.
        if (!PATRON_TELEFONO.matcher(telefono).matches()) {

            redirigir(request, response, "registro.jsp?error=telefono");
            return;
        }

        // 7. Validar la contraseña.
        if (password.length() < 8
                || !password.equals(confirmarPassword)) {

            redirigir(request, response, "registro.jsp?error=password");
            return;
        }

        // 8. Comprobar la aceptación de los términos.
        if (terminos == null) {

            redirigir(request, response, "registro.jsp?error=terminos");
            return;
        }

        // 9. Convertir y validar la fecha de nacimiento.
        LocalDate fechaNac;

        try {

            fechaNac = LocalDate.parse(fechaNacimiento);

            if (fechaNac.isAfter(LocalDate.now())) {
                redirigir(request, response, "registro.jsp?error=fecha");
                return;
            }

        } catch (DateTimeParseException e) {

            redirigir(request, response, "registro.jsp?error=fecha");
            return;
        }

        // 10. Generar un hash seguro de la contraseña.
        // No se almacena la contraseña original en la tabla.
        String passwordHash;

        try {

            passwordHash = generarHash(password);

        } catch (GeneralSecurityException e) {

            LOGGER.log(Level.SEVERE,
                    "No fue posible procesar la contraseña.", e);

            redirigir(request, response, "registro.jsp?error=seguridad");
            return;
        }

        // 11. Preparar la consulta de inserción.
        // id_cliente y fecha_registro se generan automáticamente.
        String sql = "INSERT INTO cliente "
                + "(nombre, email, direccion, telefono, "
                + "fecha_nacimiento, pasword) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        // 12. Obtener la conexión con MySQL.
        Connection conexionBD = new conexion().getConnection();

        if (conexionBD == null) {

            LOGGER.severe("No se pudo establecer la conexión con MySQL.");

            redirigir(request, response, "registro.jsp?error=conexion");
            return;
        }

        // 13. Ejecutar la consulta y cerrar los recursos automáticamente.
        try (Connection cn = conexionBD;
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, correo);

            // La tabla exige direccion NOT NULL.
            // El formulario actual todavía no solicita una dirección.
            ps.setString(3, "");

            ps.setString(4, telefono);
            ps.setDate(5, Date.valueOf(fechaNac));
            ps.setString(6, passwordHash);

            int filasInsertadas = ps.executeUpdate();

            if (filasInsertadas > 0) {

                LOGGER.info("Registro de usuario completado.");

                redirigir(
                        request,
                        response,
                        "login.jsp?registro=ok"
                );

            } else {

                redirigir(request, response, "registro.jsp?error=bd");
            }

        } catch (SQLException e) {

            // MySQL 1062 indica una entrada duplicada.
            if (e.getErrorCode() == 1062) {

                LOGGER.info("Se intentó registrar un correo existente.");

                redirigir(
                        request,
                        response,
                        "registro.jsp?error=duplicado"
                );

            } else {

                LOGGER.log(Level.SEVERE,
                        "Error SQL durante el registro de usuario.", e);

                redirigir(
                        request,
                        response,
                        "registro.jsp?error=bd"
                );
            }
        }
    }

    /**
     * Comprueba si un dato está vacío o no fue enviado.
     */
    private boolean estaVacio(String valor) {

        return valor == null || valor.trim().isEmpty();
    }

    /**
     * Genera un hash mediante PBKDF2 con HMAC-SHA-256.
     *
     * El resultado incluye el algoritmo, las iteraciones,
     * la sal aleatoria y el hash para permitir su verificación
     * posterior desde LoginServlet.
     */
    private String generarHash(String password)
            throws GeneralSecurityException {

        byte[] sal = new byte[16];
        RANDOM.nextBytes(sal);

        PBEKeySpec especificacion = new PBEKeySpec(
                password.toCharArray(),
                sal,
                ITERACIONES_PBKDF2,
                256
        );

        try {

            SecretKeyFactory fabrica =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] hash = fabrica
                    .generateSecret(especificacion)
                    .getEncoded();

            String salCodificada =
                    Base64.getEncoder().encodeToString(sal);

            String hashCodificado =
                    Base64.getEncoder().encodeToString(hash);

            return "pbkdf2-sha256$"
                    + ITERACIONES_PBKDF2 + "$"
                    + salCodificada + "$"
                    + hashCodificado;

        } finally {

            especificacion.clearPassword();
        }
    }

    /**
     * Redirige al usuario dentro del contexto de la aplicación.
     */
    private void redirigir(HttpServletRequest request,
                           HttpServletResponse response,
                           String destino) throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/" + destino
        );
    }

    @Override
    public String getServletInfo() {

        return "Controlador de registro de usuarios de BAD EAGLE.";
    }
}