# ================= SOFTWARE INSTALADO =================
Clear-Host
Write-Host "=== SOFTWARE INSTALADO ===" -ForegroundColor Cyan

try {
    # Obtener software desde el registro (64 y 32 bits)
    $uninstallPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    $programs = @()
    foreach ($path in $uninstallPaths) {
        if (Test-Path $path) {
            $keys = Get-ChildItem $path
            foreach ($key in $keys) {
                $displayName = (Get-ItemProperty $key.PSPath -ErrorAction SilentlyContinue).DisplayName
                if ($displayName) { $programs += $displayName }
            }
        }
    }

    if ($programs.Count -gt 0) {
        $programs = $programs | Sort-Object | Get-Unique
        Write-Host ""
        Write-Host "Programas instalados:" -ForegroundColor Cyan
        foreach ($p in $programs) {
            Write-Host "- $p"
        }
    } else {
        Write-Host "No se encontraron programas instalados." -ForegroundColor Yellow
    }

} catch {
    Write-Host "Error al obtener software instalado: $($_.Exception.Message)" -ForegroundColor Red
}

# -----------------------
# Opción de exportar a TXT
# -----------------------
Write-Host ""
$export = Read-Host "Desea exportar la lista a un archivo de texto en el Escritorio? (S/N)"
if ($export -match "^[Ss]") {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $exportPath = Join-Path $desktopPath "Software_Instalado.txt"
    $programs | Out-File -FilePath $exportPath -Encoding UTF8
    Write-Host "Lista exportada a: $exportPath" -ForegroundColor Green
}

# Esperar Enter y volver al menú remoto
Write-Host ""
Read-Host "Presione Enter para volver al menú..."
