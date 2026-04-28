# =============================================
# Función EstadoSeguridad - Muestra Firewall y Antivirus
# =============================================
function EstadoSeguridad {
    Write-Host "===== Estado de Seguridad =====" -ForegroundColor Cyan

    # Firewall
    try {
        $fw = Get-NetFirewallProfile | Select-Object Name, Enabled
        foreach ($f in $fw) {
            $estado = if ($f.Enabled) { "Activado" } else { "Desactivado" }
            Write-Host "Firewall ($($f.Name)):" $estado
        }
    } catch {
        Write-Host "No se pudo obtener estado del Firewall" -ForegroundColor Yellow
    }

    # Antivirus Windows Defender
    try {
        if (-not (Get-Module -ListAvailable -Name Defender)) {
            Import-Module Defender -ErrorAction SilentlyContinue
        }
        if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
            $wd = Get-MpComputerStatus
            $estadoAV = if ($wd.AntispywareEnabled) { "Activado" } else { "Desactivado" }
            Write-Host "Windows Defender Antivirus:" $estadoAV
        } else {
            Write-Host "Windows Defender no disponible en este sistema" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error al verificar Windows Defender" -ForegroundColor Yellow
    }

    Write-Host "================================" -ForegroundColor Cyan
}
# ================= EJECUTAR AUTOMÁTICAMENTE =================
EstadoSeguridad
