# ================= LIMPIEZA DE NAVEGADORES =================
Clear-Host
Write-Host "=== LIMPIEZA DE NAVEGADORES ===" -ForegroundColor Cyan

# Función para borrar carpetas de forma segura
function Borrar-Carpeta($path) {
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

# -----------------------
# Google Chrome
# -----------------------
$chromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$chromeCookies = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies"
Write-Host ""
Write-Host "Limpiando Google Chrome..." -ForegroundColor Cyan
Borrar-Carpeta $chromeCache
Borrar-Carpeta $chromeCookies

# -----------------------
# Microsoft Edge
# -----------------------
$edgeCache = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
$edgeCookies = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies"
Write-Host ""
Write-Host "Limpiando Microsoft Edge..." -ForegroundColor Cyan
Borrar-Carpeta $edgeCache
Borrar-Carpeta $edgeCookies

# -----------------------
# Mozilla Firefox
# -----------------------
$firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfiles) {
    $profiles = Get-ChildItem $firefoxProfiles -Directory
    foreach ($p in $profiles) {
        $cache = Join-Path $p.FullName "cache2"
        $cookies = Join-Path $p.FullName "cookies.sqlite"
        Write-Host ""
        Write-Host "Limpiando Firefox perfil: $($p.Name)" -ForegroundColor Cyan
        Borrar-Carpeta $cache
        if (Test-Path $cookies) { Remove-Item $cookies -Force }
    }
} else {
    Write-Host "No se encontró carpeta de perfiles de Firefox." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Limpieza de navegadores completada." -ForegroundColor Green

# Esperar Enter y volver al menú remoto
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
