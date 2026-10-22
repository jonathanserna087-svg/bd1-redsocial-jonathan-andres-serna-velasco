-- =====================================================================
-- RED SOCIAL ESTUDIANTIL PASCUALINA
-- Tarea 3 - Bases de Datos I - Implementacion del modelo fisico (DDL)
-- Autor : Jonathan Andres Serna Velasco
-- SGBD  : PostgreSQL 16 (administrado con pgAdmin4)
--
-- Convenciones de nomenclatura
--   * Tablas y campos en minusculas, singular, snake_case, sin tildes.
--   * Llaves primarias : pk_<tabla>
--   * Llaves unicas    : uq_<tabla>_<campo>
--   * Llaves foraneas  : fk_<hija>_<padre>[_rol]
--   * Restricciones CHECK : ck_<tabla>_<campo>
--   * Indices          : idx_<tabla>_<campo>
--
-- Orden del script
--   1. Esquema red_social (el script se puede ejecutar varias veces)
--   2. 24 sentencias CREATE TABLE (cada padre antes que sus hijas)
--   3. 24 indices sobre llaves foraneas
--   4. COMMENT ON TABLE para documentar cada tabla
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. ESQUEMA
-- ---------------------------------------------------------------------
DROP SCHEMA IF EXISTS red_social CASCADE;
CREATE SCHEMA red_social;
SET search_path TO red_social;


-- ---------------------------------------------------------------------
-- 2. TABLAS
-- ---------------------------------------------------------------------

-- ===== Grupo: Estructura academica (catalogos) =======================

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

-- ===== Grupo: Estructura academica (relaciones) ======================

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
    -- AJUSTE respecto a la Tarea 2: el periodo entra en la PK para conservar
    -- el historial (mismo docente, misma asignatura, distintos periodos).
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

-- ===== Grupo: Contenido social =======================================

CREATE TABLE publicacion (
    id_publicacion     BIGINT GENERATED ALWAYS AS IDENTITY,
    id_usuario_autor   INTEGER     NOT NULL,
    id_grupo           INTEGER,
    tipo_publicacion   VARCHAR(20) NOT NULL,
    contenido          TEXT        NOT NULL,
    fecha_publicacion  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
-- 3. INDICES SOBRE LLAVES FORANEAS
--    PostgreSQL no los crea automaticamente. Se omiten las FK que ya
--    encabezan una PK (simple o compuesta), porque la PK ya las indexa.
-- ---------------------------------------------------------------------
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


-- ---------------------------------------------------------------------
-- 4. DOCUMENTACION EN EL CATALOGO DEL SGBD
-- ---------------------------------------------------------------------
COMMENT ON TABLE programa_academico   IS 'Catalogo institucional de programas academicos (carreras).';
COMMENT ON TABLE asignatura           IS 'Catalogo institucional de asignaturas o materias.';
COMMENT ON TABLE usuario              IS 'Datos comunes a todo miembro de la comunidad (estudiante o docente).';
COMMENT ON TABLE estudiante           IS 'Subtipo de usuario con atributos exclusivos del estudiante (1:1).';
COMMENT ON TABLE docente              IS 'Subtipo de usuario con atributos exclusivos del docente (1:1).';
COMMENT ON TABLE habilidad            IS 'Catalogo de habilidades tecnicas, deportivas, blandas y artisticas.';
COMMENT ON TABLE interes              IS 'Catalogo de intereses o aficiones.';
COMMENT ON TABLE usuario_habilidad    IS 'Relacion N:M POSEE entre usuario y habilidad.';
COMMENT ON TABLE usuario_interes      IS 'Relacion N:M TIENE_INTERES entre usuario e interes.';
COMMENT ON TABLE sigue                IS 'Relacion reflexiva N:M de seguidores entre usuarios.';
COMMENT ON TABLE programa_asignatura  IS 'Relacion N:M OFRECE entre programa academico y asignatura.';
COMMENT ON TABLE docente_asignatura   IS 'Relacion N:M ORIENTA entre docente y asignatura, por periodo academico.';
COMMENT ON TABLE mentoria             IS 'Relacion reflexiva N:M entre estudiantes (mentor y aprendiz).';
COMMENT ON TABLE grupo                IS 'Grupo de estudio, equipo de hackaton o club de interes.';
COMMENT ON TABLE usuario_grupo        IS 'Relacion N:M PERTENECE entre usuario y grupo.';
COMMENT ON TABLE evento               IS 'Reunion de estudio, taller o actividad social programada.';
COMMENT ON TABLE usuario_evento       IS 'Relacion N:M ASISTE entre usuario y evento.';
COMMENT ON TABLE publicacion          IS 'Publicacion en el muro: pregunta, recurso, noticia o meme.';
COMMENT ON TABLE etiqueta             IS 'Catalogo de etiquetas tematicas para publicaciones.';
COMMENT ON TABLE publicacion_etiqueta IS 'Relacion N:M SE_ETIQUETA_CON entre publicacion y etiqueta.';
COMMENT ON TABLE adjunto              IS 'Archivo adjunto de una publicacion (entidad debil).';
COMMENT ON TABLE comentario           IS 'Comentario sobre una publicacion, con respuestas anidadas (entidad debil).';
COMMENT ON TABLE reaccion             IS 'Relacion N:M REACCIONA entre usuario y publicacion.';
COMMENT ON TABLE mensaje              IS 'Mensaje directo entre dos usuarios.';

-- FIN DEL SCRIPT
