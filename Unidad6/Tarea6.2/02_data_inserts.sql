-- 02 | Cargar los datos ficticios en una base de práctica recién creada.
USE [TecSoporte_Unidad6_Practica];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF DB_NAME() <> N'TecSoporte_Unidad6_Practica'
    THROW 56000, N'Destino incorrecto.', 1;
IF EXISTS (SELECT 1 FROM tecsoporte_normalizado.cliente)
    THROW 56001, N'La tabla de clientes ya contiene datos. Ejecuta la carga inicial una sola vez.', 1;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT tecsoporte_normalizado.cliente (id_cliente,nombres,apellidos) VALUES
    (1,N'Ana',N'Ejemplo'),(2,N'Luis',N'Ejemplo'),(3,N'Eva',N'Ejemplo');
    INSERT tecsoporte_normalizado.cliente_telefono (id_cliente,telefono) VALUES
    (1,N'0000000001'),(2,N'0000000002'),(3,N'0000000003');
    INSERT tecsoporte_normalizado.equipo (id_equipo,propietario,marca,modelo,tipo_equipo) VALUES
    (8,1,N'Demo',N'A1',N'Laptop'),(9,2,N'Demo',N'A2',N'Laptop'),(10,1,N'Demo',N'A3',N'Escritorio');
    INSERT tecsoporte_normalizado.orden_servicio (folio,id_equipo,fecha_ingreso,falla_reportada,estado) VALUES
    (17,8,'2026-11-18T09:00:00',N'Falla de inicio','recibida'),
    (18,9,'2026-11-18T09:30:00',N'Revisión pendiente','recibida'),
    (19,8,'2026-11-18T10:00:00',N'Diagnóstico','recibida');
    INSERT tecsoporte_normalizado.servicio VALUES (1,N'Diagnóstico',175),(2,N'Limpieza',200),(3,N'Respaldo',300);
    INSERT tecsoporte_normalizado.detalle_servicio VALUES (17,1,1,2,150),(17,2,2,1,200),(19,1,1,1,175);
    INSERT tecsoporte_normalizado.empleado VALUES
    (1,N'Sara','2026-01-01','T',N'Hardware',NULL),
    (2,N'Iván','2026-01-01','T',N'Software',NULL),
    (3,N'Elena','2026-01-01','C',NULL,N'Matutino');
    INSERT tecsoporte_normalizado.asignacion VALUES (17,1,3,'2026-11-18T11:00:00'),(19,2,3,'2026-11-18T11:00:00');
    UPDATE tecsoporte_normalizado.orden_servicio
    SET estado='cerrada', fecha_cierre='2026-11-18T12:00:00' WHERE folio IN (17,19);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

SELECT N'cliente' AS tabla, COUNT(*) AS filas FROM tecsoporte_normalizado.cliente
UNION ALL SELECT N'cliente_telefono', COUNT(*) FROM tecsoporte_normalizado.cliente_telefono
UNION ALL SELECT N'equipo', COUNT(*) FROM tecsoporte_normalizado.equipo
UNION ALL SELECT N'orden_servicio', COUNT(*) FROM tecsoporte_normalizado.orden_servicio
UNION ALL SELECT N'servicio', COUNT(*) FROM tecsoporte_normalizado.servicio
UNION ALL SELECT N'detalle_servicio', COUNT(*) FROM tecsoporte_normalizado.detalle_servicio
UNION ALL SELECT N'empleado', COUNT(*) FROM tecsoporte_normalizado.empleado
UNION ALL SELECT N'asignacion', COUNT(*) FROM tecsoporte_normalizado.asignacion;
GO
