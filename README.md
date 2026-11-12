# EGYPTX SOCIAL // CYBERREELS

Interfaz social SKYNET responsive con capa de autenticación y persistencia Supabase.

## Activar backend
1. Crea un proyecto Supabase.
2. Ejecuta todo `supabase/schema.sql` en SQL Editor.
3. En `supabase-config.js`, sustituye `url` y `anonKey` por Project URL y clave anon/public de tu proyecto.
4. Publica los cambios. Nunca pongas la clave `service_role` en el navegador.

## Funciones
- Registro, inicio y cierre de sesión con Supabase Auth.
- Perfil automático al registrar usuario.
- Feed persistente de publicaciones.
- Carga de imágenes y vídeos al bucket `egyptx-media` (máx. 100 MB).
- Likes y comentarios persistentes.
- Row Level Security en tablas y Storage.

Si las credenciales siguen como marcadores, el sitio conserva el modo demo sin llamar al backend.
