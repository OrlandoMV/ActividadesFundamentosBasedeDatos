USE [TecSoporte_Unidad5_Practica];
IF DB_NAME() <> N'TecSoporte_Unidad5_Practica'
    THROW 52001, N'Esta validacion requiere la base de practica.', 1;
-- Las tablas temporales se eliminan al salir de este ámbito.
EXEC sys.sp_executesql N'SET NOCOUNT ON;
DECLARE @verificadas int = 0;

-- Consulta 1
;WITH C AS (SELECT * FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''cerrada''),
     R AS (SELECT folio,id_equipo FROM C)
SELECT * INTO #consulta_1 FROM R;
IF EXISTS (SELECT folio, id_equipo FROM #consulta_1 EXCEPT SELECT folio, id_equipo FROM (VALUES (17, 8), (19, 8)) AS esperado(folio, id_equipo))
   OR EXISTS (SELECT folio, id_equipo FROM (VALUES (17, 8), (19, 8)) AS esperado(folio, id_equipo) EXCEPT SELECT folio, id_equipo FROM #consulta_1)
   OR (SELECT COUNT(*) FROM #consulta_1) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 1.'', 1;
SET @verificadas += 1;

-- Consulta 2
;WITH R AS (SELECT DISTINCT id_equipo FROM tecsoporte_normalizado.orden_servicio)
SELECT * INTO #consulta_2 FROM R;
IF EXISTS (SELECT id_equipo FROM #consulta_2 EXCEPT SELECT id_equipo FROM (VALUES (8), (9)) AS esperado(id_equipo))
   OR EXISTS (SELECT id_equipo FROM (VALUES (8), (9)) AS esperado(id_equipo) EXCEPT SELECT id_equipo FROM #consulta_2)
   OR (SELECT COUNT(*) FROM #consulta_2) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 2.'', 1;
SET @verificadas += 1;

-- Consulta 3
;WITH E0 AS (SELECT id_equipo FROM tecsoporte_normalizado.equipo),
     O0 AS (SELECT DISTINCT id_equipo FROM tecsoporte_normalizado.orden_servicio),
     R AS (SELECT * FROM E0 EXCEPT SELECT * FROM O0)
SELECT * INTO #consulta_3 FROM R;
IF EXISTS (SELECT id_equipo FROM #consulta_3 EXCEPT SELECT id_equipo FROM (VALUES (10)) AS esperado(id_equipo))
   OR EXISTS (SELECT id_equipo FROM (VALUES (10)) AS esperado(id_equipo) EXCEPT SELECT id_equipo FROM #consulta_3)
   OR (SELECT COUNT(*) FROM #consulta_3) <> 1
    THROW 52000, N''Resultado inesperado en la consulta 3.'', 1;
SET @verificadas += 1;

-- Consulta 4
;WITH P AS (SELECT DISTINCT propietario AS id_cliente FROM tecsoporte_normalizado.equipo),
     V AS (SELECT id_cliente FROM tecsoporte_normalizado.cliente WHERE nombres = ''Eva''),
     R AS (SELECT * FROM P UNION SELECT * FROM V)
SELECT * INTO #consulta_4 FROM R;
IF EXISTS (SELECT id_cliente FROM #consulta_4 EXCEPT SELECT id_cliente FROM (VALUES (1), (2), (3)) AS esperado(id_cliente))
   OR EXISTS (SELECT id_cliente FROM (VALUES (1), (2), (3)) AS esperado(id_cliente) EXCEPT SELECT id_cliente FROM #consulta_4)
   OR (SELECT COUNT(*) FROM #consulta_4) <> 3
    THROW 52000, N''Resultado inesperado en la consulta 4.'', 1;
SET @verificadas += 1;

-- Consulta 5
;WITH A0 AS (SELECT DISTINCT id_equipo FROM tecsoporte_normalizado.orden_servicio),
     B0 AS (SELECT DISTINCT id_equipo FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''cerrada''),
     R AS (SELECT * FROM A0 INTERSECT SELECT * FROM B0)
SELECT * INTO #consulta_5 FROM R;
IF EXISTS (SELECT id_equipo FROM #consulta_5 EXCEPT SELECT id_equipo FROM (VALUES (8)) AS esperado(id_equipo))
   OR EXISTS (SELECT id_equipo FROM (VALUES (8)) AS esperado(id_equipo) EXCEPT SELECT id_equipo FROM #consulta_5)
   OR (SELECT COUNT(*) FROM #consulta_5) <> 1
    THROW 52000, N''Resultado inesperado en la consulta 5.'', 1;
SET @verificadas += 1;

-- Consulta 6
;WITH P AS (SELECT folio FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''recibida''),
     T AS (SELECT id_empleado FROM tecsoporte_normalizado.empleado WHERE rol = ''T''),
     R AS (SELECT * FROM P CROSS JOIN T)
SELECT * INTO #consulta_6 FROM R;
IF EXISTS (SELECT folio, id_empleado FROM #consulta_6 EXCEPT SELECT folio, id_empleado FROM (VALUES (18, 1), (18, 2)) AS esperado(folio, id_empleado))
   OR EXISTS (SELECT folio, id_empleado FROM (VALUES (18, 1), (18, 2)) AS esperado(folio, id_empleado) EXCEPT SELECT folio, id_empleado FROM #consulta_6)
   OR (SELECT COUNT(*) FROM #consulta_6) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 6.'', 1;
SET @verificadas += 1;

-- Consulta 7
;WITH P AS (SELECT folio,id_equipo FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''cerrada''),
     Q AS (SELECT P.*,E.propietario FROM P JOIN tecsoporte_normalizado.equipo E ON P.id_equipo=E.id_equipo),
     R AS (SELECT DISTINCT Q.folio,C.nombres FROM Q JOIN tecsoporte_normalizado.cliente C ON Q.propietario=C.id_cliente)
SELECT * INTO #consulta_7 FROM R;
IF EXISTS (SELECT folio, nombres FROM #consulta_7 EXCEPT SELECT folio, nombres FROM (VALUES (17, N''Ana''), (19, N''Ana'')) AS esperado(folio, nombres))
   OR EXISTS (SELECT folio, nombres FROM (VALUES (17, N''Ana''), (19, N''Ana'')) AS esperado(folio, nombres) EXCEPT SELECT folio, nombres FROM #consulta_7)
   OR (SELECT COUNT(*) FROM #consulta_7) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 7.'', 1;
SET @verificadas += 1;

-- Consulta 8
;WITH P AS (SELECT DISTINCT folio,id_servicio FROM tecsoporte_normalizado.detalle_servicio),
     S0 AS (SELECT id_servicio FROM tecsoporte_normalizado.servicio WHERE id_servicio IN (1,2)),
     R AS (SELECT DISTINCT p.folio FROM P p WHERE NOT EXISTS (SELECT 1 FROM S0 s WHERE NOT EXISTS (SELECT 1 FROM P q WHERE q.folio=p.folio AND q.id_servicio=s.id_servicio)))
SELECT * INTO #consulta_8 FROM R;
IF EXISTS (SELECT folio FROM #consulta_8 EXCEPT SELECT folio FROM (VALUES (17)) AS esperado(folio))
   OR EXISTS (SELECT folio FROM (VALUES (17)) AS esperado(folio) EXCEPT SELECT folio FROM #consulta_8)
   OR (SELECT COUNT(*) FROM #consulta_8) <> 1
    THROW 52000, N''Resultado inesperado en la consulta 8.'', 1;
SET @verificadas += 1;

-- Consulta 9
;WITH I AS (SELECT folio,no_linea,cantidad*precio_aplicado AS subtotal FROM tecsoporte_normalizado.detalle_servicio),
     P AS (SELECT folio FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''cerrada''),
     J AS (SELECT I.* FROM I JOIN P ON I.folio=P.folio),
     R AS (SELECT folio,SUM(subtotal) AS total FROM J GROUP BY folio)
SELECT * INTO #consulta_9 FROM R;
IF EXISTS (SELECT folio, total FROM #consulta_9 EXCEPT SELECT folio, total FROM (VALUES (17, 500), (19, 175)) AS esperado(folio, total))
   OR EXISTS (SELECT folio, total FROM (VALUES (17, 500), (19, 175)) AS esperado(folio, total) EXCEPT SELECT folio, total FROM #consulta_9)
   OR (SELECT COUNT(*) FROM #consulta_9) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 9.'', 1;
SET @verificadas += 1;

-- Consulta 10
;WITH I AS (SELECT folio,no_linea FROM tecsoporte_normalizado.detalle_servicio),
     J AS (SELECT O.folio,I.no_linea FROM tecsoporte_normalizado.orden_servicio O LEFT JOIN I ON O.folio=I.folio),
     R AS (SELECT folio,COUNT(no_linea) AS lineas FROM J GROUP BY folio)
SELECT * INTO #consulta_10 FROM R;
IF EXISTS (SELECT folio, lineas FROM #consulta_10 EXCEPT SELECT folio, lineas FROM (VALUES (17, 2), (18, 0), (19, 1)) AS esperado(folio, lineas))
   OR EXISTS (SELECT folio, lineas FROM (VALUES (17, 2), (18, 0), (19, 1)) AS esperado(folio, lineas) EXCEPT SELECT folio, lineas FROM #consulta_10)
   OR (SELECT COUNT(*) FROM #consulta_10) <> 3
    THROW 52000, N''Resultado inesperado en la consulta 10.'', 1;
SET @verificadas += 1;

-- Consulta 11
;WITH P AS (SELECT folio FROM tecsoporte_normalizado.orden_servicio WHERE estado = ''cerrada''),
     T AS (SELECT id_empleado,nombre FROM tecsoporte_normalizado.empleado WHERE rol = ''T''),
     J AS (SELECT DISTINCT A.folio,A.tecnico FROM P JOIN tecsoporte_normalizado.asignacion A ON P.folio=A.folio),
     R AS (SELECT DISTINCT J.folio,J.tecnico,T.nombre FROM J JOIN T ON J.tecnico=T.id_empleado)
SELECT * INTO #consulta_11 FROM R;
IF EXISTS (SELECT folio, tecnico, nombre FROM #consulta_11 EXCEPT SELECT folio, tecnico, nombre FROM (VALUES (17, 1, N''Sara''), (19, 2, N''Iván'')) AS esperado(folio, tecnico, nombre))
   OR EXISTS (SELECT folio, tecnico, nombre FROM (VALUES (17, 1, N''Sara''), (19, 2, N''Iván'')) AS esperado(folio, tecnico, nombre) EXCEPT SELECT folio, tecnico, nombre FROM #consulta_11)
   OR (SELECT COUNT(*) FROM #consulta_11) <> 2
    THROW 52000, N''Resultado inesperado en la consulta 11.'', 1;
SET @verificadas += 1;
SELECT DB_NAME() AS base_de_practica, @verificadas AS consultas_verificadas;
SELECT folio, nombres AS solicitante FROM #consulta_7 ORDER BY folio;
SELECT folio, CAST(total AS decimal(12,2)) AS total FROM #consulta_9 ORDER BY folio;
SELECT folio, tecnico, nombre FROM #consulta_11 ORDER BY folio, tecnico;';
GO
