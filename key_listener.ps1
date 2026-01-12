Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class User32 {
        [DllImport("user32.dll")]
        public static extern short GetAsyncKeyState(int vKey);
    }
"@

# Códigos de Teclas Virtuales
$VK_NUMPAD9 = 0x69  # Sumar
$VK_NUMPAD7 = 0x67  # Restar

# Estado previo de teclas
$pressed9 = $false
$pressed7 = $false

Write-Host "Cyber Death Listener ACTIVADO" -ForegroundColor Cyan
Write-Host "Teclas: [NumPad 9] = +1 Muerte | [NumPad 7] = -1 Muerte" -ForegroundColor Cyan
Write-Host "Minimiza esta ventana."

while ($true) {
    # Detectar estados
    $state9 = [User32]::GetAsyncKeyState($VK_NUMPAD9)
    $state7 = [User32]::GetAsyncKeyState($VK_NUMPAD7)
    
    # Check bit significacivo (0x8000)
    $isDown9 = ($state9 -band 0x8000) -eq 0x8000
    $isDown7 = ($state7 -band 0x8000) -eq 0x8000
    
    # ------------------
    # Lógica Boton 9 (+)
    # ------------------
    if ($isDown9 -and -not $pressed9) {
        $pressed9 = $true
        # Evento: Sumar
        try {
            Invoke-RestMethod -Uri "http://localhost:3000/api/increment" -Method Post -TimeoutSec 1 -ErrorAction Stop | Out-Null
            Write-Host "[+] Muerte Sumada" -ForegroundColor Red
        }
        catch {}
    }
    elseif (-not $isDown9) {
        $pressed9 = $false
    }
    
    # ------------------
    # Lógica Boton 7 (-)
    # ------------------
    if ($isDown7 -and -not $pressed7) {
        $pressed7 = $true
        # Evento: Restar
        try {
            Invoke-RestMethod -Uri "http://localhost:3000/api/decrement" -Method Post -TimeoutSec 1 -ErrorAction Stop | Out-Null
            Write-Host "[-] Muerte Restada" -ForegroundColor Green
        }
        catch {}
    }
    elseif (-not $isDown7) {
        $pressed7 = $false
    }
    
    Start-Sleep -Milliseconds 50
}
