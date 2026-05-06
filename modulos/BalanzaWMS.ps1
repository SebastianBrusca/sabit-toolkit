# ================= MÓDULO BALANZAWMS COMPLETO =================
Clear-Host
Write-Host "=== DESCARGA BALANZAWMS ===" -ForegroundColor Cyan

# Carpeta destino en el disco donde está Windows
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"
$zipUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/SABIT-0.1/recursos/BalanzaWMS.zip"
$tempZip = Join-Path $env:TEMP "BalanzaWMS.zip"

# ----------------------- Verificar carpeta -----------------------
if (Test-Path $extractPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: La carpeta BalanzaWMS ya existe en el disco $($env:SystemDrive)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para continuar con la verificación de la IP y puertos COM..."
} else {
    # Crear carpeta y descargar ZIP
    New-Item -ItemType Directory -Path $extractPath | Out-Null
    Write-Host "Descargando BalanzaWMS..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
        Write-Host "Descarga completada." -ForegroundColor Green
    } catch {
        Write-Host "Error al descargar BalanzaWMS: $_" -ForegroundColor Red
        Read-Host "Presione Enter para volver al menú..."
        return
    }

    # Descomprimir ZIP
    Write-Host "Descomprimiendo en $extractPath..." -ForegroundColor Cyan
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
    Read-Host "Presione Enter para continuar con la verificación de la IP y puertos COM..."
}

# ================= VERIFICACIÓN DE WEB SERVICE IP =================

Write-Host "=== VERIFICACIÓN DE WEB SERVICE IP ===" -ForegroundColor Cyan
$configFile = Join-Path $extractPath "PuenteComWeb.exe.config"
if (-Not (Test-Path $configFile)) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró el archivo PuenteComWeb.exe.config" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}
$configContent = Get-Content $configFile
$webServiceLine = $configContent | Where-Object { $_ -match '<add key="WebServiceIP"' }
if ($webServiceLine -match 'value="([^"]+)"') { $configuredIP = $matches[1] } else { $configuredIP = $null }

# Obtener IP de la PC
$localIP = (Get-NetIPAddress -AddressFamily IPv4 |
            Where-Object { $_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1" } |
            Select-Object -First 1 -ExpandProperty IPAddress)

# Comparar
if ($configuredIP -eq $localIP) {
    Write-Host "`n✅ La IP configurada en el archivo coincide con la IP de la PC: $localIP" -ForegroundColor Green
} else {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  ADVERTENCIA: La IP de la PC NO coincide con la IP del archivo config" -ForegroundColor Red
    Write-Host "  IP del archivo PuenteComWeb.exe.config : $configuredIP" -ForegroundColor Red
    Write-Host "  IP actual de la PC                     : $localIP" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
}
Read-Host "Presione Enter para continuar..."

# ================= VERIFICACIÓN PUERTOS COM Y BAUDRATE =================

Write-Host "=== VERIFICACIÓN DE PUERTOS COM Y BAUDRATE ===" -ForegroundColor Cyan

$configContent = Get-Content $configFile
$comLine = $configContent | Where-Object { $_ -match '<add key="SerialPortName"' }
$configuredCOM = if ($comLine -match 'value="([^"]+)"') { $matches[1] } else { $null }
$baudLine = $configContent | Where-Object { $_ -match '<add key="SerialPortBaudRate"' }
$configuredBaud = if ($baudLine -match 'value="([^"]+)"') { $matches[1] } else { $null }

# Puertos COM en la PC
$pcCOMs = Get-WmiObject Win32_SerialPort | Select-Object -ExpandProperty DeviceID

Write-Host "`nPuertos COM detectados en la PC: $($pcCOMs -join ', ')"
Write-Host ""
Write-Host "COM configurado en PuenteComWeb.exe.config      : $configuredCOM"
Write-Host "BaudRate configurado en PuenteComWeb.exe.config : $configuredBaud"

# Comparar COM
if ($configuredCOM -and $pcCOMs -contains $configuredCOM) {
    Write-Host "`n✅ El puerto COM configurado existe en la PC." -ForegroundColor Green
} else {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "⚠️  ADVERTENCIA: El puerto COM configurado NO coincide con los de la PC" -ForegroundColor Red
    Write-Host "  COM configurado en el archivo: $configuredCOM" -ForegroundColor Red
    Write-Host "  Puertos COM disponibles       : $($pcCOMs -join ', ')" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
}


# ================= DESCARGA Y EJECUCIÓN DE PUTTY =================

Write-Host "=== DESCARGA Y EJECUCIÓN DE PUTTY ===" -ForegroundColor Cyan

# Carpeta Descargas del usuario
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$puttyPath = Join-Path $downloadsPath "putty.exe"

# Descargar Putty si no existe
if (-Not (Test-Path $puttyPath)) {
    Write-Host "Descargando Putty en $downloadsPath..." -ForegroundColor Cyan
    $puttyUrl = "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe"
    try {
        Invoke-WebRequest -Uri $puttyUrl -OutFile $puttyPath -UseBasicParsing
        Write-Host "Putty descargado en $puttyPath" -ForegroundColor Green
    } catch {
        Write-Host "Error al descargar Putty: $_" -ForegroundColor Red
        Read-Host "Presione Enter para volver al menú..."
        return
    }
} else {
    Write-Host "Putty ya existe en $puttyPath" -ForegroundColor Yellow
}

# Ejecutar Putty con COM y Baud del archivo config
$sercfg = "$configuredBaud,8,n,1,N"
Write-Host "`nAbriendo Putty con COM: $configuredCOM y BaudRate: $configuredBaud..." -ForegroundColor Cyan
Start-Process -FilePath $puttyPath -ArgumentList "-serial $configuredCOM -sercfg $sercfg"

Write-Host "`n✅ Putty abierto. Verifique la consola para ver los datos de la balanza." -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
