@echo off
openfiles > NUL 2>&1 || echo Requesting administrative privileges... | PowerShell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList '%cd%'" && exit /b 
cd /d %1
call node\npm i
cls
start "GET HWID" /d .\game korepi.exe /i
timeout /t 10 /nobreak > NUL
start /wait "LICENSE GEN" node\node.exe license_gen.js
taskkill /f /im korepi.exe > NUL 2>&1
node\node.exe ssl_gen.js
PowerShell -Command "Get-ChildItem -Path Cert:\CurrentUser\Root | Where-Object { $_.Subject -like '*md5c.korepi.com*' } | Remove-Item"
certmgr.exe /c /add "certs\\md5c.korepi.com.crt" /s root 
exit