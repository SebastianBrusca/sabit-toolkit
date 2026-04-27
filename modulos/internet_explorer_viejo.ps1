# Módulo: Internet Explorer Viejo
Clear-Host
Write-Host "=== INTERNET EXPLORER VIEJO ===" -ForegroundColor Cyan

# Carpeta Documentos del usuario
$docs = [Environment]::GetFolderPath("MyDocuments")

# Ruta del archivo VBS
$vbsPath = Join-Path $docs "Internet Explorer.vbs"

# Crear el archivo VBS solo si no existe
if (-not (Test-Path $vbsPath)) {
    $vbsContent = 'CreateObject("InternetExplorer.Application").Visible=true'
    Set-Content -Path $vbsPath -Value $vbsContent -Encoding ASCII
    Write-Host "Archivo VBS creado en: $vbsPath" -ForegroundColor Green
} else {
    Write-Host "Archivo VBS ya existe, se omite la creacion." -ForegroundColor Yellow
}

# Carpeta Escritorio
$desktop = [Environment]::GetFolderPath("Desktop")

# Ruta del acceso directo
$shortcutPath = Join-Path $desktop "Internet Explorer.lnk"

# Ruta del icono en el pendrive
$iconPath = Join-Path $PSScriptRoot "..\recursos\ie_icon.ico"

# Crear o actualizar acceso directo
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbsPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()
Write-Host "Acceso directo creado/actualizado en el escritorio: $shortcutPath" -ForegroundColor Green

# Agregar URLs a Sitios de confianza en IE (registro)
$trustedSites = @(
    "webformsext.afip.gob.ar",
    "www.arca.gob.ar"
)

foreach ($site in $trustedSites) {
    $trustedZoneKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$site"
    if (-not (Test-Path $trustedZoneKey)) {
        New-Item -Path $trustedZoneKey -Force | Out-Null
    }
    Set-ItemProperty -Path $trustedZoneKey -Name "*" -Value 2 -Type DWord
    Write-Host "Se agrego https://$site a Sitios de confianza." -ForegroundColor Green
}

# Ejecutar el acceso directo
Start-Process $shortcutPath
Write-Host "Internet Explorer Viejo se ha ejecutado." -ForegroundColor Green

# Esperar Enter y volver al menu
Write-Host ""
Write-Host "Presione Enter para volver al menu..."
$null = $Host.UI.RawUI.ReadKey("IncludeKeyDown")
. "$PSScriptRoot\..\sabit.ps1"