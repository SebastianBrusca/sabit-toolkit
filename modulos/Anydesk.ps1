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
    Read-Host "Presione Enter para continuar con la verificación / instalación manual de la contraseña"
} else {
    # Descargar AnyDesk si no existe
    Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "Descarga completada: $anydeskPath" -ForegroundColor Green

    # Instalar AnyDesk con contraseña y permisos totales en instalación limpia
    Write-Host "Instalando AnyDesk con acceso total y contraseña 'seba123'..." -ForegroundColor Cyan
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent --set-password seba123 --grant-elevated-permissions" -Wait
    Write-Host "✅ AnyDesk instalado y configurado correctamente." -ForegroundColor Green
}

# Mensaje final
Write-Host "`n⚠️  Si AnyDesk ya estaba instalado, la contraseña no se pudo cambiar automáticamente." -ForegroundColor Yellow
Write-Host "  Para cambiarla, abra AnyDesk y configure manualmente 'seba123' como contraseña de acceso total."
Read-Host "Presione Enter para volver al menú..."
