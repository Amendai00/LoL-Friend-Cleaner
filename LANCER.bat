@echo off
setlocal
cd /d "%~dp0"
start "LoL Friend Cleaner" powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0LoL-Friend-Cleaner.ps1"
