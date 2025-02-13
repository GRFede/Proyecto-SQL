CREATE VIEW VistaResumenDeVentas AS
SELECT 
    l.titulo,
    SUM(dp.cantidad) AS cantidad_vendida,
    SUM(dp.cantidad * dp.precio_unitario) AS ingreso_total
FROM 
    DetallePedido dp
JOIN 
    Libro l ON dp.id_libro = l.id_libro
GROUP BY 
    l.titulo;