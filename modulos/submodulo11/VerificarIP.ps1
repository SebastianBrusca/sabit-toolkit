Clear-Host
Write-Host "=== VERIFICACIÓN DE WEB SERVICE IP ===" -ForegroundColor Cyan

$configFile = Join-Path $env:SystemDrive "BalanzaWMS\PuenteComWeb.exe.config"
if (-Not (Test-Path $configFile)) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró el archivo PuenteComWeb.exe.config" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver..."
    return
}

$configContent = Get-Content $configFile
$webServiceLine = $configContent | Where-Object { $_ -match '<add key="WebServiceIP"' }
if ($webServiceLine -match 'value="([^"]+)"') { $configuredIP = $matches[1] } else { $configuredIP = $null }

$localIP = (Get-NetIPAddress -AddressFamily IPv4 |
            Where-Object { $_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1" } |
            Select-Object -First 1 -ExpandProperty IPAddress)

if ($configuredIP -eq $localIP) {
    Write-Host "`n✅ La IP configurada coincide con la IP de la PC: $localIP" -ForegroundColor Green
} else {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  La IP de la PC NO coincide con la IP del archivo config" -ForegroundColor Red
    Write-Host "  IP del archivo: $configuredIP" -ForegroundColor Red
    Write-Host "  IP de la PC   : $localIP" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
}

Read-Host "Presione Enter para continuar..."
