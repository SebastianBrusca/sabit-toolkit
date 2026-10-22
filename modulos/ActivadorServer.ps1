# ================= MODULO CAMBIO EDICION WINDOWS SERVER =================
# SABIT TOOLKIT
# Compatible con ejecucion desde el menu principal mediante IEX
# ========================================================================

# ================= FUNCIONES AUXILIARES =================

function Test-EsAdministrador {
    $identidad = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identidad)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Mostrar-BarraProgreso {
    param(
        [int]$Porcentaje = 0,
        [string]$Estado = "Procesando",
        [string]$Tiempo = "00:00:00"
    )

    $Porcentaje = [Math]::Max(0, [Math]::Min(100, $Porcentaje))

    $ancho = 40
    $llenos = [int][Math]::Floor(($Porcentaje / 100) * $ancho)
    $vacios = $ancho - $llenos

    $barra = ("█" * $llenos) + ("░" * $vacios)

    Write-Host "`r[$barra] $Porcentaje%  Estado: $Estado  Tiempo: $Tiempo     " `
        -NoNewline -ForegroundColor Cyan
}

# ================= MENU DEL MODULO =================

function Menu-CambioEdicionServer {

    while ($true) {

        Clear-Host

        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host "       CAMBIO DE EDICION WINDOWS SERVER" -ForegroundColor Yellow
        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host ""

        Write-Host "Este modulo utiliza DISM para cambiar la edicion." -ForegroundColor Gray
        Write-Host ""
        Write-Host "Edicion destino: Windows Server Standard" -ForegroundColor White
        Write-Host ""
        Write-Host "[1] Ejecutar cambio de edicion" -ForegroundColor Green
        Write-Host "[0] Volver al menu anterior" -ForegroundColor Red
        Write-Host ""

        $opcion = Read-Host "Selecciona una opcion"

        switch ($opcion) {

            "1" {

                Clear-Host

                Write-Host "==================================================" -ForegroundColor Cyan
                Write-Host "       CAMBIO DE EDICION WINDOWS SERVER" -ForegroundColor Yellow
                Write-Host "==================================================" -ForegroundColor Cyan
                Write-Host ""

                # Comprobar privilegios administrativos
                if (-not (Test-EsAdministrador)) {

                    Write-Host "ERROR: debes ejecutar SABIT como administrador." `
                        -ForegroundColor Red
                    Write-Host ""
                    Write-Host "Cierra el programa y vuelve a abrirlo como administrador." `
                        -ForegroundColor Yellow
                    Write-Host ""

                    Read-Host "Presiona Enter para continuar"
                    continue
                }

                # Confirmacion antes de modificar Windows
                Write-Host "ATENCION: se iniciara el cambio de edicion." `
                    -ForegroundColor Yellow
                Write-Host ""
                Write-Host "El proceso puede tardar varios minutos y puede requerir reiniciar." `
                    -ForegroundColor Gray
                Write-Host ""
                Write-Host "Asegurate de tener una licencia valida para la edicion destino." `
                    -ForegroundColor Gray
                Write-Host ""

                $confirmacion = Read-Host "Escribe SI para continuar"

                if ($confirmacion -cne "SI") {
                    Write-Host ""
                    Write-Host "Operacion cancelada." -ForegroundColor Yellow
                    Start-Sleep -Seconds 2
                    continue
                }

                # Ruta del ejecutable de DISM
                $dismExe = Join-Path $env:SystemRoot "System32\dism.exe"

                if (-not (Test-Path $dismExe)) {
                    Write-Host ""
                    Write-Host "ERROR: no se encontro DISM en:" -ForegroundColor Red
                    Write-Host $dismExe -ForegroundColor Yellow
                    Read-Host "Presiona Enter para continuar"
                    continue
                }

                # ======================================================
                # CLAVE DE PRODUCTO
                # ======================================================
                # Introduce una clave valida y autorizada para la edicion
                # de destino cuando tu escenario de licenciamiento lo requiera.
                # No se incluye ninguna clave predeterminada.

                $productKey = Read-Host "Introduce la clave de producto valida (deja vacio si no corresponde)"

                # Construir argumentos sin pasar por powershell.exe
                $argumentos = @(
                    "/Online"
                    "/Set-Edition:ServerStandard"
                )

                if (-not [string]::IsNullOrWhiteSpace($productKey)) {
                    $argumentos += "/ProductKey:$productKey"
                }

                $argumentos += "/AcceptEula"

                Write-Host ""
                Write-Host "Iniciando DISM..." -ForegroundColor Cyan
                Write-Host "No cierres esta ventana mientras se ejecuta el proceso." `
                    -ForegroundColor Gray
                Write-Host ""

                # DISM registra el progreso en su propia salida.
                # No se simula un porcentaje: se muestra un indicador de actividad.
                $inicio = Get-Date
                $salidaLog = Join-Path $env:TEMP (
                    "SABIT_DISM_" + [Guid]::NewGuid().ToString("N") + ".log"
                )

                $codigoSalida = $null
                $errorEjecucion = $null

                try {

                    # Ejecutar DISM directamente. No requiere powershell.exe.
                    # La salida se muestra en consola y se conserva en el log.
                    $proceso = Start-Process `
                        -FilePath $dismExe `
                        -ArgumentList $argumentos `
                        -PassThru `
                        -NoNewWindow `
                        -RedirectStandardOutput $salidaLog `
                        -RedirectStandardError ($salidaLog + ".err")

                    $frames = @("|", "/", "-", "\")
                    $indice = 0

                    while (-not $proceso.HasExited) {

                        $proceso.Refresh()

                        $transcurrido = (Get-Date) - $inicio
                        $tiempo = "{0:D2}:{1:D2}:{2:D2}" -f `
                            [int]$transcurrido.TotalHours, `
                            $transcurrido.Minutes, `
                            $transcurrido.Seconds

                        $frame = $frames[$indice % $frames.Count]
                        $indice++

                        Write-Host "`rDISM en ejecucion $frame  Tiempo: $tiempo     " `
                            -NoNewline -ForegroundColor Cyan

                        Start-Sleep -Milliseconds 500
                    }

                    $proceso.WaitForExit()
                    $codigoSalida = $proceso.ExitCode

                    $transcurrido = (Get-Date) - $inicio
                    $tiempo = "{0:D2}:{1:D2}:{2:D2}" -f `
                        [int]$transcurrido.TotalHours, `
                        $transcurrido.Minutes, `
                        $transcurrido.Seconds

                    Write-Host ""
                    Write-Host ""

                    if ($codigoSalida -eq 0) {

                        Mostrar-BarraProgreso `
                            -Porcentaje 100 `
                            -Estado "Completado" `
                            -Tiempo $tiempo

                        Write-Host ""
                        Write-Host ""
                        Write-Host "CAMBIO DE EDICION COMPLETADO" -ForegroundColor Green
                        Write-Host "DISM finalizo correctamente." -ForegroundColor Green
                        Write-Host "Codigo de salida: $codigoSalida" -ForegroundColor Gray
                        Write-Host ""
                        Write-Host "Comprueba la edicion instalada y sigue las indicaciones de Windows." `
                            -ForegroundColor Yellow

                    }
                    else {

                        Write-Host "DISM FINALIZO CON UN ERROR" -ForegroundColor Red
                        Write-Host "Codigo de salida: $codigoSalida" -ForegroundColor Yellow
                        Write-Host ""

                        if (Test-Path $salidaLog) {
                            Write-Host "Salida de DISM:" -ForegroundColor Cyan
                            Get-Content $salidaLog -Tail 40 -ErrorAction SilentlyContinue |
                                ForEach-Object {
                                    Write-Host $_ -ForegroundColor Gray
                                }
                        }

                        $logDism = Join-Path $env:SystemRoot "Logs\DISM\dism.log"

                        if (Test-Path $logDism) {
                            Write-Host ""
                            Write-Host "Log detallado de Windows:" -ForegroundColor Cyan
                            Write-Host $logDism -ForegroundColor Gray
                        }
                    }

                }
                catch {
                    $errorEjecucion = $_.Exception.Message

                    Write-Host ""
                    Write-Host "ERROR AL EJECUTAR DISM" -ForegroundColor Red
                    Write-Host $errorEjecucion -ForegroundColor Yellow
                }
                finally {
                    if (Test-Path $salidaLog) {
                        Remove-Item $salidaLog -Force -ErrorAction SilentlyContinue
                    }

                    if (Test-Path ($salidaLog + ".err")) {
                        Remove-Item ($salidaLog + ".err") `
                            -Force -ErrorAction SilentlyContinue
                    }
                }

                Write-Host ""
                Read-Host "Presiona Enter para volver al menu"
            }

            "0" {
                return
            }

            default {
                Write-Host ""
                Write-Host "Opcion no valida." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

# ================= INICIAR MODULO =================

Menu-CambioEdicionServer
