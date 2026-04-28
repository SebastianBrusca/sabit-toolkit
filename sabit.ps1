# =============================================
# Gestión de permisos de administrador (Compatible con IEX / Web)

$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-NOT $esAdmin) {
    Clear-Host
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: NO SE ESTÁ EJECUTANDO COMO ADMINISTRADOR" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "[1] Reintentar como Administrador (Nueva ventana)" -ForegroundColor White
    Write-Host "[2] Continuar con funciones limitadas" -ForegroundColor Yellow
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Selecciona una opción: " -NoNewline
    
    $opcion = Read-Host

    switch ($opcion) {
        '1' {
            $urlRepo = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1"
            $comando = "iex (irm $urlRepo)"
            
            try {
                Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", $comando -Verb RunAs
                exit
            } catch {
                Write-Host "`nError: No se pudo elevar privilegios o abrir la ventana." -ForegroundColor Orange
                Start-Sleep -Seconds 2
            }
        } 
        '2' {
            Write-Host " Cargando modo limitado..." -ForegroundColor Gray
            Start-Sleep -Seconds 1
        }
        '0' {
            exit
        }
        default {
            Write-Host "Opción no válida." -ForegroundColor Red
            Start-Sleep -Seconds 1
            & $MyInvocation.MyCommand.Definition
            exit
        }
    }
}

# ================= BANNER =================
function Mostrar-Banner {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "         ____      _      ____     _   _____ " -ForegroundColor Cyan
    Write-Host "        / ___|    / \    | __ \   | | |_   _|" -ForegroundColor Cyan
    Write-Host "        \___ \   / _ \   |___ /   | |   | |  " -ForegroundColor Cyan
    Write-Host "         ___) | / ___ \  | __ \   | |   | |  " -ForegroundColor Cyan
    Write-Host "        \____/ /_/   \_\ |____/   |_|   |_|  " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "          SABIT - SOPORTE TECNICO" -ForegroundColor Green
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

    # Cuarta línea: opciones 7 y 8
    Write-Host "[9] Version de Windows y Java" -ForegroundColor White -NoNewline
    Write-Host "   [10] Estado de seguridad" -ForegroundColor Yellow
    Write-Host ""  # línea en blanco

    # Salir
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""  # línea en blanco
    Write-Host "Selecciona una opcion y presiona Enter: " -NoNewline


    $key = Read-Host

    switch ($key) {
        '1' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/modulos/informacion_sistema.ps1") }
        '2' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/naveg_predeterminado.ps1") }
        '3' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/internet_explorer_viejo.ps1") }
        '4' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/informacion_red.ps1") }
        '5' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/limpieza_temporales.ps1") }
        '6' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/reinicio_servicios.ps1") }
        '7' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/limpieza_navegadores.ps1") }
        '8' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/software_instalado.ps1") }
        '9' { Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/InfoVersiones.ps1") }
        '10'{ Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/main/modulos/EstadoSeguridad.ps1") }
        '0' { Stop-Process -Id $PID }
        default { Write-Host "Opción no válida." -ForegroundColor Red; Start-Sleep 1 }
    }

    Menu-Principal
}

# ================= EJECUTAR MENU =================
Menu-Principal
