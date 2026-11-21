-- TAREA 6 | 11 CONSULTAS: SQL relacional, JSONB, IoT y analitica.
-- Fechas de simulacion fijas para reproducibilidad en cualquier momento.
SET search_path TO red_social, public;
SET TIME ZONE 'America/Bogota';

-- Q01. Publicaciones con imagen: metadatos JSONB + adjuntos normalizados.
SELECT p.id_publicacion, u.nombre_completo AS autor, p.contenido,
       a.url_archivo, p.datos_nosql ->> 'idioma' AS idioma
FROM publicacion p
JOIN usuario u ON u.id_usuario = p.id_usuario_autor
JOIN adjunto a ON a.id_publicacion = p.id_publicacion
WHERE p.datos_nosql @> '{"formato_destacado":"imagen"}'::jsonb
  AND a.tipo_archivo = 'imagen'
ORDER BY p.fecha_publicacion DESC;

-- Q02. Usuarios que activaron notificaciones sobre eventos.
SELECT u.id_usuario, u.nombre_completo,
       pc.preferencias ->> 'tema' AS tema_visual
FROM usuario u
JOIN perfil_configuracion pc ON pc.id_usuario = u.id_usuario
WHERE pc.preferencias @> '{"notificaciones":{"eventos":true}}'::jsonb
ORDER BY u.nombre_completo;

-- Q03. Participacion en la comunidad: publicaciones por autor.
SELECT u.id_usuario, u.nombre_completo,
       COUNT(p.id_publicacion) AS publicaciones,
       MAX(p.fecha_publicacion) AS fecha_ultima_publicacion
FROM usuario u LEFT JOIN publicacion p ON p.id_usuario_autor = u.id_usuario
GROUP BY u.id_usuario,u.nombre_completo
ORDER BY publicaciones DESC,u.nombre_completo;

-- Q04. Ranking de publicaciones (sin duplicacion por uniones 1:N simultaneas).
WITH reacciones_agg AS (
  SELECT id_publicacion, COUNT(*) AS reacciones
  FROM reaccion GROUP BY id_publicacion
), comentarios_agg AS (
  SELECT id_publicacion, COUNT(*) AS comentarios
  FROM comentario GROUP BY id_publicacion
)
SELECT p.id_publicacion,p.contenido,
       COALESCE(r.reacciones,0) AS reacciones,
       COALESCE(c.comentarios,0) AS comentarios,
       COALESCE(r.reacciones,0) + COALESCE(c.comentarios,0) AS total_interacciones
FROM publicacion p
LEFT JOIN reacciones_agg r ON r.id_publicacion=p.id_publicacion
LEFT JOIN comentarios_agg c ON c.id_publicacion=p.id_publicacion
ORDER BY total_interacciones DESC,p.id_publicacion;

-- Q05. Demanda de uso digital por dia y accion; JSONB @> e intervalo.
SELECT (ra.registrado_en AT TIME ZONE 'America/Bogota')::date AS dia,
       ra.accion,COUNT(*) AS interacciones_app
FROM registro_actividad ra
WHERE ra.registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
  AND ra.registrado_en < TIMESTAMPTZ '2026-11-08 00:00:00-05'
  AND ra.metadatos @> '{"canal":"app"}'::jsonb
GROUP BY (ra.registrado_en AT TIME ZONE 'America/Bogota')::date,ra.accion
ORDER BY dia,interacciones_app DESC;

-- Q06. Aforo horario promedio, maximo y cantidad de muestras de calidad.
SELECT ec.nombre AS espacio,
       date_trunc('hour',li.registrado_en AT TIME ZONE 'America/Bogota') AS hora_local,
       ROUND(AVG(li.valor),2) AS ocupacion_promedio,
       MAX(li.valor) AS maximo,
       COUNT(*) AS muestras
FROM lectura_iot li
JOIN dispositivo_iot di ON di.id_dispositivo=li.id_dispositivo
JOIN espacio_campus ec ON ec.id_espacio=di.id_espacio
WHERE di.tipo='OCUPACION' AND li.unidad='personas'
  AND li.registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
  AND li.registrado_en < TIMESTAMPTZ '2026-11-08 00:00:00-05'
  AND li.payload @> '{"calidad":"ok"}'::jsonb
GROUP BY ec.id_espacio,ec.nombre,date_trunc('hour',li.registrado_en AT TIME ZONE 'America/Bogota')
ORDER BY hora_local,espacio;

