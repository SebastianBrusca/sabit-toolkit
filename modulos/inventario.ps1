# ============================================
# SABIT - Inventario
# ============================================

try {

    $url = "https://script.google.com/macros/s/AKfycbyCPOuuOjxshxqytr7oDZ5rLOASPQxV1c_T06cVMvG8uJqne5pRUsG3bmBOW6cvRbXr/exec"

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
    # Serial
    # ----------------------------------------
    $serial = (Get-CimInstance Win32_BIOS).SerialNumber.Trim()

    # ----------------------------------------
    # CPU
    # ----------------------------------------
    $procesador = (Get-CimInstance Win32_Processor).Name.Trim()

    # ----------------------------------------
    # RAM (GB enteros)
    # ----------------------------------------
    $ram = [math]::Round(
        (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
    )

    # ----------------------------------------
    # Disco principal
    # ----------------------------------------
    $disco = Get-CimInstance Win32_LogicalDisk |
        Where-Object { $_.DeviceID -eq "C:" }

    $almacenamiento = [math]::Round(
        $disco.Size / 1GB
    )

    # ----------------------------------------
    # Windows
    # ----------------------------------------
    $windows = (Get-CimInstance Win32_OperatingSystem).Caption

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

    $macEth = if ($eth) {
        $eth.MacAddress
    }
    else {
        ""
    }

    # ----------------------------------------
    # WIFI
    # ----------------------------------------
    $wifi = Get-NetAdapter |
        Where-Object {
            $_.InterfaceDescription -match "Wireless|Wi-Fi|WiFi"
        } |
        Select-Object -First 1

    $macWifi = if ($wifi) {
        $wifi.MacAddress
    }
    else {
        ""
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
    # AnyDesk ID
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
    # Payload
    # ----------------------------------------
    $body = @{
        Token           = "SABIT-INV-2026"
        Nombre          = $nombre
        Usuario         = $usuario
        Serial          = $serial
        MacEth          = $macEth
        MacWifi         = $macWifi
        Procesador      = $procesador
        Ram             = $ram
        Almacenamiento  = $almacenamiento
        AnyDesk         = $anydesk
        IpEth           = $ipEth
        Windows         = $windows
    } | ConvertTo-Json

    # ----------------------------------------
    # Envío
    # ----------------------------------------
    $resultado = Invoke-RestMethod `
        -Uri $url `
        -Method POST `
        -ContentType "application/json" `
        -Body $body

    if ($resultado.status -eq "created" -or $resultado.status -eq "updated") {

        Write-Host ""
        Write-Host "Inventario actualizado correctamente." -ForegroundColor Green
        Write-Host ""

    }
    else {

        Write-Host ""
        Write-Host "Error al actualizar inventario." -ForegroundColor Red
        Write-Host ""

    }

}
catch {

    Write-Host ""
    Write-Host "Error al enviar inventario:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""

}
