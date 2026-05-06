# ================= BalanzaWMS.ps1 =================
Clear-Host
Write-Host "=== DESCARGA Y DESCOMPRIME BALANZAWMS ===" -ForegroundColor Cyan

# URL corregida
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"

$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"

# Descargar
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
Clear-Host
Write-Host "Descarga completada. Descomprimiendo..." -ForegroundColor Green

# Extraer
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $extractPath)

Write-Host "`nBalanzaWMS listo en $extractPath" -ForegroundColor Green
Remove-Item $tempZip -Force

# Espera Enter antes de volver al menú
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
