# Caso de estudio: Vibra — Identificación musical en pantallas inteligentes

## 1. Planteamiento del problema

Las personas escuchan canciones en lugares públicos, videos, eventos o dispositivos cercanos y con frecuencia desconocen el nombre o intérprete. Buscar manualmente fragmentos de letra es lento y poco confiable. Se requiere una aplicación de pantalla táctil que identifique música rápidamente y presente el resultado de manera clara.

## 2. Propuesta de solución

**Vibra** es una aplicación Android para celulares y tabletas. Al tocar un botón, solicita permiso al micrófono, captura aproximadamente 11 segundos de audio y los envía de forma segura por HTTPS al proveedor de reconocimiento ACRCloud. El proveedor devuelve metadatos de la pista si encuentra coincidencia. El usuario puede revisar el resultado y consultarlo luego en un historial local.

**Alcance:** MVP funcional académico. No entrena un modelo propio ni garantiza identificación de toda canción. No ofrece reproducción completa; abre enlaces legales de plataformas cuando los hay. No es una aplicación nativa para Android TV: está diseñada para pantallas táctiles Android.

## 3. Objetivo general

Desarrollar una aplicación Android intuitiva para identificar canciones mediante el micrófono, mostrar información musical y conservar un historial de reconocimientos.

## 4. Actores y requisitos

**Actor principal:** Usuario que desea identificar una canción.

**Servicios externos:** Android (micrófono, permisos, conectividad) y ACRCloud API.

| ID | Requisito funcional | Cómo se implementa |
|---|---|---|
| RF-01 | Solicitar acceso al micrófono | Permiso `RECORD_AUDIO` en ejecución |
| RF-02 | Capturar audio bajo demanda | `AudioRecord` con WAV/PCM durante 11 segundos |
| RF-03 | Identificar la canción | Solicitud `multipart/form-data` a ACRCloud |
| RF-04 | Mostrar título y artista | Pantalla de resultado Compose |
| RF-05 | Mostrar portada/enlace si existen | Metadatos Spotify (si están disponibles); icono de respaldo |
| RF-06 | Guardar canciones identificadas | Historial local (máx. 50) |
| RF-07 | Permitir cancelar grabación | Botón detener y limpieza temporal |
| RF-08 | Gestionar credenciales del proyecto (Host, Key y Secret) | Pestaña Ajustes |

## 5. Requisitos no funcionales

- **Usabilidad:** pantalla táctil, botones grandes, jerarquía visual simple, temas oscuros.
- **Compatibilidad:** Android 8.0+ con micrófono e Internet; interfaz escalable para tabletas.
- **Privacidad:** grabar solo con gesto explícito; eliminar muestras temporales.
- **Conectividad:** identificar requiere red y servicio ACRCloud disponible.
- **Mantenibilidad:** separar presentación, estado, grabación, red y persistencia.

## 6. Caso de uso principal: identificar canción

1. Usuario abre la app y configura el Host, Access Key y Access Secret del proyecto ACRCloud.
2. Toca el botón central de micrófono.
3. Android solicita permiso si aún no está autorizado.
4. Vibra captura 11 segundos y muestra progreso.
5. Vibra detiene la grabación, comprueba duración y nivel de sonido y envía un archivo WAV temporal a ACRCloud por HTTPS.
6. Si ACRCloud identifica: muestra título, intérprete, álbum, el enlace de Spotify (si existe) y guarda historial. La portada no está garantizada.
7. Si no encuentra coincidencia: informa al usuario y permite reintentar.
8. Si hay error de red, permisos o credenciales: muestra mensaje y permite resolverlo.

**Flujos alternos:** El usuario puede cancelar durante la grabación; si la aplicación va a segundo plano, la captura se detiene; si no hay conexión, el resultado informa el error.

## 7. Arquitectura

```text
Interfaz Jetpack Compose
        │ gestos / eventos
        ▼
VibraViewModel (estados y corrutinas)
    ├─► MicrophoneRecorder ─► archivo temporal WAV
    │                              │
    ├─► AcrCloudClient ────────────────┘
    │       └─► HTTPS ─► ACRCloud API ─► JSON de canción
    └─► VibraPreferences ─► historial y ajustes locales
```

## 8. Pruebas sugeridas

| Prueba | Resultado esperado |
|---|---|
| Instalar y abrir | Muestra logo y tres pestañas |
| Reconocer sin credenciales | Pide configurar Host, Access Key y Access Secret |
| Permiso denegado | Mensaje de permiso sin cierre inesperado |
| Música conocida, credenciales válidas | Muestra coincidencia si ACRCloud la reconoce |
| Silencio o audio muy bajo | Detecta el problema antes del envío y pide acercar la fuente de audio |
| Cortar la conexión | Muestra error recuperable |
| Cancelar grabación | Detiene micrófono y no envía archivo |
| Cambiar de aplicación grabando | Se cancela la grabación |
| Repetir una misma canción | Solo un registro de título + artista |
| Borrar historial | Lista vacía |
| Pantalla grande | Contenido centrado y usable |

## 9. Limitaciones y futuras mejoras

- El servicio de identificación requiere cuenta, credenciales y cuota de un tercero.
- Requiere micrófono accesible: algunos emuladores y pantallas carecen de él.
- Para lanzar públicamente: mover el Access Secret y la firma HMAC al backend, implementar rate limiting y obtener revisión legal de privacidad/servicios.
- Mejoras futuras: búsqueda por letra, compartir canción, favoritos, reconocimiento continuo opt-in y visualizaciones responsivas específicas para TV.

## 10. Conclusión

La solución demuestra captura de sensores, interacción táctil, peticiones HTTP seguras, manejo de estados y persistencia local, integradas en una experiencia Android de reconocimiento musical.
