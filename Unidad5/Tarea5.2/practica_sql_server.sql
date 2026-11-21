-- Primero crear la base vacía en SSMS:
-- CREATE DATABASE [TecSoporte_Unidad5_Practica];
USE [TecSoporte_Unidad5_Practica];
GO
-- SQL Server 2017+. Instalar en una base de practicas. No migra datos.
SET XACT_ABORT ON;
BEGIN TRANSACTION;
GO
CREATE SCHEMA tecsoporte_normalizado;
GO
CREATE TABLE tecsoporte_normalizado.cliente (
    id_cliente int NOT NULL PRIMARY KEY CHECK (id_cliente > 0),
    nombres nvarchar(80) NOT NULL CHECK (LEN(TRIM(nombres)) > 0),
    apellidos nvarchar(100) NOT NULL CHECK (LEN(TRIM(apellidos)) > 0),
    correo nvarchar(254) NULL
);

CREATE TABLE tecsoporte_normalizado.cliente_telefono (
    id_cliente int NOT NULL,
    telefono nvarchar(30) NOT NULL CHECK (LEN(TRIM(telefono)) > 0),
    PRIMARY KEY (id_cliente, telefono),
    FOREIGN KEY (id_cliente) REFERENCES tecsoporte_normalizado.cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tecsoporte_normalizado.equipo (
    id_equipo int NOT NULL PRIMARY KEY CHECK (id_equipo > 0),
    propietario int NOT NULL,
    serie nvarchar(100) NULL,
    marca nvarchar(80) NOT NULL CHECK (LEN(TRIM(marca)) > 0),
    modelo nvarchar(80) NOT NULL CHECK (LEN(TRIM(modelo)) > 0),
    tipo_equipo nvarchar(50) NOT NULL CHECK (LEN(TRIM(tipo_equipo)) > 0),
    FOREIGN KEY (propietario) REFERENCES tecsoporte_normalizado.cliente(id_cliente)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE tecsoporte_normalizado.orden_servicio (
    folio int NOT NULL PRIMARY KEY CHECK (folio > 0),
    id_equipo int NOT NULL,
    fecha_ingreso datetime2(0) NOT NULL,
    falla_reportada nvarchar(500) NOT NULL CHECK (LEN(TRIM(falla_reportada)) > 0),
    estado varchar(12) COLLATE Latin1_General_100_BIN2 NOT NULL
        CHECK (estado IN ('recibida', 'enProceso', 'cerrada', 'cancelada')),
    fecha_cierre datetime2(0) NULL,
    CONSTRAINT fk_orden_equipo FOREIGN KEY (id_equipo)
        REFERENCES tecsoporte_normalizado.equipo(id_equipo)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT ck_orden_cierre CHECK (
        (estado = 'cerrada' AND fecha_cierre IS NOT NULL AND fecha_cierre >= fecha_ingreso)
        OR (estado <> 'cerrada' AND fecha_cierre IS NULL)
    )
);

CREATE TABLE tecsoporte_normalizado.servicio (
    id_servicio int NOT NULL PRIMARY KEY CHECK (id_servicio > 0),
    nombre nvarchar(100) NOT NULL CHECK (LEN(TRIM(nombre)) > 0),
    precio_base decimal(12,2) NOT NULL CHECK (precio_base >= 0)
);

CREATE TABLE tecsoporte_normalizado.detalle_servicio (
    folio int NOT NULL,
    no_linea int NOT NULL CHECK (no_linea > 0),
    id_servicio int NOT NULL,
    cantidad int NOT NULL CHECK (cantidad > 0),
    precio_aplicado decimal(12,2) NOT NULL CHECK (precio_aplicado >= 0),
    PRIMARY KEY (folio, no_linea),
    FOREIGN KEY (folio) REFERENCES tecsoporte_normalizado.orden_servicio(folio)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES tecsoporte_normalizado.servicio(id_servicio)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE tecsoporte_normalizado.empleado (
    id_empleado int NOT NULL PRIMARY KEY CHECK (id_empleado > 0),
    nombre nvarchar(160) NOT NULL CHECK (LEN(TRIM(nombre)) > 0),
    fecha_alta date NOT NULL,
    rol char(1) COLLATE Latin1_General_100_BIN2 NOT NULL,
    especialidad nvarchar(100) NULL,
    turno nvarchar(40) NULL,
    CONSTRAINT ck_empleado_rol CHECK (
        (rol = 'T' AND especialidad IS NOT NULL AND LEN(TRIM(especialidad)) > 0 AND turno IS NULL)
        OR (rol = 'C' AND turno IS NOT NULL AND LEN(TRIM(turno)) > 0 AND especialidad IS NULL)
    )
);

CREATE TABLE tecsoporte_normalizado.asignacion (
    folio int NOT NULL,
    tecnico int NOT NULL,
    coordinador int NOT NULL,
    fecha_asignacion datetime2(0) NOT NULL,
    PRIMARY KEY (folio, tecnico),
    FOREIGN KEY (folio) REFERENCES tecsoporte_normalizado.orden_servicio(folio)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (tecnico) REFERENCES tecsoporte_normalizado.empleado(id_empleado)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (coordinador) REFERENCES tecsoporte_normalizado.empleado(id_empleado)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO
-- Se deriva el solicitante del propietario inmutable del equipo.
CREATE VIEW tecsoporte_normalizado.v_orden_solicitante AS
SELECT o.folio, e.propietario AS solicitante
FROM tecsoporte_normalizado.orden_servicio AS o
JOIN tecsoporte_normalizado.equipo AS e ON e.id_equipo = o.id_equipo;
GO
CREATE VIEW tecsoporte_normalizado.v_detalle_importe AS
SELECT folio, no_linea, cantidad * precio_aplicado AS subtotal
FROM tecsoporte_normalizado.detalle_servicio;
GO
CREATE VIEW tecsoporte_normalizado.v_orden_importe AS
SELECT o.folio, COALESCE(SUM(d.subtotal), 0) AS total
FROM tecsoporte_normalizado.orden_servicio AS o
LEFT JOIN tecsoporte_normalizado.v_detalle_importe AS d ON d.folio = o.folio
GROUP BY o.folio;
GO
CREATE VIEW tecsoporte_normalizado.v_incidencia_integridad AS
SELECT o.folio, 'cierre_incompleto' AS incidencia
FROM tecsoporte_normalizado.orden_servicio AS o
WHERE o.estado = 'cerrada'
  AND (NOT EXISTS (SELECT 1 FROM tecsoporte_normalizado.detalle_servicio AS d WHERE d.folio = o.folio)
       OR NOT EXISTS (SELECT 1 FROM tecsoporte_normalizado.asignacion AS a WHERE a.folio = o.folio))
UNION ALL
SELECT a.folio, 'fecha_asignacion'
FROM tecsoporte_normalizado.asignacion AS a
JOIN tecsoporte_normalizado.orden_servicio AS o ON o.folio = a.folio
JOIN tecsoporte_normalizado.empleado AS e ON e.id_empleado = a.tecnico
WHERE a.fecha_asignacion < o.fecha_ingreso OR a.fecha_asignacion < e.fecha_alta
UNION ALL
SELECT a.folio, 'rol_incorrecto'
FROM tecsoporte_normalizado.asignacion AS a
JOIN tecsoporte_normalizado.empleado AS t ON t.id_empleado = a.tecnico
JOIN tecsoporte_normalizado.empleado AS c ON c.id_empleado = a.coordinador
WHERE t.rol <> 'T' OR c.rol <> 'C';
GO
CREATE TRIGGER tecsoporte_normalizado.tr_orden_integridad ON tecsoporte_normalizado.orden_servicio
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM deleted AS d WHERE d.estado = 'cerrada'
               AND NOT EXISTS (SELECT 1 FROM inserted AS i WHERE i.folio = d.folio AND i.estado = 'cerrada'))
        THROW 51001, 'Una orden cerrada debe conservar su folio y estado.', 1;
    IF EXISTS (SELECT 1 FROM tecsoporte_normalizado.v_incidencia_integridad AS v
               JOIN inserted AS i ON i.folio = v.folio)
        THROW 51002, 'Cierre incompleto o fecha de asignacion inconsistente.', 1;
END;
GO
CREATE TRIGGER tecsoporte_normalizado.tr_detalle_integridad ON tecsoporte_normalizado.detalle_servicio
AFTER UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM tecsoporte_normalizado.v_incidencia_integridad AS v
               JOIN deleted AS d ON d.folio = v.folio
               WHERE v.incidencia = 'cierre_incompleto')
        THROW 51003, 'Una orden cerrada debe conservar al menos un detalle.', 1;
END;
GO
CREATE TRIGGER tecsoporte_normalizado.tr_asignacion_integridad ON tecsoporte_normalizado.asignacion
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM tecsoporte_normalizado.v_incidencia_integridad AS v
               WHERE v.folio IN (SELECT folio FROM inserted UNION SELECT folio FROM deleted))
        THROW 51004, 'Asignacion con rol o fecha incorrectos, o cierre sin asignaciones.', 1;
END;
GO
CREATE TRIGGER tecsoporte_normalizado.tr_empleado_integridad ON tecsoporte_normalizado.empleado
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted AS i JOIN tecsoporte_normalizado.asignacion AS a ON a.tecnico = i.id_empleado
               WHERE a.fecha_asignacion < i.fecha_alta)
        THROW 51005, 'La fecha de alta supera una fecha de asignacion registrada.', 1;
    IF EXISTS (
        SELECT 1 FROM inserted AS i
        WHERE (i.rol <> 'T' AND EXISTS (
            SELECT 1 FROM tecsoporte_normalizado.asignacion AS a WHERE a.tecnico = i.id_empleado))
           OR (i.rol <> 'C' AND EXISTS (
            SELECT 1 FROM tecsoporte_normalizado.asignacion AS a WHERE a.coordinador = i.id_empleado))
    )
        THROW 51007, 'El cambio de rol invalida una asignacion registrada.', 1;
END;
GO
CREATE TRIGGER tecsoporte_normalizado.tr_equipo_propietario ON tecsoporte_normalizado.equipo
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(propietario)
        THROW 51006, 'El propietario registrado no se puede modificar.', 1;
END;
GO

INSERT tecsoporte_normalizado.cliente (id_cliente,nombres,apellidos) VALUES
(1,N'Ana',N'Ejemplo'),(2,N'Luis',N'Ejemplo'),(3,N'Eva',N'Ejemplo');
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
GO
SELECT DB_NAME() AS base_de_practica, COUNT(*) AS tablas
FROM sys.tables WHERE schema_id=SCHEMA_ID(N'tecsoporte_normalizado');
SELECT folio, estado FROM tecsoporte_normalizado.orden_servicio ORDER BY folio;
