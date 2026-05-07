# ================= INTERNET EXPLORER VIEJO REMOTO =================
Clear-Host
Write-Host "=== INTERNET EXPLORER VIEJO ===" -ForegroundColor Cyan

# ------------------- Crear archivo VBS -------------------
$docs = [Environment]::GetFolderPath("MyDocuments")
$vbsPath = Join-Path $docs "Internet Explorer.vbs"

if (-not (Test-Path $vbsPath)) {
    $vbsContent = 'Set ie = CreateObject("InternetExplorer.Application")' + "`r`n" +
                  'ie.Visible = True' + "`r`n" +
                  'ie.Navigate "https://www.arca.gob.ar"'
    Set-Content -Path $vbsPath -Value $vbsContent -Encoding ASCII
    Write-Host "Archivo VBS creado en: $vbsPath" -ForegroundColor Green
} else {
    Write-Host "Archivo VBS ya existe, se omite la creacion." -ForegroundColor Yellow
}

# ------------------- Crear acceso directo -------------------
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Internet Explorer.lnk"

$iconUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/recursos/ie_icon.ico"
$iconLocal = Join-Path $env:TEMP "ie_icon.ico"

if (-not (Test-Path $iconLocal)) {
    try {
        Invoke-RestMethod -Uri $iconUrl -OutFile $iconLocal
        Write-Host "Icono descargado a: $iconLocal" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo descargar el icono remoto. El acceso directo se creará sin icono." -ForegroundColor Yellow
        $iconLocal = ""
    }
}

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbsPath
if ($iconLocal -ne "") { $shortcut.IconLocation = $iconLocal }
$shortcut.Save()
Write-Host "Acceso directo creado/actualizado en el escritorio: $shortcutPath" -ForegroundColor Green

# ------------------- Configurar Sitios de confianza -------------------
$trustedSites = @(
    "webformsext.afip.gob.ar",
    "www.arca.gob.ar",
    "intranet.afip.gov.ar",
    "intranet.afip.gob.ar",
    "webformsint.afip.gob.ar",
    "authinthomo.afip.gob.ar",
    "webformsint.afip.gob.ar"
)

foreach ($site in $trustedSites) {
    $domainKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$site"

    # Crear clave si no existe
    if (-not (Test-Path $domainKey)) {
        New-Item -Path $domainKey -Force | Out-Null
    }

    # Valor * = 2 (Sitios de confianza)
    Set-ItemProperty -Path $domainKey -Name "*" -Value 2 -Type DWord

    # ------------------- Desactivar "Requerir comprobación del servidor (https)" -------------------
    Set-ItemProperty -Path $domainKey -Name "https" -Value 0 -Type DWord

    Write-Host "Se agregó $site a Sitios de confianza permitiendo HTTP." -ForegroundColor Green
}

# ------------------- Configurar TLS 1.0 únicamente -------------------
$tlsRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $tlsRegPath -Name "SecureProtocols" -Value 0x80  # TLS 1.0
Write-Host "TLS configurado para usar únicamente TLS 1.0." -ForegroundColor Green

# ------------------- Ejecutar el acceso directo -------------------
Start-Process $shortcutPath
Write-Host "Internet Explorer Viejo se ha ejecutado y abrió www.arca.gob.ar." -ForegroundColor Green

# ------------------- Esperar y volver al menú remoto -------------------
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
$menuUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1"
Invoke-Expression (Invoke-RestMethod $menuUrl)
