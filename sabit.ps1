# ================= BANNER =================
function Mostrar-Banner {
    Clear-Host
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "	  ____      _      ____     _   _____ " -ForegroundColor Cyan
    Write-Host "	 / ___|    / \    | __ \   | | |_   _|" -ForegroundColor Cyan
    Write-Host "	 \___ \   / _ \   |___ /   | |   | |  " -ForegroundColor Cyan
    Write-Host "	  ___) | / ___ \  | __ \   | |   | |  " -ForegroundColor Cyan
    Write-Host "	 \____/ /_/   \_\ |____/   |_|   |_|  " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "         SABIT - SOPTEC TECNICO" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
}

# ================= MENU PRINCIPAL =================
function Menu-Principal {
    Mostrar-Banner

    Write-Host "[1] Informacion del sistema" -ForegroundColor White
    Write-Host "[2] Navegador Predeterminado" -ForegroundColor Yellow
    Write-Host "[3] Internet Explorer Viejo" -ForegroundColor White
    Write-Host "[4] Información de red avanzada" -ForegroundColor Yellow
    Write-Host "[5] Borrar Archivos Temporales" -ForegroundColor Yellow
    Write-Host "[6] -----" -ForegroundColor Yellow
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Selecciona una opcion: " -NoNewline

    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character

    switch ($key) {
        '1' {
            # Ejecutar módulo remoto directamente desde GitHub RAW
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/modulos/informacion_sistema.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '2' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/naveg_predeterminado.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '3' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/internet_explorer_viejo.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '4' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/informacion_red.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '5' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/limpieza_temporales.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '6' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/informacion_red.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '0' {
            Stop-Process -Id $PID
        }
        default {
            Menu-Principal
        }
    }
}

# ================= EJECUTAR MENU =================
Menu-Principal
