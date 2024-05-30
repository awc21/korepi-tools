@echo off
openfiles > NUL 2>&1 || echo Requesting administrative privileges... | PowerShell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList '%cd%'" && exit /b 
SetLocal EnableDelayedExpansion
cd /d %1

:: backup the original hosts file
ren %SystemRoot%\System32\Drivers\etc\hosts hosts-backup
copy /y .\hosts %SystemRoot%\System32\Drivers\etc > NUL

echo Starting GH Injector
attrib +r .\GH4.8_x64\Settings.ini
start "" /d .\GH4.8_x64 "GH Injector - x64.exe"
echo Starting server
timeout /t 1 /nobreak > NUL 2>&1
start "Server" "node\node.exe" server.js

echo Waiting 3 seconds...
taskkill /f /im GenshinImpact.exe > NUL 2>&1
rmdir /s /q .\game\enc > NUL 2>&1
timeout /t 3 /nobreak > NUL 2>&1
start "korepi" /d .\game korepi.exe /i
goto :KPCRASH
 
:RESTOREHOSTS
del %SystemRoot%\System32\Drivers\etc\hosts
ren %SystemRoot%\System32\Drivers\etc\hosts-backup hosts
taskkill /f /im node.exe
exit

EndLocal

:WARN
SetLocal DisableDelayedExpansion
cls
color 1f
echo Do NOT close the window!!!!!
echo The window will close automatically within ten seconds after Genshin Impact shuts down
echo and restore your hosts files
timeout /t 10 /nobreak > NUL
SetLocal EnableDelayedExpansion
goto LOOP

:KPCRASH
tasklist | findstr /I "korepi.exe" > NUL
if errorlevel 1 (
    goto RESTORENET
) else (
    goto LOOPKP
)

:LOOPKP
tasklist | findstr /I "korepi.exe" > NUL
if errorlevel 1 (
    goto LOOP
) else (
    timeout /t 1 /nobreak > NUL
    goto LOOPKP
)

:LOOP
tasklist | findstr /I "Yuanshen.exe GenshinImpact.exe" > NUL
if errorlevel 1 (
    goto RESTOREHOSTS
) else (
    goto WARN
)