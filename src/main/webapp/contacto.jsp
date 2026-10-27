<%-- 
    Document   : contacto
    Created on : 8/10/2026, 9:11:09 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BAD EAGLE - Contáctanos / PQR">
    <title>BAD EAGLE | Contáctanos / PQR</title>
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

<main class="pagina-contacto">

    <h1 class="contacto-titulo">CONTÁCTANOS</h1>

    <div class="contenido-contacto">

        <form class="formulario"
              action="ContactoServlet"
              method="POST"
              id="formulario">

            <div class="contacto-campo">
                <label for="solicitud">Tipo de solicitud</label>
                <select id="solicitud" name="solicitud" required>
                    <option value="Petición">Petición</option>
                    <option value="Queja">Queja</option>
                    <option value="Reclamo">Reclamo</option>
                    <option value="Sugerencia">Sugerencia</option>
                    <option value="Felicitación">Felicitación</option>
                </select>
            </div>

            <div class="contacto-campo">
                <label for="nombre">Nombre completo</label>
                <input type="text"
                       id="nombre"
                       name="nombre"
                       placeholder="Nombre completo"
                       required>
                <span class="contacto-error" id="errorNombre">
                    Ingresa tu nombre completo.
                </span>
            </div>

            <div class="contacto-campo">
                <label for="correo">Correo electrónico</label>
                <input type="email"
                       id="correo"
                       name="correo"
                       placeholder="Correo electrónico"
                       required>
                <span class="contacto-error" id="errorCorreo">
                    Ingresa un correo electrónico válido.
                </span>
            </div>

            <div class="contacto-campo">
                <label for="mensaje">Mensaje</label>
                <textarea id="mensaje"
                          name="mensaje"
                          maxlength="500"
                          placeholder="Escribe tu mensaje..."
                          required></textarea>
                <div class="contador">
                    <span id="contador">0 / 500</span>
                </div>
            </div>

            <button type="submit" class="btn-enviar">
                ENVIAR MENSAJE
            </button>

        </form>

        <aside class="tipos">
            <div class="tipos-titulo">Tipos de solicitud</div>
            <div class="tipo activo" data-tipo="Petición">Petición</div>
            <div class="tipo" data-tipo="Queja">Queja</div>
            <div class="tipo" data-tipo="Reclamo">Reclamo</div>
            <div class="tipo" data-tipo="Sugerencia">Sugerencia</div>
            <div class="tipo" data-tipo="Felicitación">Felicitación</div>
        </aside>

    </div>

    <div class="mensaje-info" id="mensajeConfirmacion">
        Tu solicitud ha sido enviada correctamente.
    </div>

</main>

<footer>
    <div class="footer-contenido">
              <a href="institucional.jsp" class="footer-enlace">Información Corporativa</a>
    </div>
</footer>

<script>
    const formulario = document.getElementById("formulario");
    const solicitud = document.getElementById("solicitud");
    const nombre = document.getElementById("nombre");
    const correo = document.getElementById("correo");
    const mensaje = document.getElementById("mensaje");
    const contador = document.getElementById("contador");
    const confirmacion = document.getElementById("mensajeConfirmacion");
    const tipos = document.querySelectorAll(".tipo");

    mensaje.addEventListener("input", function () {
        contador.textContent = mensaje.value.length + " / 500";
    });

    tipos.forEach(function (tipo) {
        tipo.addEventListener("click", function () {
            tipos.forEach(function (elemento) {
                elemento.classList.remove("activo");
            });
            tipo.classList.add("activo");
            solicitud.value = tipo.dataset.tipo;
        });
    });

    solicitud.addEventListener("change", function () {
        tipos.forEach(function (tipo) {
            tipo.classList.remove("activo");
            if (tipo.dataset.tipo === solicitud.value) {
                tipo.classList.add("activo");
            }
        });
    });

    formulario.addEventListener("submit", function (evento) {
        let valido = true;

        if (nombre.value.trim().length < 3) {
            valido = false;
            document.getElementById("errorNombre").classList.add("visible");
        } else {
            document.getElementById("errorNombre").classList.remove("visible");
        }

        const patronCorreo = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!patronCorreo.test(correo.value)) {
            valido = false;
            document.getElementById("errorCorreo").classList.add("visible");
        } else {
            document.getElementById("errorCorreo").classList.remove("visible");
        }

        if (mensaje.value.trim().length < 5) {
            valido = false;
        }

        if (!valido) {
            evento.preventDefault();
        }
    });

    const params = new URLSearchParams(window.location.search);
    if (params.get("envio") === "ok") {
        confirmacion.textContent = "Tu solicitud ha sido enviada correctamente.";
        confirmacion.classList.add("visible");
        setTimeout(function () {
            confirmacion.classList.remove("visible");
        }, 5000);
    }
</script>

</body>
</html>