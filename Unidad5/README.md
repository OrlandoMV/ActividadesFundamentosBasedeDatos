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

---

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad5/
├── README.md
├── Tarea5.1/
│   ├── README.md
│   ├── Tarea5.1.pdf
│   └── mapa_algebra_relacional.png
└── Tarea5.2/
    ├── README.md
    ├── Tarea5.2.pdf
    ├── flujo_consulta.png
    ├── consultas.sql
    ├── practica_sql_server.sql
    ├── verificar_sql_server.sql
    └── evidencia_ssms.png
```

Consulta las [instrucciones](./ACT.md).

---

## 📑 Resumen de Actividades

| Actividad | Tema Principal | Recursos Gráficos Clave | Documento Técnico | Documentación Detallada |
| :--- | :--- | :--- | :--- | :--- |
| **[Tarea 5.1](./Tarea5.1/README.md)** | Operadores fundamentales y extendidos | [Mapa conceptual (PNG)](./Tarea5.1/mapa_algebra_relacional.png) | 📄 [Tarea5.1.pdf](./Tarea5.1/Tarea5.1.pdf) | 📖 [README Tarea 5.1](./Tarea5.1/README.md) |
| **[Tarea 5.2](./Tarea5.2/README.md)** | Once consultas sobre el esquema normalizado | [Flujo de consulta (PNG)](./Tarea5.2/flujo_consulta.png)<br>[Evidencia de SSMS (PNG)](./Tarea5.2/evidencia_ssms.png) | 📄 [Tarea5.2.pdf](./Tarea5.2/Tarea5.2.pdf) | 📖 [README Tarea 5.2](./Tarea5.2/README.md) |

---

## 1. 📘 Tarea 5.1: Operadores fundamentales y extendidos

- **Ubicación** · [Tarea 5.1](./Tarea5.1/README.md)
- **Objetivo de la actividad.** Explicar la notación de los operadores del álgebra relacional y mostrar cómo transforma cada uno una relación.

### Contenidos Clave Abordados

1. **Operadores fundamentales.** Selección de filas, proyección de atributos y operaciones de conjuntos.
2. **Reuniones.** Combinación de datos de dos relaciones mediante atributos o condiciones de coincidencia.
3. **Álgebra extendida.** Proyección generalizada, agregación y reuniones externas.

### Recursos Gráficos Destacados

- **Mapa conceptual del álgebra relacional** · [PNG](./Tarea5.1/mapa_algebra_relacional.png)

---

## 2. 📗 Tarea 5.2: Consultas con álgebra relacional

- **Ubicación** · [Tarea 5.2](./Tarea5.2/README.md)
- **Objetivo de la actividad.** Resolver y comprobar consultas sobre el esquema normalizado de TecSoporte Monclova.

### Contenidos Clave Abordados

1. **Formulación de consultas.** El catálogo presenta once requisitos en lenguaje natural y sus expresiones algebraicas.
2. **Evaluación de resultados.** Las tablas intermedias y finales muestran cómo se obtiene cada resultado.
3. **Verificación en SQL Server.** La evidencia registra las **11 consultas verificadas** e incluye resultados sobre solicitantes, importes y técnicos de órdenes cerradas.

### Recursos Gráficos Destacados

- **Flujo de la consulta 9** · [PNG](./Tarea5.2/flujo_consulta.png)
- **Resultados en SSMS** · [PNG](./Tarea5.2/evidencia_ssms.png)

### Reproducción de la Práctica

- **SQLite.** Desde la raíz del repositorio, ejecuta `python Unidad5/Tarea5.2/validar.py`. El archivo [consultas.sql](./Tarea5.2/consultas.sql) contiene los datos ficticios y las consultas equivalentes.
- **SQL Server.** En la base de práctica `TecSoporte_Unidad5_Practica`, carga el esquema y los datos con [practica_sql_server.sql](./Tarea5.2/practica_sql_server.sql) si la base está vacía. Ejecuta [verificar_sql_server.sql](./Tarea5.2/verificar_sql_server.sql) para comprobar las once consultas.

La [versión editable del reporte](./Tarea5.2/Tarea5.2.docx) está disponible en Word.

---

## 🔄 Articulación Conceptual entre Tarea 5.1 y Tarea 5.2

La Tarea 5.1 define los operadores y muestra su notación. La Tarea 5.2 los aplica a los requisitos del taller.

| Operador estudiado en la Tarea 5.1 | Aplicación en la Tarea 5.2 |
| :--- | :--- |
| Diferencia | Identificar equipos sin órdenes de servicio. |
| Reunión | Vincular las órdenes con sus detalles de servicio. |
| Proyección generalizada y agregación | Calcular los importes de los servicios y obtener un total por orden. |

---

## 🛠️ Herramientas y Tecnologías Utilizadas

- **SQLite y Python.** Validación de las consultas mediante el script de práctica.
- **SQL Server y SSMS.** Ejecución de las consultas equivalentes y captura de los resultados.
- **Documentación académica.** Reportes PDF, documentación en Markdown y recursos gráficos en PNG.

---

## 📚 Referencias Bibliográficas (Formato APA 7ma Edición)

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2006). *Database System Concepts* (5.ª ed., cap. 2). McGraw-Hill. https://db-book.com/Previous-editions/db5/slide-dir/ch2.pdf
