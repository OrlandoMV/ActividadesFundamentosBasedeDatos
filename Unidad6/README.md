# Unidad 6: Introducción al lenguaje SQL

> **Tecnológico Nacional de México — Campus Monclova (ITSM)**  
> **Carrera:** Ingeniería en Sistemas Computacionales  
> **Materia:** Fundamentos de Bases de Datos  
> **Semestre:** 5° Semestre  
> **Docente:** Rubén Miguel Riojas  
> **Alumno:** Orlando Martínez Villarreal *(I24050386)*  
> **Competencia específica:** Aplica los comandos básicos del lenguaje SQL para la definición y manipulación de bases de datos.

---

## 📌 Presentación de la Unidad

La unidad implementa en SQL Server el modelo de TecSoporte Monclova. Los comandos de definición crean el esquema y sus restricciones. Los de manipulación permiten cargar datos, consultar las órdenes y ensayar cambios controlados. La práctica continúa el [trabajo con álgebra relacional de la Unidad 5](../Unidad5/README.md).

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad6/
├── ACT.md
├── ActUnidad6.txt
├── README.md
├── Tarea6.1/
│   ├── README.md
│   ├── TODO.md
│   └── Tarea6.1.pdf
└── Tarea6.2/
    ├── README.md
    ├── TODO.md
    ├── Tarea6.2.pdf
    ├── 01_schema_ddl.sql
    ├── 02_data_inserts.sql
    ├── 03_queries_dml.sql
    ├── 01_resultados_esquema_carga_c1.png
    ├── 02_resultados_consultas_c2_a_c5.png
    ├── 03_resultados_mantenimiento_m1_a_m3.png
    ├── 04_codigo_consulta_c1.png
    ├── 05_codigo_consultas_c2_a_c5.png
    ├── 06_codigo_actualizacion_m1.png
    └── 07_codigo_borrado_m2_y_m3.png
```

Consulta las [instrucciones de la unidad](./ACT.md).

## 📑 Resumen de Actividades

| Actividad | Tema principal | Entregables |
| --- | --- | --- |
| [Tarea 6.1](./Tarea6.1/README.md) | Clasificación y sintaxis de ocho comandos LDD y LMD | [Tarea6.1.pdf](./Tarea6.1/Tarea6.1.pdf) |
| [Tarea 6.2](./Tarea6.2/README.md) | Implementación de esquema, datos, consultas y mantenimiento | [Tarea6.2.pdf](./Tarea6.2/Tarea6.2.pdf) · [Evidencias](#evidencias-de-la-tarea-62) · [DDL](./Tarea6.2/01_schema_ddl.sql) · [Carga](./Tarea6.2/02_data_inserts.sql) · [DML](./Tarea6.2/03_queries_dml.sql) |

### Actividad 6.1 · Sintaxis y clasificación

El reporte compara ocho comandos de T-SQL y documenta su sintaxis, parámetros y restricciones. La clasificación establece qué sentencias se utilizan para definir la estructura y cuáles se aplican a los datos.

| Familia | Sentencias estudiadas | Propósito |
| --- | --- | --- |
| LDD · Definición de datos | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | Crear y modificar objetos, eliminar tablas o vaciar su contenido. |
| LMD · Manipulación de datos | `INSERT`, `UPDATE`, `DELETE`, `SELECT` | Cargar, modificar, eliminar y consultar registros. |

### Actividad 6.2 · Práctica en SQL Server

La práctica crea `TecSoporte_Unidad6_Practica` con **8 tablas y 23 registros ficticios**. Las cinco consultas muestran órdenes cerradas, importes, conteos por equipo e indicadores del catálogo. Las tres pruebas de mantenimiento muestran cómo `ROLLBACK` revierte cambios y cómo una clave foránea impide borrar un servicio referenciado.

## 🧪 Reproducción de la Tarea 6.2

Conéctate a una instancia de SQL Server desde SQL Server Management Studio (SSMS) y ejecuta los scripts en este orden:

1. [01_schema_ddl.sql](./Tarea6.2/01_schema_ddl.sql) crea la base y su esquema.
2. [02_data_inserts.sql](./Tarea6.2/02_data_inserts.sql) carga los datos iniciales. Ejecútalo una sola vez en el esquema vacío.
3. [03_queries_dml.sql](./Tarea6.2/03_queries_dml.sql) ejecuta las cinco consultas y las tres pruebas de mantenimiento. Las pruebas revierten sus cambios al terminar.

## Evidencias de la Tarea 6.2

### Resultados en SSMS

**Figura 1. Creación de la base, carga y consulta C1.** SSMS muestra las 8 tablas, los 23 registros de prueba y las órdenes cerradas de los folios 17 y 19.

![Creación de la base, carga y consulta C1](Tarea6.2/01_resultados_esquema_carga_c1.png)

**Figura 2. Resultados de las consultas C2 a C5.** Se observan los importes por orden, el conteo por equipo, los indicadores del catálogo y el equipo que cumple el filtro de HAVING.

![Resultados de las consultas C2 a C5](Tarea6.2/02_resultados_consultas_c2_a_c5.png)

**Figura 3. Resultados de las pruebas M1 a M3.** Las cuadrículas muestran el precio restaurado, el error 547 por la clave foránea y la fila recuperada con ROLLBACK.

![Resultados de las pruebas M1 a M3](Tarea6.2/03_resultados_mantenimiento_m1_a_m3.png)

### Código T-SQL

**Figura 4. Código de la consulta C1.** WHERE selecciona las órdenes cerradas y ORDER BY las ordena por folio.

![Código de la consulta C1](Tarea6.2/04_codigo_consulta_c1.png)

**Figura 5. Código de las consultas C2 a C5.** Las consultas combinan INNER JOIN, LEFT JOIN, funciones de agregación, GROUP BY y HAVING.

![Código de las consultas C2 a C5](Tarea6.2/05_codigo_consultas_c2_a_c5.png)

**Figura 6. Código de la actualización M1.** UPDATE cambia el precio base dentro de una transacción. ROLLBACK recupera el precio inicial.

![Código de la actualización M1](Tarea6.2/06_codigo_actualizacion_m1.png)

**Figura 7. Código de las pruebas de borrado M2 y M3.** El primer bloque comprueba el rechazo por clave foránea. El segundo borra un servicio sin referencias y revierte el cambio.

![Código de las pruebas de borrado M2 y M3](Tarea6.2/07_codigo_borrado_m2_y_m3.png)

## 🔄 Articulación entre las tareas

La clasificación de la Tarea 6.1 se aplica al construir el esquema y probarlo. La consulta de totales traduce a SQL el cálculo que se formuló con reunión y agregación en la [Tarea 5.2](../Unidad5/Tarea5.2/README.md).

## 📚 Referencias Bibliográficas

- Microsoft. (s. f.). *Referencia de Transact-SQL*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/t-sql/language-reference
