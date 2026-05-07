# ================= MODULO FORMULARIO DE PRUEBA =================
Clear-Host
Write-Host "=== FORMULARIO DE PRUEBA ===" -ForegroundColor Cyan

# Ruta del escritorio del usuario actual
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "FormularioDePrueba.lnk"

# URL del formulario de Google
$formURL = "https://docs.google.com/forms/d/1bIKVor-NzOnPAHDXApx8Tnk-yLVmENvIqTa8krVbCjY/viewform?edit_requested=true"

# Ruta típica de instalación de Chrome
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# ------------------- Verificar si Chrome está instalado -------------------
if (-Not (Test-Path $chromePath)) {
    Write-Host "Google Chrome no está instalado. Se descargará e instalará..." -ForegroundColor Yellow
    
    # Descargar Chrome (versión estable)
    $chromeInstaller = "$env:TEMP\ChromeSetup.exe"
    $chromeURL = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    
    Invoke-WebRequest -Uri $chromeURL -OutFile $chromeInstaller -UseBasicParsing
    Write-Host "Descarga completada: $chromeInstaller" -ForegroundColor Green
    
    # Instalar Chrome silenciosamente
    Start-Process -FilePath $chromeInstaller -ArgumentList "/silent /install" -Wait
    Write-Host "Instalación de Google Chrome completada." -ForegroundColor Green
    
    # Limpiar instalador temporal
    Remove-Item $chromeInstaller -Force
} else {
    Write-Host "Google Chrome ya está instalado." -ForegroundColor Green
}

# ------------------- Crear acceso directo en el escritorio -------------------
Write-Host "Creando acceso directo en el escritorio..." -ForegroundColor Cyan
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $chromePath
$shortcut.Arguments = $formURL
$shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($chromePath)
$shortcut.IconLocation = $chromePath
$shortcut.Save()

Write-Host "✅ Acceso directo creado: $shortcutPath" -ForegroundColor Green
Read-Host "Presione Enter para volver al menú..."
