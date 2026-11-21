# Unidad 5: Álgebra relacional

> **Tecnológico Nacional de México — Campus Monclova (ITSM)**  
> **Carrera:** Ingeniería en Sistemas Computacionales  
> **Materia:** Fundamentos de Bases de Datos  
> **Semestre:** 5° Semestre  
> **Docente:** Rubén Miguel Riojas  
> **Alumno:** Orlando Martínez Villarreal *(I24050386)*  
> **Competencia específica:** Aplica operadores de álgebra relacional básica y extendida para acceder a la información de una base de datos.

---

## 📌 Presentación de la Unidad

La unidad estudia los operadores del álgebra relacional y los aplica a consultas sobre clientes, equipos, órdenes de servicio y técnicos de TecSoporte Monclova. Las actividades parten del [esquema normalizado de la Unidad 4](../Unidad4/README.md).

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad5/
├── ACT.md                       # Instrucciones de las actividades
├── ActUnidad5.txt               # Consigna original
├── README.md                   # Índice general de la unidad
├── Tarea5.1/
│   ├── README.md               # Desarrollo y ejemplos de operadores
│   ├── TODO.md                 # Guion y pendientes de entrega
│   ├── Tarea5.1.pdf             # Documento académico
│   └── mapa_algebra_relacional.png
└── Tarea5.2/
    ├── README.md               # Catálogo y tablas de resultados
    ├── TODO.md                 # Guion y pendientes de entrega
    ├── Tarea5.2.pdf             # Reporte de consultas
    ├── Tarea5.2.docx            # Versión editable del reporte
    ├── flujo_consulta.png       # Diagrama de la consulta 9
    ├── consultas.sql           # Datos de práctica y consultas equivalentes
    ├── validar.py              # Validación de resultados en SQLite
    ├── practica_sql_server.sql # Esquema y datos de práctica para SQL Server
    ├── verificar_sql_server.sql # Verificación de las 11 consultas en SQL Server
    └── evidencia_ssms.png      # Captura de los resultados en SSMS
```

Consulta las [instrucciones](./ACT.md).

## 📑 Resumen de Actividades

| Actividad | Tema principal | Recurso gráfico | Reporte |
| --- | --- | --- | --- |
| [Tarea 5.1](./Tarea5.1/README.md) | Operadores fundamentales y extendidos | [Mapa conceptual PNG](./Tarea5.1/mapa_algebra_relacional.png) | [Tarea5.1.pdf](./Tarea5.1/Tarea5.1.pdf) |
| [Tarea 5.2](./Tarea5.2/README.md) | Once consultas resueltas sobre el esquema normalizado | [Flujo de consulta PNG](./Tarea5.2/flujo_consulta.png) · [Evidencia SSMS PNG](./Tarea5.2/evidencia_ssms.png) | [Tarea5.2.pdf](./Tarea5.2/Tarea5.2.pdf) · [Tarea5.2.docx](./Tarea5.2/Tarea5.2.docx) |

### Actividad 5.1 · Operadores fundamentales y extendidos

El mapa conceptual y el reporte explican la notación de los operadores y muestran cómo se transforma una relación con cada uno. Los ejemplos distinguen la selección de filas, la proyección de atributos, las operaciones de conjuntos y las reuniones. El apartado de álgebra extendida incluye la proyección generalizada, la agregación y las reuniones externas.

### Actividad 5.2 · Consultas con álgebra relacional

El catálogo presenta once consultas con su requisito en lenguaje natural, su expresión algebraica y sus tablas intermedias y finales. La evidencia de SSMS registra las **11 consultas verificadas** e incluye resultados de las consultas sobre solicitantes, importes y técnicos de órdenes cerradas.

## 🔄 Articulación entre las tareas

La Tarea 5.1 define los operadores y muestra su notación. La Tarea 5.2 los aplica a requisitos del taller, desde identificar equipos sin órdenes mediante diferencia hasta calcular importes con proyección generalizada, reunión y agregación.

## 🧪 Reproducción de la Actividad 5.2

- **SQLite.** Desde la raíz del repositorio, ejecuta `python Unidad5/Tarea5.2/validar.py`. El archivo [consultas.sql](./Tarea5.2/consultas.sql) contiene los datos ficticios y las consultas equivalentes.
- **SQL Server.** En la base de práctica `TecSoporte_Unidad5_Practica`, carga el esquema y los datos con [practica_sql_server.sql](./Tarea5.2/practica_sql_server.sql) si la base está vacía. Ejecuta [verificar_sql_server.sql](./Tarea5.2/verificar_sql_server.sql) para comprobar las once consultas.

## 📚 Referencias Bibliográficas

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2006). *Database System Concepts* (5.ª ed., cap. 2). McGraw-Hill. https://db-book.com/Previous-editions/db5/slide-dir/ch2.pdf
