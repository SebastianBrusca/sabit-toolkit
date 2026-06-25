function Seleccionar-Opcion {
    param(
        [string]$Titulo,
        [string[]]$Opciones
    )

    while ($true) {

        Clear-Host
    
        Write-Host ""
        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host " $Titulo" -ForegroundColor Yellow
        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host ""

        for ($i = 0; $i -lt $Opciones.Count; $i++) {
            Write-Host ("{0,2}) {1}" -f ($i + 1), $Opciones[$i])
        }

        Write-Host ""

        $seleccion = Read-Host "Seleccione una opcion"

        $numero = 0

        if ([int]::TryParse($seleccion, [ref]$numero)) {
    
            if ($numero -ge 1 -and $numero -le $Opciones.Count) {
                return $Opciones[$numero - 1]
            }
    
        }
    
        Write-Host ""
        Write-Host "Opcion invalida." -ForegroundColor Red
        Start-Sleep 2
    }
}

try {

    $url = "https://script.google.com/macros/s/AKfycbyCPOuuOjxshxqytr7oDZ5rLOASPQxV1c_T06cVMvG8uJqne5pRUsG3bmBOW6cvRbXr/exec"

    $sectores = @(
        "Operaciones ZP",
        "Sistemas",
        "Logistica",
        "Operaciones FDC",
        "Adm. SIM",
        "Adm. Expo",
        "Adm. Impo",
        "Coord. Impo",
        "Comercial",
        "Servicios",
        "Operaciones",
        "Servicio al Cliente",
        "Aduana",
        "RR.HH.",
        "Finanzas",
        "Seguridad",
        "Planeamiento",
        "Calidad",
        "Gerencia",
        "Directorio",
        "Administracion"
    )

    $tipos = @(
        "Notebook",
        "Brix"
    )

    $estados = @(
        "En uso",
        "En reparacion",
        "En deposito",
        "Baja"
    )

    $tecnicos = @(
        "Sebastian Brusca",
        "Facundo Muñiz"
    )

    $sector = Seleccionar-Opcion "SECTOR" $sectores
    $tipoEquipo = Seleccionar-Opcion "TIPO DE EQUIPO" $tipos
    $estadoEquipo = Seleccionar-Opcion "ESTADO DEL EQUIPO" $estados
    $tecnico = Seleccionar-Opcion "TECNICO" $tecnicos

    Write-Host ""
    Write-Host "Relevando informacion..." -ForegroundColor Cyan

    $nombre = $env:COMPUTERNAME

    $usuario = (Get-CimInstance Win32_ComputerSystem).UserName

    if ($usuario -match "\\") {
        $usuario = $usuario.Split("\")[-1]
    }

    $procesador = (Get-CimInstance Win32_Processor).Name.Trim()

    $ram = [math]::Round(
    (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
    )

    $disco = Get-CimInstance Win32_LogicalDisk |
        Where-Object {
            $_.DeviceID -eq "C:"
        }

    $tamanoReal = [math]::Round($disco.Size / 1GB)

    switch ($tamanoReal) {

        {$_ -ge 100 -and $_ -lt 130} {
            $almacenamiento = "120"
            break
        }

        {$_ -ge 210 -and $_ -lt 245} {
            $almacenamiento = "240"
            break
        }

        {$_ -ge 245 -and $_ -lt 280} {
            $almacenamiento = "256"
            break
        }

        {$_ -ge 430 -and $_ -lt 520} {
            $almacenamiento = "500"
            break
        }

        {$_ -ge 850 -and $_ -lt 980} {
            $almacenamiento = "1000"
            break
        }

        default {
            $almacenamiento = $tamanoReal
        }
    }

    $windows = (Get-CimInstance Win32_OperatingSystem).Caption

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

    $wifi = Get-NetAdapter |
        Where-Object {
            $_.InterfaceDescription -match "Wireless|Wi-Fi|WiFi"
        } |
        Select-Object -First 1

    $macWifi = ""

    if ($wifi) {
        $macWifi = $wifi.MacAddress
    }

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
        Token            = "SABIT-INV-2026"
        Nombre           = $nombre
        Usuario          = $usuario
        MacEth           = $macEth
        MacWifi          = $macWifi
        Procesador       = $procesador
        Ram              = $ram
        Almacenamiento   = $almacenamiento
        AnyDesk          = $anydesk
        IpEth            = $ipEth
        Windows          = $windows
        Sector           = $sector
        TipoEquipo       = $tipoEquipo
        EstadoEquipo     = $estadoEquipo
        Tecnico          = $tecnico
    } | ConvertTo-Json

    # ----------------------------------------
    # Envío
    # ----------------------------------------

    Write-Host ""
    Write-Host "Enviando inventario..." -ForegroundColor Cyan

    $resultado = Invoke-RestMethod `
        -Uri $url `
        -Method POST `
        -ContentType "application/json" `
        -Body $body

    if ($resultado.status -eq "created") {

        Write-Host ""
        Write-Host "==============================================" -ForegroundColor Green
        Write-Host " Inventario cargado correctamente" -ForegroundColor Green
        Write-Host "==============================================" -ForegroundColor Green
        Write-Host ""

    }
    else {

        Write-Host ""
        Write-Host "==============================================" -ForegroundColor Red
        Write-Host " Error al cargar inventario" -ForegroundColor Red
        Write-Host "==============================================" -ForegroundColor Red
        Write-Host ""
        Write-Host ($resultado | ConvertTo-Json)

    }

}
catch {

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Red
    Write-Host " Error al enviar inventario" -ForegroundColor Red
    Write-Host "==============================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""

}

Write-Host ""
Read-Host "Presione ENTER para continuar"
