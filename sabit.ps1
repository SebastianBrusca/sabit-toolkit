# =============================================
# Gestión de permisos de administrador

$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-NOT $esAdmin) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: NO SE ESTÁ EJECUTANDO COMO ADMINISTRADOR" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "1. Reintentar como Administrador (abre nueva ventana)"
    Write-Host "2. Continuar con funciones limitadas (en esta ventana)"
    Write-Host "0. Salir"
    Write-Host ""
    
    $opcionAdmin = Read-Host "Selecciona una opción"

    if ($opcionAdmin -eq "1") {
        Start-Process powershell.exe -ArgumentList "-NoExit", "-File `"$PSCommandPath`"" -Verb RunAs
        exit # Cerramos la ventana sin permisos porque abrimos la nueva
    } elseif ($opcionAdmin -eq "0") {
        exit
    }
    # Si elige 2, el script simplemente sigue bajando hacia el Menú
}
# ================= BANNER =================
function Mostrar-Banner {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "	  ____      _      ____     _   _____ " -ForegroundColor Cyan
    Write-Host "	 / ___|    / \    | __ \   | | |_   _|" -ForegroundColor Cyan
    Write-Host "	 \___ \   / _ \   |___ /   | |   | |  " -ForegroundColor Cyan
    Write-Host "	  ___) | / ___ \  | __ \   | |   | |  " -ForegroundColor Cyan
    Write-Host "	 \____/ /_/   \_\ |____/   |_|   |_|  " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "         SABIT - SOPORTE TECNICO" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host ""
}

# ================= MENU PRINCIPAL =================
function Menu-Principal {
    Mostrar-Banner

    # Primera línea: opciones 1 y 2
    Write-Host "[1] Información del sistema" -ForegroundColor White -NoNewline
    Write-Host "   [2] Navegador Predeterminado" -ForegroundColor Yellow
    Write-Host ""  # línea en blanco

    # Segunda línea: opciones 3 y 4
    Write-Host "[3] Internet Explorer Viejo" -ForegroundColor White -NoNewline
    Write-Host "   [4] Información de red avanzada" -ForegroundColor Yellow
    Write-Host ""  # línea en blanco

    # Tercera línea: opciones 5 y 6
    Write-Host "[5] Borrar Archivos Temporales" -ForegroundColor White -NoNewline
    Write-Host "   [6] Reinicio de servicios" -ForegroundColor Yellow
    Write-Host ""  # línea en blanco

    # Cuarta línea: opciones 7 y 8
    Write-Host "[7] Limpieza avanzada de navegadores" -ForegroundColor White -NoNewline
    Write-Host "   [8] Software instalado" -ForegroundColor Yellow
    Write-Host ""  # línea en blanco

    # Salir
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""  # línea en blanco
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
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/reinicio_servicios.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '7' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/limpieza_navegadores.ps1"
            try {
                Invoke-Expression (Invoke-RestMethod $url)
            } catch {
                Write-Host "Error al cargar módulo: $url" -ForegroundColor Red
                Pause
            }
            Menu-Principal
        }
        '8' {
            $url = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/software_instalado.ps1"
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
