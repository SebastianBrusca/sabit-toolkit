# ================= CREAR ACCESO DIRECTO RDP =================
Clear-Host
Write-Host "=== CREANDO ACCESO DIRECTO RDP ===" -ForegroundColor Cyan

# Carpeta escritorio del usuario actual
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Conexión RDP.lnk"

# Ejecutable de RDP
$mstscPath = "$env:WINDIR\System32\mstsc.exe"

# Argumentos: dirección remota
$rdpArgs = "/v:10.0.64.101"

# Crear el acceso directo
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
