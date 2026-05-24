# =============================================================================
# Función InfoVersiones - Muestra versión de Windows y versión simplificada de Java
# =============================================================================
Clear-Host

function InfoVersiones {
    Write-Host "===== Versiones del Sistema =====" -ForegroundColor Cyan

    # 1. Versión de Windows
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $winReg = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"

        $producto = $os.Caption          # Muestra "Microsoft Windows 11 Pro" correctamente
        $version = $winReg.DisplayVersion # Muestra la versión de actualización (ej. 25H2)
        $build = $os.BuildNumber          # Muestra la compilación del SO

        Write-Host "Windows: $producto" -ForegroundColor Green
        Write-Host "Version: $version" -ForegroundColor Green
        Write-Host "Build: $build" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo obtener la versión de Windows" -ForegroundColor Yellow
    }

    try {
        $javaPath = Get-Command java -ErrorAction SilentlyContinue
        if ($javaPath) {
            $javaVersionFull = & java -version 2>&1 | Out-String
            
            Write-Host "`nJava instalada:" -ForegroundColor Green

            if ($javaVersionFull -match '"(\d+)\.(\d+)\.(\d+)(_.*)?"' -or $javaVersionFull -match '"(\d+)(\.\d+)?(\.\d+)?.*"') {
                $numPrincipal = $Matches[1]
                $numSecundario = $Matches[2]

                if ($numPrincipal -eq "1" -and $numSecundario -ne $null) {
                    $versionComercial = $numSecundario.Replace(".", "")
                } else {
                    $versionComercial = $numPrincipal
                }
                
                Write-Host "-> Tipo de Java detectado: Java $versionComercial" -ForegroundColor Magentare
            } else {
                Write-Host "-> Tipo de Java detectado: Desconocido" -ForegroundColor Yellow
            }

            Write-Host "Detalle técnico:" -ForegroundColor Gray
            Write-Host $javaVersionFull
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

# -----------------------------------------------------------
# Esperar Enter y volver al menú
# -----------------------------------------------------------
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
