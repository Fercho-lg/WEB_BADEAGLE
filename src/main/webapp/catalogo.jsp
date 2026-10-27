<%-- 
    Document   : catalogo
    Created on : 8/10/2026, 9:02:32 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - FEARLESS TO FREEDOM">
    <title>BAD EAGLE | Catálogo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos.css">
</head>
<body>

<header class="header">

    <div class="header-contenido">

        <a href="${pageContext.request.contextPath}/home.jsp"
           class="logo"
           aria-label="Bad Eagle - Inicio">

            <img src="${pageContext.request.contextPath}/imagenes/logo-nombre.jpeg"
                 alt="Bad Eagle"
                 class="logo-imagen logo-imagen-nombre">

            <img src="${pageContext.request.contextPath}/imagenes/logo-eslogan.jpeg"
                 alt="Fearless to Freedom"
                 class="logo-imagen logo-imagen-eslogan">

        </a>

        <div class="acciones-header">

            <a href="${pageContext.request.contextPath}/carrito.jsp"
               class="icono"
               aria-label="Carrito de compras">

                <svg viewBox="0 0 24 24">
                    <path d="M3 4h2l2.2 10.5a2 2 0 0 0 2 1.5h7.8a2 2 0 0 0 2-1.5L20 7H6"></path>
                    <circle cx="10" cy="20" r="1"></circle>
                    <circle cx="17" cy="20" r="1"></circle>
                </svg>

            </a>

            <a href="${pageContext.request.contextPath}/PerfilServlet"
               class="icono"
               aria-label="Mi perfil">

                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="9"></circle>
                    <circle cx="12" cy="9" r="3"></circle>
                    <path d="M6.5 19c1.3-3 3.1-4.5 5.5-4.5s4.2 1.5 5.5 4.5"></path>
                </svg>

            </a>

        </div>

    </div>

    <nav class="navegacion navegacion-filtros" aria-label="Filtrar productos por categoría">

        <button type="button"
                class="nav-enlace filtro-categoria activo"
                data-categoria="todo"
                aria-pressed="true">Ver todo</button>

        <button type="button"
                class="nav-enlace filtro-categoria"
                data-categoria="pantalon"
                aria-pressed="false">Pantalones</button>

        <button type="button"
                class="nav-enlace filtro-categoria"
                data-categoria="morral"
                aria-pressed="false">Morrales</button>

        <button type="button"
                class="nav-enlace filtro-categoria"
                data-categoria="sombrero"
                aria-pressed="false">Sombreros</button>

    </nav>

</header>

<main class="catalogo-main">

    <h1 class="catalogo-titulo">CATÁLOGO DE PRODUCTOS</h1>

    <div class="catalogo-grid">

        <c:forEach var="prod" items="${listaProductos}">

            <c:set var="categoria" value="otros" />
            <c:set var="imagen" value="" />

            <c:choose>
                <c:when test="${prod.nombre.contains('Pantalón')}">
                    <c:set var="categoria" value="pantalon" />
                    <c:set var="imagen" value="${pageContext.request.contextPath}/imagenes/PANTALON.png" />
                </c:when>
                <c:when test="${prod.nombre.contains('Morral')}">
                    <c:set var="categoria" value="morral" />
                    <c:set var="imagen" value="${pageContext.request.contextPath}/imagenes/MORRAL.jpg" />
                </c:when>
                <c:when test="${prod.nombre.contains('Sombrero')}">
                    <c:set var="categoria" value="sombrero" />
                    <c:set var="imagen" value="${pageContext.request.contextPath}/imagenes/SOMBRERO.jpg" />
                </c:when>
            </c:choose>

            <div class="producto-card" data-categoria="${categoria}">

                <c:choose>
                    <c:when test="${not empty imagen}">
                        <img src="${imagen}" alt="${prod.nombre}" class="producto-imagen">
                    </c:when>
                    <c:otherwise>
                        <div class="producto-sin-imagen">Sin Imagen</div>
                    </c:otherwise>
                </c:choose>

                <h3 class="producto-nombre">${prod.nombre}</h3>
                <p class="producto-precio">$ ${prod.precio}</p>

                <a href="${pageContext.request.contextPath}/detalle-producto.jsp?id=${prod.id}&nombre=${prod.nombre}&precio=${prod.precio}"
                   class="btn-principal producto-boton">Ver Detalle</a>

            </div>

        </c:forEach>

    </div>

</main>

<script>
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {

        var filtros  = document.querySelectorAll('.filtro-categoria');
        var tarjetas = document.querySelectorAll('.producto-card');

        if (!filtros.length || !tarjetas.length) {
            return;
        }

        filtros.forEach(function (boton) {

            boton.addEventListener('click', function () {

                filtros.forEach(function (b) {
                    b.classList.remove('activo');
                    b.setAttribute('aria-pressed', 'false');
                });

                boton.classList.add('activo');
                boton.setAttribute('aria-pressed', 'true');

                var categoria = boton.getAttribute('data-categoria');

                tarjetas.forEach(function (tarjeta) {
                    if (categoria === 'todo' ||
                        tarjeta.getAttribute('data-categoria') === categoria) {
                        tarjeta.classList.remove('oculto');
                    } else {
                        tarjeta.classList.add('oculto');
                    }
                });

            });

        });

    });

})();
</script>

</body>
</html>