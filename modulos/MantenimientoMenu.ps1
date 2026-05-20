# ================= DEFINIR RAMA =================
$branch = "SABIT-0.2"  # Cambiás a "main" cuando quieras publicar

function Menu-Submodulos11 {
    $salir = $false
    while (-not $salir) {
        Clear-Host
        Write-Host "================ BalanzaWMS =================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "[1] Estado de Seguridad" -ForegroundColor White
        Write-Host ""
        Write-Host "[2] Informacion de Versiones" -ForegroundColor White
        Write-Host ""
        Write-Host "[3] Informacion de Sistema" -ForegroundColor White
        Write-Host ""
        Write-Host "[4] Lipieza de archivos temporales." -ForegroundColor White 
        Write-Host ""
        Write-Host "[0] Volver al menú principal" -ForegroundColor Red
        Write-Host ""

        $opcion = Read-Host "Selecciona una opción"

        # URLs directos de los submódulos en GitHub
        $urls = @{
            '1' = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/$branch/modulos/Mantenimiento/EstadoSeguridad.ps1"
            '2' = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/$branch/modulos/Mantenimiento/InfoVersiones.ps1"
            '3' = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/$branch/modulos/Mantenimiento/informacion_sistema.ps1"
            '4' = "https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/refs/heads/$branch/modulos/Mantenimiento/limpieza_temporales.ps1"
        }

        if ($urls.ContainsKey($opcion)) {
            try {
                # Descargar y ejecutar el script en la misma ventana
                $scriptContent = Invoke-RestMethod -Uri $urls[$opcion] -UseBasicParsing
                $scriptBlock = [scriptblock]::Create($scriptContent)
                Invoke-Command -ScriptBlock $scriptBlock
            } catch {
                Write-Host "Error al cargar el módulo: $_" -ForegroundColor Red
                Read-Host "Presione Enter para continuar..."
            }
        } elseif ($opcion -eq '0') {
            $salir = $true
        } else {
            Write-Host "Opción no válida." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
# ESTA LÍNEA ES LA QUE HACE QUE EL MENÚ SE MUESTRE AL CARGAR EL ARCHIVO
Menu-Submodulos11
