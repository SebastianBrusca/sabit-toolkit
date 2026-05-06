Clear-Host
Write-Host "=== VERIFICACIÓN DE PUERTOS COM Y BAUDRATE ===" -ForegroundColor Cyan

$configFile = Join-Path $env:SystemDrive "BalanzaWMS\PuenteComWeb.exe.config"
$configContent = Get-Content $configFile

$comLine = $configContent | Where-Object { $_ -match '<add key="SerialPortName"' }
$configuredCOM = if ($comLine -match 'value="([^"]+)"') { $matches[1] } else { $null }

$baudLine = $configContent | Where-Object { $_ -match '<add key="SerialPortBaudRate"' }
$configuredBaud = if ($baudLine -match 'value="([^"]+)"') { $matches[1] } else { $null }

$pcCOMs = Get-WmiObject Win32_SerialPort | Select-Object -ExpandProperty DeviceID

Write-Host "`nPuertos COM detectados en la PC: $($pcCOMs -join ', ')"
Write-Host "COM en config  : $configuredCOM"
Write-Host "BaudRate config: $configuredBaud"

if ($configuredCOM -and $pcCOMs -contains $configuredCOM) {
    Write-Host "`n✅ El puerto COM configurado existe en la PC." -ForegroundColor Green
} else {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  El COM configurado NO coincide con los de la PC" -ForegroundColor Red
    Write-Host "  COM del archivo: $configuredCOM" -ForegroundColor Red
    Write-Host "  Puertos COM disponibles: $($pcCOMs -join ', ')" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
}

Read-Host "Presione Enter para continuar..."
