Clear-Host
Write-Host "=== DESCARGA Y EJECUCIÓN DE PUTTY ===" -ForegroundColor Cyan

$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$puttyPath = Join-Path $downloadsPath "putty.exe"

# Leer COM y Baud del config
$configFile = Join-Path $env:SystemDrive "BalanzaWMS\PuenteComWeb.exe.config"
$configContent = Get-Content $configFile
$comLine = $configContent | Where-Object { $_ -match '<add key="SerialPortName"' }
$configuredCOM = if ($comLine -match 'value="([^"]+)"') { $matches[1] } else { $null }
$baudLine = $configContent | Where-Object { $_ -match '<add key="SerialPortBaudRate"' }
$configuredBaud = if ($baudLine -match 'value="([^"]+)"') { $matches[1] } else { $null }

# Descargar Putty si no existe
if (-Not (Test-Path $puttyPath)) {
    Write-Host "Descargando Putty en $downloadsPath..." -ForegroundColor Cyan
    $puttyUrl = "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe"
    Invoke-WebRequest -Uri $puttyUrl -OutFile $puttyPath -UseBasicParsing
    Write-Host "Putty descargado en $puttyPath" -ForegroundColor Green
} else {
    Write-Host "Putty ya existe en $puttyPath" -ForegroundColor Yellow
}

# Ejecutar Putty
$sercfg = "$configuredBaud,8,n,1,N"
Start-Process -FilePath $puttyPath -ArgumentList "-serial $configuredCOM -sercfg $sercfg"

Write-Host "`n✅ Putty abierto con COM $configuredCOM y BaudRate $configuredBaud." -ForegroundColor Green
Read-Host "Presione Enter para continuar..."
