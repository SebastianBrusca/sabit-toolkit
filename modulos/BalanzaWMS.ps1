# Limpia pantalla
Clear-Host
Write-Host "=== DESCARGA BALANZAWMS ===" -ForegroundColor Cyan

# URL raw de GitHub
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"

# Ruta temporal donde guardar el ZIP
$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"

# Carpeta destino en el disco donde está Windows
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"

# Descargar usando Invoke-WebRequest (binario seguro)
Write-Host "Descargando BalanzaWMS..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "Descarga completada." -ForegroundColor Green
} catch {
    Write-Host "Error al descargar BalanzaWMS: $_" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# Crear carpeta de destino si no existe
if (-Not (Test-Path $extractPath)) { New-Item -ItemType Directory -Path $extractPath | Out-Null }

# Descomprimir ZIP
Write-Host "Descomprimiendo en $extractPath..." -ForegroundColor Cyan
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $extractPath)

# Limpiar archivo temporal
Remove-Item $tempZip -Force

Write-Host "BalanzaWMS listo en $extractPath" -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
