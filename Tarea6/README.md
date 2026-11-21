
# Tarea 6 - Red Social Estudiantil Pascualina

**Autor:** Jonathan Andrés Serna Velasco  
**Institución:** Institución Universitaria Pascual Bravo  
**Programa:** Ingeniería de Software  
**Asignatura:** Bases de Datos I  
**Ciudad:** Medellín  
**Año:** 2026

## 1. Descripción del proyecto

Este proyecto corresponde a la Tarea 6 de Bases de Datos I, cuyo objetivo es diseñar una arquitectura de base de datos híbrida para la Red Social Estudiantil Pascualina.

La solución integra información relacional y semiestructurada mediante PostgreSQL, utilizando JSONB, consultas SQL, sensores IoT y estrategias de optimización para manejar grandes volúmenes de información.

## 2. Objetivo general

Diseñar e implementar una arquitectura híbrida de base de datos que permita almacenar, relacionar, consultar y analizar información estructurada y semiestructurada de una red social universitaria.

## 3. Tecnologías utilizadas

- PostgreSQL 16
- SQL (DDL y DML)
- JSON y JSONB
- Índices GIN
- Internet de las Cosas (IoT)
- Big Data
- Git y GitHub

## 4. Arquitectura de la base de datos

El proyecto conserva las 24 tablas originales desarrolladas en actividades anteriores y agrega 5 nuevas tablas para la integración de información IoT y datos semiestructurados.

La arquitectura contiene:

- 29 tablas lógicas.
- Relaciones mediante claves primarias y foráneas.
- Campos JSONB.
- Índices GIN para optimizar consultas.
- Particionamiento de registros de alto volumen.
- 11 consultas SQL analíticas.

## 5. Organización del repositorio

### Diccionarios

Contiene los inventarios de tablas, campos estructurados, campos semiestructurados y consultas SQL.

### Modelo_Arquitectura

Incluye los diagramas del sistema y los scripts SQL para la creación, ampliación, carga y consulta de la base de datos.

### informe

Contiene el informe técnico que explica el diseño, la implementación, las decisiones tomadas, las dificultades y las conclusiones.


## 6. Consultas SQL

Se diseñaron 11 consultas para analizar la información del sistema, utilizando:

- JOIN para relacionar tablas.
- COUNT para contar registros.
- SUM para calcular totales.
- AVG para obtener promedios.
- GROUP BY para agrupar resultados.
- Operadores JSONB para consultar datos semiestructurados.

## 7. Ejecución del proyecto

Para ejecutar el proyecto se necesita PostgreSQL 15 o superior y se recomienda utilizar pgAdmin 4.

Los scripts ubicados en `Modelo_Arquitectura/sql/` deben ejecutarse en el siguiente orden:

1. 01_ddl_base_24_tablas.sql
2. 02_ddl_extension_hibrida.sql
3. 03_dml_datos_simulados.sql
4. 04_indices_hibridos.sql
5. 05_consultas_analiticas.sql
6. 06_validaciones.sql
7. 07_explain.sql


## 8. Conclusiones

La arquitectura híbrida permite combinar las ventajas de las bases de datos relacionales con la flexibilidad de los datos semiestructurados.

El uso de PostgreSQL y JSONB facilita la gestión de información diversa, mientras que las consultas SQL y los índices especializados permiten analizar datos provenientes de publicaciones, usuarios, eventos y dispositivos IoT.

Este proyecto permite aplicar conocimientos de diseño de bases de datos, integridad referencial, optimización y procesamiento de información.

