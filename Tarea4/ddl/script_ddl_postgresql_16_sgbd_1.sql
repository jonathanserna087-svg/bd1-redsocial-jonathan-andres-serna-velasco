-- =====================================================================
-- RED SOCIAL ESTUDIANTIL PASCUALINA - TAREA 4
-- SGBD 1 : PostgreSQL 16 (administrado con pgAdmin4)
-- Autor  : Jonathan Andrés Serna Velasco
--
-- Descripción:
--   Implementación física completa de las 24 tablas del modelo relacional
--   adaptadas a PostgreSQL 16. Incluye la incorporación de la columna
--   NoSQL (JSONB) en la tabla publicacion e indices GIN para soportar
--   telemetría de IoT y análisis de metadatos en escenarios de Big Data.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. ESQUEMA
-- ---------------------------------------------------------------------
DROP SCHEMA IF EXISTS red_social CASCADE;
CREATE SCHEMA red_social;
SET search_path TO red_social;

-- ---------------------------------------------------------------------
-- 2. TABLAS (24 TABLAS)
-- ---------------------------------------------------------------------

-- ===== Grupo: Estructura académica (catálogos) =======================

CREATE TABLE programa_academico (
    id_programa      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_programa  VARCHAR(100) NOT NULL,
    facultad         VARCHAR(100) NOT NULL,
    CONSTRAINT pk_programa_academico        PRIMARY KEY (id_programa),
    CONSTRAINT uq_programa_academico_nombre UNIQUE (nombre_programa)
);

CREATE TABLE asignatura (
    id_asignatura      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_asignatura  VARCHAR(100) NOT NULL,
    codigo_asignatura  VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_asignatura        PRIMARY KEY (id_asignatura),
    CONSTRAINT uq_asignatura_codigo UNIQUE (codigo_asignatura)
);

-- ===== Grupo: Identidad y perfil =====================================

CREATE TABLE usuario (
    id_usuario           INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_completo      VARCHAR(150) NOT NULL,
    nombre_usuario       VARCHAR(50)  NOT NULL,
    correo_institucional VARCHAR(100) NOT NULL,
    contrasena_hash      VARCHAR(255) NOT NULL,
    foto_perfil_url      VARCHAR(255),
    biografia            VARCHAR(500),
    fecha_registro       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario          PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_nombre   UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuario_correo   UNIQUE (correo_institucional),
    CONSTRAINT ck_usuario_correo   CHECK (correo_institucional LIKE '%_@_%._%')
);

