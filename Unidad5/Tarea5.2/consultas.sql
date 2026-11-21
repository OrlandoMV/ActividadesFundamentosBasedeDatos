-- Proyección de las tablas del esquema normalizado de la Unidad 4.
-- Datos ficticios. Importes en pesos enteros para esta simulación.
CREATE TABLE cliente(id_cliente INTEGER PRIMARY KEY, nombres TEXT);
INSERT INTO cliente VALUES (1,'Ana'),(2,'Luis'),(3,'Eva');
CREATE TABLE equipo(id_equipo INTEGER PRIMARY KEY, propietario INTEGER);
INSERT INTO equipo VALUES (8,1),(9,2),(10,1);
CREATE TABLE orden_servicio(folio INTEGER PRIMARY KEY,id_equipo INTEGER,estado TEXT);
INSERT INTO orden_servicio VALUES (17,8,'cerrada'),(18,9,'recibida'),(19,8,'cerrada');
CREATE TABLE servicio(id_servicio INTEGER PRIMARY KEY,nombre TEXT,precio_base INTEGER);
INSERT INTO servicio VALUES (1,'Diagnóstico',175),(2,'Limpieza',200),(3,'Respaldo',300);
CREATE TABLE detalle_servicio(folio INTEGER,no_linea INTEGER,id_servicio INTEGER,cantidad INTEGER,precio_aplicado INTEGER,PRIMARY KEY(folio,no_linea));
INSERT INTO detalle_servicio VALUES (17,1,1,2,150),(17,2,2,1,200),(19,1,1,1,175);
CREATE TABLE empleado(id_empleado INTEGER PRIMARY KEY,nombre TEXT,rol TEXT);
INSERT INTO empleado VALUES (1,'Sara','T'),(2,'Iván','T'),(3,'Elena','C');
CREATE TABLE asignacion(folio INTEGER,tecnico INTEGER,coordinador INTEGER,PRIMARY KEY(folio,tecnico));
INSERT INTO asignacion VALUES (17,1,3),(19,2,3);


-- Consulta 1, relación C

WITH C AS (SELECT * FROM orden_servicio WHERE estado = 'cerrada')
SELECT * FROM C;

-- Consulta 1, relación R

WITH C AS (SELECT * FROM orden_servicio WHERE estado = 'cerrada'),
     R AS (SELECT folio,id_equipo FROM C)
SELECT * FROM R;

-- Consulta 2, relación R

WITH R AS (SELECT DISTINCT id_equipo FROM orden_servicio)
SELECT * FROM R;

-- Consulta 3, relación E0

WITH E0 AS (SELECT id_equipo FROM equipo)
SELECT * FROM E0;

-- Consulta 3, relación O0

WITH E0 AS (SELECT id_equipo FROM equipo),
     O0 AS (SELECT DISTINCT id_equipo FROM orden_servicio)
SELECT * FROM O0;

-- Consulta 3, relación R

WITH E0 AS (SELECT id_equipo FROM equipo),
     O0 AS (SELECT DISTINCT id_equipo FROM orden_servicio),
     R AS (SELECT * FROM E0 EXCEPT SELECT * FROM O0)
SELECT * FROM R;

-- Consulta 4, relación P

WITH P AS (SELECT DISTINCT propietario AS id_cliente FROM equipo)
SELECT * FROM P;

-- Consulta 4, relación V

WITH P AS (SELECT DISTINCT propietario AS id_cliente FROM equipo),
     V AS (SELECT id_cliente FROM cliente WHERE nombres = 'Eva')
SELECT * FROM V;

-- Consulta 4, relación R

WITH P AS (SELECT DISTINCT propietario AS id_cliente FROM equipo),
     V AS (SELECT id_cliente FROM cliente WHERE nombres = 'Eva'),
     R AS (SELECT * FROM P UNION SELECT * FROM V)
SELECT * FROM R;

-- Consulta 5, relación A0

WITH A0 AS (SELECT DISTINCT id_equipo FROM orden_servicio)
SELECT * FROM A0;

-- Consulta 5, relación B0

WITH A0 AS (SELECT DISTINCT id_equipo FROM orden_servicio),
     B0 AS (SELECT DISTINCT id_equipo FROM orden_servicio WHERE estado = 'cerrada')
SELECT * FROM B0;

-- Consulta 5, relación R

WITH A0 AS (SELECT DISTINCT id_equipo FROM orden_servicio),
     B0 AS (SELECT DISTINCT id_equipo FROM orden_servicio WHERE estado = 'cerrada'),
     R AS (SELECT * FROM A0 INTERSECT SELECT * FROM B0)
SELECT * FROM R;

-- Consulta 6, relación P

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'recibida')
SELECT * FROM P;

-- Consulta 6, relación T

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'recibida'),
     T AS (SELECT id_empleado FROM empleado WHERE rol = 'T')
SELECT * FROM T;

