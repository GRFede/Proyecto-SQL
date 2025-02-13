CREATE VIEW VistaLibrosDisponibles AS
SELECT 
    l.id_libro,
    l.titulo,
    l.autor,
    l.precio,
    l.stock,
    c.nombre AS categoria
FROM 
    Libro l
JOIN 
    Categoria c ON l.id_categoria = c.id_categoria
WHERE 
    l.stock > 0;