@echo off
openfiles > NUL 2>&1 || echo Requesting administrative privileges... && PowerShell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList '%cd%'" && exit /b 
cd /d %1

ren %SystemRoot%\System32\Drivers\etc\hosts hosts-backup
copy /y .\hosts %SystemRoot%\System32\Drivers\etc > NUL

echo Starting GH Injector
attrib +r .\GH4.8_x64\Settings.ini
start "" /d .\GH4.8_x64 "GH Injector - x64.exe"

echo Starting server
timeout /t 1 /nobreak > NUL
start "Server" "node\node.exe" server.js

echo Waiting 3 seconds...
taskkill /f /im GenshinImpact.exe > NUL 2>&1 || taskkill /f /im Yuanshen.exe > NUL 2>&1
rd /s /q .\game\enc 2> NUL 
timeout /t 3 /nobreak > NUL
start "korepi" /d .\game korepi.exe /i
goto :KPCRASH
 
:RESTOREHOSTS
del %SystemRoot%\System32\Drivers\etc\hosts
ren %SystemRoot%\System32\Drivers\etc\hosts-backup hosts
taskkill /f /im node.exe
exit

:WARN
SetLocal DisableDelayedExpansion
cls
color 1f
echo DO NOT CLOSE THIS WINDOW!!!!!
echo This window will automatically close within 10 seconds after Genshin Impact shuts down.
echo and restore your hosts files
echo .
echo 请勿关闭此窗口!!!!!
echo 该窗口将在 Genshin Impact 关闭后 10 秒内自动关闭。
echo 并恢复您的主机文件
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