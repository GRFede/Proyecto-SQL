-- Listado de Stored Procedures (procedimientos almacenados)

-- Procedimiento Almacenado: CrearPedido
DELIMITER $$

CREATE PROCEDURE CrearPedido(
    IN id_cliente INT, 
    IN libros JSON
)
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE id_pedido INT;
	DECLARE i INT DEFAULT 0;
    DECLARE libro_id INT;
    DECLARE cantidad INT;
    DECLARE precio_unitario DECIMAL(10,2);
    
    -- Insertar el nuevo pedido
    INSERT INTO Pedido (id_cliente, fecha)
    VALUES (id_cliente, NOW());
    
    -- Obtener el id del pedido recién insertado
    SET id_pedido = LAST_INSERT_ID();
    
    -- Calcular el total y agregar los detalles del pedido
    SET total = 0;
    
    -- Iterar sobre los libros recibidos en el parámetro JSON
    WHILE i < JSON_LENGTH(libros) DO
        SET libro_id = JSON_UNQUOTE(JSON_EXTRACT(libros, CONCAT('$[', i, '].id_libro')));
        SET cantidad = JSON_UNQUOTE(JSON_EXTRACT(libros, CONCAT('$[', i, '].cantidad')));
        
        -- Obtener el precio del libro
        SELECT precio INTO precio_unitario
        FROM Libro
        WHERE id_libro = libro_id;
        
        -- Insertar detalle del pedido
        INSERT INTO DetallePedido (id_pedido, id_libro, cantidad, precio_unitario)
        VALUES (id_pedido, libro_id, cantidad, precio_unitario);
        
        -- Actualizar el stock del libro
        UPDATE Libro
        SET stock = stock - cantidad
        WHERE id_libro = libro_id;
        
        -- Acumular el total
        SET total = total + (cantidad * precio_unitario);
        
        SET i = i + 1;
    END WHILE;
    
    -- Actualizar el total del pedido
    UPDATE Pedido
    SET total = total
    WHERE id_pedido = id_pedido;

END $$

DELIMITER ;

-- Procedimiento Almacenado: CancelarPedido
DELIMITER $$

CREATE PROCEDURE CancelarPedido(
    IN id_pedido INT
)
BEGIN
    DECLARE id_libro INT;
    DECLARE cantidad INT;
    
    -- Reponer el stock de los libros del pedido
    DECLARE cur CURSOR FOR 
        SELECT dp.id_libro, dp.cantidad
        FROM DetallePedido dp
        WHERE dp.id_pedido = id_pedido;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO id_libro, cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Reponer el stock de los libros
        UPDATE Libro
        SET stock = stock + cantidad
        WHERE id_libro = id_libro;
    END LOOP;
    
    CLOSE cur;
    
    -- Eliminar los detalles del pedido
    DELETE FROM DetallePedido WHERE id_pedido = id_pedido;
    
    -- Eliminar el pedido
    DELETE FROM Pedido WHERE id_pedido = id_pedido;
    
END $$

DELIMITER ;

-- Procedimiento Almacenado: ActualizarStockLibro
DELIMITER $$

CREATE PROCEDURE ActualizarStockLibro(
    IN id_libro INT, 
    IN cantidad INT
)
BEGIN
    -- Actualizar el stock de un libro específico
    UPDATE Libro
    SET stock = stock + cantidad
    WHERE id_libro = id_libro;
END $$

DELIMITER ;

-- Procedimiento Almacenado: GenerarFactura
DELIMITER $$

CREATE PROCEDURE GenerarFactura(
    IN id_pedido INT
)
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE id_factura INT;
    
    -- Obtener el total del pedido
    SELECT total INTO total
    FROM Pedido
    WHERE id_pedido = id_pedido;
    
    -- Crear la factura
    INSERT INTO Factura (id_pedido, total, fecha_emision)
    VALUES (id_pedido, total, NOW());
    
    -- Obtener el id de la factura recién insertada
    SET id_factura = LAST_INSERT_ID();
    
    -- Insertar los detalles de la factura
    INSERT INTO FacturaDetalle (id_factura, id_libro, cantidad, precio_unitario)
    SELECT id_factura, dp.id_libro, dp.cantidad, dp.precio_unitario
    FROM DetallePedido dp
    WHERE dp.id_pedido = id_pedido;
    
END $$

DELIMITER ;

-- Procedimiento Almacenado: ObtenerVentasPorFecha
DELIMITER $$

CREATE PROCEDURE ObtenerVentasPorFecha(
    IN fecha_inicio DATE, 
    IN fecha_fin DATE
)
BEGIN
    SELECT p.fecha_pedido, SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
    FROM Pedido p
    JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
    WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    GROUP BY p.fecha_pedido
    ORDER BY p.fecha_pedido;
END $$

DELIMITER ;
