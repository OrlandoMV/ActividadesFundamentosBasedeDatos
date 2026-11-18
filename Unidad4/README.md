# Unidad 4: Normalización de bases de datos

> **Tecnológico Nacional de México — Campus Monclova (ITSM)**  
> **Carrera:** Ingeniería en Sistemas Computacionales  
> **Materia:** Fundamentos de Bases de Datos  
> **Semestre:** 5° Semestre  
> **Docente:** Rubén Miguel Riojas  
> **Alumno:** Orlando Martínez Villarreal *(I24050386)*  
> **Competencia específica:** Aplica la normalización para detectar anomalías y garantizar la integridad de la información.

---

## 📌 Presentación de la Unidad

La unidad desarrolla las dependencias y formas normales y las aplica al esquema de TecSoporte Monclova de la [Unidad 3](../Unidad3/README.md). La transformación elimina la copia del solicitante y las columnas constantes de rol.

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad4/
├── ACT.md
├── ActUnidad4.txt
├── README.md
├── Tarea4.1/
│   ├── README.md
│   ├── TODO.md
│   ├── Tarea4.1.pdf
│   └── mapa_conceptual.png
└── Tarea4.2/
    ├── README.md
    ├── TODO.md
    ├── Tarea4.2.pdf
    ├── proceso_normalizacion.png
    └── normalized_schema.sql
```

Consulta las [instrucciones](./ACT.md).

## 📑 Resumen de Actividades

| Actividad | Tema principal | Recurso gráfico | Reporte |
| --- | --- | --- | --- |
| [Tarea 4.1](./Tarea4.1/README.md) | Dependencias, anomalías y formas normales | [Mapa conceptual PNG](./Tarea4.1/mapa_conceptual.png) | [Tarea4.1.pdf](./Tarea4.1/Tarea4.1.pdf) |
| [Tarea 4.2](./Tarea4.2/README.md) | Normalización paso a paso y DDL | [Proceso PNG](./Tarea4.2/proceso_normalizacion.png) | [Tarea4.2.pdf](./Tarea4.2/Tarea4.2.pdf) |

## 🔄 Articulación entre las tareas

La Tarea 4.1 define las reglas para detectar anomalías. La Tarea 4.2 aplica esas reglas al taller y genera [normalized_schema.sql](./Tarea4.2/normalized_schema.sql) para SQL Server.

## 📚 Referencias Bibliográficas

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database system concepts* (7.ª ed., cap. 7). McGraw-Hill. https://www.db-book.com/
