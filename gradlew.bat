@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0gradle\wrapper\bootstrap.ps1" %*
exit /b %ERRORLEVEL%