-- Consulta 6, relación R

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'recibida'),
     T AS (SELECT id_empleado FROM empleado WHERE rol = 'T'),
     R AS (SELECT * FROM P CROSS JOIN T)
SELECT * FROM R;

-- Consulta 7, relación P

WITH P AS (SELECT folio,id_equipo FROM orden_servicio WHERE estado = 'cerrada')
SELECT * FROM P;

-- Consulta 7, relación Q

WITH P AS (SELECT folio,id_equipo FROM orden_servicio WHERE estado = 'cerrada'),
     Q AS (SELECT P.*,E.propietario FROM P JOIN equipo E ON P.id_equipo=E.id_equipo)
SELECT * FROM Q;

-- Consulta 7, relación R

WITH P AS (SELECT folio,id_equipo FROM orden_servicio WHERE estado = 'cerrada'),
     Q AS (SELECT P.*,E.propietario FROM P JOIN equipo E ON P.id_equipo=E.id_equipo),
     R AS (SELECT DISTINCT Q.folio,C.nombres FROM Q JOIN cliente C ON Q.propietario=C.id_cliente)
SELECT * FROM R;

-- Consulta 8, relación P

WITH P AS (SELECT DISTINCT folio,id_servicio FROM detalle_servicio)
SELECT * FROM P;

-- Consulta 8, relación S0

WITH P AS (SELECT DISTINCT folio,id_servicio FROM detalle_servicio),
     S0 AS (SELECT id_servicio FROM servicio WHERE id_servicio IN (1,2))
SELECT * FROM S0;

-- Consulta 8, relación R

WITH P AS (SELECT DISTINCT folio,id_servicio FROM detalle_servicio),
     S0 AS (SELECT id_servicio FROM servicio WHERE id_servicio IN (1,2)),
     R AS (SELECT DISTINCT p.folio FROM P p WHERE NOT EXISTS (SELECT 1 FROM S0 s WHERE NOT EXISTS (SELECT 1 FROM P q WHERE q.folio=p.folio AND q.id_servicio=s.id_servicio)))
SELECT * FROM R;

-- Consulta 9, relación I

WITH I AS (SELECT folio,no_linea,cantidad*precio_aplicado AS subtotal FROM detalle_servicio)
SELECT * FROM I;

-- Consulta 9, relación P

WITH I AS (SELECT folio,no_linea,cantidad*precio_aplicado AS subtotal FROM detalle_servicio),
     P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada')
SELECT * FROM P;

-- Consulta 9, relación J

WITH I AS (SELECT folio,no_linea,cantidad*precio_aplicado AS subtotal FROM detalle_servicio),
     P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada'),
     J AS (SELECT I.* FROM I JOIN P USING(folio))
SELECT * FROM J;

-- Consulta 9, relación R

WITH I AS (SELECT folio,no_linea,cantidad*precio_aplicado AS subtotal FROM detalle_servicio),
     P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada'),
     J AS (SELECT I.* FROM I JOIN P USING(folio)),
     R AS (SELECT folio,SUM(subtotal) AS total FROM J GROUP BY folio)
SELECT * FROM R;

-- Consulta 10, relación I

WITH I AS (SELECT folio,no_linea FROM detalle_servicio)
SELECT * FROM I;

-- Consulta 10, relación J

WITH I AS (SELECT folio,no_linea FROM detalle_servicio),
     J AS (SELECT O.folio,I.no_linea FROM orden_servicio O LEFT JOIN I USING(folio))
SELECT * FROM J;

-- Consulta 10, relación R

WITH I AS (SELECT folio,no_linea FROM detalle_servicio),
     J AS (SELECT O.folio,I.no_linea FROM orden_servicio O LEFT JOIN I USING(folio)),
     R AS (SELECT folio,COUNT(no_linea) AS lineas FROM J GROUP BY folio)
SELECT * FROM R;

-- Consulta 11, relación P

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada')
SELECT * FROM P;

-- Consulta 11, relación T

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada'),
     T AS (SELECT id_empleado,nombre FROM empleado WHERE rol = 'T')
SELECT * FROM T;

-- Consulta 11, relación J

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada'),
     T AS (SELECT id_empleado,nombre FROM empleado WHERE rol = 'T'),
     J AS (SELECT DISTINCT A.folio,A.tecnico FROM P JOIN asignacion A USING(folio))
SELECT * FROM J;

-- Consulta 11, relación R

WITH P AS (SELECT folio FROM orden_servicio WHERE estado = 'cerrada'),
     T AS (SELECT id_empleado,nombre FROM empleado WHERE rol = 'T'),
     J AS (SELECT DISTINCT A.folio,A.tecnico FROM P JOIN asignacion A USING(folio)),
     R AS (SELECT DISTINCT J.folio,J.tecnico,T.nombre FROM J JOIN T ON J.tecnico=T.id_empleado)
SELECT * FROM R;
