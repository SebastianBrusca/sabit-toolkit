# MantenimientoPC.ps1
# Version inicial para SabIT
# Basado en la estructura de inventario.ps1

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

        $n = 0
        if ([int]::TryParse($seleccion,[ref]$n)) {
            if ($n -ge 1 -and $n -le $Opciones.Count) {
                return $Opciones[$n-1]
            }
        }

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

    $siNo = @(
        "Si",
        "No"
    )

    $tecnicos = @(
    "Sebastian Brusca",
    "Facundo Muniz",
    "Mariano Pestillo",
    "Marcelo Melle"
    )

    $paso = 0
    $continuar = $true

    while($continuar){

    switch($paso){

        #==========================
        # SEDE
        #==========================
        0{
            $sede = Seleccionar-Opcion "SEDE" $sedes -PermitirVolver

            if($sede -eq "__VOLVER__"){
                return
            }

            $paso = 1
        }

        #==========================
        # PASTA TERMICA
        #==========================
        1{
            $pasta = Seleccionar-Opcion "¿SE CAMBIO LA PASTA TERMICA?" $siNo -PermitirVolver

            if($pasta -eq "__VOLVER__"){
                $paso = 0
            }
            else{
                $paso = 2
            }
        }

        #==========================
        # COOLER
        #==========================
        2{
            $cooler = Seleccionar-Opcion "¿SE LIMPIO EL COOLER?" $siNo -PermitirVolver

            if($cooler -eq "__VOLVER__"){
                $paso = 1
            }
            else{
                $paso = 3
            }
        }

        #==========================
        # TECNICO
        #==========================
        3{

            $tecnico = Seleccionar-Opcion `
                "TECNICO" `
                $tecnicos `
                -PermitirVolver

            if($tecnico -eq "__VOLVER__"){
                $paso = 2
            }
            else{
                $paso = 4
            }

        }

        #==========================
        # NOTA
        #==========================
        4{

            Clear-Host

            Write-Host ""
            Write-Host "==============================================" -ForegroundColor Cyan
            Write-Host " NOTA (Opcional)" -ForegroundColor Yellow
            Write-Host "==============================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Deje vacio si no desea registrar ninguna nota."
            Write-Host ""

            $nota = Read-Host "Nota"

            $continuar = $false

            }

        }

    }

    Write-Host ""
    Write-Host "Obteniendo informacion del equipo..." -ForegroundColor Cyan

    $nombre = $env:COMPUTERNAME

    $eth = Get-NetAdapter |
        Where-Object {
            $_.Status -eq "Up" -and
            $_.HardwareInterface -eq $true -and
            $_.InterfaceDescription -notmatch "Wireless|Wi-Fi|WiFi"
        } |
        Select-Object -First 1

    if($eth){
        $mac = $eth.MacAddress
    }else{
        $wifi = Get-NetAdapter |
            Where-Object {
                $_.InterfaceDescription -match "Wireless|Wi-Fi|WiFi"
            } |
            Select-Object -First 1

        $mac = $wifi.MacAddress
    }

    $fechaMant = Get-Date
    $proximoMant = $fechaMant.AddMonths(6)

    $body = @{
        Token              = "SABIT-INV-2026"
        Accion             = "MantenimientoPC"
        Sede               = $sede
        Nombre             = $nombre
        Mac                = $mac
        FechaMantenimiento = $fechaMant.ToString("dd/MM/yyyy")
        ProximoMantenimiento = $proximoMant.ToString("dd/MM/yyyy")
        Pasta              = $pasta
        Cooler             = $cooler
        Tecnico            = $tecnico
        Nota               = $nota
        Estado             = "Finalizado"
    } | ConvertTo-Json

    Write-Host ""
    Write-Host "Enviando mantenimiento..." -ForegroundColor Cyan

    $resultado = Invoke-RestMethod `
        -Uri $url `
        -Method POST `
        -ContentType "application/json" `
        -Body $body

    if($resultado.status -eq "created"){
        Write-Host ""
        Write-Host "==============================================" -ForegroundColor Green
        Write-Host " Mantenimiento registrado correctamente" -ForegroundColor Green
        Write-Host "==============================================" -ForegroundColor Green
    }
    else{
        Write-Host ""
        Write-Host ($resultado | ConvertTo-Json)
    }

}
catch{
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Read-Host "Presione ENTER para continuar"
