<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>BAD EAGLE | Gestión de producción</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="admin.css">
</head>
<body class="admin-body">

<aside class="admin-sidebar">
    <div class="admin-sidebar-titulo">Dashboard</div>
    <nav class="admin-menu">
        <a href="PanelControlServlet" class="admin-menu-link">Panel de Control</a>
        <a href="ProductoServlet" class="admin-menu-link">Productos e Inventario</a>
        <a href="ProduccionServlet" class="admin-menu-link activo">Producción</a>
        <a href="gestion-usuarios.jsp" class="admin-menu-link">Usuarios</a>
        <a href="gestion-pqr.jsp" class="admin-menu-link">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">
    <div class="admin-main-header">
        <h1>ÓRDENES DE PRODUCCIÓN</h1>
        <button type="button" class="admin-btn admin-btn-primario" onclick="abrirNuevo()">+ NUEVA ORDEN</button>
    </div>

    <!-- Alertas -->
    <c:if test="${param.exito != null}">
        <div style="padding: 10px; background: #d4edda; color: #155724; margin-bottom: 15px; border: 1px solid #c3e6cb;">
            Operación realizada con éxito.
        </div>
    </c:if>
    <c:if test="${param.error != null}">
        <div style="padding: 10px; background: #f8d7da; color: #721c24; margin-bottom: 15px; border: 1px solid #f5c6cb;">
            Ocurrió un error al procesar la solicitud.
        </div>
    </c:if>

    <div class="admin-tabla-wrap">
        <table class="admin-tabla" id="tablaProduccion">
            <thead>
                <tr>
                    <th>Orden</th>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Taller</th>
                    <th>Fecha Inicio</th>
                    <th>Estado</th>
                    <th class="col-acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="orden" items="${listaOrdenes}">
                    <tr>
                        <td><strong>${orden.codigo}</strong></td>
                        <td>${orden.producto}</td>
                        <td>${orden.cantidad}</td>
                        <td>${orden.taller}</td>
                        <td>${orden.fecha}</td>
                        <td>
                            <!-- Formulario para cambiar estado rápido -->
                            <form action="ProduccionServlet" method="POST" style="margin: 0;">
                                <input type="hidden" name="accion" value="cambiarEstado">
                                <input type="hidden" name="id" value="${orden.id}">
                                <select name="estado" class="admin-badge" style="cursor: pointer; padding: 4px; font-weight: bold;" onchange="this.form.submit()">
                                    <option value="Pendiente" ${orden.estado == 'Pendiente' ? 'selected' : ''}>Pendiente</option>
                                    <option value="En producción" ${orden.estado == 'En producción' ? 'selected' : ''}>En producción</option>
                                    <option value="Finalizado" ${orden.estado == 'Finalizado' ? 'selected' : ''}>Finalizado</option>
                                    <option value="Cancelado" ${orden.estado == 'Cancelado' ? 'selected' : ''}>Cancelado</option>
                                </select>
                            </form>
                        </td>
                        <td class="col-acciones">
                            <span style="font-size: 11px; color: #777;">Cambia el estado en el selector</span>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaOrdenes}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">No hay órdenes de producción registradas.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<!-- MODAL NUEVA ORDEN -->
<div class="admin-modal" id="modal">
    <div class="admin-modal-box">
        <h2>NUEVA ORDEN DE PRODUCCIÓN</h2>
        
        <form action="ProduccionServlet" method="POST">
            <input type="hidden" name="accion" value="agregar">

            <div class="admin-form-grupo">
                <label>Producto a fabricar</label>
                <select name="id_producto" required>
                    <c:forEach var="prod" items="${listaProductos}">
                        <option value="${prod.id}">${prod.nombre}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="admin-form-grupo">
                <label>Cantidad</label>
                <input name="cantidad" type="number" min="1" required>
            </div>

            <div class="admin-form-grupo">
                <label>Taller encargado</label>
                <input name="taller" type="text" placeholder="Ej: Santa Marta" required>
            </div>

            <div class="admin-form-grupo">
                <label>Fecha de Inicio</label>
                <input name="fecha_inicio" type="date" required>
            </div>

            <div class="admin-form-grupo">
                <label>Fecha Estimada de Entrega</label>
                <input name="fecha_estimada" type="date" required>
            </div>

            <div class="admin-modal-acciones">
                <button type="button" class="admin-btn" onclick="cerrarModal()">CANCELAR</button>
                <button type="submit" class="admin-btn admin-btn-primario">CREAR ORDEN</button>
            </div>
        </form>
    </div>
</div>

<script>
    function abrirNuevo() {
        document.getElementById("modal").classList.add("activo");
    }

    function cerrarModal() {
        document.getElementById("modal").classList.remove("activo");
    }
</script>

</body>
</html>