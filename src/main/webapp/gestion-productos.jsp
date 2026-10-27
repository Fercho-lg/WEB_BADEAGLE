<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>BAD EAGLE | Gestión de productos</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="admin.css">
</head>
<body class="admin-body">

<aside class="admin-sidebar">
    <div class="admin-sidebar-titulo">Dashboard</div>
    <nav class="admin-menu">
        <a href="PanelControlServlet" class="admin-menu-link">Panel de Control</a>
        <a href="ProductoServlet" class="admin-menu-link activo">Productos e Inventario</a>
        <a href="gestion-produccion.jsp" class="admin-menu-link">Producción</a>
        <a href="gestion-usuarios.jsp" class="admin-menu-link">Usuarios</a>
        <a href="gestion-pqr.jsp" class="admin-menu-link">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">
    <div class="admin-main-header">
        <h1>PRODUCTOS E INVENTARIO</h1>
        <button type="button" class="admin-btn admin-btn-primario" onclick="abrirNuevo()">+ NUEVO PRODUCTO</button>
    </div>

    <!-- Alertas de éxito o error -->
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

    <div class="admin-toolbar">
        <input type="text" id="buscar" class="admin-buscar" placeholder="Buscar producto..." onkeyup="buscarProducto()">
    </div>

    <div class="admin-tabla-wrap">
        <table class="admin-tabla" id="tablaProductos">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Producto</th>
                    <th>Categoría</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Estado</th>
                    <th class="col-acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="prod" items="${listaProductos}">
                    <tr>
                        <td>${prod.id}</td>
                        <td>${prod.nombre}</td>
                        <td>${prod.categoria}</td>
                        <td>$ <fmt:formatNumber value="${prod.precio}" maxFractionDigits="0" /></td>
                        <td>${prod.stock}</td>
                        <td>
                            <span class="admin-badge ${prod.activo == 'Activo' ? 'admin-badge-activo' : 'admin-badge-inactivo'}">
                                ${prod.activo}
                            </span>
                        </td>
                        <td class="col-acciones">
                            <!-- Botón Editar -->
                            <button type="button" class="admin-icon-btn" 
                                    onclick="abrirEditar('${prod.id}', '${prod.nombre}', '${prod.precio}', '${prod.stock}')" 
                                    aria-label="Editar producto" title="Editar">✎</button>
                            
                            <!-- Lógica para Activar / Desactivar -->
                            <c:choose>
                                <c:when test="${prod.activo == 'Activo'}">
                                    <form action="ProductoServlet" method="POST" style="display:inline;" onsubmit="return confirm('¿Desactivar este producto? Desaparecerá del catálogo.');">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="id" value="${prod.id}">
                                        <button type="submit" class="admin-icon-btn" aria-label="Desactivar producto" title="Desactivar">🗑</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="ProductoServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="accion" value="activar">
                                        <input type="hidden" name="id" value="${prod.id}">
                                        <button type="submit" class="admin-icon-btn" style="color: #28a745; font-weight: bold;" aria-label="Activar producto" title="Activar">✔</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaProductos}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">No hay productos registrados.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<!-- MODAL NUEVO / EDITAR PRODUCTO -->
<div class="admin-modal" id="modal">
    <div class="admin-modal-box">
        <h2 id="tituloModal">NUEVO PRODUCTO</h2>
        
        <form action="ProductoServlet" method="POST" id="formProducto">
            <input type="hidden" name="accion" id="accion" value="agregar">
            <input type="hidden" name="id" id="idProducto" value="">

            <div class="admin-form-grupo">
                <label>Nombre del producto</label>
                <input id="nombre" name="nombre" type="text" required>
            </div>

            <div class="admin-form-grupo">
                <label>Categoría</label>
                <select id="id_categoria" name="id_categoria" required>
                    <c:forEach var="cat" items="${listaCategorias}">
                        <option value="${cat.id}">${cat.nombre}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="admin-form-grupo">
                <label>Precio</label>
                <input id="precio" name="precio" type="number" required>
            </div>

            <div class="admin-form-grupo">
                <label>Stock</label>
                <input id="stock" name="stock" type="number" required>
            </div>
            
            <div class="admin-form-grupo">
                <label>Stock mínimo</label>
                <input id="stock_minimo" name="stock_minimo" type="number" value="5" required>
            </div>

            <div class="admin-modal-acciones">
                <button type="button" class="admin-btn" onclick="cerrarModal()">CANCELAR</button>
                <button type="submit" class="admin-btn admin-btn-primario">GUARDAR</button>
            </div>
        </form>
    </div>
</div>

<script>
    function abrirNuevo() {
        document.getElementById("formProducto").reset();
        document.getElementById("accion").value = "agregar";
        document.getElementById("tituloModal").innerText = "NUEVO PRODUCTO";
        document.getElementById("id_categoria").disabled = false;
        document.getElementById("modal").classList.add("activo");
    }

    function abrirEditar(id, nombre, precio, stock) {
        document.getElementById("accion").value = "editar";
        document.getElementById("idProducto").value = id;
        document.getElementById("nombre").value = nombre;
        document.getElementById("precio").value = precio;
        document.getElementById("stock").value = stock;
        document.getElementById("tituloModal").innerText = "EDITAR PRODUCTO";
        
        // Deshabilitar la categoría al editar (porque el Servlet de editar no la actualiza)
        document.getElementById("id_categoria").disabled = true; 
        
        document.getElementById("modal").classList.add("activo");
    }

    function cerrarModal() {
        document.getElementById("id_categoria").disabled = false; // Restaurar para el próximo uso
        document.getElementById("modal").classList.remove("activo");
    }

    function buscarProducto() {
        var texto = document.getElementById("buscar").value.toLowerCase();
        var filas = document.querySelectorAll("#tablaProductos tbody tr");
        filas.forEach(function(fila) {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    }
</script>

</body>
</html>