<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>BAD EAGLE | Gestión de usuarios</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="admin.css">
</head>
<body class="admin-body">

<aside class="admin-sidebar">
    <div class="admin-sidebar-titulo">Dashboard</div>
    <nav class="admin-menu">
        <a href="PanelControlServlet" class="admin-menu-link">Panel de Control</a>
        <a href="ProductoServlet" class="admin-menu-link">Productos e Inventario</a>
        <a href="ProduccionServlet" class="admin-menu-link">Producción</a>
        <a href="AdminUsuariosServlet" class="admin-menu-link activo">Usuarios</a>
        <a href="gestion-pqr.jsp" class="admin-menu-link">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">
    <div class="admin-main-header">
        <h1>USUARIOS REGISTRADOS</h1>
        <!-- Botón deshabilitado (solo lectura) -->
        <button type="button" class="admin-btn" disabled style="opacity: 0.5; cursor: not-allowed;">+ NUEVO USUARIO</button>
    </div>

    <div class="admin-toolbar">
        <input type="text" id="buscarUsuario" class="admin-buscar" placeholder="Buscar por nombre o correo..." onkeyup="buscarUsuario()">
    </div>

    <div class="admin-tabla-wrap">
        <table class="admin-tabla" id="tablaUsuarios">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Correo Electrónico</th>
                    <th>Teléfono</th>
                    <th>Rol</th>
                    <th>Estado</th>
                    <th>Registro</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${listaUsuarios}">
                    <tr>
                        <td>${user.id}</td>
                        <td><strong>${user.nombre}</strong></td>
                        <td>${user.email}</td>
                        <td>${user.telefono}</td>
                        <td>
                            <!-- Badge para el Rol -->
                            <span class="admin-badge" style="border-color: #777; color: #333;">
                                ${user.rol}
                            </span>
                        </td>
                        <td>
                            <!-- Badge para el Estado -->
                            <span class="admin-badge ${user.activo == 'Activo' ? 'admin-badge-activo' : 'admin-badge-inactivo'}">
                                ${user.activo}
                            </span>
                        </td>
                        <td>${user.fecha}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaUsuarios}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">No hay usuarios registrados en el sistema.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<script>
    function buscarUsuario() {
        var texto = document.getElementById("buscarUsuario").value.toLowerCase();
        var filas = document.querySelectorAll("#tablaUsuarios tbody tr");
        filas.forEach(function(fila) {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    }
</script>

</body>
</html>