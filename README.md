# 🌐 SABIT - Herramienta de Soporte Técnico

SABIT es una **herramienta para soporte técnico** que agiliza tareas frecuentes en Windows, con **12 funciones principales** ⚡💻  

> 💡 **Cómo ejecutar en PowerShell:**
```powershell
irm https://raw.githubusercontent.com/SebastianBrusca/sabit-toolkit/main/sabit.ps1 | iex
🚀 Funciones del proyecto
🖥️ Info Sistema
Obtiene información completa del equipo donde se ejecuta:
CPU, RAM, almacenamiento
Sistema operativo y arquitectura
Información de discos y recursos disponibles
🌐 Navegador Predeterminado
Copia automáticamente una URL y abre Microsoft Edge para que la pegues y configures como predeterminado.
🔒 Internet Explorer / Seguridad
Genera un VBS listo con el icono incluido
Agrega automáticamente dos URLs a sitios de confianza (ARCA y AFIP)
🌐 Información de Red
Obtiene datos de la red local
Realiza un ping a Google para verificar conectividad
🧹 Borrar Temporales
Limpia archivos temporales del sistema para mejorar rendimiento y liberar espacio 💨
🔄 Reinicio de Servicios Básicos
Reinicia servicios esenciales del sistema que son críticos para la operación diaria 🛠️
🧼 Limpieza de Navegadores
Elimina cache, historial, cookies y demás datos de navegación de todos los navegadores
📦 Software Instalado
Enumera todos los programas instalados en el sistema
Permite exportar la lista a un archivo TXT en el escritorio 📝
🖱️ Versiones de Windows y Java
Brinda información detallada sobre la versión de Windows y Java instaladas
🛡️ Seguridad del Sistema
Muestra el estado de seguridad del equipo:
Firmware activado/desactivado
Antivirus presente y actualizado
Configuraciones de seguridad críticas
⚖️ Submenú BalanzaWMS
Función avanzada para instalar y configurar balanzas:
Descarga la carpeta de soporte en la ubicación correcta 📂
Chequea IPs, puertos COM y conectividad mediante Putty
Prueba la comunicación y continuidad de la balanza 🔌
💻 Instalación de AnyDesk
Descarga e instala AnyDesk con contraseña predefinida y acceso total 🔑
Si AnyDesk ya está instalado, notifica al usuario ✅
🧰 Tecnologías utilizadas
⚡ PowerShell 7+
🌐 Windows API / WMI
🔧 Scripts automatizados con permisos elevados (Admin)
🌟 Funciones de red, seguridad y administración de software integradas
🏗 Estructura del proyecto
/sabit-toolkit
├── modulos/           ← Scripts individuales de cada función
├── sabit.ps1          ← Script principal (menu y lógica)
├── README.md
└── .gitignore
🧠 Qué vas a encontrar
🎛️ Menú interactivo con selección de funciones
🔒 Ejecución de scripts en contexto elevado (Admin)
⏱ Automatización de tareas de soporte técnico frecuentes
🌐 Funciones de red, seguridad, limpieza y administración de software
