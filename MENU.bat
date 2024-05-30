@echo off
color a
:menu
cls
echo ==========KOREPI=TOOLS==========
echo            Main Menu
echo ================================
echo    1. first-time-setup
echo    2. start (use this after running no.1)
echo    3. Exit
echo ================================
echo github.com/fadillzzz/korepi-tools
echo github.com/Zhongli0401/korepi-tools
echo ================================
echo if you encounter any error try running the first-time-setup(1) again
echo ================================
set /p choice=Please choose an option (1-3): 

if "%choice%"=="1" goto feature1
if "%choice%"=="2" goto feature2
::if "%choice%"=="9" goto feature3
if "%choice%"=="3" goto end
echo Invalid choice, please try again.
pause
goto menu

:feature1
pushd %~dp0korepi-tools-new
call !first-time.bat
popd
pause
goto menu

:feature2
pushd %~dp0korepi-tools-new
call !test.bat
popd
timeout /t 2 /nobreak > NUL
goto end

::feature3
::call feature3.cmd
::pause
::goto menu

:end
echo Exiting...
timeout /t 1 /nobreak > NUL
exit