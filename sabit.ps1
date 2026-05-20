# =============================================
# Gestión de permisos de administrador (Compatible con IEX / Web)
# ================= DEFINIR RAMA =================
$branch = "SABIT-0.2"  # Cambiás a "main" cuando quieras publicar
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

# ================= EFECTOS =================
# --- Efecto escritura para banner ---
function Type-Text {
    param (
        [string]$text,
        [string]$color = "Cyan",
        [int]$speed = 5  # ms entre caracteres
    )

    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor $color
        Start-Sleep -Milliseconds $speed
    }
    Write-Host ""
}

# --- Efecto Matrix previo al banner ---
function Matrix-Effect {
    param (
        [int]$iterations = 100
    )

    for ($i = 0; $i -lt $iterations; $i++) {
        $randomChar = -join ((48..57 + 65..90 + 97..122) | Get-Random -Count 1 | % {[char]$_})
        Write-Host $randomChar -ForegroundColor Green -NoNewline
        Start-Sleep -Milliseconds 15
    }
    Write-Host ""
}

# ================= BANNER =================
function Mostrar-Banner {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Cyan
    Type-Text "         ____      _      ____     _   _____ " "Cyan" 10
    Type-Text "        / ___|    / \    | __ \   | | |_   _|" "Cyan" 10
    Type-Text "        \___ \   / _ \   |___ /   | |   | |  " "Cyan" 10
    Type-Text "         ___) | / ___ \  | __ \   | |   | |  " "Cyan" 10
    Type-Text "        \____/ /_/   \_\ |____/   |_|   |_|  " "Cyan" 10
    Write-Host ""
    Type-Text "              SABIT - SOPORTE TECNICO " "Green" 15
    Write-Host "====================================================" -ForegroundColor Cyan
    Type-Text "                    Version 0.37 " "Green" 10
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host ""
}

# ================= MENU PRINCIPAL =================
function Menu-Principal {
    $salir = $false

    # Efecto Matrix al iniciar
    Matrix-Effect -iterations 100

    while (-not $salir) {
        Clear-Host
        Mostrar-Banner
        
        Write-Host "[1] Mantenimiento Menu      [2] Activador Win/Office" -ForegroundColor White
        Write-Host ""
        Write-Host "[3] IE Viejo                [4] Descarga Office " -ForegroundColor White
        Write-Host "" 
        Write-Host "[5] Software Instalado      [6] BalanzaWMS" -ForegroundColor White
        Write-Host ""
        Write-Host "[7] Anydesk                 [8] Calipso A/D   " -ForegroundColor White
        Write-Host ""
        Write-Host "[0] Salir" -ForegroundColor Red
        Write-Host ""
        $key = Read-Host "Selecciona una opción"

        if ($key -eq '0') { 
            Clear-Host
            Write-Host "Saliendo..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            exit
        }

        # Diccionario de URLs para mantener el switch limpio
        $urls = @{
            '1' = "MantenimientoMenu.ps1"
            '2' = "Activador-Win-Office.ps1"
            '3' = "internet_explorer_viejo.ps1"
            '4' = "DescargaOffice.ps1"
            '5' = "software_instalado.ps1"
            '6' = "BalanzaWMS.ps1"
            '7' = "Anydesk.ps1"
            '8' = "CalipsoAccesoDirecto.ps1"
        }

        if ($urls.ContainsKey($key)) {
            $fullUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/$branch/modulos/$($urls[$key])"
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

# ================= EJECUTAR MENU =================
Menu-Principal
