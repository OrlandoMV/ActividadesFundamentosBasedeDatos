# Unidad 3: Modelo relacional

> **Tecnológico Nacional de México — Campus Monclova (ITSM)**  
> **Carrera:** Ingeniería en Sistemas Computacionales  
> **Materia:** Fundamentos de Bases de Datos  
> **Semestre:** 5° Semestre  
> **Docente:** Rubén Miguel Riojas  
> **Alumno:** Orlando Martínez Villarreal *(I24050386)*  
> **Competencia específica:** Conoce y aplica el modelo relacional para la generación de esquemas de base de datos.

---

## 📌 Presentación de la Unidad

El modelo E-R de TecSoporte Monclova se convierte en un esquema relacional de ocho tablas. La Tarea 3.1 justifica la transformación y la Tarea 3.2 implementa sus claves, dominios y reglas de integridad en SQL Server.

---

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad3/
├── ACT.md
├── ActUnidad3.txt
├── README.md
├── Tarea3.1/
│   ├── README.md
│   ├── TODO.md
│   ├── Tarea3.1.pdf
│   └── esquema_relacional.png
└── Tarea3.2/
    ├── README.md
    ├── TODO.md
    ├── Tarea3.2.pdf
    ├── esquema_fisico.png
    ├── schema.sql
    └── verificar.sql
```

Consulta las [instrucciones de la unidad](./ACT.md).

---

## 📑 Resumen de Actividades

| Actividad | Tema principal | Recurso gráfico | Documento técnico |
| :--- | :--- | :--- | :--- |
| [Tarea 3.1](./Tarea3.1/README.md) | Transformación de E-R a relaciones e integridad | [Esquema relacional PNG](./Tarea3.1/esquema_relacional.png) | [Tarea3.1.pdf](./Tarea3.1/Tarea3.1.pdf) |
| [Tarea 3.2](./Tarea3.2/README.md) | Esquema físico y validación del DDL | [Esquema físico PNG](./Tarea3.2/esquema_fisico.png) | [Tarea3.2.pdf](./Tarea3.2/Tarea3.2.pdf) |

## 📘 Tarea 3.1 · Transformación del modelo E-R

Presenta las claves primarias, foráneas y alternativas, la resolución de cardinalidades y las dependencias funcionales que justifican la separación de las tablas.

## 📗 Tarea 3.2 · Esquema físico en SQL Server

Define tipos, nulabilidad, restricciones, vistas y desencadenadores. El [DDL](./Tarea3.2/schema.sql) se acompaña de un [script de verificación](./Tarea3.2/verificar.sql) que consulta el catálogo y ejecuta pruebas con datos de ejemplo.

## 🔄 Articulación entre las tareas

La relación N:M entre orden y técnico pasa a `asignacion`. La entidad débil se convierte en `detalle_servicio` con una clave compuesta. En el esquema físico, las restricciones de ambas tablas protegen las reglas que se derivan de esas decisiones.

## 📚 Referencias Bibliográficas

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database system concepts* (7.ª ed.). McGraw-Hill.
- Microsoft. (s. f.). *CREATE TABLE (Transact-SQL)*. https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql
