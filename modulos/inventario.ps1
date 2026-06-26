function Seleccionar-Opcion {
    param(
        [string]$Titulo,
        [string[]]$Opciones,
        [switch]$PermitirVolver
    )

    while ($true) {

        Clear-Host

        Write-Host ""
        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host " $Titulo" -ForegroundColor Yellow
        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host ""

        for ($i = 0; $i -lt $Opciones.Count; $i++) {
            Write-Host (" {0}) {1}" -f ($i + 1), $Opciones[$i])
        }

        if ($PermitirVolver) {
            Write-Host ""
            Write-Host "----------------------------------------------" -ForegroundColor DarkGray
            Write-Host " 0) Volver" -ForegroundColor Yellow
        }

        Write-Host ""

        $seleccion = Read-Host "Seleccione una opcion"

        if ($PermitirVolver -and $seleccion -eq "0") {
            return "__VOLVER__"
        }

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

    $sedes = @(
        "Puerto",
        "Barracas"
    )

    $sede = Seleccionar-Opcion "SEDE" $sedes


    $gerencias = @(
        "Servicios",
        "Administracion",
        "Aduana",
        "Comercial",
        "Externo"
    )

    $sectoresPorGerencia = @{

    "Servicios" = @(
        "Seguridad",
        "Sistemas",
        "Mantenimiento",
        "Panol",
        "Compras",
        "Sala de reunion",
        "Taller",
        "Servicios"
    )

    "Administracion" = @(
        "Recursos Humanos",
        "Planeamiento",
        "Operaciones FDC",
        "Directorio",
        "Operaciones ZP",
        "Adm. Expo / Impo",
        "Logistica",
        "Finanzas",
        "Comercial",
        "Servicio al Cliente",
        "Gerencia",
        "Coord. Impo"
    )

    "Aduana" = @("Aduana")
    "Comercial" = @("Comercial")
    "Externo" = @("Finanzas")
}

$ubicaciones = @(
        "IT",
        "GateIN",
        "GateOUT",
        "Adm. Expo.",
        "Adm. Impo",
        "Seguridad",
        "Panol",
        "Balanza Porton 2",
        "Balanza Porton 4",
        "Balanza Porton 6",
        "Balanza Porton 8",
        "Recursos Humanos",
        "Contenedor Expo.",
        "Contenedor Impo",
        "Ventanilla",
        "RR.HH.",
        "Enfermeria",
        "Senasa",
        "Aduana"
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
        "Facundo Muniz",
        "Mariano Pestillo",
        "Marcelo Melle"
    )

    $paso = 0


while ($true) {

    switch ($paso) {

        #==========================
        # SEDE
        #==========================
        0 {

            $sede = Seleccionar-Opcion "SEDE" $sedes -PermitirVolver

            if ($sede -eq "__VOLVER__") {
                 return
            }

            $paso = 1
        }

        #==========================
        # GERENCIA
        #==========================
        1 {

            $gerencia = Seleccionar-Opcion "GERENCIA" $gerencias -PermitirVolver

            if ($gerencia -eq "__VOLVER__") {
                $paso = 0
            }
            else {
                $paso = 2
            }
        }

        #==========================
        # SECTOR
        #==========================
        2 {

            $sector = Seleccionar-Opcion `
                "SECTOR" `
                $sectoresPorGerencia[$gerencia] `
                -PermitirVolver

            if ($sector -eq "__VOLVER__") {
                $paso = 1
            }
            else {
                $paso = 3
            }
        }

        #==========================
        # UBICACION
        #==========================
        3 {

            $ubicacion = Seleccionar-Opcion `
                "UBICACION" `
                $ubicaciones `
                -PermitirVolver

            if ($ubicacion -eq "__VOLVER__") {
                $paso = 2
            }
            else {
                $paso = 4
            }
        }

        #==========================
        # TIPO
        #==========================
        4 {

            $tipoEquipo = Seleccionar-Opcion `
                "TIPO DE EQUIPO" `
                $tipos `
                -PermitirVolver

            if ($tipoEquipo -eq "__VOLVER__") {
                $paso = 3
            }
            else {
                $paso = 5
            }
        }

        #==========================
        # ESTADO
        #==========================
        5 {

            $estadoEquipo = Seleccionar-Opcion `
                "ESTADO DEL EQUIPO" `
                $estados `
                -PermitirVolver

            if ($estadoEquipo -eq "__VOLVER__") {
                $paso = 4
            }
            else {
                $paso = 6
            }
        }

        #==========================
        # TECNICO
        #==========================
        6 {

            $tecnico = Seleccionar-Opcion `
                "TECNICO" `
                $tecnicos `
                -PermitirVolver

            if ($tecnico -eq "__VOLVER__") {
                $paso = 5
            }
            else {
                break
            }
        }

    }

}

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
        
        Sede             = $sede
        
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
        Gerencia         = $gerencia
        Sector           = $sector
        Ubicacion        = $ubicacion
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
