-- =====================================================================
-- RED SOCIAL ESTUDIANTIL PASCUALINA - TAREA 4
-- SGBD 2 : MySQL 8.0 (administrado con MySQL Workbench)
-- Autor  : Jonathan Andrés Serna Velasco
--
-- Descripción:
--   Implementación física completa de las 24 tablas adaptadas al motor
--   InnoDB de MySQL 8.0. Incluye soporte para tipo de dato JSON nativo,
--   columnas generadas almacenadas e índices funcionales sobre campos
--   de IoT (coordenadas geográficas) y Big Data.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS red_social_pascualina
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE red_social_pascualina;

-- Deshabilitar la verificación de llaves foráneas para permitir un DROP limpio
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS mensaje;
DROP TABLE IF EXISTS reaccion;
DROP TABLE IF EXISTS comentario;
DROP TABLE IF EXISTS adjunto;
DROP TABLE IF EXISTS publicacion_etiqueta;
DROP TABLE IF EXISTS etiqueta;
DROP TABLE IF EXISTS publicacion;
DROP TABLE IF EXISTS usuario_evento;
DROP TABLE IF EXISTS evento;
DROP TABLE IF EXISTS usuario_grupo;
DROP TABLE IF EXISTS grupo;
DROP TABLE IF EXISTS mentoria;
DROP TABLE IF EXISTS docente_asignatura;
DROP TABLE IF EXISTS programa_asignatura;
DROP TABLE IF EXISTS sigue;
DROP TABLE IF EXISTS usuario_interes;
DROP TABLE IF EXISTS usuario_habilidad;
DROP TABLE IF EXISTS interes;
DROP TABLE IF EXISTS habilidad;
DROP TABLE IF EXISTS docente;
DROP TABLE IF EXISTS estudiante;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS asignatura;
DROP TABLE IF EXISTS programa_academico;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- TABLAS
-- ---------------------------------------------------------------------

-- ===== Grupo: Estructura académica (catálogos) =======================

CREATE TABLE programa_academico (
    id_programa      INT AUTO_INCREMENT,
    nombre_programa  VARCHAR(100) NOT NULL,
    facultad         VARCHAR(100) NOT NULL,
    CONSTRAINT pk_programa_academico PRIMARY KEY (id_programa),
    CONSTRAINT uq_programa_academico_nombre UNIQUE (nombre_programa)
) ENGINE=InnoDB;

CREATE TABLE asignatura (
    id_asignatura      INT AUTO_INCREMENT,
    nombre_asignatura  VARCHAR(100) NOT NULL,
    codigo_asignatura  VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_asignatura PRIMARY KEY (id_asignatura),
    CONSTRAINT uq_asignatura_codigo UNIQUE (codigo_asignatura)
) ENGINE=InnoDB;

-- ===== Grupo: Identidad y perfil =====================================

CREATE TABLE usuario (
    id_usuario           INT AUTO_INCREMENT,
    nombre_completo      VARCHAR(150) NOT NULL,
    nombre_usuario       VARCHAR(50)  NOT NULL,
    correo_institucional VARCHAR(100) NOT NULL,
    contrasena_hash      VARCHAR(255) NOT NULL,
    foto_perfil_url      VARCHAR(255),
    biografia            VARCHAR(500),
    fecha_registro       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_nombre UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuario_correo UNIQUE (correo_institucional)
) ENGINE=InnoDB;

