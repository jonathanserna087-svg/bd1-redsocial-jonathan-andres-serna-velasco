# Diccionario físico completo | Red Social Estudiantil Pascualina - Tarea 6

Fuente: esquema PostgreSQL 16 **entregado en Tarea 4** (24 tablas), complementado con cinco tablas nuevas y el campo `evento.detalles_jsonb`.

El campo `publicacion.datos_nosql` y su índice GIN **ya existían** en la Tarea 4; se conservan sin duplicarse.

Para descripciones detalladas consulte `diccionario_datos.csv`.

## programa_academico (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_programa` | `INTEGER` | PK |
| `nombre_programa` | `VARCHAR(100)` | NOT NULL |
| `facultad` | `VARCHAR(100)` | NOT NULL |

## asignatura (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_asignatura` | `INTEGER` | PK |
| `nombre_asignatura` | `VARCHAR(100)` | NOT NULL |
| `codigo_asignatura` | `VARCHAR(20)` | NOT NULL |

## usuario (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | PK |
| `nombre_completo` | `VARCHAR(150)` | NOT NULL |
| `nombre_usuario` | `VARCHAR(50)` | NOT NULL |
| `correo_institucional` | `VARCHAR(100)` | NOT NULL |
| `contrasena_hash` | `VARCHAR(255)` | NOT NULL |
| `foto_perfil_url` | `VARCHAR(255)` | Opcional / según DDL |
| `biografia` | `VARCHAR(500)` | Opcional / según DDL |
| `fecha_registro` | `TIMESTAMP` | NOT NULL |

## estudiante (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `codigo_estudiantil` | `VARCHAR(20)` | NOT NULL |
| `id_programa_academico` | `INTEGER` | NOT NULL, FK |
| `semestre_actual` | `SMALLINT` | NOT NULL |

## docente (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `codigo_docente` | `VARCHAR(20)` | NOT NULL |
| `titulo_academico` | `VARCHAR(100)` | NOT NULL |
| `departamento` | `VARCHAR(100)` | NOT NULL |

## habilidad (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_habilidad` | `INTEGER` | PK |
| `nombre_habilidad` | `VARCHAR(100)` | NOT NULL |
| `categoria` | `VARCHAR(50)` | NOT NULL |

## interes (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_interes` | `INTEGER` | PK |
| `nombre_interes` | `VARCHAR(100)` | NOT NULL |

## usuario_habilidad (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `id_habilidad` | `INTEGER` | NOT NULL, PK, FK |
| `nivel_competencia` | `VARCHAR(20)` | NOT NULL |

## usuario_interes (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `id_interes` | `INTEGER` | NOT NULL, PK, FK |

## sigue (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario_seguidor` | `INTEGER` | NOT NULL, PK, FK |
| `id_usuario_seguido` | `INTEGER` | NOT NULL, PK, FK |
| `fecha_inicio_seguimiento` | `TIMESTAMP` | NOT NULL |

## programa_asignatura (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_programa` | `INTEGER` | NOT NULL, PK, FK |
| `id_asignatura` | `INTEGER` | NOT NULL, PK, FK |
| `semestre_sugerido` | `SMALLINT` | NOT NULL |

## docente_asignatura (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_docente` | `INTEGER` | NOT NULL, PK, FK |
| `id_asignatura` | `INTEGER` | NOT NULL, PK, FK |
| `periodo_academico` | `VARCHAR(20)` | NOT NULL, PK |

## mentoria (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario_mentor` | `INTEGER` | NOT NULL, PK, FK |
| `id_usuario_aprendiz` | `INTEGER` | NOT NULL, PK, FK |
| `id_asignatura` | `INTEGER` | FK |
| `fecha_inicio` | `TIMESTAMP` | NOT NULL |
| `estado` | `VARCHAR(20)` | NOT NULL |

## grupo (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_grupo` | `INTEGER` | PK |
| `nombre_grupo` | `VARCHAR(100)` | NOT NULL |
| `descripcion` | `VARCHAR(500)` | Opcional / según DDL |
| `tipo_grupo` | `VARCHAR(30)` | NOT NULL |
| `id_usuario_creador` | `INTEGER` | NOT NULL, FK |
| `id_asignatura` | `INTEGER` | FK |
| `fecha_creacion` | `TIMESTAMP` | NOT NULL |

## usuario_grupo (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `id_grupo` | `INTEGER` | NOT NULL, PK, FK |
| `rol_en_grupo` | `VARCHAR(20)` | NOT NULL |
| `fecha_ingreso` | `TIMESTAMP` | NOT NULL |

## evento (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_evento` | `INTEGER` | PK |
| `nombre_evento` | `VARCHAR(100)` | NOT NULL |
| `descripcion` | `VARCHAR(500)` | Opcional / según DDL |
| `fecha_hora_inicio` | `TIMESTAMP` | NOT NULL |
| `fecha_hora_fin` | `TIMESTAMP` | NOT NULL |
| `modalidad` | `VARCHAR(20)` | NOT NULL |
| `ubicacion_o_enlace` | `VARCHAR(255)` | NOT NULL |
| `id_usuario_organizador` | `INTEGER` | NOT NULL, FK |
| `id_grupo` | `INTEGER` | FK |
| `detalles_jsonb` | `JSONB` | NOT NULL, semiestructurado |

