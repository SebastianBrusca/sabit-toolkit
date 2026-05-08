# ================= ACTIVADOR WIN / OFFICE =================
Clear-Host
Write-Host "=== ACTIVADOR DE WINDOWS Y OFFICE ===" -ForegroundColor Cyan
Write-Host "Este script ejecutará el activador remoto." -ForegroundColor Yellow
Write-Host "Asegúrate de tener conexión a Internet." -ForegroundColor Yellow
Write-Host ""

# Pausa antes de ejecutar para que el usuario confirme
Read-Host "Presiona Enter para iniciar la activación..."

# Ejecutar el activador remoto
try {
    Write-Host "Ejecutando activador..." -ForegroundColor Cyan
    irm https://get.activated.win | iex
    Write-Host "✅ Activador ejecutado correctamente." -ForegroundColor Green
} catch {
    Write-Host "⚠️ Error al ejecutar el activador: $_" -ForegroundColor Red
}

# Espera antes de cerrar
Read-Host "Presiona Enter para volver al menú..."
