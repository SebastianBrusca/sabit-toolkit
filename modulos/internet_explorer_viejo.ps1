# ================= INTERNET EXPLORER VIEJO REMOTO =================
Clear-Host
Write-Host "=== CONFIGURANDO INTERNET EXPLORER VIEJO ===" -ForegroundColor Cyan

# 1. DESTILDAR "Requerir comprobación del servidor (https)" (ZONA 2)
# -----------------------------------------------------------------
$zoneKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"

if (Test-Path $zoneKey) {
    # El valor decimal 67 (0x43) desactiva el check obligatorio de HTTPS
    Set-ItemProperty -Path $zoneKey -Name "Flags" -Value 67 -Type DWord
    Write-Host "✔ Casilla 'Requerir comprobación (https)' DESACTIVADA." -ForegroundColor Green
} else {
    Write-Host "⚠️ No se encontró la configuración de la Zona 2." -ForegroundColor Red
}

# 2. AGREGAR SITIOS DE CONFIANZA
# -----------------------------------------------------------------
$trustedSites = @(
    "webformsext.afip.gob.ar",
    "www.arca.gob.ar",
    "https://intranet.afip.gov.ar",
    "https://intranet.afip.gob.ar",
    "https://webformsint.afip.gob.ar",
    "http://authinthomo.afip.gob.ar",
    "http://webformsint.afip.ar"
)

$basePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains"

foreach ($site in $trustedSites) {
    $domainKey = Join-Path $basePath $site
    if (-not (Test-Path $domainKey)) {
        New-Item -Path $domainKey -Force | Out-Null
    }

    # Valor * = 2 (Sitio de confianza para cualquier protocolo)
    Set-ItemProperty -Path $domainKey -Name "*" -Value 2 -Type DWord
    # Forzar protocolo específico para evitar bloqueos
    Set-ItemProperty -Path $domainKey -Name "http" -Value 2 -Type DWord
    Set-ItemProperty -Path $domainKey -Name "https" -Value 2 -Type DWord

    Write-Host "✔ Agregado a confianza: $site" -ForegroundColor Green
}

# 3. CONFIGURAR TLS 1.0 Y OTROS
# -----------------------------------------------------------------
$tlsRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $tlsRegPath -Name "SecureProtocols" -Value 0x80 # TLS 1.0
Write-Host "✔ TLS 1.0 configurado como único protocolo activo." -ForegroundColor Green

# 4. CREAR ARCHIVO VBS Y ACCESO DIRECTO
# -----------------------------------------------------------------
$docs = [Environment]::GetFolderPath("MyDocuments")
$vbsPath = Join-Path $docs "Internet Explorer.vbs"
$vbsContent = 'Set ie = CreateObject("InternetExplorer.Application")' + "`r`n" +
              'ie.Visible = True' + "`r`n" +
              'ie.Navigate "https://www.arca.gob.ar"'
Set-Content -Path $vbsPath -Value $vbsContent -Encoding ASCII

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Internet Explorer.lnk"
$iconLocal = Join-Path $env:TEMP "ie_icon.ico"

# Intentar descargar icono
try {
    $iconUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/recursos/ie_icon.ico"
    Invoke-RestMethod -Uri $iconUrl -OutFile $iconLocal -ErrorAction SilentlyContinue
} catch {}

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbsPath
if (Test-Path $iconLocal) { $shortcut.IconLocation = $iconLocal }
$shortcut.Save()

Write-Host "✔ Acceso directo creado en el escritorio." -ForegroundColor Green

# 5. EJECUTAR Y VOLVER
# -----------------------------------------------------------------
Start-Process $shortcutPath
Write-Host ""
Write-Host "Internet Explorer se ha iniciado con la configuración aplicada." -ForegroundColor Cyan
Write-Host ""
Read-Host "Presione Enter para volver al menú..."

$menuUrl = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1"
Invoke-Expression (Invoke-RestMethod $menuUrl)
