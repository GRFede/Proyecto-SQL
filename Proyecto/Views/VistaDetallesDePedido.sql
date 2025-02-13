CREATE VIEW VistaDetallesDePedido AS
SELECT 
    p.id_pedido,
    p.fecha,
    c.nombre AS cliente,|
    l.titulo AS libro,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS total
FROM 
    Pedido p
JOIN 
    Cliente c ON p.id_cliente = c.id_cliente
JOIN 
    DetallePedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    Libro l ON dp.id_libro = l.id_libro;