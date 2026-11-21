-- DATOS FICTICIOS y deterministas, NO informacion personal ni mediciones reales.
-- Ejecutar una sola vez tras 01 y 02.
BEGIN;
SET LOCAL search_path TO red_social, public;
SET LOCAL TIME ZONE 'America/Bogota';
INSERT INTO programa_academico(id_programa,nombre_programa,facultad)
OVERRIDING SYSTEM VALUE VALUES (1,'Ingenieria de Software','Facultad de Ingenieria');
INSERT INTO asignatura(id_asignatura,nombre_asignatura,codigo_asignatura)
OVERRIDING SYSTEM VALUE VALUES (1,'Bases de Datos I','BD-101');

INSERT INTO usuario(id_usuario,nombre_completo,nombre_usuario,correo_institucional,contrasena_hash,fecha_registro)
OVERRIDING SYSTEM VALUE VALUES
(1,'Ana Martinez','ana_demo','ana@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_01','2026-10-20 10:00:00'),
(2,'Carlos Perez','carlos_demo','carlos@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_02','2026-10-20 11:00:00'),
(3,'Laura Gomez','laura_demo','laura@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_03','2026-10-21 12:00:00'),
(4,'Sofia Rojas','sofia_demo','sofia@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_04','2026-10-21 13:00:00'),
(5,'Miguel Torres','miguel_demo','miguel@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_05','2026-10-21 14:00:00'),
(6,'Daniel Ruiz','daniel_demo','daniel@ejemplo.edu.co','HASH_FICTICIO_NO_USABLE_06','2026-10-21 15:00:00');
INSERT INTO estudiante(id_usuario,codigo_estudiantil,id_programa_academico,semestre_actual)
VALUES (1,'E-001',1,4),(2,'E-002',1,4),(4,'E-004',1,4),(6,'E-006',1,4);
INSERT INTO docente(id_usuario,codigo_docente,titulo_academico,departamento)
VALUES (3,'D-003','Ingeniera de Sistemas','Sistemas');

INSERT INTO grupo(id_grupo,nombre_grupo,descripcion,tipo_grupo,id_usuario_creador,id_asignatura)
OVERRIDING SYSTEM VALUE VALUES (1,'Semillero de datos','Grupo para proyectos de datos','materia',3,1);
INSERT INTO usuario_grupo(id_usuario,id_grupo,rol_en_grupo)
VALUES (1,1,'miembro'),(2,1,'miembro'),(3,1,'administrador');

INSERT INTO publicacion(id_publicacion,id_usuario_autor,id_grupo,tipo_publicacion,contenido,fecha_publicacion,datos_nosql)
OVERRIDING SYSTEM VALUE VALUES
(1,1,1,'recurso','Material de aprendizaje del semillero','2026-11-02 08:20:00',
 '{"idioma":"es","formato_destacado":"imagen","visibilidad":"grupo","nivel":"introductorio","iot_telemetria":{"sensor_id":"PASCUAL-BEACON-04","ubicacion_geo":{"lat":6.2731,"lng":-75.5828},"dispositivos_cercanos":38},"big_data_metadata":{"dispositivo_origen":"Android 14","vistas_unicas":1420,"tiempo_lectura_seg":32.5}}'::jsonb),
(2,3,1,'noticia','Taller de PostgreSQL en el campus','2026-11-03 10:10:00',
 '{"idioma":"es","formato_destacado":"documento","visibilidad":"publica","big_data_metadata":{"vistas_unicas":530}}'::jsonb),
(3,4,NULL,'recurso','Fotografias del encuentro estudiantil','2026-11-04 12:40:00',
 '{"idioma":"es","formato_destacado":"imagen","visibilidad":"publica","temas":["campus","tecnologia"]}'::jsonb),
(4,2,NULL,'pregunta','¿Como estudiar SQL?','2026-11-05 16:15:00',
 '{"idioma":"es","formato_destacado":"texto","visibilidad":"publica"}'::jsonb);

INSERT INTO adjunto(id_adjunto,id_publicacion,url_archivo,tipo_archivo)
OVERRIDING SYSTEM VALUE VALUES
(1,1,'https://example.org/demo/semillero.png','imagen'),
(2,2,'https://example.org/demo/guia.pdf','documento'),
(3,3,'https://example.org/demo/campus.jpg','imagen'),
(4,3,'https://example.org/demo/resumen.mp4','video');
INSERT INTO comentario(id_comentario,id_publicacion,id_usuario_autor,contenido,fecha_comentario)
OVERRIDING SYSTEM VALUE VALUES (1,1,2,'Gracias por compartir','2026-11-02 09:00:00'),
       (2,1,4,'Me interesa participar','2026-11-02 09:05:00'),
       (3,3,1,'Excelente evento','2026-11-04 13:00:00');
INSERT INTO reaccion(id_usuario,id_publicacion,tipo_reaccion)
VALUES (2,1,'me_gusta'),(4,1,'util'),(3,1,'celebrar'),
       (1,2,'me_gusta'),(2,3,'me_gusta'),(6,3,'me_gusta');

INSERT INTO evento(id_evento,nombre_evento,descripcion,fecha_hora_inicio,fecha_hora_fin,
  modalidad,ubicacion_o_enlace,id_usuario_organizador,id_grupo,detalles_jsonb)
OVERRIDING SYSTEM VALUE VALUES
(1,'Taller PostgreSQL','Aprender consultas JSONB','2026-11-12 09:00:00','2026-11-12 11:00:00',
 'presencial','Laboratorio A',3,1,'{"requiere_registro":true,"materiales":["portatil"]}'::jsonb),
