# ================= INTERNET EXPLORER VIEJO REMOTO =================
Clear-Host
Write-Host "=== INTERNET EXPLORER VIEJO ===" -ForegroundColor Cyan

# Carpeta Documentos del usuario
$docs = [Environment]::GetFolderPath("MyDocuments")

# Ruta del archivo VBS
$vbsPath = Join-Path $docs "Internet Explorer.vbs"

# Crear el archivo VBS solo si no existe
if (-not (Test-Path $vbsPath)) {
    # Contenido del VBS: abrir IE y navegar a ARCA
    $vbsContent = 'Set ie = CreateObject("InternetExplorer.Application")' + "`r`n" +
                  'ie.Visible = True' + "`r`n" +
                  'ie.Navigate "https://www.arca.gob.ar"'
    Set-Content -Path $vbsPath -Value $vbsContent -Encoding ASCII
    Write-Host "Archivo VBS creado en: $vbsPath" -ForegroundColor Green
} else {
    Write-Host "Archivo VBS ya existe, se omite la creacion." -ForegroundColor Yellow
}

# Carpeta Escritorio
$desktop = [Environment]::GetFolderPath("Desktop")

# Ruta del acceso directo
$shortcutPath = Join-Path $desktop "Internet Explorer.lnk"

# Icono remoto en GitHub
$iconUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/recursos/ie_icon.ico"
$iconLocal = Join-Path $env:TEMP "ie_icon.ico"

# Descargar icono si no existe
if (-not (Test-Path $iconLocal)) {
    try {
        Invoke-RestMethod -Uri $iconUrl -OutFile $iconLocal
        Write-Host "Icono descargado a: $iconLocal" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo descargar el icono remoto. El acceso directo se creará sin icono." -ForegroundColor Yellow
        $iconLocal = ""
    }
}

# Crear o actualizar acceso directo
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbsPath
if ($iconLocal -ne "") {
    $shortcut.IconLocation = $iconLocal
}
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
Write-Host "Internet Explorer Viejo se ha ejecutado y abrió www.arca.gob.ar." -ForegroundColor Green

# Esperar Enter y volver al menu remoto
Write-Host ""
Read-Host "Presione Enter para volver al menu..."
# Ejecutar de nuevo el menú principal remoto desde GitHub
$menuUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1"
Invoke-Expression (Invoke-RestMethod $menuUrl)
