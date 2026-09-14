# Red Social Pascualina — Modelo conceptual de base de datos

Repositorio de la asignatura **Bases de Datos I** — Institución Universitaria Pascual Bravo, Medellín.
Tarea 1: diseño del modelo conceptual (Modelo Entidad-Relación).

## Datos del proyecto

| | |
|---|---|
| **Proyecto** | Red Social Pascualina — Modelo conceptual de base de datos |
| **Asignatura** | Bases de Datos I |
| **Docente** | Oralia Cortés Grajales |
| **Grupo** | Grupo [X] |
| **Integrante** | Jonathan Andrés Serna Velasco ([@usuario]) |
| **Fecha** | 9 de septiembre de 2026 |

## Breve descripción del caso

La comunidad educativa cuenta con plataformas institucionales que resuelven bien lo formal, pero
no facilitan la conexión casual entre estudiantes: el intercambio de conocimiento entre pares, la
formación de grupos de estudio o la organización de actividades informales.

La **Red Social Pascualina** es una plataforma donde los miembros de la comunidad pueden:

- **crear perfiles** con su área de estudio, intereses y habilidades;
- **conectarse con compañeros**, siguiendo a estudiantes con intereses afines o de cursos
  avanzados que puedan ofrecer mentoría;
- **publicar actualizaciones**: preguntas sobre tareas, recursos, noticias del sector o memes;
- **crear y unirse a grupos**: de estudio, equipos de hackatón o clubes de interés;
- **programar eventos**: reuniones de estudio, talleres y actividades sociales.

El objetivo de la **Tarea 1** es diseñar el **modelo conceptual** de la base de datos que soportará
esa plataforma, aplicando el Modelo Entidad-Relación (MER).

## Resultado del modelo

| Elemento | Cantidad |
|---|---|
| Entidades | 14 (10 fuertes, 2 débiles, 2 subclases) |
| Relaciones | 23 (21 binarias, 1 ternaria, 2 recursivas) |
| Atributos | 78 (claves, simples, compuestos, multivaluados, derivados y claves parciales) |
| Jerarquías | 1 especialización disyunta y total: `USUARIO -> {ESTUDIANTE, DOCENTE}` |

## Estructura del repositorio

```
bd1-redsocial-grupoX/
├── README.md
└── tarea1/
    ├── informe/
    │   ├── Tarea1_Informe_MER_RedSocialPascualina.pdf   <- entregable principal
    │   ├── MER_red_social_pascualina.drawio             <- diagrama editable (6 páginas)
    │   ├── mer_global.png                               <- vista general del MER
    │   ├── mer_m1.png … mer_m4.png                      <- detalle de atributos por módulo
    │   └── convenciones.png                             <- notación empleada
    └── video/
        ├── enlace_video.md                              <- enlace a YouTube
        └── guion_sustentacion.md                        <- guion de la sustentación
```

## Cómo abrir el diagrama

1. Entrar a [app.diagrams.net](https://app.diagrams.net) (draw.io).
2. `File > Open from > Device` y seleccionar `MER_red_social_pascualina.drawio`.
3. El archivo tiene seis páginas (pestañas inferiores): vista global, cuatro vistas de detalle por
   módulo y una página de convenciones.

## Notación utilizada

Notación de Chen según Elmasri & Navathe, *Fundamentos de Sistemas de Bases de Datos*, cap. 3:

- Rectángulo: entidad · rectángulo doble: entidad débil
- Rombo: relación · rombo doble: relación identificadora
- Elipse: atributo · subrayado: clave · doble línea: multivaluado · línea punteada: derivado
- Línea gruesa: participación total · línea delgada: participación parcial
- Círculo con `d`: especialización disyunta; `U` marca cada subclase


