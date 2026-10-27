<%-- 
    Document   : pedidos
    Created on : 8/10/2026, 9:10:37 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Mis Pedidos">
    <title>BAD EAGLE | Mis Pedidos</title>
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

<main class="pedidos-main">

    <h1 class="pedidos-titulo">MIS PEDIDOS</h1>

    <table class="pedidos-tabla">
        <thead>
            <tr>
                <th>Número de Pedido</th>
                <th>Estado</th>
                <th class="col-total">Total</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${listaPedidos}">
                <tr>
                    <td>#${p.id}</td>
                    <td class="col-estado">${p.estado}</td>
                    <td class="col-total">$ ${p.total}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty listaPedidos}">
                <tr>
                    <td colspan="3" class="pedidos-vacio">
                        No tienes pedidos registrados.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="pedidos-volver">
        <a href="${pageContext.request.contextPath}/PerfilServlet"
           class="pedidos-volver-enlace">← Volver a mi perfil</a>
    </div>

</main>

</body>
</html>