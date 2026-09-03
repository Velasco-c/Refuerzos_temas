-- ============================================================
-- MARKETFLOW - PRACTICA INTEGRAL DE POSTGRESQL
-- ============================================================
--
-- Contenido:
--   01. Consultas basicas
--   02. JOIN
--   03. GROUP BY / HAVING
--   04. UNION / INTERSECT / EXCEPT
--   05. CTE
--   06. Window Functions
--   07. VIEW
--   08. FUNCTION
--   09. PROCEDURE
--   10. TRIGGER
--   11. RETURNING
--   12. ON CONFLICT
--   13. UPDATE ... FROM
--   14. Expresiones regulares
--   15. COPY / \COPY
--   16. Backup / Restore
--   17. Examen final
--
-- Base de datos: marketflow
-- ============================================================


-- ============================================================
-- EJERCICIO 01
-- Productos con precio superior a 500
-- ============================================================

SELECT
    nombre,
    precio,
    stock
FROM productos
WHERE precio > 500
ORDER BY precio DESC;


-- ============================================================
-- EJERCICIO 02
-- Productos con stock entre 10 y 30
-- ============================================================

SELECT
    nombre,
    precio,
    stock
FROM productos
WHERE stock BETWEEN 10 AND 30
ORDER BY stock DESC;


-- ============================================================
-- EJERCICIO 03
-- Clientes pertenecientes a ciudades especificas
-- ============================================================

SELECT
    id_cliente,
    nombre,
    email,
    ciudad
FROM clientes
WHERE ciudad IN ('Guatemala', 'Mixco', 'Antigua')
ORDER BY ciudad, nombre;


-- ============================================================
-- EJERCICIO 04
-- Productos cuyo nombre contiene "Mouse"
-- ============================================================

SELECT
    id_producto,
    nombre,
    precio,
    stock
FROM productos
WHERE nombre ILIKE '%mouse%';


-- ============================================================
-- EJERCICIO 05
-- Clasificacion de productos por rango de precio
-- ============================================================

SELECT
    nombre,
    precio,
    CASE
        WHEN precio <= 200 THEN 'Económico'
        WHEN precio <= 600 THEN 'Medio'
        ELSE 'Premium'
    END AS nivel_precio
FROM productos
ORDER BY precio;


-- ============================================================
-- EJERCICIO 06
-- Productos y categorias
-- ============================================================

SELECT
    p.nombre AS producto,
    c.nombre AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS c
    ON c.id_categoria = p.id_categoria
ORDER BY c.nombre, p.nombre;


-- ============================================================
-- EJERCICIO 07
-- Pedidos con cliente y empleado responsable
-- ============================================================

SELECT
    p.id_pedido,
    p.fecha_pedido,
    c.nombre AS cliente,
    e.nombre AS empleado,
    p.estado,
    p.total
FROM pedidos AS p
INNER JOIN clientes AS c
    ON c.id_cliente = p.id_cliente
LEFT JOIN empleados AS e
    ON e.id_empleado = p.id_empleado
ORDER BY p.fecha_pedido;


-- ============================================================
-- EJERCICIO 08
-- Total comprado por cliente
-- ============================================================

SELECT
    c.nombre AS cliente,
    COALESCE(SUM(p.total), 0) AS total_comprado
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente
   AND p.estado = 'entregado'
GROUP BY
    c.id_cliente,
    c.nombre
ORDER BY total_comprado DESC;


-- ============================================================
-- EJERCICIO 09
-- Clientes sin pedidos
-- ============================================================

SELECT
    c.id_cliente,
    c.nombre,
    c.email
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL
ORDER BY c.nombre;


-- ============================================================
-- EJERCICIO 10
-- Cantidad de pedidos por estado
-- ============================================================

SELECT
    estado,
    COUNT(*) AS cantidad
FROM pedidos
GROUP BY estado
ORDER BY cantidad DESC;


-- ============================================================
-- EJERCICIO 11
-- Precio promedio por categoria
-- ============================================================

SELECT
    c.nombre AS categoria,
    ROUND(AVG(p.precio), 2) AS precio_promedio
FROM categorias AS c
INNER JOIN productos AS p
    ON p.id_categoria = c.id_categoria
GROUP BY
    c.id_categoria,
    c.nombre
ORDER BY precio_promedio DESC;