-- Q07. Ultimo aforo conocido en cada espacio y porcentaje sobre capacidad.
WITH ordenadas AS (
 SELECT ec.id_espacio,ec.nombre,ec.capacidad,li.valor,li.registrado_en,
        ROW_NUMBER() OVER (PARTITION BY ec.id_espacio
           ORDER BY li.registrado_en DESC,li.id_lectura DESC) AS rn
 FROM lectura_iot li
 JOIN dispositivo_iot di ON di.id_dispositivo=li.id_dispositivo
 JOIN espacio_campus ec ON ec.id_espacio=di.id_espacio
 WHERE di.tipo='OCUPACION' AND li.unidad='personas'
   AND li.payload @> '{"calidad":"ok"}'::jsonb
   AND li.registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
   AND li.registrado_en < TIMESTAMPTZ '2026-11-08 00:00:00-05'
)
SELECT nombre,capacidad,valor AS personas,
       ROUND(100*valor/NULLIF(capacidad,0),2) AS porcentaje_aforo,
       registrado_en AS fecha_medicion
FROM ordenadas WHERE rn=1 ORDER BY porcentaje_aforo DESC;

-- Q08. Eventos presenciales con registro obligatorio; conteos por estado.
SELECT e.id_evento,e.nombre_evento,e.fecha_hora_inicio,
 COUNT(ue.id_usuario) FILTER (WHERE ue.estado_asistencia='confirmado') AS confirmados,
 COUNT(ue.id_usuario) FILTER (WHERE ue.estado_asistencia='asistio') AS asistieron,
 COUNT(ue.id_usuario) AS inscripciones
FROM evento e LEFT JOIN usuario_evento ue ON ue.id_evento=e.id_evento
WHERE e.modalidad='presencial'
  AND e.detalles_jsonb @> '{"requiere_registro":true}'::jsonb
GROUP BY e.id_evento,e.nombre_evento,e.fecha_hora_inicio
ORDER BY confirmados DESC,e.id_evento;

-- Q09. Alertas generadas por cada sensor.
SELECT di.codigo,ec.nombre AS espacio,
       COUNT(*) AS alertas,
       MIN(li.registrado_en) AS primera_alerta,
       MAX(li.registrado_en) AS ultima_alerta
FROM lectura_iot li
JOIN dispositivo_iot di ON di.id_dispositivo=li.id_dispositivo
JOIN espacio_campus ec ON ec.id_espacio=di.id_espacio
WHERE li.registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
  AND li.registrado_en < TIMESTAMPTZ '2026-11-08 00:00:00-05'
  AND li.payload @> '{"alerta":true}'::jsonb
GROUP BY di.id_dispositivo,di.codigo,ec.nombre
ORDER BY alertas DESC,di.codigo;

-- Q10. Actividad por usuario y publicaciones, agregando antes para no multiplicar.
WITH posts AS (
 SELECT id_usuario_autor AS id_usuario,COUNT(*) AS total_posts
 FROM publicacion GROUP BY id_usuario_autor
), acciones AS (
 SELECT id_usuario, COUNT(*) AS total_acciones,
        SUM((metadatos ->> 'duracion_seg')::integer) AS total_segundos
 FROM registro_actividad
 WHERE registrado_en >= TIMESTAMPTZ '2026-11-01 00:00:00-05'
   AND registrado_en < TIMESTAMPTZ '2026-11-08 00:00:00-05'
   AND metadatos @> '{"canal":"app"}'::jsonb
 GROUP BY id_usuario
)
SELECT u.nombre_completo,
       COALESCE(p.total_posts,0) AS publicaciones,
       COALESCE(a.total_acciones,0) AS acciones_app,
       COALESCE(a.total_segundos,0) AS segundos_app
FROM usuario u
LEFT JOIN posts p ON p.id_usuario=u.id_usuario
LEFT JOIN acciones a ON a.id_usuario=u.id_usuario
ORDER BY acciones_app DESC,u.nombre_completo;

-- Q11. Desagregacion flexible de arrays JSONB: materiales requeridos.
SELECT material.valor #>> '{}' AS material,
       COUNT(*) AS eventos_que_lo_requieren
FROM evento e
CROSS JOIN LATERAL jsonb_array_elements(
    COALESCE(e.detalles_jsonb -> 'materiales','[]'::jsonb)
) AS material(valor)
GROUP BY material.valor #>> '{}'
ORDER BY eventos_que_lo_requieren DESC, material.valor #>> '{}';
