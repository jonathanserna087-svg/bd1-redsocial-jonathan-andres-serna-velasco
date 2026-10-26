# Red Social Estudiantil

## Nombre del proyecto

Red Social Estudiantil: diseño e implementación de la base de datos (Bases de Datos I).

## Integrante

- Jonathan Andrés Serna Velasco

## Descripción del caso

Esta plataforma está pensada para mejorar la comunicación y la interacción entre los estudiantes de la universidad.
Nos permite crear perfiles (área de estudio, intereses y habilidades), conectar y seguir a otros estudiantes,
publicar preguntas, recursos y novedades, crear y unirse a grupos de estudio o de interés, y programar eventos.
Este repositorio contiene el diseño y la implementación de la base de datos que soporta esta red social.

## Contenido del repositorio

- `Tarea3/`: entrega de la Tarea 3 (modelo físico en PostgreSQL):
  - `ddl_red_social.sql`: script DDL con las 24 tablas, llaves, restricciones e índices.
  - `pruebas_red_social.sql`: datos de ejemplo y pruebas de las restricciones.
  - `informe/`: informe técnico en PDF y diagrama del modelo físico.
  - `README.md`: instrucciones para ejecutar el script.

## Tarea 3 · Modelo físico

- **SGBD:** PostgreSQL 16, administrado con pgAdmin4.
- **Resultado:** esquema `red_social` con 24 tablas, 36 llaves foráneas con sus acciones `ON DELETE` / `ON UPDATE`, restricciones `CHECK` y 24 índices.
