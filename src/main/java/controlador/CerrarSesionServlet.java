
package controlador;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CerrarSesionServlet",
            urlPatterns = {"/CerrarSesionServlet"})
public class CerrarSesionServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(CerrarSesionServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        cerrarSesion(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        cerrarSesion(request, response);
    }

    private void cerrarSesion(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion != null) {

            LOGGER.info("Se ha cerrado una sesión de BAD EAGLE.");

            // Elimina los atributos y los datos almacenados en sesión.
            sesion.invalidate();
        }

        response.sendRedirect(
                request.getContextPath() + "/home.jsp"
        );
    }

    @Override
    public String getServletInfo() {
        return "Controlador de cierre de sesión de BAD EAGLE.";
    }
}