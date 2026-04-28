# =============================================
# Función EstadoSeguridad - Muestra Firewall y Antivirus
# =============================================
function EstadoSeguridad {
    Write-Host "===== Estado de Seguridad =====" -ForegroundColor Cyan

    # Firewall
    $fw = Get-NetFirewallProfile | Select-Object Name, Enabled
    foreach ($f in $fw) {
        $estado = if ($f.Enabled) { "Activado" } else { "Desactivado" }
        Write-Host "Firewall ($($f.Name)):" $estado
    }

    # Antivirus Windows Defender
    try {
        $wd = Get-MpComputerStatus
        $estadoAV = if ($wd.AntispywareEnabled) { "Activado" } else { "Desactivado" }
        Write-Host "Windows Defender Antivirus:" $estadoAV
    } catch {
        Write-Host "Windows Defender Antivirus no disponible" -ForegroundColor Yellow
    }

    Write-Host "================================" -ForegroundColor Cyan
}
