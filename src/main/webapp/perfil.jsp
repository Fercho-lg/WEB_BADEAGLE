<%--
    Document   : perfil
    Proyecto   : BAD EAGLE - SIGIBE
    Descripción: Perfil del usuario autenticado.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private String escaparHtml(String texto) {
        if (texto == null) return "";
        return texto
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    response.setHeader("Cache-Control",
            "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");

    if (session.getAttribute("idCliente") == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp?error=sesion");
        return;
    }
    if (request.getAttribute("nombrePerfil") == null) {
        response.sendRedirect(
                request.getContextPath() + "/PerfilServlet");
        return;
    }

    String nombrePerfil    = (String) request.getAttribute("nombrePerfil");
    String correoPerfil    = (String) request.getAttribute("correoPerfil");
    String telefonoPerfil  = (String) request.getAttribute("telefonoPerfil");
    String direccionPerfil = (String) request.getAttribute("direccionPerfil");
    Object idPerfil        = request.getAttribute("idClientePerfil");

    String mensaje = null;
    boolean mensajeError = false;

    String error = request.getParameter("error");
    if (error == null) error = (String) request.getAttribute("errorPerfil");

    if ("ok".equals(request.getParameter("direccion"))) {
        mensaje = "La dirección se guardó correctamente.";
    } else if ("direccion".equals(error)) {
        mensaje = "Ingresa una dirección válida de máximo 100 caracteres.";
        mensajeError = true;
    } else if ("conexion".equals(error)) {
        mensaje = "No fue posible conectar con la base de datos.";
        mensajeError = true;
    } else if ("bd".equals(error)) {
        mensaje = "No se pudo completar la operación. Inténtalo nuevamente.";
        mensajeError = true;
    } else if ("accion".equals(error)) {
        mensaje = "La operación solicitada no es válida.";
        mensajeError = true;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Mi cuenta - BAD EAGLE">
    <title>BAD EAGLE | Mi Cuenta</title>
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

    <div class="perfil-layout">

        <aside class="perfil-sidebar">
            <nav class="perfil-menu" aria-label="Menú de usuario">
                <a href="${pageContext.request.contextPath}/PerfilServlet"
                   class="perfil-menu-link activo">
                    MI PERFIL
                </a>
                <a href="${pageContext.request.contextPath}/pedidos.jsp"
                   class="perfil-menu-link">
                    MIS PEDIDOS
                </a>
                <a href="#direcciones" class="perfil-menu-link">
                    DIRECCIONES
                </a>
                <a href="${pageContext.request.contextPath}/pago.jsp"
                   class="perfil-menu-link">
                    MÉTODOS DE PAGO
                </a>
                <a href="${pageContext.request.contextPath}/carrito.jsp"
                   class="perfil-menu-link">
                    CARRITO DE COMPRAS
                </a>
                <form class="perfil-logout-form"
                      action="${pageContext.request.contextPath}/CerrarSesionServlet"
                      method="POST">
                    <button type="submit" class="perfil-menu-link">
                        CERRAR SESIÓN
                    </button>
                </form>
            </nav>
        </aside>

        <main class="perfil-contenido">

            <h1 class="perfil-titulo">MI CUENTA</h1>

            <% if (mensaje != null) { %>
                <div class="mensaje-perfil <%= mensajeError ? "error" : "exito" %>"
                     role="status">
                    <%= escaparHtml(mensaje) %>
                </div>
            <% } %>

            <section class="perfil-seccion">
                <h2 class="perfil-subtitulo">INFORMACIÓN PERSONAL</h2>
                <div class="perfil-datos">
                    <div class="perfil-fila">
                        <div class="perfil-etiqueta">Nombre completo</div>
                        <div class="perfil-valor"><%= escaparHtml(nombrePerfil) %></div>
                    </div>
                    <div class="perfil-fila">
                        <div class="perfil-etiqueta">Correo electrónico</div>
                        <div class="perfil-valor"><%= escaparHtml(correoPerfil) %></div>
                    </div>
                    <div class="perfil-fila">
                        <div class="perfil-etiqueta">Teléfono</div>
                        <div class="perfil-valor"><%= escaparHtml(telefonoPerfil) %></div>
                    </div>
                    <div class="perfil-fila">
                        <div class="perfil-etiqueta">ID Cliente</div>
                        <div class="perfil-valor"><%= escaparHtml(
                                idPerfil == null ? "-" : String.valueOf(idPerfil)
                        ) %></div>
                    </div>
                </div>
            </section>

            <section class="perfil-seccion" id="direcciones">
                <h2 class="perfil-subtitulo">DIRECCIÓN DE ENTREGA</h2>
                <p class="perfil-descripcion">
                    Esta dirección se guarda en tu cuenta y podrá
                    utilizarse durante el proceso de compra.
                </p>
                <form class="perfil-formulario"
                      action="${pageContext.request.contextPath}/PerfilServlet"
                      method="POST">
                    <input type="hidden" name="accion" value="actualizarDireccion">
                    <label for="direccion">Dirección de entrega</label>
                    <input type="text" id="direccion" name="direccion"
                           maxlength="100"
                           value="<%= escaparHtml(direccionPerfil) %>"
                           placeholder="Ingresa tu dirección completa" required>
                    <button type="submit" class="btn-principal">
                        GUARDAR DIRECCIÓN
                    </button>
                </form>
            </section>

        </main>
    </div>

</body>
</html>