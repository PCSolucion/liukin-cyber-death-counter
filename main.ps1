$ErrorActionPreference = "SilentlyContinue"
$host.UI.RawUI.WindowTitle = "Cyber Death Widget (JUGANDO)"

# Helper function to find process using port 3000
function Get-PortProcess {
    $found = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
    return $found
}

# 1. Limpieza previa (Matar zombies)
Write-Host "[1/3] Limpiando procesos anteriores..." -ForegroundColor Yellow
$zombies = Get-PortProcess
if ($zombies) {
    # Extract PID and Kill
    $pidToKill = $zombies.OwningProcess
    Stop-Process -Id $pidToKill -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# 2. Iniciar SERVIDOR (Oculto)
Write-Host "[2/3] Iniciando servidor (Oculto)..." -ForegroundColor Green
$serverProcess = Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\server.ps1`"" -WindowStyle Hidden -PassThru

if (!$serverProcess) {
    Write-Host "ERROR CRITICO: No se pudo arrancar el servidor." -ForegroundColor Red
    pause
    exit
}

# Esperar a que arranque
Start-Sleep -Seconds 2

# Verificar si sigue vivo
if ($serverProcess.HasExited) {
    Write-Host "ERROR: El servidor se cerro inesperadamente." -ForegroundColor Red
    Write-Host "Posible causa: Puerto 3000 ocupado o error de script."
    pause
    exit
}

# 3. Iniciar LISTENER (Visible)
Write-Host "[3/3] Iniciando Listener..." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   TODO LISTO. MINIMIZA ESTA VENTANA." -ForegroundColor Cyan
Write-Host "========================================="
Write-Host ""

try {
    & "$PSScriptRoot\key_listener.ps1"
}
finally {
    # Al cerrar ventana, matar servidor
    if ($serverProcess -and -not $serverProcess.HasExited) {
        Stop-Process -Id $serverProcess.Id -Force
    }
}
