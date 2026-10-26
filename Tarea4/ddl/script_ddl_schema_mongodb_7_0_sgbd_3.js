/**
 * =====================================================================
 * RED SOCIAL ESTUDIANTIL PASCUALINA - TAREA 4
 * SGBD 3 : MongoDB 7.0 (NoSQL Orientado a Documentos / BSON)
 * Autor  : Jonathan Andrés Serna Velasco
 *
 * Descripción:
 *   Estructuración completa del modelo NoSQL equivalente para MongoDB.
 *   Implementa colecciones con validación de esquemas (JSON Schema),
 *   documentos embebidos para relaciones de alto rendimiento, e
 *   índices geoespaciales 2dsphere para soporte nativo de IoT.
 * =====================================================================
 */

// Selección de la base de datos
db = db.getSiblingDB('red_social_pascualina');

// Limpieza previa de colecciones si existen
db.usuarios.drop();
db.grupos.drop();
db.publicaciones.drop();
db.mensajes.drop();

// ---------------------------------------------------------------------
// 1. COLECCIÓN: usuarios
// Contiene la identidad de los usuarios y embebe sus roles, habilidades e intereses.
// ---------------------------------------------------------------------
db.createCollection("usuarios", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["nombre_completo", "nombre_usuario", "correo_institucional", "contrasena_hash"],
         properties: {
            nombre_completo: { bsonType: "string" },
            nombre_usuario: { bsonType: "string" },
            correo_institucional: { 
               bsonType: "string",
               pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$" 
            },
            contrasena_hash: { bsonType: "string" },
            foto_perfil_url: { bsonType: ["string", "null"] },
            biografia: { bsonType: ["string", "null"] },
            fecha_registro: { bsonType: "date" },
            
            // Subdocumento condicional para perfil Estudiante
            perfil_estudiante: {
               bsonType: ["object", "null"],
               required: ["codigo_estudiantil", "programa_academico", "semestre_actual"],
               properties: {
                  codigo_estudiantil: { bsonType: "string" },
                  programa_academico: { bsonType: "string" },
                  semestre_actual: { bsonType: "int", minimum: 1, maximum: 14 }
               }
            },
            
            // Subdocumento condicional para perfil Docente
            perfil_docente: {
               bsonType: ["object", "null"],
               required: ["codigo_docente", "titulo_academico", "departamento"],
               properties: {
                  codigo_docente: { bsonType: "string" },
                  titulo_academico: { bsonType: "string" },
                  departamento: { bsonType: "string" }
               }
            },

            // Embebido N:M - Habilidades del usuario
            habilidades: {
               bsonType: "array",
               items: {
                  bsonType: "object",
                  required: ["nombre_habilidad", "nivel_competencia"],
                  properties: {
                     nombre_habilidad: { bsonType: "string" },
                     nivel_competencia: { enum: ["basico", "intermedio", "avanzado"] }
                  }
               }
            },

            // Embebido N:M - Intereses del usuario
            intereses: {
               bsonType: "array",
               items: { bsonType: "string" }
            }
         }
      }
   }
});

db.usuarios.createIndex({ "nombre_usuario": 1 }, { unique: true });
db.usuarios.createIndex({ "correo_institucional": 1 }, { unique: true });

// ---------------------------------------------------------------------
// 2. COLECCIÓN: publicaciones (Soporte Principal NoSQL / Big Data / IoT)
// ---------------------------------------------------------------------
db.createCollection("publicaciones", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["id_usuario_autor", "tipo_publicacion", "contenido", "fecha_publicacion"],
         properties: {
            id_usuario_autor: { bsonType: "objectId" },
            id_grupo: { bsonType: ["objectId", "null"] },
            tipo_publicacion: { 
               enum: ["pregunta", "recurso", "noticia", "meme"] 
            },
            contenido: { bsonType: "string" },
            fecha_publicacion: { bsonType: "date" },
            etiquetas: {
               bsonType: "array",
               items: { bsonType: "string" }
            },
            adjuntos: {
               bsonType: "array",
               items: {
                  bsonType: "object",
                  required: ["url_archivo", "tipo_archivo"],
                  properties: {
                     url_archivo: { bsonType: "string" },
                     tipo_archivo: { enum: ["imagen", "video", "documento", "enlace"] }
                  }
               }
            },
            
            // Documento NoSQL Flexible para IoT y Big Data
            datos_nosql: {
               bsonType: "object",
               properties: {
                  iot_telemetria: {
                     bsonType: "object",
                     properties: {
                        sensor_id: { bsonType: "string" },
                        ubicacion_geo: {
                           bsonType: "object",
                           required: ["type", "coordinates"],
                           properties: {
                              type: { enum: ["Point"] },
                              coordinates: { 
                                 bsonType: "array",
                                 items: { bsonType: "double" } // [longitud, latitud]
                              }
                           }
                        },
                        aforo_detectado: { bsonType: "int" }
                     }
                  },
                  big_data_metadata: {
                     bsonType: "object",
                     properties: {
                        ip_origen: { bsonType: "string" },
                        dispositivo: { bsonType: "string" },
                        vistas: { bsonType: "int" },
                        tiempo_lectura_seg: { bsonType: "double" }
                     }
                  }
               }
            }
         }
      }
   }
});

// Índice geoespacial 2dsphere para consultas IoT por proximidad
db.publicaciones.createIndex({ "datos_nosql.iot_telemetria.ubicacion_geo": "2dsphere" });

// Índice compuesto para consultas eficientes de muros de publicaciones
db.publicaciones.createIndex({ "tipo_publicacion": 1, "fecha_publicacion": -1 });
db.publicaciones.createIndex({ "id_usuario_autor": 1 });

// ---------------------------------------------------------------------
// 3. COLECCIÓN: mensajes
// Optimizado para chats masivos y consultas temporales.
// ---------------------------------------------------------------------
db.createCollection("mensajes", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["id_usuario_emisor", "id_usuario_receptor", "contenido", "fecha_envio", "leido"],
         properties: {
            id_usuario_emisor: { bsonType: "objectId" },
            id_usuario_receptor: { bsonType: "objectId" },
            contenido: { bsonType: "string" },
            fecha_envio: { bsonType: "date" },
            leido: { bsonType: "bool" }
         }
      }
   }
});

db.mensajes.createIndex({ "id_usuario_emisor": 1, "id_usuario_receptor": 1, "fecha_envio": -1 });

print("Scripts NoSQL / MongoDB para Tarea 4 ejecutados correctamente.");