-- ============================================================
-- EJERCICIO 12
-- Categorias con precio promedio superior a 500
-- ============================================================

SELECT
    c.nombre AS categoria,
    ROUND(AVG(p.precio), 2) AS precio_promedio
FROM categorias AS c
INNER JOIN productos AS p
    ON p.id_categoria = c.id_categoria
GROUP BY
    c.id_categoria,
    c.nombre
HAVING AVG(p.precio) > 500
ORDER BY precio_promedio DESC;


-- ============================================================
-- EJERCICIO 13
-- UNION de ciudades de clientes y empleados
-- ============================================================

SELECT ciudad
FROM clientes

UNION

SELECT ciudad
FROM empleados
WHERE ciudad IS NOT NULL

ORDER BY ciudad;


-- ============================================================
-- EJERCICIO 14
-- INTERSECT de ciudades
-- ============================================================

SELECT ciudad
FROM clientes

INTERSECT

SELECT ciudad
FROM empleados

ORDER BY ciudad;


-- ============================================================
-- EJERCICIO 15
-- Ciudades de clientes sin empleados asociados
-- ============================================================

SELECT ciudad
FROM clientes

EXCEPT

SELECT ciudad
FROM empleados

ORDER BY ciudad;


-- ============================================================
-- EJERCICIO 16
-- Clientes cuyo gasto entregado supera 1500
-- ============================================================

WITH gasto_clientes AS (
    SELECT
        c.id_cliente,
        c.nombre,
        SUM(p.total) AS total_gastado
    FROM clientes AS c
    INNER JOIN pedidos AS p
        ON p.id_cliente = c.id_cliente
    WHERE p.estado = 'entregado'
    GROUP BY
        c.id_cliente,
        c.nombre
)
SELECT
    nombre,
    total_gastado
FROM gasto_clientes
WHERE total_gastado > 1500
ORDER BY total_gastado DESC;


-- ============================================================
-- EJERCICIO 17
-- Ventas totales por categoria
-- ============================================================

WITH ventas_categoria AS (
    SELECT
        c.id_categoria,
        c.nombre AS categoria,
        SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
    FROM categorias AS c
    INNER JOIN productos AS pr
        ON pr.id_categoria = c.id_categoria
    INNER JOIN detalle_pedido AS dp
        ON dp.id_producto = pr.id_producto
    INNER JOIN pedidos AS pe
        ON pe.id_pedido = dp.id_pedido
    WHERE pe.estado = 'entregado'
    GROUP BY
        c.id_categoria,
        c.nombre
)
SELECT
    categoria,
    total_vendido
FROM ventas_categoria
ORDER BY total_vendido DESC;


-- ============================================================
-- EJERCICIO 18
-- Empleados por encima del promedio de ventas
-- ============================================================

WITH ventas_empleado AS (
    SELECT
        e.id_empleado,
        e.nombre,
        COALESCE(SUM(p.total), 0) AS total_ventas
    FROM empleados AS e
    LEFT JOIN pedidos AS p
        ON p.id_empleado = e.id_empleado
       AND p.estado = 'entregado'
    GROUP BY
        e.id_empleado,
        e.nombre
),
promedio_ventas AS (
    SELECT
        AVG(total_ventas) AS promedio_general
    FROM ventas_empleado
)
SELECT
    ve.nombre,
    ve.total_ventas,
    pv.promedio_general
FROM ventas_empleado AS ve
CROSS JOIN promedio_ventas AS pv
WHERE ve.total_ventas > pv.promedio_general
ORDER BY ve.total_ventas DESC;


-- ============================================================
-- EJERCICIO 19
-- ROW_NUMBER por categoria
-- ============================================================

SELECT
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio,
    ROW_NUMBER() OVER (
        PARTITION BY p.id_categoria
        ORDER BY p.precio DESC
    ) AS posicion
FROM productos AS p
INNER JOIN categorias AS c
    ON c.id_categoria = p.id_categoria
ORDER BY
    categoria,
    posicion;


-- ============================================================
-- EJERCICIO 20
-- RANK de clientes por gasto
-- ============================================================

