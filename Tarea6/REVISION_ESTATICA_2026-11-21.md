# Informe de revisión estática — Tarea 6

Fecha: 21 de noviembre de 2026. Análisis de archivos en este entorno.

| Comprobación | Resultado |
|---|---|
| DDL base coincide byte a byte con archivo original de Tarea 4 | Correcto (SHA-256 c3faeaa46e36…) |
| Tablas originales en CREATE TABLE | 24 |
| Nuevas tablas lógicas en CREATE TABLE | 5 |
| Particiones declaradas | 8 |
| Consultas Q01 a Q11 | 11 |
| Índices declarados CREATE INDEX en el proyecto | 34 (incluye los índices heredados) |
| Índices mencionados en inventario | Todos existen en los scripts, luego de la corrección |
| Delimitadores léxicos (comillas, comentarios y paréntesis) | Sin inconsistencias detectadas |
| Filas IoT que generaría el SELECT de simulación, según series y dispositivos | 2688 esperadas, **no ejecutadas** |
| Registros de actividad que generaría generate_series | 1400 esperados, **no ejecutados** |

## Correcciones hechas en esta revisión

El archivo `Diccionarios/inventario_consultas.csv` mencionaba cuatro índices que no existían en ningún script: `idx_publicacion_autor_fecha`, `idx_reaccion_publicacion`, `idx_comentario_publicacion_fecha` e `idx_usuario_evento_evento`. Se corrigieron por los nombres reales; también se aclaró que Q04 suma conteos ya agregados, no usa la función `SUM()`.


## Revisión por archivo

- `01_ddl_base_24_tablas.sql`: estructura balanceada (54 terminadores SQL visibles)
- `02_ddl_extension_hibrida.sql`: estructura balanceada (25 terminadores SQL visibles)
- `03_dml_datos_simulados.sql`: estructura balanceada (35 terminadores SQL visibles)
- `04_indices_hibridos.sql`: estructura balanceada (14 terminadores SQL visibles)
- `05_consultas_analiticas.sql`: estructura balanceada (13 terminadores SQL visibles)
- `06_validaciones.sql`: estructura balanceada (4 terminadores SQL visibles)
- `07_explain.sql`: estructura balanceada (9 terminadores SQL visibles)
- `08_carga_masiva_opcional.sql`: estructura balanceada (2 terminadores SQL visibles)
