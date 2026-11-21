# Control de calidad y alcance de pruebas - Tarea 6

Validaciones estáticas realizadas sobre los archivos entregados:

- El DDL original PostgreSQL 16 de Tarea 4 se copió íntegro: mismo SHA-256.
- El modelo PostgreSQL contiene 24 tablas heredadas y cinco tablas nuevas.
- Se identificaron 11 consultas SQL documentadas, cinco índices GIN nuevos más el GIN original.
- Se corrigieron los valores de enumeraciones para respetar los CHECK existentes en el esquema original.
- Las inserciones con IDs explícitos de tablas GENERATED ALWAYS incluyen OVERRIDING SYSTEM VALUE.
- Se reutiliza publicacion.datos_nosql de Tarea 4 en lugar de duplicarlo.
- El informe se renderizó a PDF de 11 páginas y se inspeccionaron sus páginas.
