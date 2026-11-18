# VIBRA WEAR — Android + Wear OS

**Caso de estudio:** reconocimiento de canciones solicitado desde reloj inteligente y realizado por el celular Android con ACRCloud.

El proyecto contiene dos módulos Android Studio:

- `:app` — Vibra para celular con interfaz y reconocimiento musical existente, ampliada con receptor de solicitudes del reloj.
- `:wear` — Vibra Watch, app para reloj inteligente con interfaz circular, icono, estado de conexión, botón de reconocimiento y resultado.

## Instalación

1. Abre esta **carpeta completa** en Android Studio. Usa Gradle JDK 17 o 21, SDK 36 y conexión a internet para las dependencias iniciales.
2. En Device Manager inicia un teléfono y un reloj Wear OS compatible con Google Play Services.
3. Vincúlalos con Wear OS / Wear OS Pairing Assistant.
4. Ejecuta `app` en el **teléfono** y `wear` en el **reloj**.
5. En Ajustes del celular configura ACRCloud; concede micrófono y notificaciones.
6. En reloj pulsa el icono Vibra; abre la notificación del celular, donde se hará la grabación. El resultado volverá al reloj.

## APK (después de compilar)

Ejecuta `Generar_APKs_Windows.bat` desde el Explorador o desde CMD en esta carpeta. Copia APKs a `Entregables/` únicamente cuando Gradle termina correctamente. Alternativa:

`gradlew.bat :app:assembleDebug :wear:assembleDebug`

- Celular: `app/build/outputs/apk/debug/app-debug.apk`
- Reloj: `wear/build/outputs/apk/debug/wear-debug.apk`

Ambos deben estar firmados con el mismo certificado. No están incluidos APK ya compilados porque no se cuenta con el SDK Android de compilación en este entorno.

## Archivos para entregar

- `CASO_DE_ESTUDIO_WEAR.md`: informe del proyecto y pruebas pendientes.
- `CODIGO_FUENTE_COMPLETO.txt`: código íntegro en texto plano.
- `app/`, `wear/`: código fuente real, Gradle y recursos.
- `Generar_APKs_Windows.bat`: generador automático de APK para Windows.
- `wear/src/main/res/mipmap-xxxhdpi/ic_launcher.png`: icono reloj.

## Conectividad

Usa Data Layer de Google Play Services, no conexiones Bluetooth directas. Mismo `applicationId=com.vibra.app`, misma firma en los dos dispositivos. `MessageClient` solicita reconocimiento; `DataClient` envía estado/resultados. La captura de audio se inicia en primer plano en el teléfono por restricciones del sistema Android.
