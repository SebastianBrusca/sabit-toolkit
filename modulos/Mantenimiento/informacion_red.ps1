# ================= INFORMACION DE RED =================
Clear-Host
Write-Host "=== INFORMACION DE RED ===" -ForegroundColor Cyan

try {
    # Obtener todas las interfaces activas IPv4
    $adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" }

    if ($adapters) {
        foreach ($adapter in $adapters) {
            try {
                $nic = Get-NetAdapter | Where-Object {$_.InterfaceIndex -eq $adapter.InterfaceIndex} | Select-Object -First 1
                $type = if ($nic.PhysicalMediaType -eq "802.3") {"Ethernet"} else {"Wi-Fi"}

                # Gateway con manejo de error si no existe
                try {
                    $route = Get-NetRoute -InterfaceIndex $adapter.InterfaceIndex -DestinationPrefix "0.0.0.0/0" -ErrorAction Stop
                    $gateway = if ($route) { $route.NextHop } else { "" }
                } catch {
                    $gateway = ""
                }

                # Obtener DNS
                $dns = (Get-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4).ServerAddresses -join ", "

                # Mostrar info
                Write-Host ""
                Write-Host "Interfaz : $($nic.Name)" -ForegroundColor Cyan
                Write-Host "Tipo     : $type"
                Write-Host "IP       : $($adapter.IPAddress)"
                Write-Host "Mascara  : $($adapter.PrefixLength)"
                Write-Host "Gateway  : $gateway"
                Write-Host "DNS      : $dns"

            } catch {
                Write-Host "No se pudo obtener información para la interfaz $($adapter.InterfaceIndex)" -ForegroundColor Yellow
            }
        }

        # Test de conectividad rápida
        Write-Host ""
        Write-Host "Test de ping a 8.8.8.8..." -ForegroundColor Yellow
        try {
            Test-Connection 8.8.8.8 -Count 2 -ErrorAction Stop | ForEach-Object {
                Write-Host "Ping: $($_.Address) - $($_.ResponseTime) ms"
            }
        } catch {
            Write-Host "No se pudo realizar ping." -ForegroundColor Red
        }

    } else {
        Write-Host "No se encontraron interfaces activas." -ForegroundColor Red
    }

} catch {
    Write-Host "Error al obtener información de red: $($_.Exception.Message)" -ForegroundColor Red
}

# Esperar Enter para volver al menú remoto
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