(2,'Encuentro de Semilleros','Muestra de proyectos','2026-11-18 14:00:00','2026-11-18 16:00:00',
 'presencial','Auditorio Central',3,NULL,'{"requiere_registro":true,"materiales":[]}'::jsonb);
INSERT INTO usuario_evento(id_usuario,id_evento,estado_asistencia)
VALUES (1,1,'confirmado'),(2,1,'confirmado'),(4,1,'interesado'),
       (1,2,'confirmado'),(6,2,'asistio');

INSERT INTO perfil_configuracion(id_usuario,preferencias)
VALUES
(1,'{"tema":"oscuro","idioma":"es","notificaciones":{"eventos":true}}'::jsonb),
(2,'{"tema":"claro","idioma":"es","notificaciones":{"eventos":true}}'::jsonb),
(3,'{"tema":"oscuro","idioma":"es","notificaciones":{"eventos":false}}'::jsonb),
(4,'{"tema":"claro","idioma":"en","notificaciones":{"eventos":true}}'::jsonb),
(5,'{"tema":"claro","idioma":"es","notificaciones":{"eventos":false}}'::jsonb),
(6,'{"tema":"oscuro","idioma":"es","notificaciones":{"eventos":true}}'::jsonb);

INSERT INTO espacio_campus(id_espacio,codigo,nombre,tipo,capacidad,ubicacion)
VALUES (1,'LAB-01','Laboratorio de software','LABORATORIO',60,'Bloque A'),
       (2,'BIB-01','Biblioteca central','BIBLIOTECA',45,'Bloque B'),
       (3,'AUD-01','Auditorio principal','AUDITORIO',120,'Bloque C');
INSERT INTO dispositivo_iot(id_dispositivo,id_espacio,codigo,tipo,estado,configuracion)
VALUES
(1,1,'OCP-LAB01','OCUPACION','ACTIVO','{"protocolo":"MQTT","intervalo_segundos":900}'::jsonb),
(2,2,'OCP-BIB01','OCUPACION','ACTIVO','{"protocolo":"MQTT","intervalo_segundos":900}'::jsonb),
(3,3,'OCP-AUD01','OCUPACION','ACTIVO','{"protocolo":"MQTT","intervalo_segundos":900}'::jsonb),
(4,2,'TMP-BIB01','TEMPERATURA','ACTIVO','{"protocolo":"MQTT","intervalo_segundos":900}'::jsonb);

-- 672 tiempos cada 15 minutos durante 7 dias x 4 dispositivos = 2688 registros.
INSERT INTO lectura_iot(id_dispositivo,registrado_en,valor,unidad,payload)
SELECT d.id_dispositivo,
       TIMESTAMPTZ '2026-11-01 00:00:00-05' + g.n * INTERVAL '15 minutes',
       CASE d.id_dispositivo
            WHEN 1 THEN ((g.n * 7 + 11) % 55)::numeric
            WHEN 2 THEN ((g.n * 3 + 5) % 45)::numeric
            WHEN 3 THEN ((g.n * 9 + 29) % 115)::numeric
            ELSE 20 + (g.n % 41)::numeric/10 END,
       CASE WHEN d.tipo='OCUPACION' THEN 'personas' ELSE 'celsius' END,
       jsonb_build_object('calidad',CASE WHEN g.n % 17 = 0 THEN 'revision' ELSE 'ok' END,
                          'alerta',g.n % 29 = 0,'bateria_pct',70 + g.n % 29,
                          'origen','gateway-simulado')
FROM dispositivo_iot d
CROSS JOIN generate_series(0,671) g(n);

-- 1400 registros de actividad ficticia no sensible.
INSERT INTO registro_actividad(id_usuario,registrado_en,accion,metadatos)
SELECT 1 + g.n % 6,
       TIMESTAMPTZ '2026-11-01 00:00:00-05' + g.n * INTERVAL '7 minutes',
       CASE WHEN g.n % 3 = 0 THEN 'ingresar_espacio'
            WHEN g.n % 3 = 1 THEN 'ver_publicacion'
            ELSE 'buscar_evento' END,
       jsonb_build_object('canal',CASE WHEN g.n % 2 = 0 THEN 'app' ELSE 'web' END,
                          'espacio_id',1 + g.n % 3,'duracion_seg',10 + g.n % 180,
                          'simulacion',true)
FROM generate_series(0,1399) g(n);

-- Tras los INSERT explicitos, sincronizar secuencias para futuras altas.
SELECT setval(pg_get_serial_sequence('red_social.programa_academico','id_programa'),1,true);
SELECT setval(pg_get_serial_sequence('red_social.asignatura','id_asignatura'),1,true);
SELECT setval(pg_get_serial_sequence('red_social.usuario','id_usuario'),6,true);
SELECT setval(pg_get_serial_sequence('red_social.grupo','id_grupo'),1,true);
SELECT setval(pg_get_serial_sequence('red_social.publicacion','id_publicacion'),4,true);
SELECT setval(pg_get_serial_sequence('red_social.adjunto','id_adjunto'),4,true);
SELECT setval(pg_get_serial_sequence('red_social.comentario','id_comentario'),3,true);
SELECT setval(pg_get_serial_sequence('red_social.evento','id_evento'),2,true);
SELECT setval(pg_get_serial_sequence('red_social.espacio_campus','id_espacio'),3,true);
SELECT setval(pg_get_serial_sequence('red_social.dispositivo_iot','id_dispositivo'),4,true);
COMMIT;
ANALYZE red_social.publicacion;
ANALYZE red_social.lectura_iot;
ANALYZE red_social.registro_actividad;
