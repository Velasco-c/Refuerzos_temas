-- 01. Categorías

INSERT INTO categorias (nombre) VALUES
('Tecnologia'),
('Hogar'),
('Oficina'),
('Videojuegos'),
('Accesorios');

-- 02. Productos

INSERT INTO productos
(nombre, precio, stock, id_categoria)
VALUES
('Teclado mecanico', 320.00, 25, 1),
('Mouse inalambrico', 145.50, 40, 1),
('Monitor 24 pulgadas', 1250.00, 12, 1),
('Audifonos Bluetooth', 280.00, 30, 5),
('Webcam HD', 390.00, 18, 1),
('Lampara LED', 175.00, 35, 2),
('Silla ergonomica', 1450.00, 8, 2),
('Escritorio compacto', 980.00, 10, 2),
('Cuaderno profesional', 45.00, 100, 3),
('Calculadora cientifica', 180.00, 25, 3),
('Control Xbox', 850.00, 15, 4),
('Teclado numerico', 120.00, 50, 3),
('Mouse gamer', 450.00, 22, 4),
('Microfono USB', 620.00, 14, 5),
('Hub USB-C', 230.00, 28, 5);


-- 03. Clientes
INSERT INTO clientes
(nombre, email, ciudad, fecha_registro)
VALUES
('Carlos Mendoza', 'carlos@example.com', 'Guatemala', '2025-01-15'),
('Ana Lopez', 'ana@example.com', 'Mixco', '2025-02-10'),
('Luis Ramirez', 'luis@example.com', 'Villa Nueva', '2025-02-25'),
('Sofia Castillo', 'sofia@example.com', 'Guatemala', '2025-03-03'),
('Miguel Herrera', 'miguel@example.com', 'Antigua', '2025-03-17'),
('Daniela Perez', 'daniela@example.com', 'Mixco', '2025-04-01'),
('Jorge Morales', 'jorge@example.com', 'Escuintla', '2025-04-12'),
('Valeria Gomez', 'valeria@example.com', 'Guatemala', '2025-05-08'),
('Andres Torres', 'andres@example.com', 'Quetzaltenango', '2025-05-21'),
('Paola Sanchez', 'paola@example.com', 'Guatemala', '2025-06-02'),
('Diego Flores', 'diego@example.com', 'Mixco', '2025-06-15'),
('Mariana Ortiz', 'mariana@example.com', 'Antigua', '2025-07-01');


-- 04. Empleados

INSERT INTO empleados
(nombre, departamento, salario, fecha_contratacion)
VALUES
('Laura Ramirez', 'Ventas', 6500.00, '2023-01-10'),
('Pedro Castillo', 'Ventas', 7200.00, '2022-08-15'),
('Andrea Morales', 'Soporte', 5800.00, '2024-02-20'),
('Fernando Lopez', 'Logistica', 6100.00, '2023-06-12'),
('Gabriela Torres', 'Ventas', 7900.00, '2021-11-05'),
('Ricardo Perez', 'Logistica', 6300.00, '2024-01-18');
4. Pedidos

-- 05. pedidos

INSERT INTO pedidos
(id_cliente, id_empleado, fecha_pedido, estado, total)
VALUES
(1, 1, '2025-08-01 09:15:00', 'entregado', 1465.50),
(2, 2, '2025-08-02 10:30:00', 'entregado', 850.00),
(3, 1, '2025-08-03 14:20:00', 'enviado', 1250.00),
(4, 5, '2025-08-05 16:45:00', 'entregado', 600.00),
(5, 3, '2025-08-07 11:10:00', 'procesando', 1450.00),
(1, 2, '2025-08-09 13:25:00', 'entregado', 900.00),
(6, 5, '2025-08-10 15:40:00', 'cancelado', 390.00),
(7, 4, '2025-08-12 09:50:00', 'entregado', 1225.00),
(8, 1, '2025-08-14 12:15:00', 'enviado', 280.00),
(9, 2, '2025-08-15 17:30:00', 'entregado', 1450.00),
(10, 5, '2025-08-17 10:05:00', 'procesando', 1370.00),
(11, 3, '2025-08-19 14:00:00', 'entregado', 620.00),
(12, 4, '2025-08-20 16:20:00', 'entregado', 1025.00),
(3, 1, '2025-08-22 11:45:00', 'enviado', 840.00),
(4, 5, '2025-08-24 13:10:00', 'pendiente', 1250.00),
(5, 2, '2025-08-26 09:35:00', 'entregado', 1320.00),
(2, 1, '2025-08-27 15:55:00', 'entregado', 450.00),
(8, 3, '2025-08-29 10:40:00', 'cancelado', 980.00);

-- 06. Detalle de pedidos

INSERT INTO detalle_pedido
(id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(1, 1, 1, 320),
(1, 2, 1, 145.50),
(1, 3, 1, 1000),
(2, 11, 1, 850),
(3, 3, 1, 1250),
(4, 4, 1, 280),
(4, 6, 1, 175),
(4, 9, 2, 45),
(5, 7, 1, 1450),
(6, 13, 2, 450),
(7, 5, 1, 390),
(8, 10, 1, 180),
(8, 14, 1, 620),
(8, 9, 1, 45),
(8, 12, 1, 120),
(9, 4, 1, 280),
(10, 7, 1, 1450),
(11, 5, 1, 390),
(11, 14, 1, 620),
(11, 12, 2, 120),
(12, 8, 1, 980),
(12, 9, 1, 45),
(13, 6, 1, 175),
(13, 8, 1, 850),
(14, 4, 3, 280),
(15, 3, 1, 1250),
(16, 1, 1, 320),
(16, 14, 1, 620),
(16, 12, 2, 120),
(17, 13, 1, 450),
(18, 8, 1, 980);