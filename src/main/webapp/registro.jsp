<%--
    Document   : registro
    Proyecto   : BAD EAGLE - SIGIBE
    Descripción: Formulario de registro de usuarios.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Registro de usuarios de BAD EAGLE">
    <title>BAD EAGLE | Crear cuenta</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos.css">
</head>

<body>

<div class="pagina-formulario">

    <main class="tarjeta-formulario">

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

        <h1 class="titulo-formulario">CREAR CUENTA</h1>

        <%
            String error = request.getParameter("error");
            String mensajeError = null;

            if ("campos".equals(error)) {
                mensajeError = "Completa todos los campos obligatorios.";
            } else if ("password".equals(error)) {
                mensajeError = "Las contraseñas no coinciden o no cumplen los requisitos.";
            } else if ("terminos".equals(error)) {
                mensajeError = "Debes aceptar los términos y condiciones.";
            } else if ("fecha".equals(error)) {
                mensajeError = "La fecha de nacimiento no es válida.";
            } else if ("email".equals(error)) {
                mensajeError = "Introduce un correo electrónico válido.";
            } else if ("telefono".equals(error)) {
                mensajeError = "Revisa el formato del número de teléfono.";
            } else if ("longitud".equals(error)) {
                mensajeError = "Uno o más campos superan la longitud permitida.";
            } else if ("duplicado".equals(error)) {
                mensajeError = "Este correo ya está registrado. Intenta iniciar sesión.";
            } else if ("conexion".equals(error)) {
                mensajeError = "No se pudo conectar con el servicio de registro.";
            } else if ("seguridad".equals(error)) {
                mensajeError = "No fue posible procesar la contraseña. Inténtalo nuevamente.";
            } else if ("bd".equals(error)) {
                mensajeError = "No fue posible completar el registro. Verifica los datos e inténtalo nuevamente.";
            }
        %>

        <% if (mensajeError != null) { %>
            <div class="mensaje-registro error" role="alert">
                <%= mensajeError %>
            </div>
        <% } %>

        <form class="formulario-form"
              action="${pageContext.request.contextPath}/RegistroServlet"
              method="POST"
              id="formRegistro">

            <div class="campo">
                <input type="text" id="nombre" name="nombre"
                       placeholder="Nombre completo" maxlength="100"
                       autocomplete="name" required>
            </div>

            <div class="campo">
                <input type="email" id="correo" name="correo"
                       placeholder="Correo electrónico" maxlength="100"
                       autocomplete="email" required>
            </div>

            <div class="campo">
                <input type="tel" id="telefono" name="telefono"
                       placeholder="Teléfono" maxlength="20"
                       pattern="[0-9+() -]{7,20}"
                       autocomplete="tel" required>
            </div>

            <div class="campo">
                <input type="date" id="fechaNacimiento" name="fechaNacimiento"
                       aria-label="Fecha de nacimiento" required>
            </div>

            <div class="campo">
                <input type="password" id="password" name="password"
                       placeholder="Contraseña (mínimo 8 caracteres)"
                       minlength="8" maxlength="128"
                       autocomplete="new-password" required>
            </div>

            <div class="campo">
                <input type="password" id="confirmarPassword" name="confirmarPassword"
                       placeholder="Confirmar contraseña"
                       minlength="8" maxlength="128"
                       autocomplete="new-password" required>
            </div>

            <div class="terminos">
                <input type="checkbox" id="terminos" name="terminos" required>
                <label for="terminos">Acepto términos y condiciones</label>
            </div>

            <button type="submit" class="btn-principal">REGISTRARME</button>

        </form>

        <div class="iniciar-sesion">
            <span>¿Ya tienes cuenta?</span>
            <a href="${pageContext.request.contextPath}/login.jsp">INICIAR SESIÓN</a>
        </div>

    </main>

</div>

</body>
</html>