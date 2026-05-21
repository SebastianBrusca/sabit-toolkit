# ================= MODULO ANYDESK: DESCARGA, EJECUTA O ABRE =================
Clear-Host
Write-Host "=== ANYDESK: DESCARGA, EJECUCIÓN O INSTALACIÓN ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario actual
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDeskSetup.exe"

# URL oficial de AnyDesk
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

# Ruta de instalación final
$installPath = "C:\Program Files\AnyDesk\AnyDesk.exe"

# ------------------- Si AnyDesk ya está instalado -------------------
if (Test-Path $installPath) {
    Write-Host "✅ AnyDesk ya está instalado. Ejecutando..." -ForegroundColor Green
    Start-Process -FilePath $installPath
    return
}

# ------------------- Si el instalador ya existe en Descargas -------------------
if (Test-Path $anydeskPath) {
    Write-Host "⚠️  Instalador encontrado en Descargas. Ejecutando instalación..." -ForegroundColor Yellow
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent" -Wait
    Write-Host "✅ Instalación completada." -ForegroundColor Green
    Remove-Item $anydeskPath -Force
    return
}

# ------------------- Descargar AnyDesk si no existe -------------------
Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "✅ Descarga completada: $anydeskPath" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al descargar AnyDesk. Verifique la conexión a Internet." -ForegroundColor Red
    Read-Host "Presione Enter para salir..."
    return
}

# ------------------- Ejecutar instalador -------------------
Write-Host "Ejecutando instalador de AnyDesk..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent" -Wait
    Write-Host "✅ Instalación completada." -ForegroundColor Green
} catch {
    Write-Host "❌ Error durante la instalación." -ForegroundColor Red
    Read-Host "Presione Enter para salir..."
    return
}

# Limpiar instalador temporal
Remove-Item $anydeskPath -Force

Write-Host "`n✅ Proceso completado. AnyDesk está listo para usar." -ForegroundColor Green
Start-Process -FilePath $installPath