CREATE TABLE estudiante (
    id_usuario              INT         NOT NULL,
    codigo_estudiantil      VARCHAR(20) NOT NULL,
    id_programa_academico   INT         NOT NULL,
    semestre_actual         TINYINT     NOT NULL,
    CONSTRAINT pk_estudiante PRIMARY KEY (id_usuario),
    CONSTRAINT uq_estudiante_codigo UNIQUE (codigo_estudiantil),
    CONSTRAINT ck_estudiante_semestre CHECK (semestre_actual BETWEEN 1 AND 14),
    CONSTRAINT fk_estudiante_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estudiante_programa_academico
        FOREIGN KEY (id_programa_academico) REFERENCES programa_academico (id_programa)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE docente (
    id_usuario         INT          NOT NULL,
    codigo_docente     VARCHAR(20)  NOT NULL,
    titulo_academico   VARCHAR(100) NOT NULL,
    departamento       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_docente PRIMARY KEY (id_usuario),
    CONSTRAINT uq_docente_codigo UNIQUE (codigo_docente),
    CONSTRAINT fk_docente_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE habilidad (
    id_habilidad      INT AUTO_INCREMENT,
    nombre_habilidad  VARCHAR(100) NOT NULL,
    categoria         VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_habilidad PRIMARY KEY (id_habilidad),
    CONSTRAINT uq_habilidad_nombre UNIQUE (nombre_habilidad)
) ENGINE=InnoDB;

CREATE TABLE interes (
    id_interes      INT AUTO_INCREMENT,
    nombre_interes  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_interes PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_nombre UNIQUE (nombre_interes)
) ENGINE=InnoDB;

CREATE TABLE usuario_habilidad (
    id_usuario         INT         NOT NULL,
    id_habilidad       INT         NOT NULL,
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
) ENGINE=InnoDB;

CREATE TABLE usuario_interes (
    id_usuario  INT NOT NULL,
    id_interes  INT NOT NULL,
    CONSTRAINT pk_usuario_interes PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_usuario_interes_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_interes_interes
        FOREIGN KEY (id_interes) REFERENCES interes (id_interes)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE sigue (
    id_usuario_seguidor      INT       NOT NULL,
    id_usuario_seguido       INT       NOT NULL,
    fecha_inicio_seguimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_sigue PRIMARY KEY (id_usuario_seguidor, id_usuario_seguido),
    CONSTRAINT ck_sigue_no_autoseguimiento CHECK (id_usuario_seguidor <> id_usuario_seguido),
    CONSTRAINT fk_sigue_usuario_seguidor
        FOREIGN KEY (id_usuario_seguidor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sigue_usuario_seguido
        FOREIGN KEY (id_usuario_seguido) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ===== Grupo: Estructura académica (relaciones) ======================

CREATE TABLE programa_asignatura (
    id_programa        INT     NOT NULL,
    id_asignatura      INT     NOT NULL,
    semestre_sugerido  TINYINT NOT NULL,
    CONSTRAINT pk_programa_asignatura PRIMARY KEY (id_programa, id_asignatura),
    CONSTRAINT ck_programa_asignatura_semestre CHECK (semestre_sugerido BETWEEN 1 AND 14),
    CONSTRAINT fk_programa_asignatura_programa
        FOREIGN KEY (id_programa) REFERENCES programa_academico (id_programa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_programa_asignatura_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE docente_asignatura (
    id_docente          INT         NOT NULL,
    id_asignatura       INT         NOT NULL,
    periodo_academico   VARCHAR(20) NOT NULL,
    CONSTRAINT pk_docente_asignatura PRIMARY KEY (id_docente, id_asignatura, periodo_academico),
    CONSTRAINT fk_docente_asignatura_docente
        FOREIGN KEY (id_docente) REFERENCES docente (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_docente_asignatura_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mentoria (
    id_usuario_mentor    INT         NOT NULL,
    id_usuario_aprendiz  INT         NOT NULL,
    id_asignatura        INT,
    fecha_inicio         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado               VARCHAR(20) NOT NULL DEFAULT 'activa',
    CONSTRAINT pk_mentoria PRIMARY KEY (id_usuario_mentor, id_usuario_aprendiz),
    CONSTRAINT ck_mentoria_no_automentor CHECK (id_usuario_mentor <> id_usuario_aprendiz),
    CONSTRAINT ck_mentoria_estado CHECK (estado IN ('activa', 'finalizada')),
    CONSTRAINT fk_mentoria_estudiante_mentor
        FOREIGN KEY (id_usuario_mentor) REFERENCES estudiante (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentoria_estudiante_aprendiz
        FOREIGN KEY (id_usuario_aprendiz) REFERENCES estudiante (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentoria_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ===== Grupo: Grupos y eventos =======================================

CREATE TABLE grupo (
    id_grupo           INT AUTO_INCREMENT,
    nombre_grupo       VARCHAR(100) NOT NULL,
    descripcion        VARCHAR(500),
    tipo_grupo         VARCHAR(30)  NOT NULL,
    id_usuario_creador INT          NOT NULL,
    id_asignatura      INT,
    fecha_creacion     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT ck_grupo_tipo CHECK (tipo_grupo IN ('materia', 'hackaton', 'club_interes')),
    CONSTRAINT fk_grupo_usuario_creador
        FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_grupo_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura (id_asignatura)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario_grupo (
    id_usuario     INT         NOT NULL,
    id_grupo       INT         NOT NULL,
    rol_en_grupo   VARCHAR(20) NOT NULL DEFAULT 'miembro',
    fecha_ingreso  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario_grupo PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT ck_usuario_grupo_rol CHECK (rol_en_grupo IN ('miembro', 'administrador')),
    CONSTRAINT fk_usuario_grupo_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_grupo_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE evento (
    id_evento               INT AUTO_INCREMENT,
    nombre_evento           VARCHAR(100) NOT NULL,
    descripcion             VARCHAR(500),
    fecha_hora_inicio       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_fin          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modalidad               VARCHAR(20)  NOT NULL,
    ubicacion_o_enlace      VARCHAR(255) NOT NULL,
    id_usuario_organizador  INT          NOT NULL,
    id_grupo                INT,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT ck_evento_modalidad CHECK (modalidad IN ('presencial', 'virtual')),
    CONSTRAINT fk_evento_usuario_organizador
        FOREIGN KEY (id_usuario_organizador) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_evento_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario_evento (
    id_usuario         INT         NOT NULL,
    id_evento          INT         NOT NULL,
    estado_asistencia  VARCHAR(20) NOT NULL DEFAULT 'interesado',
    CONSTRAINT pk_usuario_evento PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT ck_usuario_evento_estado CHECK (estado_asistencia IN ('interesado', 'confirmado', 'asistio')),
    CONSTRAINT fk_usuario_evento_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_evento_evento
        FOREIGN KEY (id_evento) REFERENCES evento (id_evento)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ===== Grupo: Contenido social (Adaptación NoSQL / JSON MySQL 8) =====

CREATE TABLE publicacion (
    id_publicacion     BIGINT AUTO_INCREMENT,
    id_usuario_autor   INT         NOT NULL,
    id_grupo           INT,
    tipo_publicacion   VARCHAR(20) NOT NULL,
    contenido          TEXT        NOT NULL,
    fecha_publicacion  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_nosql        JSON, -- Campo JSON nativo de MySQL
    
    -- Columna generada almacenada para extraer coordenadas IoT e indexarlas
    latitud_iot DOUBLE GENERATED ALWAYS AS (
        CAST(datos_nosql->'$.iot_telemetria.ubicacion_geo.lat' AS DOUBLE)
    ) STORED,

    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT ck_publicacion_tipo CHECK (tipo_publicacion IN ('pregunta', 'recurso', 'noticia', 'meme')),
    CONSTRAINT fk_publicacion_usuario_autor
        FOREIGN KEY (id_usuario_autor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_publicacion_grupo
        FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE etiqueta (
    id_etiqueta      INT AUTO_INCREMENT,
    nombre_etiqueta  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_etiqueta PRIMARY KEY (id_etiqueta),
    CONSTRAINT uq_etiqueta_nombre UNIQUE (nombre_etiqueta)
) ENGINE=InnoDB;

CREATE TABLE publicacion_etiqueta (
    id_publicacion  BIGINT NOT NULL,
    id_etiqueta     INT    NOT NULL,
    CONSTRAINT pk_publicacion_etiqueta PRIMARY KEY (id_publicacion, id_etiqueta),
    CONSTRAINT fk_publicacion_etiqueta_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_publicacion_etiqueta_etiqueta
        FOREIGN KEY (id_etiqueta) REFERENCES etiqueta (id_etiqueta)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE adjunto (
    id_adjunto      BIGINT AUTO_INCREMENT,
    id_publicacion  BIGINT       NOT NULL,
    url_archivo     VARCHAR(255) NOT NULL,
    tipo_archivo    VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_adjunto PRIMARY KEY (id_adjunto),
    CONSTRAINT ck_adjunto_tipo CHECK (tipo_archivo IN ('imagen', 'video', 'documento', 'enlace')),
    CONSTRAINT fk_adjunto_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE comentario (
    id_comentario        BIGINT AUTO_INCREMENT,
    id_publicacion       BIGINT       NOT NULL,
    id_usuario_autor     INT          NOT NULL,
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
) ENGINE=InnoDB;

CREATE TABLE reaccion (
    id_usuario       INT         NOT NULL,
    id_publicacion   BIGINT      NOT NULL,
    tipo_reaccion    VARCHAR(20) NOT NULL,
    fecha_reaccion   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_usuario, id_publicacion),
    CONSTRAINT ck_reaccion_tipo CHECK (tipo_reaccion IN ('me_gusta', 'util', 'celebrar', 'divertido')),
    CONSTRAINT fk_reaccion_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reaccion_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mensaje (
    id_mensaje            BIGINT AUTO_INCREMENT,
    id_usuario_emisor     INT           NOT NULL,
    id_usuario_receptor   INT           NOT NULL,
    contenido             VARCHAR(1000) NOT NULL,
    fecha_envio           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    leido                 TINYINT(1)    NOT NULL DEFAULT 0,
    CONSTRAINT pk_mensaje PRIMARY KEY (id_mensaje),
    CONSTRAINT ck_mensaje_no_autoenvio CHECK (id_usuario_emisor <> id_usuario_receptor),
    CONSTRAINT fk_mensaje_usuario_emisor
        FOREIGN KEY (id_usuario_emisor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mensaje_usuario_receptor
        FOREIGN KEY (id_usuario_receptor) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- INDICES
-- ---------------------------------------------------------------------

-- Índice funcional sobre la columna generada para acelerar la telemetría IoT
CREATE INDEX idx_publicacion_latitud ON publicacion (latitud_iot);