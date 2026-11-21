# Tarea 6.2: Implementación de DDL, carga de datos y consultas DML

- **Institución:** TecNM Campus Monclova (ITSM)
- **Alumno:** Orlando Martínez Villarreal (I24050386)
- **Docente:** Rubén Miguel Riojas
- **Materia:** Fundamentos de Bases de Datos
- **Semestre:** 5
- **Unidad:** 6 — Introducción al lenguaje SQL

[Volver al índice de la Unidad 6](../README.md)

## 📦 Entregables de la Actividad

- 📑 **Reporte técnico** · [Tarea6.2.pdf](./Tarea6.2.pdf)
- [Capturas de la práctica](#6-evidencias-de-ejecución)
- **Scripts** · [01_schema_ddl.sql](./01_schema_ddl.sql), [02_data_inserts.sql](./02_data_inserts.sql) y [03_queries_dml.sql](./03_queries_dml.sql)
- 🎥 **Video explicativo** · [Guion y pendientes](./TODO.md)

---

## 1. Objetivo y alcance

Implementar el esquema normalizado de TecSoporte Monclova en SQL Server y demostrar cómo las restricciones protegen sus datos durante las operaciones de consulta y mantenimiento. Se utiliza la base de práctica `TecSoporte_Unidad6_Practica` con datos ficticios.

## 2. Estructura e integridad

| Tabla | Clave primaria | Claves foráneas o regla de negocio |
| --- | --- | --- |
| cliente | id_cliente | Identificador positivo y nombre obligatorio. |
| cliente_telefono | id_cliente, telefono | Cliente válido e identificación única de cada teléfono por cliente. |
| equipo | id_equipo | propietario referencia a cliente y queda fijo después de registrar el equipo. |
| orden_servicio | folio | id_equipo referencia a equipo. El cierre requiere fecha, detalle y asignación. |
| servicio | id_servicio | Nombre obligatorio y precio base no negativo. |
| detalle_servicio | folio, no_linea | Referencias a orden y servicio. La cantidad es positiva y el precio aplicado se registra por línea. |
| empleado | id_empleado | Rol de técnico o coordinador, con sus campos correspondientes. |
| asignacion | folio, tecnico | Referencias a orden y empleados. Se validan roles y fechas. |

## 3. Clonar y ejecutar en SSMS

1. En GitHub, copia la URL de clonación desde **Code**. Ejecuta `git clone URL_DEL_REPOSITORIO`, sustituyendo el marcador por la URL copiada.
2. Abre en SSMS la carpeta `Unidad6/Tarea6.2` de la copia local. Usa una instancia que permita crear la base de práctica.
3. Ejecuta **01_schema_ddl.sql**. Crea la base, ocho tablas, vistas y desencadenadores. La cuadrícula confirma el nombre de la base y el número de tablas.
4. Ejecuta **02_data_inserts.sql** una sola vez en el esquema vacío. Carga 23 registros en ocho tablas y devuelve los conteos.
5. Ejecuta **03_queries_dml.sql**. Devuelve cinco consultas y tres comprobaciones de mantenimiento. Estas pruebas ejecutan ROLLBACK para conservar la carga inicial.

## 4. Consultas y resultados esperados

| Consulta | Operación demostrada | Resultado con la carga inicial |
| --- | --- | --- |
| C1 · Órdenes cerradas | WHERE, ORDER BY | Folios 17 y 19, ambos del equipo 8. |
| C2 · Importe por orden | INNER JOIN, SUM, GROUP BY | Folio 17 = 500.00, folio 19 = 175.00. |
| C3 · Órdenes por equipo | LEFT JOIN, COUNT | Equipo 8 = 2, equipo 9 = 1, equipo 10 = 0. |
| C4 · Indicadores del catálogo | COUNT, SUM, AVG, MIN, MAX | 3 servicios, suma 675.00, promedio 225.00, mínimo 175.00 y máximo 300.00. |
| C5 · Equipos con dos o más órdenes | GROUP BY, HAVING | Equipo 8 con 2 órdenes. |

## 5. Pruebas de mantenimiento

| Prueba | Acción | Resultado esperado |
| --- | --- | --- |
| M1 · UPDATE | Cambiar el precio base del servicio 1 de 175.00 a 185.00 dentro de una transacción. | El precio aplicado en la orden 17 sigue en 150.00. ROLLBACK restaura el precio base a 175.00. |
| M2 · DELETE restringido | Intentar borrar el servicio 1, que tiene líneas asociadas. | La FK con NO ACTION devuelve el error 547. El servicio permanece. |
| M3 · DELETE permitido | Borrar el servicio 3, que carece de referencias. | Se elimina una fila dentro de la transacción y ROLLBACK la recupera. |

## 6. Evidencias de ejecución

### Resultados en SSMS

**Figura 1. Creación de la base, carga y consulta C1.** SSMS muestra las 8 tablas, los 23 registros de prueba y las órdenes cerradas de los folios 17 y 19.

![Creación de la base, carga y consulta C1](./01_resultados_esquema_carga_c1.png)

**Figura 2. Resultados de las consultas C2 a C5.** Se observan los importes por orden, el conteo por equipo, los indicadores del catálogo y el equipo que cumple el filtro de HAVING.

![Resultados de las consultas C2 a C5](./02_resultados_consultas_c2_a_c5.png)

**Figura 3. Resultados de las pruebas M1 a M3.** Las cuadrículas muestran el precio restaurado, el error 547 por la clave foránea y la fila recuperada con ROLLBACK.

![Resultados de las pruebas M1 a M3](./03_resultados_mantenimiento_m1_a_m3.png)

### Código T-SQL

**Figura 4. Código de la consulta C1.** WHERE selecciona las órdenes cerradas y ORDER BY las ordena por folio.

![Código de la consulta C1](./04_codigo_consulta_c1.png)

**Figura 5. Código de las consultas C2 a C5.** Las consultas combinan INNER JOIN, LEFT JOIN, funciones de agregación, GROUP BY y HAVING.

![Código de las consultas C2 a C5](./05_codigo_consultas_c2_a_c5.png)

**Figura 6. Código de la actualización M1.** UPDATE cambia el precio base dentro de una transacción. ROLLBACK recupera el precio inicial.

![Código de la actualización M1](./06_codigo_actualizacion_m1.png)

**Figura 7. Código de las pruebas de borrado M2 y M3.** El primer bloque comprueba el rechazo por clave foránea. El segundo borra un servicio sin referencias y revierte el cambio.

![Código de las pruebas de borrado M2 y M3](./07_codigo_borrado_m2_y_m3.png)

## 7. Conclusión

Las claves foráneas garantizan que las órdenes y sus detalles conserven relaciones válidas. La consulta con LEFT JOIN muestra equipos sin actividad, mientras que HAVING restringe los grupos según su conteo. El registro separado del precio aplicado mantiene los importes históricos cuando cambia la tarifa del catálogo.

## 8. Referencias bibliográficas

- Microsoft. (s. f.). *Aggregate functions (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/functions/aggregate-functions-transact-sql>
- Microsoft. (s. f.). *CREATE DATABASE (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql>
- Microsoft. (s. f.). *CREATE TABLE (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql>
- Microsoft. (s. f.). *DELETE (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/queries/delete-transact-sql>
- Microsoft. (s. f.). *FROM clause plus JOIN, APPLY, PIVOT (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql>
- Microsoft. (s. f.). *INSERT (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/queries/insert-transact-sql>
- Microsoft. (s. f.). *ROLLBACK TRANSACTION (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/language-elements/rollback-transaction-transact-sql>
- Microsoft. (s. f.). *SELECT (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql>
- Microsoft. (s. f.). *UPDATE (Transact-SQL)*. Microsoft Learn. <https://learn.microsoft.com/en-us/sql/t-sql/queries/update-transact-sql>
