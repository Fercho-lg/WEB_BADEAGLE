<%-- 
    Document   : detalle-producto
    Created on : 8/10/2026, 9:37:12 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Detalle de producto">
    <title>BAD EAGLE | Detalle de producto</title>
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

<%
    String idProd     = request.getParameter("id");
    String nombreProd = request.getParameter("nombre");
    String precioProd = request.getParameter("precio");

    String imagen = "logo.jpeg";
    if (nombreProd != null) {
        if (nombreProd.contains("Pantalón")) imagen = "PANTALON.png";
        else if (nombreProd.contains("Morral")) imagen = "MORRAL.jpg";
        else if (nombreProd.contains("Sombrero")) imagen = "SOMBRERO.jpg";
    }

    if (nombreProd == null) nombreProd = "Producto";
    if (precioProd == null) precioProd = "0";
    if (idProd == null)     idProd = "";
%>

<main class="detalle-main">
    <div class="detalle-grid">

        <div class="detalle-imagen detalle-imagen-real">
            <img src="${pageContext.request.contextPath}/imagenes/<%= imagen %>"
                 alt="<%= nombreProd %>">
        </div>

        <div class="detalle-info">

            <h1><%= nombreProd %></h1>

            <h2 class="detalle-precio">$ <%= precioProd %></h2>

            <p class="detalle-descripcion">
                Excelente producto de la mejor calidad, ideal para tus
                actividades al aire libre.
            </p>

            <div class="detalle-grupo">
                <h2>Tallas</h2>
                <div class="detalle-tallas">
                    <button type="button" class="detalle-talla">S</button>
                    <button type="button" class="detalle-talla activo">M</button>
                    <button type="button" class="detalle-talla">L</button>
                    <button type="button" class="detalle-talla">XL</button>
                </div>
            </div>

            <div class="detalle-grupo">
                <h2>Colores</h2>
                <div class="detalle-colores">
                    <button type="button" class="detalle-color detalle-color-gris"
                            aria-label="Color gris"></button>
                    <button type="button" class="detalle-color detalle-color-negro"
                            aria-label="Color negro"></button>
                    <button type="button" class="detalle-color detalle-color-claro"
                            aria-label="Color gris claro"></button>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/AgregarCarritoServlet" method="POST">
                <input type="hidden" name="idProducto"     value="<%= idProd %>">
                <input type="hidden" name="nombreProducto" value="<%= nombreProd %>">
                <input type="hidden" name="precioProducto" value="<%= precioProd %>">
                <input type="hidden" name="cantidad"       value="1">
                <button type="submit" class="btn-principal detalle-boton">
                    AGREGAR AL CARRITO
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/CatalogoServlet"
               class="detalle-volver">
                ← Volver al catálogo
            </a>

        </div>

    </div>
</main>

</body>
</html>