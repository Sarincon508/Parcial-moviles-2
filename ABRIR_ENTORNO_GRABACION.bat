@echo off
chcp 65001 > nul
title Preparación de Entorno para Video - Parcial 2 Móviles
color 0A

echo ================================================================
echo   🚀 INICIANDO ENTORNO COMPLETO PARA GRABAR EL VIDEO
echo ================================================================
echo.

echo 1. Abriendo Visual Studio Code con el proyecto...
start "" code "F:\Users\Max\Desktop\moviles\parcial 2"

echo 2. Abriendo DB Browser for SQLite con la base de datos cargada...
start "" "F:\Users\Max\Desktop\moviles\DBBrowser\DB Browser for SQLite.exe" "F:\Users\Max\Desktop\moviles\parcial 2\backend\database.sqlite"

echo 3. Abriendo Postman...
if exist "C:\Users\Max\AppData\Local\Postman\Postman.exe" (
    start "" "C:\Users\Max\AppData\Local\Postman\Postman.exe"
) else (
    start "" postman
)

echo 4. Iniciando el Emulador Android (Pixel 7)...
start "" "F:\Android\Sdk\emulator\emulator.exe" -avd Pixel_7_API_34

echo 5. Iniciando el Backend Node.js en una ventana dedicada...
start "Backend API REST (Puerto 3000)" cmd /k "cd /d F:\Users\Max\Desktop\moviles\parcial 2\backend && npm start"

echo.
echo ================================================================
echo   ✅ Todas las aplicaciones han sido abiertas en tu pantalla:
echo      - VS Code (Código del Backend y Frontend)
echo      - DB Browser for SQLite (Visor visual de database.sqlite)
echo      - Postman (Para probar los endpoints)
echo      - Emulador Android Pixel 7
echo      - Ventana del Servidor Backend
echo ================================================================
echo.
echo Presiona cualquier tecla para lanzar la app Flutter en el emulador...
pause > nul

cd /d "F:\Users\Max\Desktop\moviles\parcial 2\frontend"
flutter run
