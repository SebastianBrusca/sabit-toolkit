# Limpia pantalla
Clear-Host
Write-Host "=== DESCARGA BALANZAWMS ===" -ForegroundColor Cyan

# Carpeta destino en el disco donde está Windows
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"

# Verificar si la carpeta ya existe
if (Test-Path $extractPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: La carpeta BalanzaWMS ya existe en el disco $($env:SystemDrive)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# URL raw de GitHub
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"

# Ruta temporal donde guardar el ZIP
$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"

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

# Crear carpeta de destino
New-Item -ItemType Directory -Path $extractPath | Out-Null

# Descomprimir ZIP de forma compatible
Write-Host "Descomprimiendo en $extractPath..." -ForegroundColor Cyan
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zip = [System.IO.Compression.ZipFile]::OpenRead($tempZip)

foreach ($entry in $zip.Entries) {
    if ([string]::IsNullOrEmpty($entry.Name)) { continue }  # Ignorar carpetas

    # Ruta destino final
    $destFile = Join-Path $extractPath $entry.Name

    # Crear carpeta si no existe
    $destDir = Split-Path $destFile
    if (-Not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

    # Copiar contenido del archivo usando streams
    $sourceStream = $entry.Open()
    $targetStream = [System.IO.File]::Open($destFile, [System.IO.FileMode]::Create)
    try {
        $sourceStream.CopyTo($targetStream)
    } finally {
        $sourceStream.Close()
        $targetStream.Close()
    }
}

$zip.Dispose()

# Limpiar archivo temporal
Remove-Item $tempZip -Force

Write-Host "BalanzaWMS listo en $extractPath" -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
