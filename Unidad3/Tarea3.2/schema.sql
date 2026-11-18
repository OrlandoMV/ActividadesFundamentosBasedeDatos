-- Ejecutar una vez en una base de datos de practicas.
SET XACT_ABORT ON;
BEGIN TRANSACTION;
GO
CREATE SCHEMA tecsoporte;
GO
CREATE TABLE tecsoporte.cliente (
    id_cliente int NOT NULL PRIMARY KEY CHECK (id_cliente > 0),
    nombres nvarchar(80) NOT NULL CHECK (LEN(TRIM(nombres)) > 0),
    apellidos nvarchar(100) NOT NULL CHECK (LEN(TRIM(apellidos)) > 0),
    correo nvarchar(254) NULL
);

CREATE TABLE tecsoporte.cliente_telefono (
    id_cliente int NOT NULL,
    telefono nvarchar(30) NOT NULL CHECK (LEN(TRIM(telefono)) > 0),
    PRIMARY KEY (id_cliente, telefono),
    FOREIGN KEY (id_cliente) REFERENCES tecsoporte.cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tecsoporte.equipo (
    id_equipo int NOT NULL PRIMARY KEY CHECK (id_equipo > 0),
    propietario int NOT NULL,
    serie nvarchar(100) NULL,
    marca nvarchar(80) NOT NULL CHECK (LEN(TRIM(marca)) > 0),
    modelo nvarchar(80) NOT NULL CHECK (LEN(TRIM(modelo)) > 0),
    tipo_equipo nvarchar(50) NOT NULL CHECK (LEN(TRIM(tipo_equipo)) > 0),
    FOREIGN KEY (propietario) REFERENCES tecsoporte.cliente(id_cliente)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT uq_equipo_propietario UNIQUE (id_equipo, propietario)
);

CREATE TABLE tecsoporte.orden_servicio (
    folio int NOT NULL PRIMARY KEY CHECK (folio > 0),
    id_equipo int NOT NULL,
    solicitante int NOT NULL,
    fecha_ingreso datetime2(0) NOT NULL,
    falla_reportada nvarchar(500) NOT NULL CHECK (LEN(TRIM(falla_reportada)) > 0),
    estado varchar(12) COLLATE Latin1_General_100_BIN2 NOT NULL
        CHECK (estado IN ('recibida', 'enProceso', 'cerrada', 'cancelada')),
    fecha_cierre datetime2(0) NULL,
    CONSTRAINT fk_orden_equipo_propietario FOREIGN KEY (id_equipo, solicitante)
        REFERENCES tecsoporte.equipo(id_equipo, propietario)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT ck_orden_cierre CHECK (
        (estado = 'cerrada' AND fecha_cierre IS NOT NULL AND fecha_cierre >= fecha_ingreso)
        OR (estado <> 'cerrada' AND fecha_cierre IS NULL)
    )
);

CREATE TABLE tecsoporte.servicio (
    id_servicio int NOT NULL PRIMARY KEY CHECK (id_servicio > 0),
    nombre nvarchar(100) NOT NULL CHECK (LEN(TRIM(nombre)) > 0),
    precio_base decimal(12,2) NOT NULL CHECK (precio_base >= 0)
);

CREATE TABLE tecsoporte.detalle_servicio (
    folio int NOT NULL,
    no_linea int NOT NULL CHECK (no_linea > 0),
    id_servicio int NOT NULL,
    cantidad int NOT NULL CHECK (cantidad > 0),
    precio_aplicado decimal(12,2) NOT NULL CHECK (precio_aplicado >= 0),
    PRIMARY KEY (folio, no_linea),
    FOREIGN KEY (folio) REFERENCES tecsoporte.orden_servicio(folio)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES tecsoporte.servicio(id_servicio)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE tecsoporte.empleado (
    id_empleado int NOT NULL PRIMARY KEY CHECK (id_empleado > 0),
    nombre nvarchar(160) NOT NULL CHECK (LEN(TRIM(nombre)) > 0),
    fecha_alta date NOT NULL,
    rol char(1) COLLATE Latin1_General_100_BIN2 NOT NULL,
    especialidad nvarchar(100) NULL,
    turno nvarchar(40) NULL,
    UNIQUE (id_empleado, rol),
    CONSTRAINT ck_empleado_rol CHECK (
        (rol = 'T' AND especialidad IS NOT NULL AND LEN(TRIM(especialidad)) > 0 AND turno IS NULL)
        OR (rol = 'C' AND turno IS NOT NULL AND LEN(TRIM(turno)) > 0 AND especialidad IS NULL)
    )
);

CREATE TABLE tecsoporte.asignacion (
    folio int NOT NULL,
    tecnico int NOT NULL,
    coordinador int NOT NULL,
    fecha_asignacion datetime2(0) NOT NULL,
    rol_tecnico char(1) COLLATE Latin1_General_100_BIN2 NOT NULL DEFAULT 'T' CHECK (rol_tecnico = 'T'),
    rol_coordinador char(1) COLLATE Latin1_General_100_BIN2 NOT NULL DEFAULT 'C' CHECK (rol_coordinador = 'C'),
    PRIMARY KEY (folio, tecnico),
    FOREIGN KEY (folio) REFERENCES tecsoporte.orden_servicio(folio)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (tecnico, rol_tecnico) REFERENCES tecsoporte.empleado(id_empleado, rol)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (coordinador, rol_coordinador) REFERENCES tecsoporte.empleado(id_empleado, rol)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO
CREATE VIEW tecsoporte.v_detalle_importe AS
SELECT folio, no_linea, cantidad * precio_aplicado AS subtotal
FROM tecsoporte.detalle_servicio;
GO
CREATE VIEW tecsoporte.v_orden_importe AS
SELECT o.folio, COALESCE(SUM(d.subtotal), 0) AS total
FROM tecsoporte.orden_servicio AS o
LEFT JOIN tecsoporte.v_detalle_importe AS d ON d.folio = o.folio
GROUP BY o.folio;
GO
CREATE VIEW tecsoporte.v_incidencia_integridad AS
SELECT o.folio, 'cierre_incompleto' AS incidencia
FROM tecsoporte.orden_servicio AS o
WHERE o.estado = 'cerrada'
  AND (NOT EXISTS (SELECT 1 FROM tecsoporte.detalle_servicio AS d WHERE d.folio = o.folio)
       OR NOT EXISTS (SELECT 1 FROM tecsoporte.asignacion AS a WHERE a.folio = o.folio))
UNION ALL
SELECT a.folio, 'fecha_asignacion'
FROM tecsoporte.asignacion AS a
JOIN tecsoporte.orden_servicio AS o ON o.folio = a.folio
JOIN tecsoporte.empleado AS e ON e.id_empleado = a.tecnico
WHERE a.fecha_asignacion < o.fecha_ingreso OR a.fecha_asignacion < e.fecha_alta;
GO
CREATE TRIGGER tecsoporte.tr_orden_integridad ON tecsoporte.orden_servicio
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM deleted AS d WHERE d.estado = 'cerrada'
               AND NOT EXISTS (SELECT 1 FROM inserted AS i WHERE i.folio = d.folio AND i.estado = 'cerrada'))
        THROW 51001, 'Una orden cerrada debe conservar su folio y estado.', 1;
    IF EXISTS (SELECT 1 FROM tecsoporte.v_incidencia_integridad AS v
               JOIN inserted AS i ON i.folio = v.folio)
        THROW 51002, 'Cierre incompleto o fecha de asignacion inconsistente.', 1;
END;
GO
CREATE TRIGGER tecsoporte.tr_detalle_integridad ON tecsoporte.detalle_servicio
AFTER UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM tecsoporte.v_incidencia_integridad AS v
               JOIN deleted AS d ON d.folio = v.folio
               WHERE v.incidencia = 'cierre_incompleto')
        THROW 51003, 'Una orden cerrada debe conservar al menos un detalle.', 1;
END;
GO
CREATE TRIGGER tecsoporte.tr_asignacion_integridad ON tecsoporte.asignacion
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM tecsoporte.v_incidencia_integridad AS v
               WHERE v.folio IN (SELECT folio FROM inserted UNION SELECT folio FROM deleted))
        THROW 51004, 'Asignacion fuera de fecha o cierre sin asignaciones.', 1;
END;
GO
CREATE TRIGGER tecsoporte.tr_empleado_fecha ON tecsoporte.empleado
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted AS i JOIN tecsoporte.asignacion AS a ON a.tecnico = i.id_empleado
               WHERE a.fecha_asignacion < i.fecha_alta)
        THROW 51005, 'La fecha de alta supera una fecha de asignacion registrada.', 1;
END;
GO
CREATE TRIGGER tecsoporte.tr_equipo_propietario ON tecsoporte.equipo
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(propietario)
        THROW 51006, 'El propietario registrado no se puede modificar.', 1;
END;
GO
COMMIT TRANSACTION;
GO
