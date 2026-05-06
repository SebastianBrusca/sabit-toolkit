# Limpia pantalla
Clear-Host
Write-Host "=== DESCARGA BALANZAWMS ===" -ForegroundColor Cyan

# Carpeta destino en el disco donde está Windows
$extractPath = Join-Path $env:SystemDrive "BalanzaWMS"

# ----------------------- Verificar si la carpeta existe -----------------------
if (Test-Path $extractPath) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ADVERTENCIA: La carpeta BalanzaWMS ya existe en el disco $($env:SystemDrive)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para continuar con la verificación de la IP y puertos COM..."
    # <-- NO hacemos return aquí, así el script sigue
} else {
    # Si no existe, se crea la carpeta normalmente
    New-Item -ItemType Directory -Path $extractPath | Out-Null

    # Descargar y descomprimir ZIP normalmente
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

# ================= VERIFICACIÓN DE PUENTECOMWEB.EXE.CONFIG =================
Write-Host "=== VERIFICACIÓN DE PUENTECOMWEB.EXE.CONFIG ===" -ForegroundColor Cyan

# Ruta del archivo config
$configFile = "C:\BalanzaWMS\PuenteComWeb.exe.config"

# Comprobar que exista el archivo
if (-Not (Test-Path $configFile)) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró el archivo PuenteComWeb.exe.config en C:\BalanzaWMS" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# Leer el contenido
$configContent = Get-Content $configFile

# ----------------------- Verificar WebServiceIP -----------------------
$webServiceLine = $configContent | Where-Object { $_ -match '<add key="WebServiceIP"' }

if (-Not $webServiceLine) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró la línea WebServiceIP en el config." -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# Extraer la IP configurada
if ($webServiceLine -match 'value="([^"]+)"') {
    $configuredIP = $matches[1]
} else {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se pudo extraer la IP de la línea WebServiceIP." -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

# Obtener la IP actual de la PC (IPv4 real)
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

Read-Host "Presione Enter para volver al menú..."


# ================= VERIFICACIÓN PUERTOS COM Y BAUDRATE =================
Clear-Host
Write-Host "=== VERIFICACIÓN DE PUERTOS COM Y BAUDRATE ===" -ForegroundColor Cyan

# Archivo config
$configFile = "C:\BalanzaWMS\PuenteComWeb.exe.config"

if (-Not (Test-Path $configFile)) {
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  ERROR: No se encontró el archivo PuenteComWeb.exe.config en C:\BalanzaWMS" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Read-Host "Presione Enter para volver al menú..."
    return
}

$configContent = Get-Content $configFile

# ----------------------- SerialPortName -----------------------
$comLine = $configContent | Where-Object { $_ -match '<add key="SerialPortName"' }
if ($comLine -match 'value="([^"]+)"') { $configuredCOM = $matches[1] } else { $configuredCOM = $null }

# ----------------------- SerialPortBaudRate -----------------------
$baudLine = $configContent | Where-Object { $_ -match '<add key="SerialPortBaudRate"' }
if ($baudLine -match 'value="([^"]+)"') { $configuredBaud = $matches[1] } else { $configuredBaud = $null }

# Obtener puertos COM de la PC
$pcCOMs = Get-WmiObject Win32_SerialPort | Select-Object -ExpandProperty DeviceID

Write-Host "`nPuertos COM detectados en la PC: $($pcCOMs -join ', ')"
Write-Host "COM configurado en el archivo : $configuredCOM"
Write-Host "BaudRate configurado          : $configuredBaud"

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

Read-Host "Presione Enter para volver al menú..."
