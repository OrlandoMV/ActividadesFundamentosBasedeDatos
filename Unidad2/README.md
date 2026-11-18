# Unidad 2: Diseño de Bases de Datos con el Modelo E-R

> **Tecnológico Nacional de México — Campus Monclova (ITSM)**  
> **Carrera:** Ingeniería en Sistemas Computacionales  
> **Materia:** Fundamentos de Bases de Datos  
> **Semestre:** 5° Semestre  
> **Docente:** Rubén Miguel Riojas  
> **Alumno:** Orlando Martínez Villarreal *(Matrícula: I24050386)*  
> **Competencia específica:** Conoce y aplica el modelo E-R para el diseño conceptual de bases de datos con el fin de organizar la información y atender necesidades del entorno.


---

## 📌 Presentación de la Unidad

La **Unidad 2** aplica el modelo entidad–relación al diseño conceptual de **TecSoporte Monclova**, un caso académico de un taller de computadoras. El diseño registra clientes, equipos, órdenes, servicios y personal desde la recepción hasta el cierre de una orden. El mismo caso se transforma después en un modelo de clases UML para comprobar que se conservan la identidad, las multiplicidades y las reglas de negocio.

---

## 📂 Estructura del Repositorio de la Unidad

```plaintext
Unidad2/
├── README.md
├── Tarea2.1/
│   ├── README.md
│   ├── Tarea2.1.pdf
│   ├── modelo_er
│   ├── atributos_er
│   └── modelo_eer
│
└── Tarea2.2/
    ├── README.md
    ├── Tarea2.2.pdf
    ├── clases_dominio
    └── clases_personal
```

---

## 📑 Resumen de Actividades

| Actividad | Tema Principal | Recursos Gráficos Clave | Documento Técnico | Documentación Detallada |
| :--- | :--- | :--- | :--- | :--- |
| **[Tarea 2.1](./Tarea2.1/README.md)** | Modelado conceptual E-R y E-R extendido | [Modelo entidad–relación (PNG)](./Tarea2.1/modelo_er.png)<br>[Diccionario gráfico de atributos (PNG)](./Tarea2.1/atributos_er.png)<br>[Modelo E-R extendido (PNG)](./Tarea2.1/modelo_eer.png) | 📄 [Tarea2.1.pdf](./Tarea2.1/Tarea2.1.pdf) | 📖 [README Tarea 2.1](./Tarea2.1/README.md) |
| **[Tarea 2.2](./Tarea2.2/README.md)** | Transición del modelo E-R a UML | [Clases de dominio (PNG)](./Tarea2.2/clases_dominio.png)<br>[Clases de personal y asignaciones (PNG)](./Tarea2.2/clases_personal.png) | 📄 [Tarea2.2.pdf](./Tarea2.2/Tarea2.2.pdf) | 📖 [README Tarea 2.2](./Tarea2.2/README.md) |

---

## 1. 📘 Tarea 2.1: Modelado conceptual E-R y E-R extendido

- **Ubicación** · [Tarea 2.1](./Tarea2.1/README.md)
- **Objetivo de la actividad.** Modelar la recepción y reparación de computadoras mediante la notación Chen.

### Contenidos Clave Abordados

1. **Entidades y relaciones.** Cliente, Equipo, OrdenServicio y Servicio identifican a los participantes principales y sus cardinalidades.
2. **Identidad y atributos.** DetalleServicio se identifica por el folio y el número de línea. El modelo distingue atributos compuestos, multivalorados y derivados.
3. **Especialización y agregación.** Técnico y Coordinador especializan Empleado. La supervisión recae sobre la asignación de un técnico a una orden.

### Recursos Gráficos Destacados

- 🖼️ **Modelo entidad–relación** · [PNG](./Tarea2.1/modelo_er.png)
- 🖼️ **Diccionario gráfico de atributos** · [PNG](./Tarea2.1/atributos_er.png)
- 🖼️ **Modelo E-R extendido** · [PNG](./Tarea2.1/modelo_eer.png)

---

## 2. 📗 Tarea 2.2: Transición del modelo E-R a UML

- **Ubicación** · [Tarea 2.2](./Tarea2.2/README.md)
- **Objetivo de la actividad.** Transformar el modelo conceptual en un diagrama de clases UML que conserve sus reglas de negocio.

### Contenidos Clave Abordados

1. **Clases y propiedades.** Las entidades se convierten en clases y los atributos conservan sus tipos, identidad y restricciones.
2. **Asociaciones y multiplicidades.** La composición vincula OrdenServicio con DetalleServicio. Las multiplicidades preservan la participación de los extremos.
3. **Herencia y asignación.** Técnico y Coordinador heredan de Empleado. Asignacion reúne la orden, el técnico y el coordinador que la supervisa.

### Recursos Gráficos Destacados

- 🖼️ **Clases de dominio** · [PNG](./Tarea2.2/clases_dominio.png)
- 🖼️ **Clases de personal y asignaciones** · [PNG](./Tarea2.2/clases_personal.png)

---

## 🔄 Articulación Conceptual entre Tarea 2.1 y Tarea 2.2

| Modelo E-R de la Tarea 2.1 | Correspondencia en UML de la Tarea 2.2 |
| :--- | :--- |
| Entidad débil DetalleServicio | Clase DetalleServicio compuesta por OrdenServicio, con identidad local por número de línea |
| Especialización total y disjunta de Empleado | Clase abstracta Empleado con subclases Técnico y Coordinador |
| Relación ejecuta supervisada por Coordinador | Clase Asignacion asociada con OrdenServicio, Técnico y Coordinador |

---

## 🛠️ Herramientas y Tecnologías Utilizadas

- **Modelado.** Notación Chen, E-R extendido y diagramas de clases UML. Los archivos `.drawio` se pueden editar en diagrams.net.
- **Recursos gráficos.** SVG y PDF vectoriales, además de PNG de alta resolución.
- **Documentación académica.** Markdown y reportes PDF con portada institucional.
- **Generación.** [generar_entregables.py](./generar_entregables.py) utiliza ReportLab, svglib y PyMuPDF. Se ejecuta desde la raíz con `python Unidad2/generar_entregables.py` y vuelve a generar las fuentes draw.io, las imágenes y los reportes.

---

## 📚 Referencias Bibliográficas (Formato APA 7ma Edición)

- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database system concepts* (7.ª ed.). McGraw-Hill. [Material del capítulo 6](https://www.db-book.com/slides-dir/PDF-dir/ch6.pdf).
- Object Management Group. (2017). *OMG Unified Modeling Language, version 2.5.1*. https://www.omg.org/spec/UML/2.5.1/
- JGraph Ltd. (s. f.). *Save a diagram in various formats*. https://www.drawio.com/docs/manual/editor/save-file-formats/
