<%-- 
    Document   : institucional
    Created on : 8/10/2026, 9:03:37 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Información Institucional">
    <title>BAD EAGLE | Información Institucional</title>
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

<main class="institucional-main">

    <div class="institucional-layout">

        <div class="institucional-row">
            <div class="institucional-label">MISIÓN</div>
            <div class="institucional-text">
                Ofrecer productos de expresión con la mejor calidad, creando
                estilo auténtico que inspira libertad, confianza y autenticidad.
            </div>
        </div>

        <div class="institucional-row">
            <div class="institucional-label">VISIÓN</div>
            <div class="institucional-text">
                Ser una marca líder en moda, reconocida por innovación, calidad
                y compromiso con cada cliente.
            </div>
        </div>

        <div class="institucional-row">
            <div class="institucional-label">HISTORIA</div>
            <div class="institucional-text">
                Bad Eagle nace con el propósito de crear prendas que reflejen
                actitud, estilo y personalidad. Desde nuestra pasión, hemos
                trabajado para acompañarte en cada paso de tu camino.
            </div>
        </div>

    </div>

</main>

<footer>
    <div class="footer-contenido">
                <a href="contacto.jsp" class="footer-enlace">Contactenos</a>
    </div>
</footer>

</body>
</html>