# Tarea 6.1: Sintaxis y clasificación de sentencias SQL

- **Institución:** TecNM Campus Monclova (ITSM)
- **Alumno:** Orlando Martínez Villarreal (I24050386)
- **Docente:** Rubén Miguel Riojas
- **Materia:** Fundamentos de Bases de Datos
- **Semestre:** 5
- **Unidad:** 6 — Introducción al lenguaje SQL

[Volver al índice de la Unidad 6](../README.md)

## 📦 Entregables de la Actividad

- 📑 **Reporte técnico** · [Tarea6.1.pdf](./Tarea6.1.pdf)
- **Tabla comparativa** · [Clasificación y sintaxis](#2-tabla-comparativa)
- 🎥 **Video explicativo** · [Enlace Youtube](https://youtu.be/UpwNmR0XSs0)

---

## 1. Características de SQL

SQL permite definir estructuras, imponer reglas de integridad, modificar datos y consultar información relacional. Su componente de consulta es declarativo: se expresa qué filas y atributos se requieren y el motor decide cómo obtenerlos. T-SQL es el dialecto de SQL Server. Las formas siguientes están acotadas a tablas y consultas en ese motor.

El lenguaje de definición de datos (LDD o DDL) opera sobre objetos y sus estructuras. El lenguaje de manipulación de datos (LMD o DML) opera sobre las filas. La consigna incluye SELECT en LMD. En clasificaciones que distinguen el lenguaje de consulta, SELECT corresponde a LQD o DQL.

## 2. Tabla comparativa

| Familia | Comando | Alcance | Restricción u opción |
| --- | --- | --- | --- |
| LDD | CREATE | Crea un objeto y, en una tabla, define columnas y restricciones. | PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT, IDENTITY. |
| LDD | ALTER | Modifica una tabla existente o sus restricciones. | El cambio debe ser compatible con los datos y dependencias. |
| LDD | DROP | Quita la tabla y sus datos. | IF EXISTS evita el error si falta el objeto. Comprueba dependencias. |
| LDD | TRUNCATE | Vacía una tabla y conserva su definición. | Actúa sin WHERE y reinicia IDENTITY. Hay restricciones con claves foráneas. |
| LMD | INSERT | Agrega una o más filas. | VALUES, SELECT como origen y OUTPUT. |
| LMD | UPDATE | Cambia los valores de filas existentes. | WHERE delimita las filas. Puede combinarse con FROM y OUTPUT. |
| LMD | DELETE | Quita filas de una tabla. | WHERE delimita las filas. Aplica las reglas referenciales. |
| LMD | SELECT | Devuelve un conjunto de resultados. | DISTINCT, JOIN, GROUP BY, HAVING, ORDER BY y OFFSET/FETCH. |

## 3. Sintaxis de LDD

En los patrones, los nombres en minúsculas representan elementos que se sustituyen. Los corchetes indican partes opcionales y la barra indica alternativas. Son formas representativas de T-SQL.

### CREATE

```sql
CREATE TABLE esquema.tabla (
    columna tipo [NULL | NOT NULL] [, ...]
    [, CONSTRAINT nombre PRIMARY KEY (columna [, ...])]
    [, CONSTRAINT nombre FOREIGN KEY (columna)
       REFERENCES esquema.otra_tabla (columna)]
);
```

También se puede declarar UNIQUE para claves candidatas, CHECK para condiciones válidas y DEFAULT para valores por omisión. Una FK requiere que el valor referenciado exista en una clave primaria o única. En TecSoporte, la clave compuesta (folio, no_linea) identifica cada línea de servicio de forma inequívoca.

### ALTER

```sql
ALTER TABLE esquema.tabla ADD columna tipo [NULL | NOT NULL];
ALTER TABLE esquema.tabla ALTER COLUMN columna tipo [NULL | NOT NULL];
ALTER TABLE esquema.tabla DROP CONSTRAINT nombre;
```

ADD CONSTRAINT agrega reglas de integridad. Con WITH CHECK se verifican los datos existentes al agregar una restricción CHECK o FK. Una conversión de tipo, un cambio de nulabilidad o el retiro de una columna pueden fallar si los datos o las dependencias lo impiden.

### DROP

```sql
DROP TABLE [IF EXISTS] esquema.tabla [, ...];
```

DROP TABLE elimina la definición y los datos, junto con las restricciones e índices propios de la tabla. Una FK desde otra tabla puede impedir el borrado. IF EXISTS solo cubre el caso en que el objeto está ausente.

### TRUNCATE

```sql
TRUNCATE TABLE esquema.tabla
    [WITH (PARTITIONS (particion [, ...]))];
```

Desasigna páginas de datos y registra esas desasignaciones. Conserva la estructura y, al truncar toda la tabla, reinicia el contador IDENTITY si existe. SQL Server permite revertir el truncado con ROLLBACK dentro de una transacción. Entre otras limitaciones, una FK de otra tabla que apunte a la tabla impide el truncado. Las particiones requieren alineación de los índices.

## 4. Sintaxis de LMD

### INSERT

```sql
INSERT INTO esquema.tabla (columna [, ...])
    VALUES (valor [, ...]) [, ...];
INSERT INTO esquema.tabla (columna [, ...])
    SELECT expresion [, ...] FROM origen;
```

La lista explícita de columnas evita depender de su orden físico. Cada fila debe cumplir tipos, nulabilidad y restricciones. OUTPUT puede mostrar los datos insertados. Una identidad normalmente se genera de forma automática.

### UPDATE

```sql
UPDATE esquema.tabla
SET columna = expresion [, ...]
[WHERE condicion];
```

SET indica los nuevos valores. Sin WHERE se consideran todas las filas. FROM permite asignar valores desde otras relaciones, siempre que cada fila de destino se relacione con una fuente inequívoca. OUTPUT permite consultar los valores anteriores y posteriores mediante deleted e inserted.

### DELETE

```sql
DELETE FROM esquema.tabla [WHERE condicion];
```

Sin WHERE se quitan todas las filas alcanzables por la sentencia. Las acciones de la FK determinan si se rechaza el borrado o se aplica una acción referencial configurada, como CASCADE. OUTPUT deleted permite observar las filas afectadas. En la práctica se emplea ROLLBACK para poder repetir la prueba.

### SELECT

```sql
SELECT [DISTINCT] expresion [AS alias] [, ...]
FROM origen
[ { INNER JOIN | LEFT JOIN } otra_tabla ON condicion ]
[WHERE condicion]
[GROUP BY expresion [, ...]]
[HAVING condicion_de_grupo]
[ORDER BY expresion [ASC | DESC] [, ...]];
```

La reunión combina tablas y WHERE filtra filas antes de agrupar. HAVING filtra grupos después de la agregación. ORDER BY define el orden de la salida. OFFSET/FETCH, con ORDER BY, permite paginar. COUNT(columna) omite valores NULL, lo que sirve para obtener cero en una reunión externa sin coincidencia.

## 5. Aplicación al taller

La definición del esquema garantiza que una línea tenga un servicio válido. Las consultas calculan el total histórico con el precio aplicado y permiten contar órdenes por equipo. Las pruebas de mantenimiento muestran que la tarifa vigente puede cambiar sin modificar el precio histórico y que la referencia impide borrar un servicio utilizado.


## Referencias bibliográficas

- Microsoft. (s. f.). *CREATE TABLE (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql
- Microsoft. (s. f.). *ALTER TABLE (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-table-transact-sql
- Microsoft. (s. f.). *DROP TABLE (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/statements/drop-table-transact-sql
- Microsoft. (s. f.). *TRUNCATE TABLE (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/es-es/sql/t-sql/statements/truncate-table-transact-sql
- Microsoft. (s. f.). *SELECT (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql
- Microsoft. (s. f.). *OUTPUT clause (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/queries/output-clause-transact-sql
