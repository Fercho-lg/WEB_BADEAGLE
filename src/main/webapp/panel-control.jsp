<%-- 
    Document   : panel-control
    Descripción: Panel principal con datos dinámicos desde PanelControlServlet.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BAD EAGLE | Panel de Control</title>
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="admin.css">
</head>
<body class="admin-body">

<aside class="admin-sidebar">
    <div class="admin-sidebar-titulo">Dashboard</div>
    <nav class="admin-menu" aria-label="Menú administrativo">
        <a href="PanelControlServlet" class="admin-menu-link activo" aria-current="page">Panel de Control</a>
        <a href="gestion-productos.jsp" class="admin-menu-link">Productos e Inventario</a>
        <a href="gestion-produccion.jsp" class="admin-menu-link">Producción</a>
        <a href="gestion-usuarios.jsp" class="admin-menu-link">Usuarios</a>
        <a href="gestion-pqr.jsp" class="admin-menu-link">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">
    <h1>PANEL DE CONTROL</h1>
    
    <div class="admin-metricas">
        <!-- Métrica de Ventas -->
        <div class="admin-metrica">
            <div class="admin-metrica-label">Ventas</div>
            <div class="admin-metrica-valor">
                <fmt:formatNumber value="${ventas}" type="currency" currencySymbol="$" maxFractionDigits="0" />
            </div>
        </div>
        
        <!-- Métrica de Inventario -->
        <div class="admin-metrica">
            <div class="admin-metrica-label">Inventario (Unidades)</div>
            <div class="admin-metrica-valor">
                ${not empty inventario ? inventario : '0'}
            </div>
        </div>
        
        <!-- Métrica de Pedidos -->
        <div class="admin-metrica">
            <div class="admin-metrica-label">Pedidos</div>
            <div class="admin-metrica-valor">
                ${not empty pedidos ? pedidos : '0'}
            </div>
        </div>
        
        <!-- Métrica de Usuarios -->
        <div class="admin-metrica">
            <div class="admin-metrica-label">Usuarios Registrados</div>
            <div class="admin-metrica-valor">
                ${not empty usuarios ? usuarios : '0'}
            </div>
        </div>
    </div>

    <div class="admin-paneles">
        <div class="admin-panel">
            <div class="admin-panel-titulo">Ventas (Últimos 30 días)</div>
            <div class="admin-panel-placeholder">[Gráfico de ventas - Próxima Fase]</div>
        </div>
        <div class="admin-panel">
            <div class="admin-panel-titulo">Resumen de Pedidos</div>
            <div class="admin-panel-placeholder">[Gráfico resumen - Próxima Fase]</div>
        </div>
    </div>
</main>

</body>
</html>