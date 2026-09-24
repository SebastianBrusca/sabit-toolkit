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

            $comando = '/c dism /online /set-edition:serverStandard /productkey:TVRH6-WHNXV-R9WG3-9XRFY-MY832 /accepteula'

            $proceso = Start-Process `
                -FilePath "cmd.exe" `
                -ArgumentList $comando `
                -Verb RunAs `
                -Wait `
                -PassThru

            Write-Host ""

            if ($proceso.ExitCode -eq 0) {

                Write-Host "==============================================" -ForegroundColor Green
                Write-Host "   COMANDO EJECUTADO CORRECTAMENTE" -ForegroundColor Green
                Write-Host "==============================================" -ForegroundColor Green

            }
            else {

                Write-Host "==============================================" -ForegroundColor Red
                Write-Host "   DISM FINALIZO CON UN ERROR" -ForegroundColor Red
                Write-Host "==============================================" -ForegroundColor Red
                Write-Host ""
                Write-Host "Codigo de salida: $($proceso.ExitCode)" -ForegroundColor Yellow

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