## usuario_evento (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `id_evento` | `INTEGER` | NOT NULL, PK, FK |
| `estado_asistencia` | `VARCHAR(20)` | NOT NULL |

## publicacion (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_publicacion` | `BIGINT` | PK |
| `id_usuario_autor` | `INTEGER` | NOT NULL, FK |
| `id_grupo` | `INTEGER` | FK |
| `tipo_publicacion` | `VARCHAR(20)` | NOT NULL |
| `contenido` | `TEXT` | NOT NULL |
| `fecha_publicacion` | `TIMESTAMP` | NOT NULL |
| `datos_nosql` | `JSONB, -- Campo NoSQL para telemetría IoT y Big Data` | JSONB semiestructurado |

## etiqueta (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_etiqueta` | `INTEGER` | PK |
| `nombre_etiqueta` | `VARCHAR(50)` | NOT NULL |

## publicacion_etiqueta (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_publicacion` | `BIGINT` | NOT NULL, PK, FK |
| `id_etiqueta` | `INTEGER` | NOT NULL, PK, FK |

## adjunto (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_adjunto` | `BIGINT` | PK |
| `id_publicacion` | `BIGINT` | NOT NULL, FK |
| `url_archivo` | `VARCHAR(255)` | NOT NULL |
| `tipo_archivo` | `VARCHAR(20)` | NOT NULL |

## comentario (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_comentario` | `BIGINT` | PK |
| `id_publicacion` | `BIGINT` | NOT NULL, FK |
| `id_usuario_autor` | `INTEGER` | NOT NULL, FK |
| `id_comentario_padre` | `BIGINT` | FK |
| `contenido` | `VARCHAR(500)` | NOT NULL |
| `fecha_comentario` | `TIMESTAMP` | NOT NULL |

## reaccion (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | NOT NULL, PK, FK |
| `id_publicacion` | `BIGINT` | NOT NULL, PK, FK |
| `tipo_reaccion` | `VARCHAR(20)` | NOT NULL |
| `fecha_reaccion` | `TIMESTAMP` | NOT NULL |

## mensaje (Tarea 4)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_mensaje` | `BIGINT` | PK |
| `id_usuario_emisor` | `INTEGER` | NOT NULL, FK |
| `id_usuario_receptor` | `INTEGER` | NOT NULL, FK |
| `contenido` | `VARCHAR(1000)` | NOT NULL |
| `fecha_envio` | `TIMESTAMP` | NOT NULL |
| `leido` | `BOOLEAN` | NOT NULL |

## perfil_configuracion (Tarea 6)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_usuario` | `INTEGER` | PK, FK |
| `preferencias` | `JSONB` | NOT NULL, JSONB semiestructurado |
| `actualizado_en` | `TIMESTAMPTZ` | NOT NULL |

## espacio_campus (Tarea 6)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_espacio` | `INTEGER` | PK |
| `codigo` | `VARCHAR(30)` | NOT NULL, UNIQUE |
| `nombre` | `VARCHAR(120)` | NOT NULL |
| `tipo` | `VARCHAR(25)` | NOT NULL |
| `capacidad` | `INTEGER` | NOT NULL |
| `ubicacion` | `VARCHAR(150)` | NOT NULL |

## dispositivo_iot (Tarea 6)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_dispositivo` | `INTEGER` | PK |
| `id_espacio` | `INTEGER` | NOT NULL, FK |
| `codigo` | `VARCHAR(40)` | NOT NULL, UNIQUE |
| `tipo` | `VARCHAR(20)` | NOT NULL |
| `estado` | `VARCHAR(20)` | NOT NULL |
| `configuracion` | `JSONB` | NOT NULL, JSONB semiestructurado |

## lectura_iot (Tarea 6)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_lectura` | `BIGINT` | PK |
| `id_dispositivo` | `INTEGER` | NOT NULL, FK |
| `registrado_en` | `TIMESTAMPTZ` | NOT NULL, PK |
| `valor` | `NUMERIC(10,2)` | NOT NULL |
| `unidad` | `VARCHAR(15)` | NOT NULL |
| `payload` | `JSONB` | NOT NULL, JSONB semiestructurado |

## registro_actividad (Tarea 6)

| Campo | Tipo | Restricción |
|---|---|---|
| `id_registro` | `BIGINT` | PK |
| `id_usuario` | `INTEGER` | FK |
| `registrado_en` | `TIMESTAMPTZ` | NOT NULL, PK |
| `accion` | `VARCHAR(40)` | NOT NULL |
| `metadatos` | `JSONB` | NOT NULL, JSONB semiestructurado |

