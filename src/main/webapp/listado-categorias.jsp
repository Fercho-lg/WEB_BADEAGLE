<%-- 
    Document   : listado-categorias
    Created on : 8/10/2026, 9:37:58 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>BAD EAGLE | Categorías</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>

<header class="header">
    <div class="header-contenido">
        <a href="home.jsp" class="logo">
            <span class="logo-nombre">BAD EAGLE</span>
            <span class="logo-eslogan">FEARLESS TO FREEDOM</span>
        </a>
    </div>
</header>

<main style="display: block; padding: 40px 20px;">

    <h1 style="text-align: center; font-size: 18px; margin-bottom: 30px;">CATEGORÍAS</h1>

    <div style="max-width: 900px; margin: 0 auto; display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">

        <a href="catalogo.jsp" style="text-decoration: none; color: #000; border: 1px solid #ccc; padding: 30px 10px; text-align: center;">
            <div style="font-size: 30px; margin-bottom: 15px;">▦</div>
            <div style="font-weight: bold; font-size: 12px;">VER TODO</div>
        </a>

        <a href="catalogo.jsp?categoria=ropa" style="text-decoration: none; color: #000; border: 1px solid #ccc; padding: 30px 10px; text-align: center;">
            <div style="font-size: 30px; margin-bottom: 15px;">👕</div>
            <div style="font-weight: bold; font-size: 12px;">ROPA</div>
        </a>

        <a href="catalogo.jsp?categoria=bolsos" style="text-decoration: none; color: #000; border: 1px solid #ccc; padding: 30px 10px; text-align: center;">
            <div style="font-size: 30px; margin-bottom: 15px;">👜</div>
            <div style="font-weight: bold; font-size: 12px;">BOLSOS</div>
        </a>

        <a href="catalogo.jsp?categoria=accesorios" style="text-decoration: none; color: #000; border: 1px solid #ccc; padding: 30px 10px; text-align: center;">
            <div style="font-size: 30px; margin-bottom: 15px;">🧢</div>
            <div style="font-weight: bold; font-size: 12px;">ACCESORIOS</div>
        </a>

    </div>

</main>

<footer>
    <div class="footer-contenido">
        <a href="institucional.jsp" class="footer-enlace">Misión, Visión, Historia</a>
        <a href="institucional.jsp" class="footer-enlace">Información Corporativa</a>
    </div>
</footer>

</body>
</html>
