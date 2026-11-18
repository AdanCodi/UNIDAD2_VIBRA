@echo off
setlocal
cd /d "%~dp0"
echo =======================================================
echo             VIBRA WEAR - GENERAR 2 APK DEBUG
 echo =======================================================
if not defined JAVA_HOME if exist "C:\Program Files\Android\Android Studio\jbr\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
)
if defined JAVA_HOME set "PATH=%JAVA_HOME%\bin;%PATH%"
where java >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se encontro Java. Usa JDK 17 o 21 desde Android Studio.
    pause
    exit /b 1
)
java -version
set "JAVA_VERSION="
for /f "tokens=3" %%V in ('java -version 2^>^&1 ^| findstr /C:"version"') do set "JAVA_VERSION=%%~V"
if "%JAVA_VERSION:~0,2%"=="25" (
    echo ERROR: Java 25 no es compatible con Gradle 8.13.
    echo Selecciona Gradle JDK 17 o 21 en Android Studio, o fija JAVA_HOME.
    pause
    exit /b 1
)
call gradlew.bat :app:assembleDebug :wear:assembleDebug
if errorlevel 1 (
    echo ERROR: Fallo Gradle. Abre el proyecto en Android Studio y revisa Build Output.
    pause
    exit /b 1
)
if not exist "Entregables" mkdir "Entregables"
copy /Y "app\build\outputs\apk\debug\app-debug.apk" "Entregables\Vibra_Celular_debug.apk" >nul
copy /Y "wear\build\outputs\apk\debug\wear-debug.apk" "Entregables\Vibra_Reloj_debug.apk" >nul
echo.
echo APK para telefono y reloj disponibles en Entregables\
pause
