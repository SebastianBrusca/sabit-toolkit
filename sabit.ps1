# =============================================
# Gestión de permisos de administrador (Compatible con IEX / Web)
# ================= DEFINIR RAMA =================
$branch = "SABIT-0.1"  # Cambiás a "main" cuando quieras publicar
# =============================================
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
            $urlRepo = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/$branch/sabit.ps1"
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
    $salir = $false
    while (-not $salir) {
        Clear-Host
        Mostrar-Banner
        
        Write-Host "[1] Info Sistema      [2] Nav. Predeterminado" -ForegroundColor Yellow
        Write-Host "[3] IE Viejo          [4] Red Avanzada" -ForegroundColor Yellow
        Write-Host "[5] Borrar Temporales [6] Reinicio Servicios" -ForegroundColor Yellow
        Write-Host "[7] Limpieza Nav.     [8] Software Instalado" -ForegroundColor Yellow
        Write-Host "[9] Win y Java        [10] Seguridad" -ForegroundColor Yellow
        Write-Host "[0] Salir" -ForegroundColor Red
        Write-Host ""
        $key = Read-Host "Selecciona una opción"

        if ($key -eq '0') { 
            $salir = $true
            break 
        }

        # Diccionario de URLs para mantener el switch limpio
        $urls = @{
            '1' = "informacion_sistema.ps1"
            '2' = "naveg_predeterminado.ps1"
            '3' = "internet_explorer_viejo.ps1"
            '4' = "informacion_red.ps1"
            '5' = "limpieza_temporales.ps1"
            '6' = "reinicio_servicios.ps1"
            '7' = "limpieza_navegadores.ps1"
            '8' = "software_instalado.ps1"
            '9' = "InfoVersiones.ps1"
            '10'= "EstadoSeguridad.ps1"
        }

        if ($urls.ContainsKey($key)) {
            $fullUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/modulos/$($urls[$key])"
            try {
                $scriptContent = Invoke-RestMethod -Uri $fullUrl -UseBasicParsing
                Clear-Host
                # Forzamos la ejecución en un ámbito limpio
                & ([scriptblock]::Create($scriptContent))
            } catch {
                Write-Host "Error al cargar el módulo: $_" -ForegroundColor Red
            }
            Write-Host "`nPresiona Enter para volver..." -ForegroundColor Cyan
            Read-Host
        } else {
            Write-Host "Opción no válida" -ForegroundColor Red
            Start-Sleep 1
        }
    }
}
Menu-Principal
