<%-- 
    Document   : confirmacion
    Created on : 8/10/2026, 9:09:44 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Compra exitosa">
    <title>BAD EAGLE | Compra Exitosa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos.css">
</head>
<body>

<div class="pagina-confirmacion">

    <main class="confirmacion-tarjeta">

        <div class="confirmacion-icono" aria-hidden="true">
            <svg viewBox="0 0 48 48">
                <polyline points="10,25 20,35 38,13"></polyline>
            </svg>
        </div>

        <h1 class="confirmacion-titulo">¡COMPRA REALIZADA!</h1>

        <p class="confirmacion-texto">
            Tu pedido ha sido registrado con éxito.<br>
            Número de pedido: <strong>#<%= request.getParameter("id") %></strong>
        </p>

        <a href="${pageContext.request.contextPath}/MisPedidosServlet"
           class="btn-principal confirmacion-btn">
            VER MIS PEDIDOS
        </a>

        <a href="${pageContext.request.contextPath}/home.jsp"
           class="confirmacion-volver">
            Volver al Inicio
        </a>

    </main>

</div>

</body>
</html>