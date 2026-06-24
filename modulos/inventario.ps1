try {

    $url = "https://script.google.com/macros/s/AKfycbyCPOuuOjxshxqytr7oDZ5rLOASPQxV1c_T06cVMvG8uJqne5pRUsG3bmBOW6cvRbXr/exec"

    # ----------------------------------------
    # Datos manuales
    # ----------------------------------------

    $ubicacion = Read-Host "Ubicacion del equipo"
    $tecnico   = Read-Host "Tecnico"

    # ----------------------------------------
    # Nombre PC
    # ----------------------------------------

    $nombre = $env:COMPUTERNAME

    # ----------------------------------------
    # Usuario
    # ----------------------------------------

    $usuario = (Get-CimInstance Win32_ComputerSystem).UserName

    if ($usuario -match "\\") {
        $usuario = $usuario.Split("\")[-1]
    }

    # ----------------------------------------
    # CPU
    # ----------------------------------------

    $procesador = (
        Get-CimInstance Win32_Processor
    ).Name.Trim()

    # ----------------------------------------
    # RAM
    # ----------------------------------------

    $ram = [math]::Round(
        (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
    )

    # ----------------------------------------
    # Disco C:
    # ----------------------------------------

    $disco = Get-CimInstance Win32_LogicalDisk |
        Where-Object {
            $_.DeviceID -eq "C:"
        }

    $tamanoReal = [math]::Round(
        $disco.Size / 1GB
    )

    switch ($tamanoReal) {

        {$_ -ge 100 -and $_ -lt 130} {
            $almacenamiento = 120
            break
        }

        {$_ -ge 210 -and $_ -lt 245} {
            $almacenamiento = 240
            break
        }

        {$_ -ge 245 -and $_ -lt 280} {
            $almacenamiento = 256
            break
        }

        {$_ -ge 430 -and $_ -lt 520} {
            $almacenamiento = 500
            break
        }

        {$_ -ge 850 -and $_ -lt 980} {
            $almacenamiento = 1000
            break
        }

        default {
            $almacenamiento = $tamanoReal
        }
    }

    # ----------------------------------------
    # Windows
    # ----------------------------------------

    $windows = (
        Get-CimInstance Win32_OperatingSystem
    ).Caption

    # ----------------------------------------
    # Ethernet
    # ----------------------------------------

    $eth = Get-NetAdapter |
        Where-Object {
            $_.Status -eq "Up" -and
            $_.HardwareInterface -eq $true -and
            $_.InterfaceDescription -notmatch "Wireless|Wi-Fi|WiFi"
        } |
        Select-Object -First 1

    $macEth = ""

    if ($eth) {
        $macEth = $eth.MacAddress
    }

    # ----------------------------------------
    # WiFi
    # ----------------------------------------

    $wifi = Get-NetAdapter |
        Where-Object {
            $_.InterfaceDescription -match "Wireless|Wi-Fi|WiFi"
        } |
        Select-Object -First 1

    $macWifi = ""

    if ($wifi) {
        $macWifi = $wifi.MacAddress
    }

    # ----------------------------------------
    # IP Ethernet
    # ----------------------------------------

    $ipEth = ""

    if ($eth) {

        $ipEth = (
            Get-NetIPAddress `
                -InterfaceIndex $eth.ifIndex `
                -AddressFamily IPv4 `
                -ErrorAction SilentlyContinue |
            Where-Object {
                $_.IPAddress -notlike "169.254*"
            } |
            Select-Object -ExpandProperty IPAddress -First 1
        )
    }

    # ----------------------------------------
    # AnyDesk
    # ----------------------------------------

    $anydesk = ""

    $confFile = "C:\ProgramData\AnyDesk\system.conf"

    if (Test-Path $confFile) {

        $line = Get-Content $confFile |
            Where-Object {
                $_ -match "^ad\.anynet\.id="
            } |
            Select-Object -First 1

        if ($line) {
            $anydesk = $line.Replace("ad.anynet.id=","").Trim()
        }
    }

    # ----------------------------------------
    # JSON
    # ----------------------------------------

    $body = @{
        Token          = "SABIT-INV-2026"
        Nombre         = $nombre
        Usuario        = $usuario
        MacEth         = $macEth
        MacWifi        = $macWifi
        Procesador     = $procesador
        Ram            = $ram
        Almacenamiento = $almacenamiento
        AnyDesk        = $anydesk
        IpEth          = $ipEth
        Windows        = $windows
        Ubicacion      = $ubicacion
        Tecnico        = $tecnico
    } | ConvertTo-Json

    # ----------------------------------------
    # Envio
    # ----------------------------------------

    $resultado = Invoke-RestMethod `
        -Uri $url `
        -Method POST `
        -ContentType "application/json" `
        -Body $body

    if ($resultado.status -eq "created") {

        Write-Host ""
        Write-Host "Inventario cargado correctamente." -ForegroundColor Green
        Write-Host ""

    } else {

        Write-Host ""
        Write-Host "Error al cargar inventario." -ForegroundColor Red
        Write-Host ""

    }

}
catch {

    Write-Host ""
    Write-Host "Error al enviar inventario:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""

}
