<%-- 
    Document   : carrito
    Created on : 8/10/2026, 9:08:42 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Carrito de compras">
    <title>BAD EAGLE | Carrito</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos.css">
</head>
<body>

<header class="header">
    <div class="header-contenido">
        <a href="${pageContext.request.contextPath}/home.jsp"
           class="logo" aria-label="Bad Eagle - Inicio">
            <img src="${pageContext.request.contextPath}/imagenes/logo-nombre.jpeg"
                 alt="Bad Eagle"
                 class="logo-imagen logo-imagen-nombre">
            <img src="${pageContext.request.contextPath}/imagenes/logo-eslogan.jpeg"
                 alt="Fearless to Freedom"
                 class="logo-imagen logo-imagen-eslogan">
        </a>
        <div class="acciones-header">
            <a href="${pageContext.request.contextPath}/carrito.jsp"
               class="icono" aria-label="Carrito de compras">
                <svg viewBox="0 0 24 24">
                    <path d="M3 4h2l2.2 10.5a2 2 0 0 0 2 1.5h7.8a2 2 0 0 0 2-1.5L20 7H6"></path>
                    <circle cx="10" cy="20" r="1"></circle>
                    <circle cx="17" cy="20" r="1"></circle>
                </svg>
            </a>
            <a href="${pageContext.request.contextPath}/PerfilServlet"
               class="icono" aria-label="Mi perfil">
                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="9"></circle>
                    <circle cx="12" cy="9" r="3"></circle>
                    <path d="M6.5 19c1.3-3 3.1-4.5 5.5-4.5s4.2 1.5 5.5 4.5"></path>
                </svg>
            </a>
        </div>
    </div>
</header>

<main class="carrito-main">

    <h1 class="carrito-titulo">CARRITO DE COMPRAS</h1>

    <%
        List<String> carrito = (List<String>) session.getAttribute("carrito");
        double total = 0;

        if (carrito != null && !carrito.isEmpty()) {
    %>

    <table class="carrito-tabla">
        <thead>
            <tr>
                <th>Producto</th>
                <th>Precio Unitario</th>
                <th class="col-subtotal">Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (String item : carrito) {
                    String[] datos = item.split("\\|");
                    String nombreProd = datos[1];
                    double precioProd = Double.parseDouble(datos[2]);
                    total += precioProd;

                    String imagenProd = "";
                    if (nombreProd != null) {
                        if (nombreProd.contains("Pantalón")) imagenProd = "PANTALON.png";
                        else if (nombreProd.contains("Morral")) imagenProd = "MORRAL.jpg";
                        else if (nombreProd.contains("Sombrero")) imagenProd = "SOMBRERO.jpg";
                    }
            %>
            <tr>
                <td class="carrito-celda-producto">
                    <% if (!imagenProd.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/imagenes/<%= imagenProd %>"
                             alt="<%= nombreProd %>"
                             class="carrito-thumb">
                    <% } else { %>
                        <div class="carrito-thumb carrito-thumb-sin">Sin imagen</div>
                    <% } %>
                    <span class="carrito-nombre"><%= nombreProd %></span>
                </td>
                <td>$ <%= String.format("%,.0f", precioProd) %></td>
                <td class="col-subtotal">$ <%= String.format("%,.0f", precioProd) %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div class="carrito-total">
        <h2>Total a Pagar: $ <%= String.format("%,.0f", total) %></h2>
        <form action="${pageContext.request.contextPath}/PedidoServlet" method="POST">
            <button type="submit" class="btn-principal carrito-boton-pago">
                PROCEDER AL PAGO
            </button>
        </form>
    </div>

    <% } else { %>
        <div class="carrito-vacio">
            <h2>Tu carrito está vacío</h2>
            <a href="${pageContext.request.contextPath}/CatalogoServlet"
               class="btn-principal carrito-vacio-boton">Ir al Catálogo</a>
        </div>
    <% } %>

</main>

</body>
</html>