Clear-Host
Write-Host "=== EJECUTAR PUENTECOMWEB.EXE ===" -ForegroundColor Cyan

$exePath = Join-Path $env:SystemDrive "BalanzaWMS\PuenteComWeb.exe"

if (-Not (Test-Path $exePath)) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró PuenteComWeb.exe en C:\BalanzaWMS" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para continuar..."
    return
}

# Ejecutar como administrador
Start-Process -FilePath $exePath -Verb RunAs
Write-Host "PuenteComWeb.exe iniciado como administrador." -ForegroundColor Green
Read-Host "Presione Enter para continuar..."
