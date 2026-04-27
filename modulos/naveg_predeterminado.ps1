# Módulo: Navegador Predeterminado
Clear-Host
Write-Host "=== NAVEGADOR PREDETERMINADO ===" -ForegroundColor Cyan

# URL que queremos agregar
$url = "https://www.sebba.site/"

# Ruta predeterminada de Edge
$edgePath = "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe"

if (Test-Path $edgePath) {
    Write-Host ""
    Write-Host "Abriendo Microsoft Edge..." -ForegroundColor Green
    Start-Process $edgePath
    # Copiar link al portapapeles
    $url | Set-Clipboard
    Write-Host "El link $url ya esta copiado al portapapeles." -ForegroundColor Green
    Write-Host ""
    Write-Host "Ahora ve a Configuracion -> Explorador predeterminado y pega el link que ya esta copiado." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "No se encontro Microsoft Edge en la ruta predeterminada." -ForegroundColor Red
}

Write-Host ""
Write-Host "Presione Enter para volver al menu..."
$null = $Host.UI.RawUI.ReadKey("IncludeKeyDown")

# Volver al menu principal
. "$PSScriptRoot\..\sabit.ps1"