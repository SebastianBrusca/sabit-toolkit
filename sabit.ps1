# ================= MENU PRINCIPAL =================

function Menu-Principal {
    Mostrar-Banner

    Write-Host "[1] Informacion del sistema" -ForegroundColor White
    Write-Host "[2] Navegador Predeterminado" -ForegroundColor Yellow
    Write-Host "[3] Internet Explorer Viejo" -ForegroundColor White
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Selecciona una opcion: " -NoNewline

    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character

    switch ($key) {
        '1' { 
            $scriptPath = Join-Path $PSScriptRoot "modulos\informacion_sistema.ps1"
            if (Test-Path $scriptPath) { & $scriptPath; Menu-Principal } else { Write-Host "Archivo no encontrado: $scriptPath" -ForegroundColor Red; Pause; Menu-Principal }
        }
        '2' {
            $scriptPath = Join-Path $PSScriptRoot "modulos\naveg_predeterminado.ps1"
            if (Test-Path $scriptPath) { & $scriptPath; Menu-Principal } else { Write-Host "Archivo no encontrado: $scriptPath" -ForegroundColor Red; Pause; Menu-Principal }
        }
        '3' {
            $scriptPath = Join-Path $PSScriptRoot "modulos\internet_explorer_viejo.ps1"
            if (Test-Path $scriptPath) { & $scriptPath; Menu-Principal } else { Write-Host "Archivo no encontrado: $scriptPath" -ForegroundColor Red; Pause; Menu-Principal }
        }
        '0' { Stop-Process -Id $PID }
        default { Menu-Principal }
    }
}

# ================= BANNER =================
function Mostrar-Banner {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "	  ____      _      ____     _   _____ " -ForegroundColor Cyan
    Write-Host "	 / ___|    / \    | __ \   | | |_   _|" -ForegroundColor Cyan
    Write-Host "	 \___ \   / _ \   |___ /   | |   | |  " -ForegroundColor Cyan
    Write-Host "	  ___) | / ___ \  | __ \   | |   | |  " -ForegroundColor Cyan
    Write-Host "	 \____/ /_/   \_\ |____/   |_|   |_|  " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "         SABIT - SOPTEC TECNICO" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

# ================= EJECUTAR MENU =================
Menu-Principal
