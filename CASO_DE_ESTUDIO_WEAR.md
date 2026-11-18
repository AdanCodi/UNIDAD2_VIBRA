# Caso de estudio: Vibra Watch — Reconocimiento musical desde Wear OS

**Proyecto académico:** Aplicación para dispositivos wearables con vinculación a un dispositivo móvil Android.  
**Versión:** 1.3 — Prototipo funcional diseñado para compilación y validación en dispositivos.  
**Tecnologías:** Kotlin, Jetpack Compose, Android Studio, Google Play Services Wearable Data Layer, ACRCloud, Android API 36.

## 1. Situación problemática

Una persona escucha música en un lugar público y quiere conocer el nombre de la canción sin tener que buscar el teléfono, desbloquearlo y navegar por varias pantallas. Los relojes inteligentes permiten iniciar acciones rápidas con una sola pulsación, pero no siempre cuentan con una conexión adecuada ni es conveniente procesar audio de forma independiente en un reloj.

## 2. Objetivo

Desarrollar **Vibra Watch**, una app para Wear OS que se vincule con **Vibra para Android** y permita solicitar desde el reloj el reconocimiento de una canción, así como recibir su título y artista cuando el teléfono concluye el proceso.

## 3. Actores y dispositivos

- **Persona usuaria:** tiene reloj Wear OS y celular Android enlazados.
- **Reloj:** muestra conexión, botón principal, progreso y respuesta.
- **Celular:** recibe la solicitud y usa su micrófono con autorización del usuario.
- **Servicio ACRCloud:** identifica el fragmento WAV y devuelve metadatos de la canción (se requieren credenciales y conectividad).

## 4. Flujo de uso

1. El usuario instala la app del teléfono (`:app`) y la del reloj (`:wear`).
2. Empareja el teléfono con el reloj en Wear OS o en el Pairing Assistant de Android Studio.
3. En el celular configura Host, Access Key y Access Secret de ACRCloud, y autoriza los permisos de micrófono y notificaciones.
4. En el reloj pulsa el icono circular de Vibra.
5. Wear OS envía un mensaje `MessageClient` por la ruta `/vibra/request`.
6. El celular presenta una notificación. El usuario la toca para abrir Vibra y autorizar la captura de audio en primer plano.
7. Vibra graba aproximadamente 11 segundos, envía el archivo WAV a ACRCloud y evalúa la respuesta.
8. El celular publica un `DataItem` con estado (`waiting`, `recording`, `identifying`, `found`, `no_match` o `error`) en la ruta `/vibra/state`.
9. El reloj presenta título y artista cuando existe coincidencia; en caso contrario muestra el estado o error.

> La notificación y la interacción del usuario son intencionales: Android restringe iniciar captura de micrófono desde segundo plano en versiones recientes. No se afirma reconocimiento autónomo desde el reloj.

## 5. Funciones implementadas

| Requisito de la actividad | Implementación |
|---|---|
| Icono de aplicación | Se reutiliza el isotipo circular original de Vibra como icono de Wear OS en las densidades de Android. |
| Vinculación con otros dispositivos móviles | Enlace entre reloj Wear OS y teléfono Android mediante `MessageClient`, `NodeClient` y `DataClient` de Google Play Services. |
| Funcionalidad acorde al caso | Inicio de solicitud desde reloj, notificación en celular, escucha autorizada, búsqueda de la canción, devolución de estado y resultado. |
| Código fuente | Módulos `app/` y `wear/`, clases Kotlin, manifiestos, archivos Gradle y copia concatenada en `CODIGO_FUENTE_COMPLETO.txt`. |
| Archivos ejecutables | Dos APK Android **se generan** con `:app:assembleDebug` y `:wear:assembleDebug`. No hay APK incluido antes de compilar. |

## 6. Componentes de software

- `app/src/main/java/com/vibra/app/wearlink/PhoneWatchListenerService.kt`: recibe mensajes del reloj.
- `app/src/main/java/com/vibra/app/wearlink/WatchLink.kt`: guarda solicitudes, crea notificaciones y publica estados.
- `app/src/main/java/com/vibra/app/MainActivity.kt`: permisos, inicio del reconocimiento y devolución del resultado al reloj.
- `app/src/main/java/com/vibra/app/VibraViewModel.kt`: grabación y reconocimiento ACRCloud de la app de celular ya existente.
- `wear/src/main/java/com/vibra/wear/MainActivity.kt`: interfaz circular y envío/recepción de mensajes de vinculación.
- `wear/src/main/res/drawable-nodpi/vibra_mark.png`: icono de la interfaz.

