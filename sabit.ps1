# ================= CONFIG =================
$Host.UI.RawUI.WindowTitle = "SABIT Toolkit"

# ================= FUNCIONES =================

function Es-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Pause {
    Write-Host ""
    Read-Host "Presioná ENTER para continuar"
}

function Banner {
    Clear-Host
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "        SABIT TOOLKIT v1.0" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan

    if (Es-Admin) {
        Write-Host "Modo: ADMIN" -ForegroundColor Green
    } else {
        Write-Host "Modo: USUARIO (algunas funciones pueden fallar)" -ForegroundColor Yellow
    }

    Write-Host ""
}

function Crear-IEViejo {
    $ruta = "$env:USERPROFILE\Documents\Internet Explorer.vbs"

    if (!(Test-Path $ruta)) {
        'CreateObject("InternetExplorer.Application").Visible=true' | Out-File $ruta -Encoding ASCII
        Write-Host "Archivo creado" -ForegroundColor Green
    } else {
        Write-Host "El archivo ya existe" -ForegroundColor Yellow
    }

    $desktop = [Environment]::GetFolderPath("Desktop")
    $acceso = "$desktop\Internet Explorer.lnk"

    if (!(Test-Path $acceso)) {
        $ws = New-Object -ComObject WScript.Shell
        $shortcut = $ws.CreateShortcut($acceso)
        $shortcut.TargetPath = $ruta
        $shortcut.IconLocation = "D:\icono.ico"
        $shortcut.Save()
        Write-Host "Acceso directo creado" -ForegroundColor Green
    }

    Start-Process $ruta
}

function Abrir-Navegador {
    Start-Process "https://www.google.com"
}

function Agregar-Sitios-Confianza {
    $sites = @(
        "webformsext.afip.gob.ar",
        "arca.gob.ar"
    )

    foreach ($site in $sites) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Name $site -Force | Out-Null
        Write-Host "$site agregado" -ForegroundColor Green
    }
}

# ================= MENU =================

while ($true) {
    Banner

    Write-Host "1. Internet Explorer Viejo" -ForegroundColor White
    Write-Host "2. Abrir Navegador" -ForegroundColor White
    Write-Host "3. Agregar sitios AFIP/ARCA" -ForegroundColor White
    Write-Host "0. Salir" -ForegroundColor Red
    Write-Host ""

    $op = Read-Host "Elegí una opción"

    switch ($op) {
        "1" { Crear-IEViejo; Pause }
        "2" { Abrir-Navegador; Pause }
        "3" { Agregar-Sitios-Confianza; Pause }
        "0" { break }
        default { Write-Host "Opción inválida" -ForegroundColor Red; Pause }
    }
}
