```powershell
# ================= MODULO CAMBIO EDICION WINDOWS SERVER =================

Clear-Host

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "      CAMBIO DE EDICION WINDOWS SERVER" -ForegroundColor Yellow
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Este modulo ejecutara:" -ForegroundColor Gray
Write-Host ""
Write-Host "DISM /Online /Set-Edition:ServerStandard" -ForegroundColor White
Write-Host ""

Write-Host "[1] Ejecutar ProductKey" -ForegroundColor Green
Write-Host "[0] Volver al menu anterior" -ForegroundColor Red
Write-Host ""

$opcion = Read-Host "Selecciona una opcion"

switch ($opcion) {

    "1" {

        Clear-Host

        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host "      CAMBIO DE EDICION WINDOWS SERVER" -ForegroundColor Yellow
        Write-Host "==============================================" -ForegroundColor Cyan
        Write-Host ""

        Write-Host "Ejecutando DISM como administrador..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "El proceso puede tardar varios minutos." -ForegroundColor Gray
        Write-Host ""

        try {

            # ==========================================================
            # CONFIGURACION
            # ==========================================================

            $productKey = "TVRH6-WHNXV-R9WG3-9XRFY-MY832"

            # Creamos un archivo temporal para guardar la salida de DISM
            $archivoSalida = Join-Path $env:TEMP "DISM_Edicion_Server.log"

            if (Test-Path $archivoSalida) {
                Remove-Item $archivoSalida -Force -ErrorAction SilentlyContinue
            }

            # ==========================================================
            # INICIAR DISM
            # ==========================================================

            $argumentos = @(
                "/Online"
                "/Set-Edition:ServerStandard"
                "/ProductKey:$productKey"
                "/AcceptEula"
            )

            $inicio = Get-Date

            $proceso = Start-Process `
                -FilePath "dism.exe" `
                -ArgumentList $argumentos `
                -Verb RunAs `
                -RedirectStandardOutput $archivoSalida `
                -RedirectStandardError $archivoSalida `
                -PassThru

            # ==========================================================
            # BARRA DE PROGRESO
            # ==========================================================

            $porcentaje = 0
            $spinner = @("|", "/", "-", "\")
            $spinnerIndex = 0

            while (-not $proceso.HasExited) {

                # Leer la salida que DISM va generando
                if (Test-Path $archivoSalida) {

                    try {

                        $contenido = Get-Content $archivoSalida -Raw -ErrorAction SilentlyContinue

                        if ($contenido) {

                            # Buscar porcentajes como:
                            # 10.0%
                            # 25.0%
                            # 50.0%
                            # 100.0%

                            $coincidencias = [regex]::Matches(
                                $contenido,
                                '(\d{1,3}(?:\.\d+)?)%'
                            )

                            if ($coincidencias.Count -gt 0) {

                                $ultimo = $coincidencias[$coincidencias.Count - 1].Groups[1].Value

                                $valor = [int][math]::Floor(
                                    [double]$ultimo
                                )

                                if ($valor -ge 0 -and $valor -le 100) {
                                    $porcentaje = $valor
                                }
                            }
                        }

                    }
                    catch {
                        # Si el archivo todavía está siendo escrito,
                        # simplemente continuamos.
                    }
                }

                # Tiempo transcurrido
                $transcurrido = (Get-Date) - $inicio

                $horas = [int]$transcurrido.TotalHours
                $minutos = $transcurrido.Minutes
                $segundos = $transcurrido.Seconds

                $tiempo = "{0:D2}:{1:D2}:{2:D2}" -f $horas, $minutos, $segundos

                # ======================================================
                # DIBUJAR BARRA
                # ======================================================

                $anchoBarra = 40

                $cantidadLlena = [int][math]::Floor(
                    ($porcentaje / 100) * $anchoBarra
                )

                $cantidadVacia = $anchoBarra - $cantidadLlena

                $barraLlena = "█" * $cantidadLlena
                $barraVacia = "░" * $cantidadVacia

                $indicador = $spinner[$spinnerIndex % $spinner.Count]
                $spinnerIndex++

                Write-Host "`r[$barraLlena$barraVacia] $porcentaje%  Estado: Procesando $indicador  Tiempo: $tiempo" -NoNewline -ForegroundColor Cyan

                Start-Sleep -Milliseconds 500

                # Actualizar objeto del proceso
                $proceso.Refresh()
            }

            # ==========================================================
            # PROCESO TERMINADO
            # ==========================================================

            $proceso.WaitForExit()

            # Leer nuevamente la salida final
            $salidaFinal = ""

            if (Test-Path $archivoSalida) {
                $salidaFinal = Get-Content $archivoSalida -Raw -ErrorAction SilentlyContinue
            }

            # Intentar obtener el último porcentaje informado
            $coincidenciasFinales = [regex]::Matches(
                $salidaFinal,
                '(\d{1,3}(?:\.\d+)?)%'
            )

            if ($coincidenciasFinales.Count -gt 0) {

                $ultimoFinal = $coincidenciasFinales[
                    $coincidenciasFinales.Count - 1
                ].Groups[1].Value

                $porcentaje = [int][math]::Floor(
                    [double]$ultimoFinal
                )
            }

            # Si DISM terminó correctamente, mostrar 100%
            if ($proceso.ExitCode -eq 0) {
                $porcentaje = 100
            }

            # ==========================================================
            # BARRA FINAL
            # ==========================================================

            $anchoBarra = 40

            $cantidadLlena = [int][math]::Floor(
                ($porcentaje / 100) * $anchoBarra
            )

            $cantidadVacia = $anchoBarra - $cantidadLlena

            if ($cantidadLlena -lt 0) {
                $cantidadLlena = 0
            }

            if ($cantidadVacia -lt 0) {
                $cantidadVacia = 0
            }

            $barraLlena = "█" * $cantidadLlena
            $barraVacia = "░" * $cantidadVacia

            Write-Host "`r[$barraLlena$barraVacia] $porcentaje%  Estado: Finalizado" -ForegroundColor Green

            Write-Host ""
            Write-Host ""

            # ==========================================================
            # RESULTADO
            # ==========================================================

            if ($proceso.ExitCode -eq 0) {

                Write-Host "==============================================" -ForegroundColor Green
                Write-Host "   CAMBIO DE EDICION COMPLETADO" -ForegroundColor Green
                Write-Host "==============================================" -ForegroundColor Green
                Write-Host ""
                Write-Host "DISM finalizo correctamente." -ForegroundColor Green
                Write-Host ""
                Write-Host "Codigo de salida: $($proceso.ExitCode)" -ForegroundColor Gray

            }
            else {

                Write-Host "==============================================" -ForegroundColor Red
                Write-Host "   DISM FINALIZO CON UN ERROR" -ForegroundColor Red
                Write-Host "==============================================" -ForegroundColor Red
                Write-Host ""
                Write-Host "Codigo de salida: $($proceso.ExitCode)" -ForegroundColor Yellow
                Write-Host ""

                if ($salidaFinal) {

                    Write-Host "Ultima salida de DISM:" -ForegroundColor Yellow
                    Write-Host ""
                    Write-Host $salidaFinal -ForegroundColor Gray
                }
            }

            # ==========================================================
            # LIMPIAR ARCHIVO TEMPORAL
            # ==========================================================

            if (Test-Path $archivoSalida) {
                Remove-Item $archivoSalida -Force -ErrorAction SilentlyContinue
            }

        }
        catch {

            Write-Host ""
            Write-Host "==============================================" -ForegroundColor Red
            Write-Host "   ERROR AL EJECUTAR DISM" -ForegroundColor Red
            Write-Host "==============================================" -ForegroundColor Red
            Write-Host ""
            Write-Host $_.Exception.Message -ForegroundColor Yellow

        }

        Write-Host ""
        Read-Host "Presione Enter para volver al menu"

        return
    }

    "0" {

        Write-Host ""
        Write-Host "Volviendo al menu..." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    default {

        Write-Host ""
        Write-Host "Opcion no valida." -ForegroundColor Red
        Start-Sleep -Seconds 1
        return
    }
}
```
