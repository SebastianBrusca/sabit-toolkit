Clear-Host
Write-Host "=== VERIFICAR CARPETA E INSTALAR BALANZAWMS ===" -ForegroundColor Cyan
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"
$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"

if (Test-Path $extractPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: La carpeta BalanzaWMS ya existe en $($env:SystemDrive)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para continuar..."
} else {
    New-Item -ItemType Directory -Path $extractPath | Out-Null
    Write-Host "Descargando BalanzaWMS..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "Descomprimiendo..." -ForegroundColor Cyan
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($tempZip)
    foreach ($entry in $zip.Entries) {
        if ([string]::IsNullOrEmpty($entry.Name)) { continue }
        $destFile = Join-Path $extractPath $entry.Name
        $destDir = Split-Path $destFile
        if (-Not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }
        $sourceStream = $entry.Open()
        $targetStream = [System.IO.File]::Open($destFile, [System.IO.FileMode]::Create)
        try { $sourceStream.CopyTo($targetStream) } finally { $sourceStream.Close(); $targetStream.Close() }
    }
    $zip.Dispose()
    Remove-Item $tempZip -Force
    Write-Host "BalanzaWMS listo en $extractPath" -ForegroundColor Green
    Read-Host "Presione Enter para continuar..."
}
