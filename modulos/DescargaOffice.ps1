# ================= MODULO DESCARGA Y EJECUCION OFFICE =================

param(
    [switch]$UseBasicParsing
)

Clear-Host

Write-Host "=== DESCARGA DE OFFICE 2024 ===" -ForegroundColor Cyan
Write-Host ""

# Carpeta de descargas
$downloadsPath = Join-Path $env:USERPROFILE "Downloads"

# Crear carpeta si no existe
if (-not (Test-Path $downloadsPath)) {
    New-Item -Path $downloadsPath -ItemType Directory -Force | Out-Null
}

# Nombre del instalador
$officeInstaller = Join-Path $downloadsPath "OfficeSetup.exe"

# URL oficial de descarga de Office
$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2024Retail&platform=x64&language=es-es&version=O16GA"


# ============================================================
# SI EL INSTALADOR YA EXISTE
# ============================================================

if (Test-Path $officeInstaller) {

    Write-Host "El instalador de Office ya existe:" -ForegroundColor Yellow
    Write-Host $officeInstaller -ForegroundColor Gray
    Write-Host ""

    Write-Host "[1] Ejecutar instalador existente" -ForegroundColor Green
    Write-Host "[2] Descargar nuevamente" -ForegroundColor Cyan
    Write-Host "[0] Volver al menu anterior" -ForegroundColor Red
    Write-Host ""

    $opcion = Read-Host "Selecciona una opcion"

    switch ($opcion) {

        "1" {

            Write-Host ""
            Write-Host "Iniciando instalador de Office..." -ForegroundColor Cyan
            Write-Host ""

            try {

                Start-Process -FilePath $officeInstaller -Wait -ErrorAction Stop

                Write-Host ""
                Write-Host "Instalador ejecutado correctamente." -ForegroundColor Green

            }
            catch {

                Write-Host ""
                Write-Host "Error al ejecutar el instalador:" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
            }

            Write-Host ""
            Read-Host "Presione Enter para volver al menu"
            return
        }


        "2" {

            Write-Host ""
            Write-Host "Eliminando instalador anterior..." -ForegroundColor Yellow

            try {
                Remove-Item -Path $officeInstaller -Force -ErrorAction Stop
                Write-Host "Instalador anterior eliminado." -ForegroundColor Green
            }
            catch {
                Write-Host "No se pudo eliminar el instalador anterior." -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red

                Read-Host "Presione Enter para volver al menu"
                return
            }
        }


        "0" {

            Write-Host ""
            Write-Host "Volviendo al menu..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            return
        }


        default {

            Write-Host ""
            Write-Host "Opcion no valida. Volviendo al menu..." -ForegroundColor Red
            Start-Sleep -Seconds 1
            return
        }
    }
}


# ============================================================
# DESCARGA DE OFFICE
# ============================================================

if (-not (Test-Path $officeInstaller)) {

    Write-Host ""
    Write-Host "Descargando Office 2024..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Destino:" -ForegroundColor Gray
    Write-Host $officeInstaller -ForegroundColor Gray
    Write-Host ""

    try {

        # Compatible con PowerShell 5.1 y PowerShell 7+
        Invoke-WebRequest `
            -Uri $officeUrl `
            -OutFile $officeInstaller `
            -ErrorAction Stop

        Write-Host ""
        Write-Host "Descarga completada correctamente." -ForegroundColor Green
        Write-Host $officeInstaller -ForegroundColor Gray
    }
    catch {

        Write-Host ""
        Write-Host "ERROR AL DESCARGAR OFFICE" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""

        # Eliminar archivo incompleto si quedó creado
        if (Test-Path $officeInstaller) {
            Remove-Item $officeInstaller -Force -ErrorAction SilentlyContinue
        }

        Read-Host "Presione Enter para volver al menu"
        return
    }
}


# ============================================================
# VERIFICAR INSTALADOR
# ============================================================

if (-not (Test-Path $officeInstaller)) {

    Write-Host ""
    Write-Host "No se encontró el instalador de Office." -ForegroundColor Red
    Write-Host ""

    Read-Host "Presione Enter para volver al menu"
    return
}


# ============================================================
# EJECUTAR INSTALADOR
# ============================================================

Write-Host ""
Write-Host "Iniciando instalador de Office 2024..." -ForegroundColor Cyan
Write-Host ""

try {

    Start-Process `
        -FilePath $officeInstaller `
        -Wait `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "Instalador ejecutado correctamente." -ForegroundColor Green
}
catch {

    Write-Host ""
    Write-Host "ERROR AL EJECUTAR OFFICE" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Read-Host "Presione Enter para volver al menu"
return
