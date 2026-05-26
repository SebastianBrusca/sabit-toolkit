# ================= MODULO DESCARGA Y EJECUCION OFFICE =================
Clear-Host
Write-Host "=== DESCARGA DE OFFICE 2024 ===" -ForegroundColor Cyan

$downloadsPath = Join-Path $env:USERPROFILE "Downloads"
$officeInstaller = Join-Path $downloadsPath "OfficeSetup.exe"

$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2024Retail&platform=x64&language=es-es&version=O16GA"

if (Test-Path $officeInstaller) {

    Write-Host "El instalador de Office ya existe en:" -ForegroundColor Yellow
    Write-Host $officeInstaller -ForegroundColor Gray
    Write-Host ""

    Write-Host "[1] Ejecutar instalador existente" -ForegroundColor Green
    Write-Host "[0] Volver al menu anterior" -ForegroundColor Red
    Write-Host ""

    $opcion = Read-Host "Selecciona una opcion"

    switch ($opcion) {
        "1" {
            Write-Host ""
            Write-Host "Iniciando instalador..." -ForegroundColor Cyan

            try {
                Start-Process -FilePath $officeInstaller -Wait
                Write-Host "Instalador ejecutado correctamente." -ForegroundColor Green
            } catch {
                Write-Host "Error al ejecutar el instalador: $($_.Exception.Message)" -ForegroundColor Red
            }

            Read-Host "Presione Enter para volver al menu"
            return
        }

        "0" {
            Write-Host "Volviendo al menu..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            return
        }

        default {
            Write-Host "Opcion no valida. Volviendo al menu..." -ForegroundColor Red
            Start-Sleep -Seconds 1
            return
        }
    }

} else {

    Write-Host "Descargando Office 2024 en $downloadsPath..." -ForegroundColor Cyan

    try {
        Invoke-WebRequest -Uri $officeUrl -OutFile $officeInstaller -UseBasicParsing
        Write-Host "Descarga completada: $officeInstaller" -ForegroundColor Green
    } catch {
        Write-Host "Error al descargar Office: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Presione Enter para volver al menu"
        return
    }

    Write-Host ""
    Write-Host "Iniciando instalador de Office..." -ForegroundColor Cyan

    try {
        Start-Process -FilePath $officeInstaller -Wait
        Write-Host "Instalador ejecutado correctamente." -ForegroundColor Green
    } catch {
        Write-Host "Error al ejecutar el instalador: $($_.Exception.Message)" -ForegroundColor Red
    }

    Read-Host "Presione Enter para volver al menu"
    return
}
