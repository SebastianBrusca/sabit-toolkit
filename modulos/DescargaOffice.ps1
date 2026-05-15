# ================= MODULO DESCARGA OFFICE =================
Clear-Host
Write-Host "=== DESCARGA DE OFFICE 365 ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario (portable para cualquier PC)
$downloadsPath = [Environment]::GetFolderPath("Downloads")
$officeInstaller = Join-Path $downloadsPath "OfficeSetup.exe"

# URL de descarga directa de Office
$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=es-es&version=O16GA"

# ------------------- Verificar si ya existe el instalador -------------------
if (Test-Path $officeInstaller) {
    Write-Host "⚠️ El instalador de Office ya existe en $officeInstaller" -ForegroundColor Yellow
    Read-Host "Presione Enter para continuar o eliminar el archivo manualmente antes de volver a descargar..."
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

# Mensaje final
Write-Host "`nLa descarga de Office 365 ha finalizado." -ForegroundColor Green
Write-Host "Puedes iniciar la instalación ejecutando: $officeInstaller"
Read-Host "Presione Enter para volver al menú..."
