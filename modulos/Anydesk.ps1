# ================= MODULO ANYDESK =================
Clear-Host
Write-Host "=== DESCARGA E INSTALACIÓN DE ANYDESK ===" -ForegroundColor Cyan

$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$anydeskPath = Join-Path $downloadsPath "AnyDesk.exe"
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

if (Test-Path $anydeskPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  AnyDesk ya está instalado en $anydeskPath" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "`n❗ Para cambiar la contraseña y permisos, abra AnyDesk manualmente." -ForegroundColor Yellow
    Read-Host "Presione Enter para continuar..."
} else {
    Write-Host "Descargando AnyDesk en $downloadsPath..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath -UseBasicParsing
    Write-Host "Descarga completada: $anydeskPath" -ForegroundColor Green

    Write-Host "Instalando AnyDesk con acceso total y contraseña 'seba123'..." -ForegroundColor Cyan
    Start-Process -FilePath $anydeskPath -ArgumentList "/install /silent --set-password seba123 --grant-elevated-permissions" -Wait
    Write-Host "✅ AnyDesk instalado y configurado correctamente." -ForegroundColor Green
    Read-Host "Presione Enter para volver al menú..."
}
