# ================= MODULO ANYDESK =================
Clear-Host
Write-Host "=== DESCARGA E INSTALACIÓN DE ANYDESK ===" -ForegroundColor Cyan

$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDesk.exe"
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

# Verificar si AnyDesk ya existe
if (Test-Path $anydeskPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  AnyDesk ya está descargado en $anydeskPath" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para actualizar contraseña y permisos..."
} else {
    # Descargar AnyDesk
    Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "Descarga completada: $anydeskPath" -ForegroundColor Green
}

# Instalar o actualizar AnyDesk con contraseña y permisos totales
Write-Host "Aplicando configuración: acceso total y contraseña 'seba123'..." -ForegroundColor Cyan
Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent --set-password seba123 --grant-elevated-permissions" -Wait

Write-Host "✅ AnyDesk instalado / actualizado y configurado correctamente." -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
