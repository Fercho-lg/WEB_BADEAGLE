/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
    "/PanelControlServlet", 
    "/ProductoServlet", 
    "/ProduccionServlet", 
    "/AdminUsuariosServlet", 
    "/AdminPQRServlet", 
    "/panel-control.jsp",
    "/gestion-productos.jsp",
    "/gestion-produccion.jsp",
    "/gestion-usuarios.jsp",
    "/gestion-pqr.jsp",
    "/reportes.jsp"
})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Verificamos si hay sesión y si el rol es administrador
        boolean esAdmin = session != null && "administrador".equals(session.getAttribute("rol"));

        if (esAdmin) {
            // Si es admin, lo dejamos pasar
            chain.doFilter(request, response);
        } else {
            // Si no, lo enviamos al login con un mensaje de error
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=sesion");
        }
    }

    @Override
    public void destroy() {}
}