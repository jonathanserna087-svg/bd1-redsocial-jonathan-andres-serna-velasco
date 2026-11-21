-- Complementa, no reemplaza, los indices del modelo de la Tarea 4.
BEGIN;
SET LOCAL search_path TO red_social, public;
-- JSONB containment (@>) -> GIN jsonb_path_ops.
-- PUBLICACION.datos_nosql ya tiene idx_publicacion_datos_nosql (GIN jsonb_ops)
-- creado en 01_ddl_base_24_tablas.sql; no se crea un indice redundante.
CREATE INDEX idx_evento_detalles_gin ON evento
  USING GIN (detalles_jsonb jsonb_path_ops);
CREATE INDEX idx_perfil_preferencias_gin ON perfil_configuracion
  USING GIN (preferencias jsonb_path_ops);
CREATE INDEX idx_dispositivo_configuracion_gin ON dispositivo_iot
  USING GIN (configuracion jsonb_path_ops);
CREATE INDEX idx_lectura_payload_gin ON lectura_iot
  USING GIN (payload jsonb_path_ops);
CREATE INDEX idx_actividad_metadatos_gin ON registro_actividad
  USING GIN (metadatos jsonb_path_ops);
-- B-tree por rango temporal, join y ultimo dato del sensor.
CREATE INDEX idx_dispositivo_espacio_tipo ON dispositivo_iot(id_espacio,tipo);
CREATE INDEX idx_lectura_dispositivo_fecha ON lectura_iot(id_dispositivo,registrado_en DESC);
CREATE INDEX idx_actividad_usuario_fecha ON registro_actividad(id_usuario,registrado_en DESC);
CREATE INDEX idx_actividad_accion_fecha ON registro_actividad(accion,registrado_en DESC);
COMMIT;
ANALYZE red_social.lectura_iot;
ANALYZE red_social.registro_actividad;
