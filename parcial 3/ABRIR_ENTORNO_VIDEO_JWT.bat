@echo off
chcp 65001 > nul
title Preparación de Entorno para Grabación de Video - Taller JWT (Parcial 3)
color 0B

echo ================================================================
echo   🚀 INICIANDO ENTORNO COMPLETO PARA GRABAR EL VIDEO (TALLER JWT)
echo ================================================================
echo.

echo 1. Abriendo Visual Studio Code en la carpeta del Taller JWT...
start "" code "F:\Users\Max\Desktop\moviles\parcial 2\parcial 3"

echo 2. Abriendo DB Browser for SQLite con la base de datos de usuarios y productos...
if exist "F:\Users\Max\Desktop\moviles\DBBrowser\DB Browser for SQLite.exe" (
    start "" "F:\Users\Max\Desktop\moviles\DBBrowser\DB Browser for SQLite.exe" "F:\Users\Max\Desktop\moviles\parcial 2\parcial 3\backend\database.sqlite"
)

echo 3. Abriendo Postman...
if exist "C:\Users\Max\AppData\Local\Postman\Postman.exe" (
    start "" "C:\Users\Max\AppData\Local\Postman\Postman.exe"
) else (
    start "" postman
)

echo 4. Iniciando el Backend con seguridad JWT en una ventana dedicada...
start "Backend JWT API REST (Puerto 3000)" cmd /k "cd /d F:\Users\Max\Desktop\moviles\parcial 2\parcial 3\backend && npm run dev"

echo.
echo ================================================================
echo   ✅ Herramientas abiertas:
echo      - VS Code (Código Backend JWT y Frontend Flutter)
echo      - DB Browser for SQLite (Tabla usuarios y productos)
echo      - Postman (Colección Taller JWT lista)
echo      - Ventana del Servidor Backend en ejecución
echo ================================================================
echo.
echo Presiona cualquier tecla para ejecutar la aplicación Flutter...
pause > nul

cd /d "F:\Users\Max\Desktop\moviles\parcial 2\parcial 3\frontend"
flutter run
