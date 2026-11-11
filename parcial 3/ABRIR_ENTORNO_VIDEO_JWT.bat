@echo off
chcp 65001 > nul
title Preparacion de Entorno para Video - Taller JWT Parcial 3
color 0B

set "BASE_DIR=%~dp0"

echo ================================================================
echo   INICIANDO ENTORNO COMPLETO PARA GRABAR EL VIDEO (TALLER JWT)
echo ================================================================
echo.

echo 1. Abriendo Visual Studio Code en la carpeta del Taller JWT...
start "" code "%BASE_DIR%"

echo 2. Abriendo DB Browser for SQLite con la base de datos...
if exist "F:\Users\Max\Desktop\moviles\DBBrowser\DB Browser for SQLite.exe" (
    start "" "F:\Users\Max\Desktop\moviles\DBBrowser\DB Browser for SQLite.exe" "%BASE_DIR%backend\database.sqlite"
)

echo 3. Abriendo Postman...
if exist "%LOCALAPPDATA%\Postman\Postman.exe" (
    start "" "%LOCALAPPDATA%\Postman\Postman.exe"
) else (
    start "" postman
)

echo 4. Iniciando el Emulador Android Pixel 7...
if exist "F:\Android\Sdk\emulator\emulator.exe" (
    start "" "F:\Android\Sdk\emulator\emulator.exe" -avd Pixel_7_API_34
)

echo 5. Iniciando el Backend JWT en una ventana dedicada...
start "Backend JWT API REST (Puerto 3000)" cmd /k "cd /d ""%BASE_DIR%backend"" && npm run dev"

echo.
echo ================================================================
echo   Herramientas iniciadas en tu pantalla:
echo   - VS Code (Codigo Backend y Frontend)
echo   - DB Browser for SQLite (Tabla usuarios y productos)
echo   - Postman (Para pruebas con la URL de Render o Local)
echo   - Emulador Android Pixel 7 (iniciando...)
echo   - Servidor Backend Node.js en http://localhost:3000
echo ================================================================
echo.
echo [PASO OBLIGATORIO ANTES DE CONTINUAR]:
echo 1. Mira tu pantalla y verifica que el Emulador Pixel 7 haya terminado de encender.
echo 2. Cuando veas la pantalla de inicio de Android (los iconos del celular),
echo    presiona cualquier tecla en esta ventana para abrir la app Flutter...
echo.
pause > nul

cd /d "%BASE_DIR%frontend"
echo Lanzando aplicacion en el Emulador Android...
flutter run -d android
if errorlevel 1 (
    echo No se detecto el emulador automaticamente, seleccionando dispositivo...
    flutter run
)