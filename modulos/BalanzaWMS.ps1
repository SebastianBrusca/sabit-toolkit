# ================= BalanzaWMS.ps1 =================
# Módulo para descargar y descomprimir BalanzaWMS en la PC local

Clear-Host
Write-Host "=== DESCARGA Y DESCOMPRIME BALANZAWMS ===" -ForegroundColor Cyan

# URL raw del ZIP en GitHub (modificar si cambia)
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"

# Carpeta temporal para descargar el ZIP
$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"

# Carpeta de destino en disco donde está Windows
$windowsDrive = $env:SystemDrive  # Normalmente C:
$extractPath = Join-Path $windowsDrive "BalanzaWMS"

# Descargar el ZIP
Write-Host "`nDescargando BalanzaWMS..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "Descarga completada." -ForegroundColor Green
} catch {
    Write-Host "Error al descargar BalanzaWMS: $_" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# Crear carpeta de destino si no existe
if (-Not (Test-Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath | Out-Null
}

# Extraer el ZIP
Write-Host "`nDescomprimiendo en $extractPath ..." -ForegroundColor Cyan
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $extractPath)
    Write-Host "BalanzaWMS descargado y descomprimido correctamente." -ForegroundColor Green
} catch {
    Write-Host "Error al descomprimir BalanzaWMS: $_" -ForegroundColor Red
}

# Limpiar archivo temporal
Remove-Item $tempZip -Force

# Esperar Enter antes de volver al menú
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
