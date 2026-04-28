# ================= LIMPIEZA DE TEMPORALES =================
Clear-Host
Write-Host "=== LIMPIEZA DE TEMPORALES ===" -ForegroundColor Cyan

# Función para eliminar archivos de forma segura
function Borrar-Archivos($path) {
    if (Test-Path $path) {
        try {
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "Se limpiaron archivos en: $path" -ForegroundColor Green
        } catch {
            Write-Host "No se pudieron borrar algunos archivos en: $path" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Ruta no encontrada: $path" -ForegroundColor Yellow
    }
}

# Carpetas temporales de Windows
$tempUser = $env:TEMP
$tempWin = "$env:WINDIR\Temp"

Write-Host ""
Write-Host "Limpiando temporales de usuario: $tempUser"
Borrar-Archivos $tempUser

Write-Host ""
Write-Host "Limpiando temporales de Windows: $tempWin"
Borrar-Archivos $tempWin

# (Opcional) agregar limpieza de caches de navegador
# Ejemplo: Chrome (en %LocalAppData%\Google\Chrome\User Data\Default\Cache)
$chromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
Write-Host ""
Write-Host "Limpiando cache de Chrome (si existe): $chromeCache"
Borrar-Archivos $chromeCache

# Fin
Write-Host ""
Write-Host "Limpieza completada." -ForegroundColor Green

# Esperar Enter y volver al menú remoto
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