CREATE TABLE estudiante (
    id_usuario              INTEGER     NOT NULL,
    codigo_estudiantil      VARCHAR(20) NOT NULL,
    id_programa_academico   INTEGER     NOT NULL,
    semestre_actual         SMALLINT    NOT NULL,
    CONSTRAINT pk_estudiante        PRIMARY KEY (id_usuario),
    CONSTRAINT uq_estudiante_codigo UNIQUE (codigo_estudiantil),
    CONSTRAINT ck_estudiante_semestre CHECK (semestre_actual BETWEEN 1 AND 14),
    CONSTRAINT fk_estudiante_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estudiante_programa_academico
        FOREIGN KEY (id_programa_academico) REFERENCES programa_academico (id_programa)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE docente (
    id_usuario         INTEGER      NOT NULL,
    codigo_docente     VARCHAR(20)  NOT NULL,
    titulo_academico   VARCHAR(100) NOT NULL,
    departamento       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_docente        PRIMARY KEY (id_usuario),
    CONSTRAINT uq_docente_codigo UNIQUE (codigo_docente),
    CONSTRAINT fk_docente_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE habilidad (
    id_habilidad      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_habilidad  VARCHAR(100) NOT NULL,
    categoria         VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_habilidad        PRIMARY KEY (id_habilidad),
    CONSTRAINT uq_habilidad_nombre UNIQUE (nombre_habilidad)
);

CREATE TABLE interes (
    id_interes      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_interes  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_interes        PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_nombre UNIQUE (nombre_interes)
);

CREATE TABLE usuario_habilidad (
    id_usuario         INTEGER     NOT NULL,
    id_habilidad       INTEGER     NOT NULL,
    nivel_competencia  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_usuario_habilidad PRIMARY KEY (id_usuario, id_habilidad),
    CONSTRAINT ck_usuario_habilidad_nivel
        CHECK (nivel_competencia IN ('basico', 'intermedio', 'avanzado')),
    CONSTRAINT fk_usuario_habilidad_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_habilidad_habilidad
        FOREIGN KEY (id_habilidad) REFERENCES habilidad (id_habilidad)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE usuario_interes (
    id_usuario  INTEGER NOT NULL,
    id_interes  INTEGER NOT NULL,
    CONSTRAINT pk_usuario_interes PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_usuario_interes_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_interes_interes
        FOREIGN KEY (id_interes) REFERENCES interes (id_interes)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sigue (
    id_usuario_seguidor      INTEGER   NOT NULL,
    id_usuario_seguido       INTEGER   NOT NULL,
    fecha_inicio_seguimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_sigue PRIMARY KEY (id_usuario_seguidor, id_usuario_seguido),
    CONSTRAINT ck_sigue_no_autoseguimiento
        CHECK (id_usuario_seguidor <> id_usuario_seguido),
    CONSTRAINT fk_sigue_usuario_seguidor
        FOREIGN KEY (id_usuario_seguidor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sigue_usuario_seguido
        FOREIGN KEY (id_usuario_seguido) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===== Grupo: Estructura académica (relaciones) ======================

CREATE TABLE programa_asignatura (
    id_programa        INTEGER  NOT NULL,
    id_asignatura      INTEGER  NOT NULL,
    semestre_sugerido  SMALLINT NOT NULL,
    CONSTRAINT pk_programa_asignatura PRIMARY KEY (id_programa, id_asignatura),
    CONSTRAINT ck_programa_asignatura_semestre
        CHECK (semestre_sugerido BETWEEN 1 AND 14),
    CONSTRAINT fk_programa_asignatura_programa_academico
        FOREIGN KEY (id_programa) REFERENCES programa_academico (id_programa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_programa_asignatura_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE docente_asignatura (
    id_docente          INTEGER     NOT NULL,
    id_asignatura       INTEGER     NOT NULL,
    periodo_academico   VARCHAR(20) NOT NULL,
    CONSTRAINT pk_docente_asignatura
        PRIMARY KEY (id_docente, id_asignatura, periodo_academico),
    CONSTRAINT ck_docente_asignatura_periodo
        CHECK (periodo_academico ~ '^[0-9]{4}-[12]$'),
    CONSTRAINT fk_docente_asignatura_docente
        FOREIGN KEY (id_docente) REFERENCES docente (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_docente_asignatura_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mentoria (
    id_usuario_mentor    INTEGER     NOT NULL,
    id_usuario_aprendiz  INTEGER     NOT NULL,
    id_asignatura        INTEGER,
    fecha_inicio         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado               VARCHAR(20) NOT NULL DEFAULT 'activa',
    CONSTRAINT pk_mentoria PRIMARY KEY (id_usuario_mentor, id_usuario_aprendiz),
    CONSTRAINT ck_mentoria_no_automentor
        CHECK (id_usuario_mentor <> id_usuario_aprendiz),
    CONSTRAINT ck_mentoria_estado
        CHECK (estado IN ('activa', 'finalizada')),
    CONSTRAINT fk_mentoria_estudiante_mentor
        FOREIGN KEY (id_usuario_mentor) REFERENCES estudiante (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentoria_estudiante_aprendiz
        FOREIGN KEY (id_usuario_aprendiz) REFERENCES estudiante (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentoria_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ===== Grupo: Grupos y eventos =======================================

CREATE TABLE grupo (
    id_grupo           INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_grupo       VARCHAR(100) NOT NULL,
    descripcion        VARCHAR(500),
    tipo_grupo         VARCHAR(30)  NOT NULL,
    id_usuario_creador INTEGER      NOT NULL,
    id_asignatura      INTEGER,
    fecha_creacion     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT ck_grupo_tipo
        CHECK (tipo_grupo IN ('materia', 'hackaton', 'club_interes')),
    CONSTRAINT fk_grupo_usuario_creador
        FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_grupo_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE usuario_grupo (
    id_usuario     INTEGER     NOT NULL,
    id_grupo       INTEGER     NOT NULL,
    rol_en_grupo   VARCHAR(20) NOT NULL DEFAULT 'miembro',
    fecha_ingreso  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario_grupo PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT ck_usuario_grupo_rol
        CHECK (rol_en_grupo IN ('miembro', 'administrador')),
    CONSTRAINT fk_usuario_grupo_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_grupo_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evento (
    id_evento               INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_evento           VARCHAR(100) NOT NULL,
    descripcion             VARCHAR(500),
    fecha_hora_inicio       TIMESTAMP    NOT NULL,
    fecha_hora_fin          TIMESTAMP    NOT NULL,
    modalidad               VARCHAR(20)  NOT NULL,
    ubicacion_o_enlace      VARCHAR(255) NOT NULL,
    id_usuario_organizador  INTEGER      NOT NULL,
    id_grupo                INTEGER,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT ck_evento_fechas
        CHECK (fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_evento_modalidad
        CHECK (modalidad IN ('presencial', 'virtual')),
    CONSTRAINT fk_evento_usuario_organizador
        FOREIGN KEY (id_usuario_organizador) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_evento_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE usuario_evento (
    id_usuario         INTEGER     NOT NULL,
    id_evento          INTEGER     NOT NULL,
    estado_asistencia  VARCHAR(20) NOT NULL DEFAULT 'interesado',
    CONSTRAINT pk_usuario_evento PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT ck_usuario_evento_estado
        CHECK (estado_asistencia IN ('interesado', 'confirmado', 'asistio')),
    CONSTRAINT fk_usuario_evento_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_evento_evento
        FOREIGN KEY (id_evento) REFERENCES evento (id_evento)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===== Grupo: Contenido social (Adaptación NoSQL / Big Data / IoT) ===

CREATE TABLE publicacion (
    id_publicacion     BIGINT GENERATED ALWAYS AS IDENTITY,
    id_usuario_autor   INTEGER     NOT NULL,
    id_grupo           INTEGER,
    tipo_publicacion   VARCHAR(20) NOT NULL,
    contenido          TEXT        NOT NULL,
    fecha_publicacion  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_nosql        JSONB, -- Campo NoSQL para telemetría IoT y Big Data
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT ck_publicacion_tipo
        CHECK (tipo_publicacion IN ('pregunta', 'recurso', 'noticia', 'meme')),
    CONSTRAINT fk_publicacion_usuario_autor
        FOREIGN KEY (id_usuario_autor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_publicacion_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE etiqueta (
    id_etiqueta      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_etiqueta  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_etiqueta        PRIMARY KEY (id_etiqueta),
    CONSTRAINT uq_etiqueta_nombre UNIQUE (nombre_etiqueta)
);

CREATE TABLE publicacion_etiqueta (
    id_publicacion  BIGINT  NOT NULL,
    id_etiqueta     INTEGER NOT NULL,
    CONSTRAINT pk_publicacion_etiqueta PRIMARY KEY (id_publicacion, id_etiqueta),
    CONSTRAINT fk_publicacion_etiqueta_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_publicacion_etiqueta_etiqueta
        FOREIGN KEY (id_etiqueta) REFERENCES etiqueta (id_etiqueta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE adjunto (
    id_adjunto      BIGINT GENERATED ALWAYS AS IDENTITY,
    id_publicacion  BIGINT       NOT NULL,
    url_archivo     VARCHAR(255) NOT NULL,
    tipo_archivo    VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_adjunto PRIMARY KEY (id_adjunto),
    CONSTRAINT ck_adjunto_tipo
        CHECK (tipo_archivo IN ('imagen', 'video', 'documento', 'enlace')),
    CONSTRAINT fk_adjunto_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE comentario (
    id_comentario        BIGINT GENERATED ALWAYS AS IDENTITY,
    id_publicacion       BIGINT       NOT NULL,
    id_usuario_autor     INTEGER      NOT NULL,
    id_comentario_padre  BIGINT,
    contenido            VARCHAR(500) NOT NULL,
    fecha_comentario     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comentario_usuario_autor
        FOREIGN KEY (id_usuario_autor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comentario_comentario_padre
        FOREIGN KEY (id_comentario_padre) REFERENCES comentario (id_comentario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reaccion (
    id_usuario       INTEGER     NOT NULL,
    id_publicacion   BIGINT      NOT NULL,
    tipo_reaccion    VARCHAR(20) NOT NULL,
    fecha_reaccion   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_usuario, id_publicacion),
    CONSTRAINT ck_reaccion_tipo
        CHECK (tipo_reaccion IN ('me_gusta', 'util', 'celebrar', 'divertido')),
    CONSTRAINT fk_reaccion_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reaccion_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mensaje (
    id_mensaje            BIGINT GENERATED ALWAYS AS IDENTITY,
    id_usuario_emisor     INTEGER       NOT NULL,
    id_usuario_receptor   INTEGER       NOT NULL,
    contenido             VARCHAR(1000) NOT NULL,
    fecha_envio           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    leido                 BOOLEAN       NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_mensaje PRIMARY KEY (id_mensaje),
    CONSTRAINT ck_mensaje_no_autoenvio
        CHECK (id_usuario_emisor <> id_usuario_receptor),
    CONSTRAINT fk_mensaje_usuario_emisor
        FOREIGN KEY (id_usuario_emisor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mensaje_usuario_receptor
        FOREIGN KEY (id_usuario_receptor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- 3. INDICES
-- ---------------------------------------------------------------------

-- Índices B-Tree sobre llaves foráneas
CREATE INDEX idx_estudiante_id_programa_academico      ON estudiante          (id_programa_academico);
CREATE INDEX idx_usuario_habilidad_id_habilidad        ON usuario_habilidad   (id_habilidad);
CREATE INDEX idx_usuario_interes_id_interes            ON usuario_interes     (id_interes);
CREATE INDEX idx_sigue_id_usuario_seguido              ON sigue               (id_usuario_seguido);
CREATE INDEX idx_programa_asignatura_id_asignatura     ON programa_asignatura (id_asignatura);
CREATE INDEX idx_docente_asignatura_id_asignatura      ON docente_asignatura  (id_asignatura);
CREATE INDEX idx_mentoria_id_usuario_aprendiz          ON mentoria            (id_usuario_aprendiz);
CREATE INDEX idx_mentoria_id_asignatura                ON mentoria            (id_asignatura);
CREATE INDEX idx_grupo_id_usuario_creador              ON grupo               (id_usuario_creador);
CREATE INDEX idx_grupo_id_asignatura                   ON grupo               (id_asignatura);
CREATE INDEX idx_usuario_grupo_id_grupo                ON usuario_grupo       (id_grupo);
CREATE INDEX idx_evento_id_usuario_organizador         ON evento              (id_usuario_organizador);
CREATE INDEX idx_evento_id_grupo                       ON evento              (id_grupo);
CREATE INDEX idx_usuario_evento_id_evento              ON usuario_evento      (id_evento);
CREATE INDEX idx_publicacion_id_usuario_autor          ON publicacion         (id_usuario_autor);
CREATE INDEX idx_publicacion_id_grupo                  ON publicacion         (id_grupo);
CREATE INDEX idx_publicacion_etiqueta_id_etiqueta      ON publicacion_etiqueta(id_etiqueta);
CREATE INDEX idx_adjunto_id_publicacion                ON adjunto             (id_publicacion);
CREATE INDEX idx_comentario_id_publicacion             ON comentario          (id_publicacion);
CREATE INDEX idx_comentario_id_usuario_autor           ON comentario          (id_usuario_autor);
CREATE INDEX idx_comentario_id_comentario_padre        ON comentario          (id_comentario_padre);
CREATE INDEX idx_reaccion_id_publicacion               ON reaccion            (id_publicacion);
CREATE INDEX idx_mensaje_id_usuario_emisor             ON mensaje             (id_usuario_emisor);
CREATE INDEX idx_mensaje_id_usuario_receptor           ON mensaje             (id_usuario_receptor);

-- Índice GIN para búsquedas aceleradas sobre atributos dentro del campo JSONB
CREATE INDEX idx_publicacion_datos_nosql ON publicacion USING gin (datos_nosql);

-- ---------------------------------------------------------------------
-- 4. DOCUMENTACION DEL CATALOGO
-- ---------------------------------------------------------------------
COMMENT ON TABLE publicacion IS 'Publicación con soporte NoSQL (JSONB) para telemetría IoT y métricas de Big Data.';
COMMENT ON COLUMN publicacion.datos_nosql IS 'Estructura JSONB semiestructurada: coordenadas IoT, sensores del campus y analítica de lectura.';