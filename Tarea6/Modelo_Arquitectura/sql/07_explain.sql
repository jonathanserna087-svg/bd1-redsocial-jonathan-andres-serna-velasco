-- Planes reales: ejecutar y capturar en pgAdmin 4; no confundir con capturas simuladas.
SET search_path TO red_social, public;
ANALYZE red_social.publicacion;
ANALYZE red_social.lectura_iot;
EXPLAIN (ANALYZE,BUFFERS,VERBOSE)
SELECT id_publicacion FROM publicacion
WHERE datos_nosql @> '{"formato_destacado":"imagen"}'::jsonb;
EXPLAIN (ANALYZE,BUFFERS,VERBOSE)
SELECT count(*) FROM lectura_iot
WHERE registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
AND registrado_en < TIMESTAMPTZ '2026-12-01 00:00:00-05'
AND payload @> '{"alerta":true}'::jsonb;
-- En bases pequenas puede aparecer Seq Scan; para medir escalabilidad usar 08_carga_masiva_opcional.sql.
-- El siguiente plan forzado SOLO sirve para entender que el indice es utilizable.
BEGIN;
SET LOCAL enable_seqscan=off;
EXPLAIN (ANALYZE,BUFFERS)
SELECT id_publicacion FROM publicacion
WHERE datos_nosql @> '{"formato_destacado":"imagen"}'::jsonb;
ROLLBACK;
