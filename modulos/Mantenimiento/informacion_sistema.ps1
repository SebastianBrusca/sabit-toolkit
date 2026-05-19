# ================= INFORMACION DEL SISTEMA =================
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
    Write-Host ""
    Write-Host "DISCOS" -ForegroundColor Cyan
    foreach ($disk in $disks) {
        # Obtener información de tipo físico (HDD o SSD)
        $phys = Get-PhysicalDisk | Where-Object { $_.FriendlyName -like "*$($disk.DeviceID)*" } | Select-Object -First 1
        $mediaType = if ($phys) { $phys.MediaType } else { "Desconocido" }

        $totalGB = [math]::round($disk.Size / 1GB,2)
        $freeGB  = [math]::round($disk.FreeSpace / 1GB,2)
        $usedGB  = [math]::round($totalGB - $freeGB,2)

        Write-Host "Disco $($disk.DeviceID) - Tipo: $mediaType"
        Write-Host "Total : $totalGB GB | Libre: $freeGB GB | Ocupado: $usedGB GB"
        Write-Host ""
    }
} catch {
    Write-Host "No se pudo obtener información de los discos." -ForegroundColor Red
}

# -----------------------
# RED (Ethernet y Wi-Fi reales)
# -----------------------
try {
    Write-Host ""
    Write-Host "IPCONFIG" -ForegroundColor Cyan

    # Ethernet real
    $ethernet = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -match "Ethernet" -and $_.IPAddress -notlike "169.254*" } | Select-Object -First 1
    if ($ethernet) {
        $nic = Get-NetAdapter -InterfaceIndex $ethernet.InterfaceIndex
        Write-Host "Ethernet IP : $($ethernet.IPAddress)"
        Write-Host "Ethernet MAC: $($nic.MacAddress)"
    }

    # Wi-Fi real
    $wifi = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -match "Wi-Fi" -and $_.IPAddress -notlike "169.254*" } | Select-Object -First 1
    if ($wifi) {
        $nic = Get-NetAdapter -InterfaceIndex $wifi.InterfaceIndex
        Write-Host "Wi-Fi IP : $($wifi.IPAddress)"
        Write-Host "Wi-Fi MAC: $($nic.MacAddress)"
    }

} catch {
    Write-Host "No se pudo obtener información de red." -ForegroundColor Red
}

# -----------------------
# Esperar Enter y volver al menu
# -----------------------
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
