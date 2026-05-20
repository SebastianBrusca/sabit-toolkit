# ================= REINICIO DE SERVICIOS =================
Clear-Host
Write-Host "=== REINICIO DE SERVICIOS CLAVE ===" -ForegroundColor Cyan

# Lista de servicios a reiniciar
$servicios = @("Spooler","W32Time","BITS")

foreach ($svc in $servicios) {
    try {
        $serv = Get-Service -Name $svc -ErrorAction Stop

        if ($serv.Status -eq "Running") {
            Write-Host "Reiniciando servicio: $svc"
            Restart-Service -Name $svc -Force -ErrorAction Stop
        } else {
            Write-Host "Iniciando servicio: $svc"
            Start-Service -Name $svc -ErrorAction Stop
        }

        Write-Host "Servicio $svc está ahora: $((Get-Service $svc).Status)" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo acceder o reiniciar el servicio $svc. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Reinicio de servicios completado." -ForegroundColor Cyan

# Esperar Enter y volver al menú remoto
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
