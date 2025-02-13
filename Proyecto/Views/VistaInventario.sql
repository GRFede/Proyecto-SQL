CREATE VIEW VistaInventario AS
SELECT 
    l.id_libro,
    l.titulo,
    c.nombre AS categoria,
    l.stock,
    l.precio
FROM 
    Libro l
JOIN 
    Categoria c ON l.id_categoria = c.id_categoria;