## 7. Configuración del emulador Wear OS y vinculación

1. Abrir la carpeta `Vibra_WearOS` en Android Studio con **JDK 17 o 21**, Android SDK 36 y Gradle sincronizado.
2. En **Tools > Device Manager > Create Device**, elegir un modelo **Wear OS** (por ejemplo, reloj redondo) y descargar una imagen que incluya Google Play Services.
3. Crear también un dispositivo virtual Phone con servicios de Google, o usar un celular físico Android.
4. Iniciar ambos dispositivos; abrir **Tools > Wear OS > Pair with Wear OS Emulator** (el nombre puede variar según Android Studio) y completar el emparejamiento.
5. En la configuración de ejecución, seleccionar el módulo **`app`** y ejecutarlo en el celular.
6. Seleccionar el módulo **`wear`** y ejecutarlo en el reloj.
7. Verificar que la pantalla del reloj indique `Celular conectado`.
8. Configurar ACRCloud en el teléfono, otorgar permisos y realizar la prueba con música reproducida en otro dispositivo.

## 8. Compilación y archivos ejecutables

Desde la raíz del proyecto:

```bat
Generar_APKs_Windows.bat
```

O desde Android Studio abrir **Build > Build APK(s)** eligiendo el módulo y ejecutar también el otro módulo; también se puede compilar en terminal:

```bat
gradlew.bat :app:assembleDebug :wear:assembleDebug
```

Luego de una compilación correcta, los archivos estarán en:

```text
app/build/outputs/apk/debug/app-debug.apk
wear/build/outputs/apk/debug/wear-debug.apk
```

El script copia ambos como:

```text
Entregables/Vibra_Celular_debug.apk
Entregables/Vibra_Reloj_debug.apk
```

**Importante:** ambos módulos usan el mismo `applicationId=com.vibra.app` y, para la vinculación, deben estar firmados con la misma clave. Los APK de depuración generados en la misma computadora usan normalmente el mismo certificado debug. En un mismo dispositivo no se instalan los dos APK simultáneamente; uno corresponde al celular y otro al reloj.

## 9. Pruebas propuestas (evidencia pendiente)

| Prueba | Resultado esperado | Evidencia actual |
|---|---|---|
| P01: abrir aplicación Wear | Se ve logo y botón en pantalla circular | Falta captura real de emulador. |
| P02: reloj desvinculado | Aparece mensaje de conexión ausente | Falta ejecutar prueba. |
| P03: reloj vinculado | Aparece `Celular conectado` | Falta ejecutar prueba. |
| P04: solicitud desde reloj | Se muestra notificación en celular | Falta ejecutar prueba. |
| P05: identificación correcta | Aparecen canción y artista en reloj | Requiere ACRCloud y audio real. |
| P06: sin coincidencia | Muestra respuesta sin coincidencia | Falta ejecutar prueba. |
| P07: sin permisos | Estado de error entendible | Falta ejecutar prueba. |

**Estado verificable:** se entrega el código y el proyecto listo para importación, pero **no** se ha compilado ni ejecutado aquí con Android SDK ni se han generado APK reales.

## 10. Consideraciones

- Requiere reloj Wear OS compatible y teléfono Android con Google Play Services; no se garantiza compatibilidad con relojes genéricos ni con dispositivos iOS emparejados.
- La ruta Data Layer exige que ambos APK utilicen **el mismo nombre de paquete y firma**.
- El reconocimiento ACRCloud requiere credenciales y conexión de red, y puede fallar con ruido o música poco distinguible.
- Audio y claves no viajan al reloj: únicamente la solicitud de inicio y metadatos del resultado.
- Este proyecto conserva el guardado local de claves ACRCloud de la versión educativa del celular. Antes de publicar una aplicación comercial, se recomienda mover el secreto a un backend.

## 11. Referencias técnicas

- Wear OS Data Layer: https://developer.android.com/training/wearables/data/overview
- Uso de MessageClient: https://developer.android.com/training/wearables/data/client-types
- Listener de eventos: https://developer.android.com/training/wearables/data/events
- Restricciones de micrófono en segundo plano: https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start
- ACRCloud Music Recognition: https://docs.acrcloud.com/
