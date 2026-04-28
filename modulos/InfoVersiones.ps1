# =============================================
# Función InfoVersiones - Muestra versión de Windows y Java
# =============================================
function InfoVersiones {
    Write-Host "===== Versiones del Sistema =====" -ForegroundColor Cyan

    # Versión de Windows
    $win = (Get-ComputerInfo -Property WindowsProductName, WindowsVersion)
    Write-Host "Windows:" $win.WindowsProductName "Version:" $win.WindowsVersion

    # Versión de Java
    try {
        $java = & java -version 2>&1
        Write-Host "`nJava instalada:" -ForegroundColor Green
        Write-Host $java
    } catch {
        Write-Host "`nJava no está instalada" -ForegroundColor Red
    }

    Write-Host "================================" -ForegroundColor Cyan
}
