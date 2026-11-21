-- Escalamiento OPCIONAL: agregar 100.000 lecturas ficticias, SOLO UNA VEZ.
-- Esto cambia el conteo de 06_validaciones.sql: realizar validacion ANTES.
INSERT INTO red_social.lectura_iot(id_dispositivo,registrado_en,valor,unidad,payload)
SELECT 1,TIMESTAMPTZ '2026-11-08 00:00:00-05' + g.n * INTERVAL '10 seconds',
       ((g.n*13+7)%58)::numeric,'personas',
       jsonb_build_object('calidad','ok','alerta',g.n%97=0,'origen','carga-demo')
FROM generate_series(0,99999) g(n);
ANALYZE red_social.lectura_iot;
