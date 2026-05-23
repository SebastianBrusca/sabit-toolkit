# =============================================
# Gestion de permisos de administrador Compatible con IEX / Web
# ================= DEFINIR RAMA =================
$branch = "main2"
# =============================================

$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-NOT $esAdmin) {
    Clear-Host
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: NO SE ESTA EJECUTANDO COMO ADMINISTRADOR" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "[1] Reintentar como Administrador Nueva ventana" -ForegroundColor White
    Write-Host "[2] Continuar con funciones limitadas" -ForegroundColor Yellow
    Write-Host "[0] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Selecciona una opcion: " -NoNewline

    $opcion = Read-Host

    switch ($opcion) {
        '1' {
            $urlRepo = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/$branch/sabit.ps1"
            $comando = "iex (irm $urlRepo)"

            try {
                Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", $comando -Verb RunAs
                exit
            } catch {
                Write-Host "`nError: No se pudo elevar privilegios o abrir la ventana." -ForegroundColor DarkYellow
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
            Write-Host "Opcion no valida." -ForegroundColor Red
            Start-Sleep -Seconds 1
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
    Write-Host "              SABIT - SOPORTE TECNICO " -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "             Version 0.64             Hora: " -NoNewline -ForegroundColor Green
    Write-Host $hora -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host ""
}

# ================= ACTUALIZAR HORA Y LEER OPCION =================
function Leer-Opcion-Con-Hora {
    Write-Host "Selecciona una opcion: " -NoNewline -ForegroundColor White

    $inputX = [Console]::CursorLeft
    $inputY = [Console]::CursorTop

    # Ajustado para tu banner actual
    $horaX = 49
    $horaY = 8

    while ($true) {

        # Actualiza solo los numeros de la hora
        [Console]::SetCursorPosition($horaX, $horaY)
        Write-Host "$(Get-Date -Format 'HH:mm:ss')" -NoNewline -ForegroundColor Green

        # Vuelve al input
        [Console]::SetCursorPosition($inputX, $inputY)

        if ([Console]::KeyAvailable) {
            $tecla = [Console]::ReadKey($true)

            if ($tecla.Key -eq 'Enter') {
                continue
            }

            $key = $tecla.KeyChar
            Write-Host $key -ForegroundColor Cyan
            return $key
        }

        Start-Sleep -Milliseconds 200
    }
}

# ================= SPINNER ANIMADO =================
function Mostrar-Spinner {
    param (
        [string]$Mensaje = "Cargando",
        [int]$Duracion = 3
    )

    $frames = @('|', '/', '-', '\')
    $endTime = (Get-Date).AddSeconds($Duracion)

    while ((Get-Date) -lt $endTime) {
        foreach ($frame in $frames) {
            Write-Host "`r$Mensaje... $frame" -NoNewline -ForegroundColor Cyan
            Start-Sleep -Milliseconds 120
        }
    }

    Write-Host "`r$Mensaje... OK " -ForegroundColor Green
}

# ================= MENU PRINCIPAL =================
function Menu-Principal {
    $salir = $false

    while (-not $salir) {
        Clear-Host
        Mostrar-Banner

        Write-Host "[1] Mantenimiento Menu      [2] Activador Win/Office" -ForegroundColor White
        Write-Host ""
        Write-Host "[3] IE Viejo                [4] Descarga Office 2024 " -ForegroundColor White
        Write-Host ""
        Write-Host "[5] Software Instalado      [6] BalanzaWMS" -ForegroundColor White
        Write-Host ""
        Write-Host "[7] Anydesk                 [8] Calipso A/D" -ForegroundColor White
        Write-Host ""
        Write-Host "[0] Salir" -ForegroundColor Red
        Write-Host ""

        $key = Leer-Opcion-Con-Hora

        if ($key -eq '0') {
            Clear-Host
            Write-Host "Saliendo..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            exit
        }

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
                Clear-Host
                Mostrar-Banner
                Mostrar-Spinner "Cargando modulo"

                $scriptContent = Invoke-RestMethod -Uri $fullUrl -UseBasicParsing

                Clear-Host
                & ([scriptblock]::Create($scriptContent))
            } catch {
                Write-Host "Error al cargar el modulo: $_" -ForegroundColor Red
            }

            Write-Host "`nPresiona Enter para volver..." -ForegroundColor Cyan
            Read-Host
        } else {
            Write-Host "Opcion no valida" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}

# ================= EJECUTAR MENU =================
Menu-Principal
