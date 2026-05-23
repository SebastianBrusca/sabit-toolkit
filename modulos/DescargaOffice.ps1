# ================= MODULO DESCARGA Y EJECUCION OFFICE =================
Clear-Host
Write-Host "=== DESCARGA DE OFFICE 365 ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario
$downloadsPath = Join-Path $env:USERPROFILE "Downloads"
$officeInstaller = Join-Path $downloadsPath "OfficeSetup.exe"

# URL de descarga directa de Office
$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2024Retail&platform=x64&language=es-es&version=O16GA"

# ------------------- Verificar si ya existe el instalador -------------------
if (Test-Path $officeInstaller) {

    Write-Host "⚠️ El instalador de Office ya existe en:" -ForegroundColor Yellow
    Write-Host "$officeInstaller" -ForegroundColor Gray
    Write-Host ""

    Write-Host "[1] Ejecutar instalador existente" -ForegroundColor Green
    Write-Host "[0] Volver al menu anterior" -ForegroundColor Red
    Write-Host ""

    $opcion = Read-Host "Selecciona una opcion"

    switch ($opcion) {

        '1' {
            Write-Host "`nIniciando instalador..." -ForegroundColor Cyan

            try {
                Start-Process -FilePath $officeInstaller -Wait
                Write-Host "✅ Instalacion finalizada o iniciada correctamente." -ForegroundColor Green
            } catch {
                Write-Host "⚠️ Error al ejecutar el instalador: $_" -ForegroundColor Red
            }

            Read-Host "`nPresione Enter para volver al menu..."
            return
        }

        '0' {
            Write-Host "Volviendo al menu..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            return
        }

        default {
            Write-Host "⚠️ Opcion no valida." -ForegroundColor Red
            Start-Sleep -Seconds 1
            return
        }
    }

} else {

# ------------------- Ejecutar instalador -------------------
Write-Host "`nIniciando instalación de Office 365..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $officeInstaller -Wait
    Write-Host "✅ Instalación finalizada o iniciada correctamente." -ForegroundColor Green
} catch {
    Write-Host "⚠️ Error al ejecutar el instalador: $_" -ForegroundColor Red
}

Read-Host "Presione Enter para volver al menú..."
