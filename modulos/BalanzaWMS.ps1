function Menu-Submodulos11 {
    $salir = $false
    while (-not $salir) {
        Clear-Host
        Write-Host "================ BalanzaWMS =================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "[1] Verificar carpeta e instalar BalanzaWMS" -ForegroundColor White
        Write-Host ""
        Write-Host "[2] Verificar IP" -ForegroundColor White
        Write-Host ""
        Write-Host "[3] Verificar COM y BaudRate" -ForegroundColor White
        Write-Host ""
        Write-Host "[4] Ejecutar PuenteComWeb.exe como administrador" -ForegroundColor White 
        Write-Host ""
        Write-Host "[5] Abrir Putty" -ForegroundColor White
        Write-Host ""
        Write-Host "[0] Volver al menú principal" -ForegroundColor Red
        Write-Host ""

        $opcion = Read-Host "Selecciona una opción"

        $rutaSubmodulos = Join-Path $PSScriptRoot "submodulos11"

        switch ($opcion) {
            '1' { & (Join-Path $rutaSubmodulos "1_VerificarCarpeta.ps1") }
            '2' { & (Join-Path $rutaSubmodulos "2_VerificarIP.ps1") }
            '3' { & (Join-Path $rutaSubmodulos "3_VerificarCOM.ps1") }
            '4' { & (Join-Path $rutaSubmodulos "4_EjecutarPuenteComWeb.ps1") }
            '5' { & (Join-Path $rutaSubmodulos "5_AbrirPutty.ps1") }
            '0' { $salir = $true }
            default { Write-Host "Opción no válida." -ForegroundColor Red; Start-Sleep -Seconds 1 }
        }
    }
}
