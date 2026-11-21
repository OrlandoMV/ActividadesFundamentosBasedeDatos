-- 03 | Consultas analíticas y operaciones de mantenimiento reversibles.
USE [TecSoporte_Unidad6_Practica];
GO
SET NOCOUNT ON;
SET XACT_ABORT OFF;
IF DB_NAME() <> N'TecSoporte_Unidad6_Practica'
    THROW 56000, N'Destino incorrecto.', 1;
IF @@TRANCOUNT <> 0
    THROW 56002, N'Ejecuta este archivo desde una sesión sin transacciones abiertas.', 1;

-- C1 | Órdenes cerradas. WHERE filtra y ORDER BY organiza.
SELECT folio, id_equipo, estado
FROM tecsoporte_normalizado.orden_servicio
WHERE estado = 'cerrada'
ORDER BY folio;

-- C2 | Importes por orden. INNER JOIN exige una línea de servicio coincidente.
SELECT o.folio, CAST(SUM(d.cantidad*d.precio_aplicado) AS decimal(12,2)) AS total
FROM tecsoporte_normalizado.orden_servicio AS o
INNER JOIN tecsoporte_normalizado.detalle_servicio AS d ON d.folio=o.folio
GROUP BY o.folio
ORDER BY o.folio;

-- C3 | Órdenes por equipo. LEFT JOIN conserva equipos sin órdenes.
SELECT e.id_equipo, COUNT(o.folio) AS ordenes
FROM tecsoporte_normalizado.equipo AS e
LEFT JOIN tecsoporte_normalizado.orden_servicio AS o ON o.id_equipo=e.id_equipo
GROUP BY e.id_equipo
ORDER BY e.id_equipo;

-- C4 | Indicadores del catálogo. AVG opera sobre precio decimal.
SELECT COUNT(*) AS servicios, SUM(precio_base) AS suma,
       CAST(AVG(precio_base) AS decimal(12,2)) AS promedio,
       MIN(precio_base) AS minimo, MAX(precio_base) AS maximo
FROM tecsoporte_normalizado.servicio;

-- C5 | HAVING filtra grupos después de contar las órdenes.
SELECT id_equipo, COUNT(*) AS ordenes
FROM tecsoporte_normalizado.orden_servicio
GROUP BY id_equipo
HAVING COUNT(*) >= 2
ORDER BY ordenes DESC, id_equipo;

-- M1 | Actualización legítima del catálogo con rollback.
DECLARE @antes decimal(12,2), @durante decimal(12,2), @historico decimal(12,2);
BEGIN TRY
    BEGIN TRANSACTION;
    SELECT @antes=precio_base FROM tecsoporte_normalizado.servicio WHERE id_servicio=1;
    UPDATE tecsoporte_normalizado.servicio SET precio_base=185 WHERE id_servicio=1;
    SELECT @durante=precio_base FROM tecsoporte_normalizado.servicio WHERE id_servicio=1;
    SELECT @historico=precio_aplicado FROM tecsoporte_normalizado.detalle_servicio
    WHERE folio=17 AND no_linea=1;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT @antes AS precio_anterior,@durante AS precio_temporal,@historico AS aplicado_orden_17,
       precio_base AS precio_restaurado
FROM tecsoporte_normalizado.servicio WHERE id_servicio=1;

-- M2 | NO ACTION impide borrar un servicio referenciado.
DECLARE @error_fk int;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM tecsoporte_normalizado.servicio WHERE id_servicio=1;
    ROLLBACK TRANSACTION;
    THROW 56003,N'La prueba esperaba que la clave foránea rechazara el borrado.',1;
END TRY
BEGIN CATCH
    SET @error_fk=ERROR_NUMBER();
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    IF @error_fk <> 547 THROW;
END CATCH;
SELECT @error_fk AS error_fk, COUNT(*) AS servicio_1_conservado
FROM tecsoporte_normalizado.servicio WHERE id_servicio=1;

-- M3 | Se puede borrar un servicio sin referencias. Se revierte para repetir la prueba.
DECLARE @eliminadas int;
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM tecsoporte_normalizado.servicio WHERE id_servicio=3;
    SET @eliminadas=@@ROWCOUNT;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT @eliminadas AS filas_eliminadas, COUNT(*) AS filas_restauradas
FROM tecsoporte_normalizado.servicio WHERE id_servicio=3;
GO
