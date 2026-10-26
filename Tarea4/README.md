# Tarea 4: Implementación Multi-SGBD, Extensión NoSQL, Big Data e IoT
**Curso:** Bases de Datos I  
**Estudiante:** Jonathan Andrés Serna Velasco  
**Institución:** Institución Universitaria Pascual Bravo  

---

## 📌 Descripción del Proyecto
Este módulo corresponde a la **Tarea 4**, en la cual se amplia la arquitectura de datos de la **Red Social Estudiantil Pascualina**. Se implementa y adapta el modelo físico para soportar tres Sistemas Gestores de Bases de Datos (SGBD) distintos, integrando el paradigma NoSQL (JSON / BSON) para el manejo de datos semiestructurados en escenarios de Big Data e Internet de las Cosas (IoT).

---

## 📁 Estructura del Repositorio

La solución técnica y la documentación requerida se encuentran organizadas en las siguientes subcarpetas:

* **`/diccionarios`**: Contiene la documentación técnica del diccionario de datos genérico actualizado y los diccionarios de datos físicos específicos para cada SGBD.
* **`/ddl`**: Contiene los scripts de código e instrucciones DDL para la creación física del esquema en los tres motores evaluados:
  * `script_ddl_postgresql_16_sgbd_1.sql` (PostgreSQL 16 con extensión JSONB e índices GIN)
  * `script_ddl_mysql_8_0_sgbd_2.sql` (MySQL 8.0 con tipo JSON y columnas generadas)
  * `script_ddl_schema_mongodb_7_0_sgbd_3.js` (MongoDB 7.0 con validación JSON Schema e índice geoespacial 2dsphere)
* **`/Informe`**: Contiene la memoria técnica detallada en formato PDF (`informe_tarea4.pdf`) con la justificación de la elección de los SGBD, casos de uso de Big Data/IoT, análisis comparativo, dificultades encontradas y conclusiones.

---

## ⚙️ Paradigmas y SGBD Utilizados
1. **PostgreSQL 16 (SGBD 1):** Modelo relacional estricto con soporte híbrido JSONB para alto rendimiento en analítica de publicaciones.
2. **MySQL 8.0 (SGBD 2):** Modelo RDBMS con columnas generadas persistentes sobre documentos JSON nativos.
3. **MongoDB 7.0 (SGBD 3):** Modelo NoSQL orientado a documentos BSON, optimizado para escalabilidad y lecturas de geolocalización de sensores IoT.

