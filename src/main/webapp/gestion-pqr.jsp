<%-- 
    Document   : gestion-pqr
    Descripción: Panel de administración para gestionar Peticiones, Quejas, Reclamos y Sugerencias.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BAD EAGLE | Gestión de P.Q.R.</title>
    <!-- Enlace a ambos archivos CSS -->
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="admin.css">
</head>
<body class="admin-body">

<aside class="admin-sidebar">
    <div class="admin-sidebar-titulo">Dashboard</div>
    <nav class="admin-menu" aria-label="Menú administrativo">
        <a href="panel-control.jsp" class="admin-menu-link">Panel de Control</a>
        <a href="gestion-productos.jsp" class="admin-menu-link">Productos e Inventario</a>
        <a href="gestion-produccion.jsp" class="admin-menu-link">Producción</a>
        <a href="gestion-usuarios.jsp" class="admin-menu-link">Usuarios</a>
        <a href="gestion-pqr.jsp" class="admin-menu-link activo" aria-current="page">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">

    <div class="admin-main-header">
        <h1>P.Q.R. (Peticiones, Quejas, Reclamos)</h1>
    </div>

    <div class="admin-toolbar">
        <input type="text" id="buscarPqr" class="admin-buscar" placeholder="Buscar por correo o nombre..." aria-label="Buscar PQR">
        <div class="admin-toolbar-botones">
            <select class="admin-btn" style="padding: 0 10px;">
                <option value="">Todos los estados</option>
                <option value="Pendiente">Pendientes</option>
                <option value="Realizada">Realizadas</option>
            </select>
        </div>
    </div>

    <div class="admin-tabla-wrap">
        <table class="admin-tabla">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Fecha</th>
                    <th>Cliente</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th class="col-acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Ejemplo de fila: Pendiente -->
                <tr>
                    <td>001</td>
                    <td>10/10/2026</td>
                    <td>Carlos Ruiz<br><small>carlos@hotmail.com</small></td>
                    <td>Reclamo</td>
                    <td><span class="admin-badge admin-badge-alerta">Pendiente</span></td>
                    <td class="col-acciones">
                        <button type="button" class="admin-btn" onclick="abrirModalPqr('001', 'Carlos', 'Reclamo', 'El pedido llegó incompleto.')">Ver / Responder</button>
                    </td>
                </tr>
                <!-- Ejemplo de fila: Realizada -->
                <tr>
                    <td>002</td>
                    <td>08/10/2026</td>
                    <td>Ana Gómez<br><small>ana@gmail.com</small></td>
                    <td>Petición</td>
                    <td><span class="admin-badge admin-badge-activo">Realizada</span></td>
                    <td class="col-acciones">
                        <button type="button" class="admin-btn" onclick="abrirModalPqr('002', 'Ana', 'Petición', 'Quisiera saber si tienen envíos internacionales.')">Ver / Responder</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

</main>

<!-- MODAL PQR -->
<div class="admin-modal" id="modalPqr" role="dialog" aria-modal="true">
    <div class="admin-modal-box">
        <h2>GESTIONAR P.Q.R.</h2>
        
        <div class="admin-form-grupo">
            <label>Cliente / Tipo</label>
            <input type="text" id="pqrCliente" readonly style="background-color: #f7f7f7;">
        </div>

        <div class="admin-form-grupo">
            <label>Mensaje Original</label>
            <textarea id="pqrMensaje" readonly style="background-color: #f7f7f7;"></textarea>
        </div>

        <div class="admin-form-grupo">
            <label>Estado</label>
            <select id="pqrEstado">
                <option value="Pendiente">Pendiente</option>
                <option value="En proceso">En proceso</option>
                <option value="Realizada">Realizada</option>
            </select>
        </div>

        <div class="admin-form-grupo">
            <label>Respuesta al Cliente</label>
            <textarea id="pqrRespuesta" placeholder="Escribe aquí la respuesta que se guardará en el sistema..."></textarea>
        </div>

        <div class="admin-modal-acciones">
            <button type="button" class="admin-btn" onclick="cerrarModalPqr()">CANCELAR</button>
            <button type="button" class="admin-btn admin-btn-primario" onclick="guardarPqr()">GUARDAR RESPUESTA</button>
        </div>
    </div>
</div>

<script>
    function abrirModalPqr(id, cliente, tipo, mensaje) {
        document.getElementById('pqrCliente').value = cliente + ' (' + tipo + ')';
        document.getElementById('pqrMensaje').value = mensaje;
        document.getElementById('pqrRespuesta').value = '';
        document.getElementById('pqrEstado').value = 'Pendiente';
        document.getElementById('modalPqr').classList.add('activo');
    }

    function cerrarModalPqr() {
        document.getElementById('modalPqr').classList.remove('activo');
    }

    function guardarPqr() {
        // Aquí irá el fetch o submit en la Fase 3
        alert("Simulación: PQR actualizada y respuesta guardada.");
        cerrarModalPqr();
    }
</script>

</body>
</html>