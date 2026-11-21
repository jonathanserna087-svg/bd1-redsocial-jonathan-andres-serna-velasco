# Tarea 6 - Red Social Estudiantil Pascualina | PostgreSQL

**Autor:** Jonathan Andrés Serna Velasco  
**Asignatura:** Bases de Datos I · **Institución Universitaria Pascual Bravo** · **Medellín, 2026**

## Continuidad real con entregas anteriores

Esta propuesta parte de las **24 tablas originales** de la Tarea 4 que proporcionaste como referencia. Conserva el esquema PostgreSQL `red_social`, los nombres de tablas y su lógica de relaciones. La Tarea 6 agrega **5 tablas nuevas** y **1 columna JSONB nueva en EVENTO**. Además, conserva `PUBLICACION.datos_nosql` y su índice GIN de la Tarea 4. Se incluyen **8 particiones físicas** (4 de lectura IoT y 4 de actividad), nuevos índices y 11 consultas. En total hay **29 tablas lógicas**; las particiones son tablas físicas hijas, no 8 entidades adicionales del modelo conceptual.

No se reemplaza el modelo previo por una base diferente. Los registros de ejemplo son **completamente simulados**. No hay datos de personas reales, dispositivos conectados ni medidas de rendimiento inventadas.

## Organización requerida

- `Modelo_Arquitectura/`: diagramas PNG/SVG/DOT y todos los scripts PostgreSQL.
- `Diccionarios/`: inventario de 29 tablas, diccionario físico de campos y de las 11 consultas.
- `informe/`: informe técnico editable en Word y PDF.

## Puesta en marcha por pgAdmin 4

1. **Haz copia de seguridad** de cualquier base existente. Crea una base de PRUEBAS completamente vacía llamada `red_social_estudiantil` (u otro nombre a elección). **No ejecutes el DDL base en una base que ya contenga las 24 tablas**: el archivo original de Tarea 4 contiene `DROP SCHEMA IF EXISTS red_social CASCADE` y BORRARÍA todas las tablas y datos de ese esquema.
2. Abre pgAdmin 4 → Servers → tu servidor → Databases → `red_social_estudiantil` → Query Tool.
3. Abre **cada archivo**, ejecutando *en este orden*: `01_ddl_base_24_tablas.sql`, `02_ddl_extension_hibrida.sql`, `03_dml_datos_simulados.sql`, `04_indices_hibridos.sql`, `05_consultas_analiticas.sql`, `06_validaciones.sql` y `07_explain.sql`.
4. Conserva capturas **reales** de la estructura de 29 tablas lógicas, el resultado del bloque DO en Messages, las consultas Q01, Q06, Q09 y los planes de EXPLAIN.
5. `08_carga_masiva_opcional.sql` añade 100.000 filas sintéticas: úsalo solo **después** de `06_validaciones.sql`, porque cambia el conteo esperado.

### Alternativa de ejecución en psql

Desde `Modelo_Arquitectura/sql/`:

```bash
psql -X -v ON_ERROR_STOP=1 -d red_social_estudiantil -f 00_ejecutar_todo.psql
```

El archivo `00_ejecutar_todo.psql` contiene comandos `\ir` de **psql**; no debe copiarse al Query Tool de pgAdmin. Usa PostgreSQL **15 o posterior**.



