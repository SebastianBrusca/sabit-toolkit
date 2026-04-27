@echo off
:: Ejecutar PowerShell como administrador y mantener la ventana abierta
powershell -Command "Start-Process powershell -ArgumentList '-NoExit -ExecutionPolicy Bypass -File \"%~dp0sabit.ps1\"' -Verb RunAs"