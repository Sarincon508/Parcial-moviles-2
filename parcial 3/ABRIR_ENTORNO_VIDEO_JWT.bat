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

echo 4. Iniciando el Backend en una ventana dedicada...
start "Backend JWT API REST (Puerto 3000)" cmd /k "cd /d ""%BASE_DIR%backend"" && npm run dev"

echo.
echo ================================================================
echo   Herramientas iniciadas exitosamente:
echo   - VS Code (Codigo Backend y Frontend)
echo   - DB Browser for SQLite (Tabla usuarios y productos)
echo   - Postman (Coleccion Taller JWT lista)
echo   - Ventana del Servidor Backend en ejecucion
echo ================================================================
echo.
echo Presiona cualquier tecla para ejecutar la app Flutter...
pause > nul

cd /d "%BASE_DIR%frontend"
flutter run