-- ================================================
-- PROYECTO: Monitoreo de Canales y Desempeño 
-- Comercial - Kola Real
-- Autor: Eduard Garcia Taveras
-- Email: eduardgarciataverass@gmail.com
-- Herramientas: PostgreSQL · Power BI · DAX · Excel
-- Fecha: 2026
-- ================================================

-- ================================================
-- PARTE 1: CREACIÓN DE LA BASE DE DATOS
-- ================================================

CREATE DATABASE cola_real_db;

\c cola_real_db;

-- ================================================
-- PARTE 2: ESTRUCTURA DE LA TABLA
-- ================================================

CREATE TABLE IF NOT EXISTS public.ventas_cola_real
(
    id SERIAL PRIMARY KEY,
    fecha DATE,
    sabor CHARACTER VARYING(20),
    formato CHARACTER VARYING(20),
    precio_publico NUMERIC(10,2),
    costo_produccion NUMERIC(10,2),
    unidades_vendidas INT,
    provincia CHARACTER VARYING(50),
    canal_venta CHARACTER VARYING(50)
);

-- ================================================
-- PARTE 3: INSERCIÓN DE DATOS
-- ================================================

INSERT INTO public.ventas_cola_real 
(fecha, sabor, formato, precio_publico, 
costo_produccion, unidades_vendidas, 
provincia, canal_venta)
VALUES 
-- Santo Domingo
('2026-04-01', 'Cola', '3L', 85.00, 42.00, 
1500, 'Santo Domingo', 'Supermercado'),
('2026-04-01', 'Cola', '3L', 85.00, 42.00, 
1100, 'Santiago', 'Mayorista'),
('2026-04-01', 'Merengue', '3L', 85.00, 42.00, 
900, 'Santo Domingo', 'Colmado'),
('2026-04-01', 'Uva', '1.5L', 45.00, 26.00, 
800, 'La Romana', 'Colmado'),

-- San Francisco de Macorís
('2026-04-02', 'Merengue', '350ml', 20.00, 
9.00, 4500, 'San Francisco de Macoris', 
'Colmado'),
('2026-04-02', 'Cola', '3L', 85.00, 42.00, 
1200, 'Santiago', 'Supermercado'),
('2026-04-02', 'Uva', '1.5L', 45.00, 26.00, 
600, 'La Romana', 'Mayorista'),
('2026-04-02', 'Cola', '350ml', 20.00, 9.00, 
2000, 'Santo Domingo', 'Colmado'),

-- Dajabón
('2026-04-03', 'Cola', '3L', 85.00, 70.00, 
800, 'Dajabón', 'Colmado'),
('2026-04-03', 'Merengue', '1.5L', 45.00, 
26.00, 700, 'Santiago', 'Colmado'),
('2026-04-03', 'Cola', '350ml', 20.00, 9.00, 
3000, 'San Francisco de Macoris', 'Mayorista'),
('2026-04-03', 'Uva', '3L', 85.00, 42.00, 
500, 'Santo Domingo', 'Supermercado'),

-- Duarte
('2026-04-04', 'Merengue', '3L', 85.00, 42.00, 
1800, 'Duarte', 'Supermercado'),
('2026-04-04', 'Cola', '1.5L', 45.00, 26.00, 
2200, 'Duarte', 'Colmado'),
('2026-04-04', 'Uva', '350ml', 20.00, 9.00, 
1100, 'Santiago', 'Mayorista'),
('2026-04-04', 'Cola', '3L', 85.00, 42.00, 
900, 'La Romana', 'Supermercado');

-- ================================================
-- PARTE 4: LIMPIEZA Y NORMALIZACIÓN DE DATOS
-- ================================================

-- Paso 1: Revisión inicial de los datos
SELECT * FROM public.ventas_cola_real;

-- Paso 2: Limpiar espacios en blanco 
-- en columnas clave
UPDATE public.ventas_cola_real
SET canal_venta = TRIM(canal_venta),
    sabor = TRIM(sabor),
    provincia = TRIM(provincia);

-- Paso 3: Corregir nombre de Santo Domingo
UPDATE public.ventas_cola_real
SET provincia = 'Santo Domingo'
WHERE provincia ILIKE '%Santo Domingo%';

-- Paso 4: Corregir error de codificación 
-- en Dajabón
UPDATE public.ventas_cola_real
SET provincia = 'Dajabón'
WHERE provincia LIKE 'Dajab%';

-- ================================================
-- PARTE 5: VERIFICACIÓN FINAL
-- ================================================

-- Verificar provincias y canales normalizados
SELECT 
    provincia, 
    canal_venta,
    COUNT(*) AS total_registros
FROM public.ventas_cola_real
GROUP BY provincia, canal_venta
ORDER BY provincia ASC;

-- Análisis final de ganancias por 
-- sabor, provincia y canal
SELECT 
    sabor,
    provincia,
    canal_venta,
    SUM(unidades_vendidas) AS total_unidades,
    SUM(precio_publico * unidades_vendidas) 
        AS ganancia_total
FROM public.ventas_cola_real
GROUP BY sabor, provincia, canal_venta
ORDER BY ganancia_total DESC;