WITH gasto_clientes AS (
    SELECT
        c.id_cliente,
        c.nombre,
        COALESCE(
            SUM(
                CASE
                    WHEN p.estado = 'entregado'
                    THEN p.total
                    ELSE 0
                END
            ),
            0
        ) AS total_comprado
    FROM clientes AS c
    LEFT JOIN pedidos AS p
        ON p.id_cliente = c.id_cliente
    GROUP BY
        c.id_cliente,
        c.nombre
)
SELECT
    nombre AS cliente,
    total_comprado,
    RANK() OVER (
        ORDER BY total_comprado DESC
    ) AS ranking
FROM gasto_clientes
ORDER BY ranking, cliente;


-- ============================================================
-- EJERCICIO 21
-- Total acumulado de pedidos entregados
-- ============================================================

SELECT
    id_pedido,
    fecha_pedido,
    total,
    SUM(total) OVER (
        ORDER BY fecha_pedido, id_pedido
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS total_acumulado
FROM pedidos
WHERE estado = 'entregado'
ORDER BY
    fecha_pedido,
    id_pedido;


-- ============================================================
-- EJERCICIO 22
-- Promedio de precio dentro de cada categoria
-- ============================================================

SELECT
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio,
    ROUND(
        AVG(p.precio) OVER (
            PARTITION BY p.id_categoria
        ),
        2
    ) AS promedio_categoria
FROM productos AS p
INNER JOIN categorias AS c
    ON c.id_categoria = p.id_categoria
ORDER BY
    categoria,
    precio DESC;


-- ============================================================
-- EJERCICIO 23
-- Pedido anterior de cada cliente
-- ============================================================

SELECT
    c.nombre AS cliente,
    p.id_pedido,
    p.fecha_pedido,
    p.total,
    LAG(p.total) OVER (
        PARTITION BY p.id_cliente
        ORDER BY p.fecha_pedido, p.id_pedido
    ) AS total_pedido_anterior
FROM pedidos AS p
INNER JOIN clientes AS c
    ON c.id_cliente = p.id_cliente
WHERE p.estado = 'entregado'
ORDER BY
    cliente,
    p.fecha_pedido;


-- ============================================================
-- EJERCICIO 24
-- Vista de resumen de pedidos
-- ============================================================

CREATE OR REPLACE VIEW vw_resumen_pedidos AS
SELECT
    p.id_pedido,
    p.fecha_pedido,
    c.nombre AS cliente,
    e.nombre AS empleado,
    p.estado,
    p.total
FROM pedidos AS p
INNER JOIN clientes AS c
    ON c.id_cliente = p.id_cliente
LEFT JOIN empleados AS e
    ON e.id_empleado = p.id_empleado;


SELECT *
FROM vw_resumen_pedidos
ORDER BY fecha_pedido;


-- ============================================================
-- EJERCICIO 25
-- Funcion para obtener gasto total de un cliente
-- ============================================================

CREATE OR REPLACE FUNCTION fn_total_cliente(
    p_id_cliente INTEGER
)
RETURNS NUMERIC(12,2)
LANGUAGE SQL
STABLE
AS $$
    SELECT
        COALESCE(SUM(total), 0)::NUMERIC(12,2)
    FROM pedidos
    WHERE id_cliente = p_id_cliente
      AND estado = 'entregado';
$$;


SELECT fn_total_cliente(1);


-- ============================================================
-- EJERCICIO 26
-- Funcion para clasificar precios
-- ============================================================

CREATE OR REPLACE FUNCTION fn_nivel_precio(
    p_precio NUMERIC
)
RETURNS VARCHAR(20)
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT
        CASE
            WHEN p_precio <= 200 THEN 'Económico'
            WHEN p_precio <= 600 THEN 'Medio'
            ELSE 'Premium'
        END;
$$;


SELECT
    nombre,
    precio,
    fn_nivel_precio(precio) AS nivel_precio
FROM productos
ORDER BY precio;


-- ============================================================
-- EJERCICIO 27
-- Procedimiento para actualizar estado de pedido
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_actualizar_estado_pedido(
    p_id_pedido INTEGER,
    p_nuevo_estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedidos
    SET estado = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;
END;
$$;


CALL sp_actualizar_estado_pedido(5, 'enviado');

SELECT
    id_pedido,
    estado
FROM pedidos
WHERE id_pedido = 5;


-- ============================================================
-- EJERCICIO 28
-- Funcion trigger de auditoria de estados
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditar_estado_pedido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.estado IS DISTINCT FROM NEW.estado THEN
        INSERT INTO auditoria_pedidos (
            id_pedido,
            operacion,
            estado_anterior,
            estado_nuevo
        )
        VALUES (
            NEW.id_pedido,
            'UPDATE',
            OLD.estado,
            NEW.estado
        );
    END IF;

    RETURN NEW;
END;
$$;


DROP TRIGGER IF EXISTS tr_auditar_estado_pedido
ON pedidos;


CREATE TRIGGER tr_auditar_estado_pedido
AFTER UPDATE OF estado
ON pedidos
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_estado_pedido();


-- ============================================================
-- EJERCICIO 29
-- Validacion del trigger de auditoria
-- ============================================================

UPDATE pedidos
SET estado = 'enviado'
WHERE id_pedido = 5;


SELECT
    id_auditoria,
    id_pedido,
    operacion,
    estado_anterior,
    estado_nuevo,
    fecha_operacion
FROM auditoria_pedidos
ORDER BY id_auditoria DESC;


-- ============================================================
-- EJERCICIO 30
-- INSERT con RETURNING
-- ============================================================

INSERT INTO clientes (
    nombre,
    email,
    ciudad,
    fecha_registro
)
VALUES (
    'Cliente Returning',
    'returning@example.com',
    'Guatemala',
    CURRENT_DATE
)
RETURNING
    id_cliente,
    nombre,
    email;


-- ============================================================
-- EJERCICIO 31
-- UPDATE con precio anterior y precio nuevo
-- ============================================================

WITH anterior AS (
    SELECT
        id_producto,
        precio AS precio_anterior
    FROM productos
    WHERE id_producto = 1
),
actualizado AS (
    UPDATE productos AS p
    SET precio = p.precio + 50
    FROM anterior AS a
    WHERE p.id_producto = a.id_producto
    RETURNING
        p.id_producto,
        p.nombre,
        p.precio AS precio_nuevo
)
SELECT
    a.id_producto,
    u.nombre,
    a.precio_anterior,
    u.precio_nuevo
FROM anterior AS a
INNER JOIN actualizado AS u
    ON u.id_producto = a.id_producto;


-- ============================================================
-- EJERCICIO 32
-- INSERT evitando conflicto por email
-- ============================================================

INSERT INTO clientes (
    nombre,
    email,
    ciudad,
    fecha_registro
)
VALUES (
    'Carlos Mendoza',
    'carlos@example.com',
    'Guatemala',
    '2025-01-15'
)
ON CONFLICT (email)
DO NOTHING;


SELECT
    id_cliente,
    nombre,
    email
FROM clientes
WHERE email = 'carlos@example.com';


-- ============================================================
-- EJERCICIO 33
-- Actualizacion de totales mediante UPDATE ... FROM
-- ============================================================

WITH totales AS (
    SELECT
        dp.id_pedido,
        SUM(dp.cantidad * dp.precio_unitario) AS total_calculado
    FROM detalle_pedido AS dp
    GROUP BY dp.id_pedido
)
UPDATE pedidos AS p
SET total = t.total_calculado
FROM totales AS t
WHERE p.id_pedido = t.id_pedido
RETURNING
    p.id_pedido,
    p.total;


-- ============================================================
-- EJERCICIO 34
-- Validacion de estructura de emails mediante REGEX
-- ============================================================

SELECT
    id_cliente,
    nombre,
    email
FROM clientes
WHERE email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
ORDER BY email;


-- ============================================================
-- EJERCICIO 35
-- Busqueda de productos mediante REGEX
-- ============================================================

SELECT
    id_producto,
    nombre,
    precio
FROM productos
WHERE nombre ~* '(Mouse|Teclado|Monitor)'
ORDER BY nombre;


-- ============================================================
-- EJERCICIO 36
-- EXPORTACION E IMPORTACION CON \COPY
-- ============================================================

-- Ejecutar dentro de psql:

\copy productos TO 'productos.csv' WITH (FORMAT csv, HEADER true);


-- Tabla auxiliar para comprobar la importacion:

CREATE TEMP TABLE productos_importacion AS
SELECT *
FROM productos
WITH NO DATA;


-- Importacion:

\copy productos_importacion FROM 'productos.csv' WITH (FORMAT csv, HEADER true);


-- Validacion:

SELECT COUNT(*)
FROM productos_importacion;


SELECT *
FROM productos_importacion
ORDER BY id_producto;


-- ============================================================
-- EJERCICIO 37
-- BACKUP Y RESTORE
-- ============================================================

-- Ejecutar desde la terminal, no dentro de psql:

pg_dump \
    -h localhost \
    -p 5433 \
    -U postgres \
    -d marketflow \
    -F c \
    -f marketflow.backup


-- Crear base de restauracion:

createdb \
    -h localhost \
    -p 5433 \
    -U postgres \
    marketflow_restore


-- Restaurar:

pg_restore \
    -h localhost \
    -p 5433 \
    -U postgres \
    -d marketflow_restore \
    marketflow.backup


-- Validar desde psql:

psql \
    -h localhost \
    -p 5433 \
    -U postgres \
    -d marketflow_restore


-- Dentro de psql:

\dt

SELECT COUNT(*) FROM productos;
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM pedidos;


-- ============================================================
-- EXAMEN FINAL
-- Clientes importantes de Marketflow
-- ============================================================

WITH gasto_clientes AS (
    SELECT
        c.id_cliente,
        c.nombre,
        c.ciudad,
        COUNT(p.id_pedido) AS pedidos_entregados,
        SUM(p.total) AS total_gastado
    FROM clientes AS c
    INNER JOIN pedidos AS p
        ON p.id_cliente = c.id_cliente
    WHERE p.estado = 'entregado'
    GROUP BY
        c.id_cliente,
        c.nombre,
        c.ciudad
),
estadisticas AS (
    SELECT
        AVG(total_gastado) AS promedio_gasto
    FROM gasto_clientes
),
clientes_importantes AS (
    SELECT
        gc.id_cliente,
        gc.nombre,
        gc.ciudad,
        gc.pedidos_entregados,
        gc.total_gastado,
        e.promedio_gasto
    FROM gasto_clientes AS gc
    CROSS JOIN estadisticas AS e
    WHERE gc.total_gastado > e.promedio_gasto
)
SELECT
    id_cliente,
    nombre,
    ciudad,
    pedidos_entregados,
    total_gastado,
    RANK() OVER (
        ORDER BY total_gastado DESC
    ) AS posicion,
    ROUND(
        total_gastado - promedio_gasto,
        2
    ) AS diferencia_promedio
FROM clientes_importantes
ORDER BY posicion;


-- ============================================================
-- EXAMEN FINAL
-- Vista de clientes importantes
-- ============================================================

CREATE OR REPLACE VIEW vw_clientes_importantes AS
WITH gasto_clientes AS (
    SELECT
        c.id_cliente,
        c.nombre,
        c.ciudad,
        COUNT(p.id_pedido) AS pedidos_entregados,
        SUM(p.total) AS total_gastado
    FROM clientes AS c
    INNER JOIN pedidos AS p
        ON p.id_cliente = c.id_cliente
    WHERE p.estado = 'entregado'
    GROUP BY
        c.id_cliente,
        c.nombre,
        c.ciudad
),
estadisticas AS (
    SELECT
        AVG(total_gastado) AS promedio_gasto
    FROM gasto_clientes
)
SELECT
    gc.id_cliente,
    gc.nombre,
    gc.ciudad,
    gc.pedidos_entregados,
    gc.total_gastado,
    RANK() OVER (
        ORDER BY gc.total_gastado DESC
    ) AS posicion,
    ROUND(
        gc.total_gastado - e.promedio_gasto,
        2
    ) AS diferencia_promedio
FROM gasto_clientes AS gc
CROSS JOIN estadisticas AS e
WHERE gc.total_gastado > e.promedio_gasto;


SELECT *
FROM vw_clientes_importantes
ORDER BY posicion;


-- ============================================================
-- EXAMEN FINAL
-- Funcion para obtener gasto total de cualquier cliente
-- ============================================================

CREATE OR REPLACE FUNCTION fn_gasto_cliente(
    p_id_cliente INTEGER
)
RETURNS NUMERIC(12,2)
LANGUAGE SQL
STABLE
AS $$
    SELECT
        COALESCE(
            SUM(total),
            0
        )::NUMERIC(12,2)
    FROM pedidos
    WHERE id_cliente = p_id_cliente
      AND estado = 'entregado';
$$;


SELECT fn_gasto_cliente(1);
