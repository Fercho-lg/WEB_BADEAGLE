<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>BAD EAGLE | Reportes</title>
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
        <a href="gestion-pqr.jsp" class="admin-menu-link">P.Q.R.</a>
        <a href="reportes.jsp" class="admin-menu-link activo" aria-current="page">Reportes</a>
        <a href="home.jsp" class="admin-menu-link admin-menu-salir">← Volver al sitio</a>
    </nav>
</aside>

<main class="admin-main">
    <div class="admin-main-header">
        <h1>REPORTES</h1>
    </div>

    <div class="admin-panel-placeholder" style="height: 400px; flex-direction: column;">
        <h2>Módulo en construcción</h2>
        <p>Aquí se generarán los reportes de ventas, inventario y pedidos.</p>
    </div>
</main>

</body>
</html>