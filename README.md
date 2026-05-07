# 🌐 SABIT - Herramienta de Soporte Técnico

SABIT es un toolkit de automatización desarrollado en **PowerShell** diseñado para agilizar las tareas más frecuentes de soporte técnico en entornos Windows. Reúne 12 funciones críticas en una interfaz interactiva y ligera.

---

## 🚀 Instalación y Ejecución Rápida

No necesitas descargar nada manualmente. Ejecuta el siguiente comando en tu terminal de **PowerShell (como Administrador)**:

```powershell
irm [https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1](https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1) | iex
🛠️ Funciones Principales
🖥️ Diagnóstico de Sistema
Info Sistema: Reporte detallado de CPU, RAM, almacenamiento y arquitectura del SO.

Versiones: Consulta rápida de versiones de Windows y entorno de ejecución Java.

Software Instalado: Listado completo de programas con opción de exportar a .txt en el escritorio.

🌐 Red y Conectividad
Información de Red: Datos de la IP local y prueba de latencia (Ping) a Google.

Navegador Predeterminado: Automatización para configurar Microsoft Edge.

IE / Seguridad: Generación de scripts VBS y configuración automática de sitios de confianza (ARCA/AFIP).

🧹 Mantenimiento y Limpieza
Borrar Temporales: Limpieza profunda de archivos residuales del sistema.

Limpieza de Navegadores: Eliminación de caché, cookies e historial en todos los navegadores instalados.

Reinicio de Servicios: Restablecimiento de servicios críticos del sistema.

🛡️ Seguridad y Soporte Remoto
Seguridad del Sistema: Estado del Firewall, Antivirus y configuraciones críticas.

Instalación de AnyDesk: Despliegue automatizado con contraseña predefinida y permisos de acceso total.

⚖️ Módulo Especializado: BalanzaWMS
Herramienta avanzada para la configuración de hardware logístico:

Descarga de dependencias en rutas locales.

Chequeo de puertos COM e IPs.

Pruebas de continuidad mediante Putty.

🧰 Tecnologías Utilizadas
Lenguaje: PowerShell 7+

Gestión: Windows API / WMI

Entorno: Scripts con elevación de privilegios (Admin).

🏗️ Estructura del Proyecto
Plaintext
sabit-toolkit/
├── modulos/           # Scripts individuales por función
├── sabit.ps1          # Script principal (Menú y lógica)
├── README.md          # Documentación
└── .gitignore         # Archivos excluidos
🧠 Características Destacadas
Menú Interactivo: Navegación simple y orientada al usuario.

Contexto Elevado: Validación automática de permisos de Administrador.

Automatización: Reduce tareas de 15 minutos a un par de clics.
