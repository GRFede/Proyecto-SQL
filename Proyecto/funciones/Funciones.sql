-- Listado de Funciones

DELIMITER $$

CREATE FUNCTION CalcularTotalPedido(id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT IFNULL(SUM(dp.cantidad * dp.precio_unitario), 0.00)
    INTO total
    FROM DetallePedido dp
    WHERE dp.id_pedido = id_pedido;

    RETURN total;
END $$

DELIMITER ;
-- Función: VerificarStock
DELIMITER $$

CREATE FUNCTION VerificarStock(id_libro INT, cantidad INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock_disponible INT;

    SELECT stock INTO stock_disponible
    FROM Libro
    WHERE id_libro = id_libro;

    IF stock_disponible >= cantidad THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

-- Función: TotalPedidosPorCliente
DELIMITER $$

CREATE FUNCTION TotalPedidosPorCliente(id_cliente INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_pedidos INT;

    SELECT COUNT(*) INTO total_pedidos
    FROM Pedido
    WHERE id_cliente = id_cliente;

    RETURN total_pedidos;
END $$

DELIMITER ;

-- Función: TotalVentasPorLibro
DELIMITER $$

CREATE FUNCTION TotalVentasPorLibro(id_libro INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_ventas DECIMAL(10,2);

    SELECT SUM(dp.cantidad * dp.precio_unitario)
    INTO total_ventas
    FROM DetallePedido dp
    WHERE dp.id_libro = id_libro;

    RETURN total_ventas;
END $$

DELIMITER ;

-- Función: DescuentoPorCliente
DELIMITER $$

CREATE FUNCTION DescuentoPorCliente(id_cliente INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_pedidos INT;
    DECLARE descuento DECIMAL(10,2);

    SELECT COUNT(*) INTO total_pedidos
    FROM Pedido
    WHERE id_cliente = id_cliente;

    IF total_pedidos >= 5 THEN
        SET descuento = 0.10;  -- 10% de descuento
    ELSE
        SET descuento = 0.00;  -- Sin descuento
    END IF;

    RETURN descuento;
END $$

DELIMITER ;

-- Función: CalcularStockTotalPorCategoria
DELIMITER $$

CREATE FUNCTION CalcularStockTotalPorCategoria(id_categoria INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_stock INT;

    SELECT SUM(l.stock) INTO total_stock
    FROM Libro l
    WHERE l.id_categoria = id_categoria;

    RETURN total_stock;
END $$

DELIMITER ;

-- Función: CalcularIngresosTotales
DELIMITER $$

CREATE FUNCTION CalcularIngresosTotales() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE ingresos_totales DECIMAL(10,2);

    SELECT SUM(dp.cantidad * dp.precio_unitario)
    INTO ingresos_totales
    FROM DetallePedido dp;

    RETURN ingresos_totales;
END $$

DELIMITER ;

