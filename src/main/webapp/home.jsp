<%-- 
    Document   : home
    Created on : 6/10/2026, 6:38:14 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - FEARLESS TO FREEDOM">
    <title>BAD EAGLE | Inicio</title>
    <link rel="stylesheet" href="estilos.css">
</head>

<body>

    <header class="header">
        <div class="header-contenido">
            <a href="home.jsp" class="logo" aria-label="Bad Eagle - Inicio">
                <img src="${pageContext.request.contextPath}/imagenes/logo-nombre.jpeg"
                     alt="Bad Eagle"
                     class="logo-imagen logo-imagen-nombre">
                <img src="${pageContext.request.contextPath}/imagenes/logo-eslogan.jpeg"
                     alt="Fearless to Freedom"
                     class="logo-imagen logo-imagen-eslogan">
            </a>
            <div class="acciones-header">
                <a href="carrito.jsp" class="icono" aria-label="Carrito de compras">
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

    <main class="inicio-principal">
        <img src="${pageContext.request.contextPath}/imagenes/logo.jpeg"
             alt="Bad Eagle - Fearless to Freedom"
             class="inicio-imagen">

        <a href="${pageContext.request.contextPath}/CatalogoServlet"
           class="btn-principal inicio-boton">
            VER CATÁLOGO
        </a>
    </main>

    <footer>
        <div class="footer-contenido">
            <a href="institucional.jsp" class="footer-enlace">Información Corporativa</a>
        </div>
    </footer>

</body>
</html>