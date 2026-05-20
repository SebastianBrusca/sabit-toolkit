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
    Write-Host "⚠️ El instalador de Office ya existe en $officeInstaller" -ForegroundColor Yellow
    $continue = Read-Host "Presione Enter para continuar y ejecutar el instalador, o cancelar con Ctrl+C..."
} else {
    Write-Host "Descargando Office 365 en $downloadsPath..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $officeUrl -OutFile $officeInstaller -UseBasicParsing
        Write-Host "✅ Descarga completada: $officeInstaller" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Error al descargar Office: $_" -ForegroundColor Red
        Read-Host "Presione Enter para cerrar el script..."
        return
    }
}

# ------------------- Ejecutar instalador -------------------
Write-Host "`nIniciando instalación de Office 365..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $officeInstaller -Wait
    Write-Host "✅ Instalación finalizada o iniciada correctamente." -ForegroundColor Green
} catch {
    Write-Host "⚠️ Error al ejecutar el instalador: $_" -ForegroundColor Red
}

Read-Host "Presione Enter para volver al menú..."
