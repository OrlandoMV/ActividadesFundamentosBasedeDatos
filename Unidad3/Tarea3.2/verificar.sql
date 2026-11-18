-- Run after schema.sql in the same database.
SET NOCOUNT ON;
SELECT t.name AS tabla FROM sys.tables AS t
WHERE t.schema_id = SCHEMA_ID('tecsoporte') ORDER BY t.name;

SELECT OBJECT_NAME(parent_object_id) AS hija, OBJECT_NAME(referenced_object_id) AS padre,
       name AS clave, update_referential_action_desc AS actualizacion,
       delete_referential_action_desc AS eliminacion
FROM sys.foreign_keys WHERE schema_id = SCHEMA_ID('tecsoporte') ORDER BY hija, padre;

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT tecsoporte.cliente (id_cliente, nombres, apellidos)
    VALUES (900001, N'Ana', N'Lopez'), (900002, N'Luis', N'Garcia');
    INSERT tecsoporte.cliente_telefono VALUES (900002, N'08660000000');
    UPDATE tecsoporte.cliente SET id_cliente=900003 WHERE id_cliente=900002;
    IF NOT EXISTS (SELECT 1 FROM tecsoporte.cliente_telefono WHERE id_cliente=900003)
        THROW 51101, 'No se propago la actualizacion del telefono.', 1;
    DELETE tecsoporte.cliente WHERE id_cliente=900003;
    IF EXISTS (SELECT 1 FROM tecsoporte.cliente_telefono WHERE id_cliente=900003)
        THROW 51102, 'No se propago la eliminacion del telefono.', 1;

    INSERT tecsoporte.equipo (id_equipo, propietario, marca, modelo, tipo_equipo)
    VALUES (900001, 900001, N'Demo', N'A1', N'Laptop');
    INSERT tecsoporte.orden_servicio VALUES
        (900001, 900001, 900001, '2026-11-18T09:00:00', N'Falla de inicio', 'recibida', NULL);
    INSERT tecsoporte.servicio VALUES (900001, N'Diagnostico', 150.00);
    INSERT tecsoporte.detalle_servicio VALUES (900001, 1, 900001, 2, 150.00);
    INSERT tecsoporte.empleado VALUES
        (900001, N'Tecnico de prueba', '2026-01-01', 'T', N'Hardware', NULL),
        (900002, N'Coordinador de prueba', '2026-01-01', 'C', NULL, N'Matutino');
    INSERT tecsoporte.asignacion (folio, tecnico, coordinador, fecha_asignacion)
    VALUES (900001, 900001, 900002, '2026-11-18T10:00:00');
    UPDATE tecsoporte.servicio SET precio_base=175.00 WHERE id_servicio=900001;
    UPDATE tecsoporte.orden_servicio SET estado='cerrada', fecha_cierre='2026-11-18T11:00:00'
    WHERE folio=900001;
    IF NOT EXISTS (SELECT 1 FROM tecsoporte.v_orden_importe WHERE folio=900001 AND total=300.00)
        THROW 51103, 'El importe historico no coincide.', 1;
    SELECT folio, total FROM tecsoporte.v_orden_importe WHERE folio=900001;
    ROLLBACK TRANSACTION;
    PRINT 'OK: cierre valido, importe historico y cascadas.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT tecsoporte.cliente (id_cliente, nombres, apellidos)
    VALUES (900001, N'Ana', N'Lopez'), (900002, N'Luis', N'Garcia');
    INSERT tecsoporte.equipo (id_equipo, propietario, marca, modelo, tipo_equipo)
    VALUES (900001, 900001, N'Demo', N'A1', N'Laptop');
    INSERT tecsoporte.orden_servicio VALUES
        (900001, 900001, 900002, '2026-11-18T09:00:00', N'Falla de inicio', 'recibida', NULL);
    THROW 51104, 'Se acepto un solicitante distinto del propietario.', 1;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 547 THROW;
    PRINT 'OK: se rechazo el solicitante incorrecto.';
END CATCH;

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT tecsoporte.cliente (id_cliente, nombres, apellidos) VALUES (900001, N'Ana', N'Lopez');
    INSERT tecsoporte.equipo (id_equipo, propietario, marca, modelo, tipo_equipo)
    VALUES (900001, 900001, N'Demo', N'A1', N'Laptop');
    INSERT tecsoporte.orden_servicio VALUES
        (900001, 900001, 900001, '2026-11-18T09:00:00', N'Falla de inicio', 'cerrada', '2026-11-18T11:00:00');
    THROW 51105, 'Se acepto un cierre sin detalle ni asignacion.', 1;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 51002 THROW;
    PRINT 'OK: se rechazo el cierre incompleto.';
END CATCH;
