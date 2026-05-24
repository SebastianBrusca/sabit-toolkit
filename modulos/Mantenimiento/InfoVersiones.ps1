# =============================================================================
# Función InfoVersiones - Muestra versión de Windows y versión simplificada de Java
# =============================================================================
Clear-Host

function InfoVersiones {
    Write-Host "===== Versiones del Sistema =====" -ForegroundColor Cyan

    # 1. Versión de Windows (Usando CIM)
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $winReg = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"

        $producto = $os.Caption          
        $version = $winReg.DisplayVersion 
        $build = $os.BuildNumber          

        Write-Host "Windows: $producto" -ForegroundColor Green
        Write-Host "Version: $version" -ForegroundColor Green
        Write-Host "Build: $build" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo obtener la versión de Windows" -ForegroundColor Yellow
    }

    # 2. Versión de Java (Corregido y simplificado)
    try {
        # Buscar java.exe en el PATH
        $javaPath = Get-Command java -ErrorAction SilentlyContinue
        if ($javaPath) {
            # Capturar la salida de versión de Java
            $javaVersionFull = & java -version 2>&1 | Out-String
            
            Write-Host "`nJava instalada:" -ForegroundColor Green

            # Buscamos el formato clásico "1.8.0..." o los formatos nuevos "9...", "11...", "17..."
            if ($javaVersionFull -match '"(1\.)?(\d+)\.') {
                $versionDetectada = $Matches[2]
                Write-Host "-> Tipo de Java detectado: Java $versionDetectada" -ForegroundColor Magenta
            } else {
                Write-Host "-> Tipo de Java detectado: Versión comercial no identificada" -ForegroundColor Yellow
            }

            # Mostrar la salida detallada original
            Write-Host "Detalle técnico:" -ForegroundColor Gray
            Write-Host $javaVersionFull
        } else {
            Write-Host "`nJava no está instalada o no está en el PATH" -ForegroundColor Red
        }
    } catch {
        # Esto te mostrará el error real en pantalla si algo vuelve a fallar
        Write-Host "`nError al verificar Java: $_" -ForegroundColor Red
    }

    Write-Host "================================" -ForegroundColor Cyan
}

# ================= EJECUTAR AUTOMÁTICAMENTE =================
InfoVersiones

# -----------------------------------------------------------
# Esperar Enter y volver al menú
# -----------------------------------------------------------
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
