<%-- 
    Document   : pago
    Created on : 8/10/2026, 9:09:03 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BAD EAGLE | Proceso de pago</title>
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

<main style="display: block; padding: 30px;">

    <h1 style="text-align: center; margin-bottom: 25px;">PROCESO DE PAGO</h1>

    <div style="max-width: 900px; margin: 0 auto;">

        <section style="border: 1px solid #ccc; padding: 20px; margin-bottom: 20px;">
            <h2 style="font-size: 14px; margin-bottom: 15px;">1. Dirección de envío</h2>
            <p style="font-size: 13px;">Calle 10 # 25-30<br>Girardot, Cundinamarca<br>Colombia</p>
        </section>

        <section style="border: 1px solid #ccc; padding: 20px; margin-bottom: 20px;">
            <h2 style="font-size: 14px; margin-bottom: 15px;">2. Método de pago</h2>

            <label style="display: block; padding: 8px 0;">
                <input type="radio" name="pago" value="tarjeta" checked>
                Tarjeta de crédito / débito
            </label>
            <label style="display: block; padding: 8px 0;">
                <input type="radio" name="pago" value="pse">
                PSE
            </label>
            <label style="display: block; padding: 8px 0;">
                <input type="radio" name="pago" value="contra-entrega">
                Efectivo contra entrega
            </label>
        </section>

        <section style="border: 1px solid #ccc; padding: 20px; margin-bottom: 20px;">
            <h2 style="font-size: 14px; margin-bottom: 15px;">3. Resumen del pedido</h2>
            <p style="font-size: 13px;">3 productos — Total: <strong>$ 199.898</strong></p>
        </section>

        <div style="text-align: right;">
            <a href="confirmacion.jsp" class="btn-principal"
               style="display: inline-block; padding: 0 40px; line-height: 48px; text-decoration: none;">
                CONTINUAR CON EL PAGO
            </a>
        </div>

    </div>

</main>

<footer>
    <div class="footer-contenido">
        <a href="contacto.jsp" class="footer-enlace">contactenos</a>
            </div>
</footer>

</body>
</html>
