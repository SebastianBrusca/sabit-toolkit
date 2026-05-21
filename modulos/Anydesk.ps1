# ================= MODULO ANYDESK ACTUALIZADO =================
Clear-Host
Write-Host "=== DESCARGA E INSTALACIÓN DE ANYDESK (INSTALACIÓN DEFINITIVA) ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario que inició sesión
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDeskSetup.exe"

# URL del instalador oficial
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

# Ruta típica de instalación definitiva de AnyDesk
$installPath = "C:\Program Files\AnyDesk\AnyDesk.exe"

# ------------------- Verificar si AnyDesk ya está instalado -------------------
if (Test-Path $installPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  AnyDesk ya está instalado en $installPath" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "`n❗ Para actualizar la contraseña o permisos, abra AnyDesk manualmente." -ForegroundColor Yellow
    Read-Host "Presione Enter para continuar..."
    return
}

# ------------------- Descargar el instalador completo -------------------
Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "✅ Descarga completada: $anydeskPath" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al descargar AnyDesk. Verifique la URL o la conexión a Internet." -ForegroundColor Red
    Read-Host "Presione Enter para volver..."
    return
}

# ------------------- Instalar AnyDesk con contraseña y permisos totales -------------------
Write-Host "Instalando AnyDesk con acceso total y contraseña '*Gemez$$'..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent --set-password *Gemez$$ --grant-elevated-permissions" -Wait
    Write-Host "✅ AnyDesk instalado y configurado correctamente." -ForegroundColor Green
} catch {
    Write-Host "❌ Error durante la instalación de AnyDesk." -ForegroundColor Red
    Read-Host "Presione Enter para volver..."
    return
}

# Limpiar instalador temporal
Remove-Item $anydeskPath -Force

# Mensaje final
Write-Host "`n✅ Proceso completado." -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
