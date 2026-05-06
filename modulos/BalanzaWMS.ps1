# ================= VERIFICACIÓN DE PUENTECOMWEB.EXE.CONFIG =================
Clear-Host
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
