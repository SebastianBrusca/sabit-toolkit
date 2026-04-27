function Pause {
    Write-Host ""
    Read-Host "Presioná ENTER para continuar"
}

function Crear-IEViejo {
    $ruta = "$env:USERPROFILE\Documents\Internet Explorer.vbs"

    if (!(Test-Path $ruta)) {
        'CreateObject("InternetExplorer.Application").Visible=true' | Out-File $ruta -Encoding ASCII
        Write-Host "Archivo creado en Documentos"
    } else {
        Write-Host "El archivo ya existe"
    }

    # Crear acceso directo
    $desktop = [Environment]::GetFolderPath("Desktop")
    $acceso = "$desktop\Internet Explorer.lnk"

    if (!(Test-Path $acceso)) {
        $ws = New-Object -ComObject WScript.Shell
        $shortcut = $ws.CreateShortcut($acceso)
        $shortcut.TargetPath = $ruta

        # 👉 Cambiá esta ruta según donde tengas el icono en el pendrive
        $shortcut.IconLocation = "D:\icono.ico"

        $shortcut.Save()
        Write-Host "Acceso directo creado en el escritorio"
    } else {
        Write-Host "El acceso directo ya existe"
    }

    # Ejecutar
    Start-Process $ruta
}

function Abrir-Navegador {
    Start-Process "https://www.google.com"
}

function Agregar-Sitios-Confianza {
    $sites = @(
        "https://webformsext.afip.gob.ar",
        "https://www.arca.gob.ar"
    )

    foreach ($site in $sites) {
        Write-Host "Agregando $site a sitios de confianza..."
        
        # Zona 2 = Trusted Sites
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Name ($site -replace "https://","") -Force | Out-Null
    }

    Write-Host "Sitios agregados (puede requerir ajustes adicionales)"
}

# ================= MENU =================

while ($true) {
    Clear-Host
    Write-Host "==============================="
    Write-Host "      SABIT TOOLKIT"
    Write-Host "==============================="
    Write-Host "1. Internet Explorer Viejo"
    Write-Host "2. Abrir Navegador"
    Write-Host "3. Agregar sitios AFIP/ARCA"
    Write-Host "0. Salir"
    Write-Host ""

    $op = Read-Host "Elegí una opción"

    switch ($op) {
        "1" {
            Crear-IEViejo
            Pause
        }
        "2" {
            Abrir-Navegador
            Pause
        }
        "3" {
            Agregar-Sitios-Confianza
            Pause
        }
        "0" {
            break
        }
        default {
            Write-Host "Opción inválida"
            Pause
        }
    }
}