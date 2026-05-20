# ================= MODULO ANYDESK =================
Clear-Host
Write-Host "=== DESCARGA E INSTALACIÓN DE ANYDESK (INSTALACIÓN DEFINITIVA) ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDeskSetup.exe"

# URL del instalador completo de AnyDesk (64-bit Windows)
$anydeskUrl = "https://download.anydesk.com/AnyDesk_7.7.1.exe"  # Cambiar a la versión más reciente si se necesita

# Ruta típica de instalación definitiva de AnyDesk
$installPath = "C:\Program Files\AnyDesk\AnyDesk.exe"

# ------------------- Verificar si AnyDesk ya está instalado -------------------
if (Test-Path $installPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  AnyDesk ya está instalado en $installPath" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "`n❗ Para actualizar la contraseña o permisos, abra AnyDesk manualmente." -ForegroundColor Yellow
    Read-Host "Presione Enter para continuar..."
} else {
    # ------------------- Descargar el instalador completo -------------------
    Write-Host "Descargando AnyDesk completo en $downloadsPath..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "Descarga completada: $anydeskPath" -ForegroundColor Green

    # ------------------- Instalar AnyDesk con contraseña y permisos totales -------------------
    Write-Host "Instalando AnyDesk con acceso total y contraseña '*Gemez$$'..." -ForegroundColor Cyan
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent --set-password *Gemez$$ --grant-elevated-permissions" -Wait
    Write-Host "✅ AnyDesk instalado y configurado correctamente." -ForegroundColor Green

    # Limpiar instalador temporal
    Remove-Item $anydeskPath -Force
}

# Mensaje final
Write-Host "`n✅ Proceso completado." -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
