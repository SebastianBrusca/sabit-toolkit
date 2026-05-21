# ================= MODULO ANYDESK DESCARGA Y EJECUTA SIN CONTRASEÑA =================
Clear-Host
Write-Host "=== DESCARGA E INSTALACIÓN DE ANYDESK ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario actual
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDeskSetup.exe"

# URL oficial de AnyDesk
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

# Ruta de instalación final
$installPath = "C:\Program Files\AnyDesk\AnyDesk.exe"

# ------------------- Verificar si AnyDesk ya está instalado -------------------
if (Test-Path $installPath) {
    Write-Host "⚠️  AnyDesk ya está instalado en $installPath" -ForegroundColor Yellow
    Read-Host "Presione Enter para continuar..."
    return
}

# ------------------- Descargar AnyDesk -------------------
Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "✅ Descarga completada: $anydeskPath" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al descargar AnyDesk. Verifique la conexión a Internet." -ForegroundColor Red
    Read-Host "Presione Enter para volver..."
    return
}

# ------------------- Ejecutar instalador -------------------
Write-Host "Ejecutando instalador de AnyDesk..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent" -Wait
    Write-Host "✅ AnyDesk instalado correctamente." -ForegroundColor Green
} catch {
    Write-Host "❌ Error durante la instalación." -ForegroundColor Red
    Read-Host "Presione Enter para volver..."
    return
}

# ------------------- Limpiar -------------------
Remove-Item $anydeskPath -Force

Write-Host "`n✅ Proceso completado. AnyDesk está listo para usar." -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
