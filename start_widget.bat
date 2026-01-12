@echo off
cd /d "%~dp0"

:: Check Admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    EXIT /B
)

:: Ejecutar el script unificado
powershell -NoProfile -ExecutionPolicy Bypass -File main.ps1
