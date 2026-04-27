# Módulo: Información del sistema mejorado
Clear-Host
Write-Host "=== INFORMACION DEL SISTEMA ===" -ForegroundColor Cyan

# -----------------------
# PROCESADOR
# -----------------------
$cpu = Get-CimInstance Win32_Processor
Write-Host ""
Write-Host "PROCESADOR" -ForegroundColor Cyan
Write-Host "Nombre   : $($cpu.Name)"
Write-Host "Nucleos  : $($cpu.NumberOfCores)"
Write-Host "Velocidad: $($cpu.MaxClockSpeed) MHz"

# -----------------------
# MEMORIA RAM
# -----------------------
$ram = Get-CimInstance Win32_PhysicalMemory
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

# -----------------------
# SISTEMA OPERATIVO
# -----------------------
$os = Get-CimInstance Win32_OperatingSystem
Write-Host ""
Write-Host "SISTEMA OPERATIVO" -ForegroundColor Cyan
Write-Host "Nombre : $($os.Caption)"
Write-Host "Arq    : $($os.OSArchitecture)"
Write-Host "Version: $($os.Version)"

# -----------------------
# DISCOS
# -----------------------
$disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$totalDisk = [math]::round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB,2)
$diskNames = ($disks | Select-Object -ExpandProperty DeviceID) -join ", "

Write-Host ""
Write-Host "DISCOS" -ForegroundColor Cyan
Write-Host "Memoria Total: $totalDisk GB"
Write-Host "Nombres      : $diskNames"

# -----------------------
# RED (IP y MAC)
# -----------------------
Write-Host ""
Write-Host "IPCONFIG" -ForegroundColor Cyan

# Obtener todas las interfaces activas con IPv4
$adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" }

if ($adapters) {
    foreach ($adapter in $adapters) {
        $nic = Get-NetAdapter | Where-Object {$_.InterfaceIndex -eq $adapter.InterfaceIndex} | Select-Object -First 1
        $type = if ($nic.PhysicalMediaType -eq "802.3") {"Ethernet"} else {"Wi-Fi"}
        Write-Host "$type IP : $($adapter.IPAddress)"
        Write-Host "$type MAC: $($nic.MacAddress)"
    }
} else {
    Write-Host "No se encontraron interfaces activas."
}

# -----------------------
# Esperar Enter y volver al menu
# -----------------------
Write-Host ""
Write-Host "Presione Enter para volver al menú..."
$null = $Host.UI.RawUI.ReadKey("IncludeKeyDown")
. "$PSScriptRoot\..\sabit.ps1"