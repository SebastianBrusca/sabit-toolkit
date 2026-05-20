# ================= CREAR ACCESO DIRECTO RDP =================
Clear-Host
Write-Host "=== CREANDO ACCESO DIRECTO RDP ===" -ForegroundColor Cyan

# Detectar el usuario que actualmente inició sesión
try {
    $loggedUser = (Get-CimInstance Win32_ComputerSystem).UserName
    if (-not $loggedUser) {
        throw "No se pudo detectar el usuario logueado"
    }
    $loggedUserName = $loggedUser.Split('\')[-1]
} catch {
    Write-Host "⚠️ Error al detectar usuario logueado. Se usará el usuario actual del proceso" -ForegroundColor Yellow
    $loggedUserName = $env:USERNAME
}

# Ruta del escritorio del usuario logueado
$desktop = "C:\Users\$loggedUserName\Desktop"

# Crear el acceso directo
$shortcutPath = Join-Path $desktop "Clipso 101.lnk"
$mstscPath = "$env:WINDIR\System32\mstsc.exe"
$rdpArgs = "/v:10.0.64.101"

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $mstscPath
$shortcut.Arguments = $rdpArgs
$shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($mstscPath)
$shortcut.IconLocation = "$mstscPath,0"
$shortcut.Save()

Write-Host "✔ Acceso directo RDP creado en: $shortcutPath" -ForegroundColor Green

# Abrir el acceso directo automáticamente (opcional)
# Start-Process $shortcutPath

Read-Host "Presione Enter para cerrar el script..."
