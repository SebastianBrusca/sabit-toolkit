# =============================================
# Función InfoVersiones - Muestra versión de Windows y Java
# =============================================
function InfoVersiones {
    Write-Host "===== Versiones del Sistema =====" -ForegroundColor Cyan

    # Versión de Windows
    try {
        $win = Get-ComputerInfo -Property WindowsProductName, WindowsVersion
        Write-Host "Windows:" $win.WindowsProductName "Version:" $win.WindowsVersion
    } catch {
        Write-Host "No se pudo obtener la versión de Windows" -ForegroundColor Yellow
    }

    # Versión de Java
    try {
        # Buscar java.exe en el PATH
        $javaPath = Get-Command java -ErrorAction SilentlyContinue
        if ($javaPath) {
            $javaVersion = & java -version 2>&1
            Write-Host "`nJava instalada:" -ForegroundColor Green
            Write-Host $javaVersion
        } else {
            Write-Host "`nJava no está instalada o no está en el PATH" -ForegroundColor Red
        }
    } catch {
        Write-Host "`nError al verificar Java" -ForegroundColor Red
    }

    Write-Host "================================" -ForegroundColor Cyan
}
# ================= EJECUTAR AUTOMÁTICAMENTE =================
InfoVersiones
