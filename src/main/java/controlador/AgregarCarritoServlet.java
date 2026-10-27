/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AgregarCarritoServlet", urlPatterns = {"/AgregarCarritoServlet"})
public class AgregarCarritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("idProducto");
        String nombre = request.getParameter("nombreProducto");
        String precio = request.getParameter("precioProducto");

        HttpSession session = request.getSession();
        List<String> carrito = (List<String>) session.getAttribute("carrito");
        
        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        // Formato: id|nombre|precio
        String item = id + "|" + nombre + "|" + precio;
        carrito.add(item);
        
        session.setAttribute("carrito", carrito);
        response.sendRedirect(request.getContextPath() + "/carrito.jsp");
    }
}
