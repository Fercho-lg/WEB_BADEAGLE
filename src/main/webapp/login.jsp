<%--
    Document   : login
    Proyecto   : BAD EAGLE - SIGIBE
    Descripción: Formulario de inicio de sesión.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Inicio de sesión - BAD EAGLE">
    <title>BAD EAGLE | Iniciar sesión</title>
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

        <h1 class="titulo-formulario">INICIAR SESIÓN</h1>

        <%
            String error = request.getParameter("error");
            String registro = request.getParameter("registro");
            String mensaje = null;
            String claseMensaje = "mensaje-registro";

            if ("ok".equals(registro)) {
                mensaje = "Cuenta creada correctamente. Inicia sesión.";
                claseMensaje = "mensaje-registro exito";
            } else if ("campos".equals(error)) {
                mensaje = "Completa todos los campos.";
                claseMensaje = "mensaje-registro error";
            } else if ("credenciales".equals(error)) {
                mensaje = "Correo o contraseña incorrectos.";
                claseMensaje = "mensaje-registro error";
            } else if ("conexion".equals(error)) {
                mensaje = "No se pudo conectar con el servicio.";
                claseMensaje = "mensaje-registro error";
            } else if ("bd".equals(error)) {
                mensaje = "Error al procesar la solicitud.";
                claseMensaje = "mensaje-registro error";
            } else if ("sesion".equals(error)) {
                mensaje = "Debes iniciar sesión para continuar.";
                claseMensaje = "mensaje-registro error";
            }
        %>

        <% if (mensaje != null) { %>
            <div class="<%= claseMensaje %>" role="alert">
                <%= mensaje %>
            </div>
        <% } %>

        <form class="formulario-form"
              action="${pageContext.request.contextPath}/LoginServlet"
              method="POST"
              id="formLogin">

            <div class="campo">
                <input type="email"
                       id="correo"
                       name="correo"
                       placeholder="Correo electrónico"
                       maxlength="100"
                       autocomplete="email"
                       required>
            </div>

            <div class="campo">
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Contraseña"
                       maxlength="128"
                       autocomplete="current-password"
                       required>
            </div>

            <button type="submit" class="btn-principal">
                INGRESAR
            </button>

        </form>

        <div class="iniciar-sesion">
            <span>¿No tienes cuenta?</span>
            <a href="${pageContext.request.contextPath}/registro.jsp">
                REGÍSTRATE
            </a>
        </div>

    </main>

</div>

</body>
</html>