-- Validacion tras instalar esquema, extensiones, datos e indices; se espera EXCEPTION si hay discrepancias.
SET search_path TO red_social, public;
DO $$
DECLARE
 n_base integer;
 n_nuevas integer;
 n_usuarios bigint;
 n_publicaciones bigint;
 n_lecturas bigint;
 n_actividad bigint;
 n_hijas bigint;
 n_gin bigint;
 n_imagenes bigint;
BEGIN
 SELECT count(*) INTO n_base FROM information_schema.tables
 WHERE table_schema='red_social' AND table_type='BASE TABLE'
 AND table_name IN ('programa_academico','asignatura','usuario','estudiante','docente',
  'habilidad','interes','usuario_habilidad','usuario_interes','sigue','mensaje','grupo',
  'usuario_grupo','publicacion','etiqueta','publicacion_etiqueta','adjunto',
  'comentario','reaccion','evento','usuario_evento','programa_asignatura',
  'docente_asignatura','mentoria');
 SELECT count(*) INTO n_nuevas FROM information_schema.tables
 WHERE table_schema='red_social' AND table_type='BASE TABLE'
 AND table_name IN ('perfil_configuracion','espacio_campus','dispositivo_iot',
  'lectura_iot','registro_actividad');
 SELECT count(*) INTO n_usuarios FROM usuario;
 SELECT count(*) INTO n_publicaciones FROM publicacion;
 SELECT count(*) INTO n_lecturas FROM lectura_iot;
 SELECT count(*) INTO n_actividad FROM registro_actividad;
 SELECT count(*) INTO n_imagenes FROM publicacion
 WHERE datos_nosql @> '{"formato_destacado":"imagen"}'::jsonb;
 SELECT count(*) INTO n_hijas FROM pg_inherits i
 JOIN pg_class c ON c.oid=i.inhparent
 JOIN pg_namespace n ON n.oid=c.relnamespace
 WHERE n.nspname='red_social' AND c.relname IN ('lectura_iot','registro_actividad');
 SELECT count(*) INTO n_gin FROM pg_indexes
 WHERE schemaname='red_social' AND indexdef ILIKE '%USING gin%';
 IF n_base <> 24 THEN RAISE EXCEPTION 'Se esperaban 24 tablas originales, hay %',n_base; END IF;
 IF n_nuevas <> 5 THEN RAISE EXCEPTION 'Se esperaban 5 tablas nuevas, hay %',n_nuevas; END IF;
 IF n_usuarios <> 6 THEN RAISE EXCEPTION 'Se esperaban 6 usuarios, hay %',n_usuarios; END IF;
 IF n_publicaciones <> 4 THEN RAISE EXCEPTION 'Se esperaban 4 publicaciones, hay %',n_publicaciones; END IF;
 IF n_lecturas <> 2688 THEN RAISE EXCEPTION 'Se esperaban 2688 lecturas, hay %',n_lecturas; END IF;
 IF n_actividad <> 1400 THEN RAISE EXCEPTION 'Se esperaban 1400 actividades, hay %',n_actividad; END IF;
 IF n_imagenes <> 2 THEN RAISE EXCEPTION 'Se esperaban 2 publicaciones con imagen, hay %',n_imagenes; END IF;
 IF n_hijas <> 8 THEN RAISE EXCEPTION 'Se esperaban 8 particiones hijas, hay %',n_hijas; END IF;
 IF n_gin < 6 THEN RAISE EXCEPTION 'Se esperaban al menos 6 indices GIN, hay %',n_gin; END IF;
 RAISE NOTICE 'OK: 24 tablas previas, 5 nuevas, 8 particiones, % lecturas, % logs, % GIN',
 n_lecturas,n_actividad,n_gin;
END $$;

SELECT tableoid::regclass AS particion,COUNT(*) AS filas
FROM lectura_iot GROUP BY tableoid ORDER BY particion;
SELECT id_publicacion,jsonb_typeof(datos_nosql) AS tipo_json
FROM publicacion ORDER BY id_publicacion;
