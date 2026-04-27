# Módulo: Información del sistema compatible remoto
Clear-Host
Write-Host "=== INFORMACION DEL SISTEMA ===" -ForegroundColor Cyan

# -----------------------
# PROCESADOR
# -----------------------
try {
    $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop
    Write-Host ""
    Write-Host "PROCESADOR" -ForegroundColor Cyan
    Write-Host "Nombre   : $($cpu.Name)"
    Write-Host "Nucleos  : $($cpu.NumberOfCores)"
    Write-Host "Velocidad: $($cpu.MaxClockSpeed) MHz"
} catch {
    Write-Host "No se pudo obtener información del procesador." -ForegroundColor Red
}

# -----------------------
# MEMORIA RAM
# -----------------------
try {
    $ram = Get-CimInstance Win32_PhysicalMemory -ErrorAction Stop
    $totalRam = [math]::round(($ram | Measure-Object -Property Capacity -Sum).Sum / 1GB,2)
    $socketType = ($ram | Select-Object -First 1).MemoryType
    $socketText = switch ($socketType) {
        20 { "DDR" }
        21 { "DDR2" }
        24 { "DDR3" }
        26 { "DDR4" }
        default { "Desconocido" }
    }
    $ramCount = ($ram | Measure-Object).Count

    Write-Host ""
    Write-Host "MEMORIA RAM" -ForegroundColor Cyan
    Write-Host "Total   : $totalRam GB"
    Write-Host "Socket  : $socketText"
    Write-Host "Cantidad: $ramCount modulos"
} catch {
    Write-Host "No se pudo obtener información de la RAM." -ForegroundColor Red
}

# -----------------------
# SISTEMA OPERATIVO
# -----------------------
try {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    Write-Host ""
    Write-Host "SISTEMA OPERATIVO" -ForegroundColor Cyan
    Write-Host "Nombre : $($os.Caption)"
    Write-Host "Arq    : $($os.OSArchitecture)"
    Write-Host "Version: $($os.Version)"
} catch {
    Write-Host "No se pudo obtener información del sistema operativo." -ForegroundColor Red
}

# -----------------------
# DISCOS
# -----------------------
try {
    $disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    $totalDisk = [math]::round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB,2)
    $diskNames = ($disks | Select-Object -ExpandProperty DeviceID) -join ", "

    Write-Host ""
    Write-Host "DISCOS" -ForegroundColor Cyan
    Write-Host "Memoria Total: $totalDisk GB"
    Write-Host "Nombres      : $diskNames"
} catch {
    Write-Host "No se pudo obtener información de los discos." -ForegroundColor Red
}

# -----------------------
# RED (IP y MAC)
# -----------------------
try {
    Write-Host ""
    Write-Host "IPCONFIG" -ForegroundColor Cyan

    $adapters = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop | Where-Object { $_.IPAddress -ne "127.0.0.1" }

    if ($adapters) {
        foreach ($adapter in $adapters) {
            try {
                $nic = Get-NetAdapter | Where-Object {$_.InterfaceIndex -eq $adapter.InterfaceIndex} | Select-Object -First 1
                $type = if ($nic.PhysicalMediaType -eq "802.3") {"Ethernet"} else {"Wi-Fi"}
                Write-Host "$type IP : $($adapter.IPAddress)"
                Write-Host "$type MAC: $($nic.MacAddress)"
            } catch {
                Write-Host "No se pudo obtener MAC para la interfaz $($adapter.InterfaceIndex)." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "No se encontraron interfaces activas."
    }
} catch {
    Write-Host "No se pudo obtener información de red." -ForegroundColor Red
}

# -----------------------
# Esperar Enter y volver al menu
# -----------------------
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
