@echo off
setlocal enabledelayedexpansion

:: --- ADMINISTRATOR RIGHTS CHECK ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo ==========================================================
    echo [ERROR] YOU MUST RUN THIS SCRIPT AS AN ADMINISTRATOR.
    echo Right-click -^> "Run as Administrator"
    echo ==========================================================
    pause
    exit
)

:menu
cls
color 0B
echo ==========================================================
echo       WINDOWS MAINTENANCE UTILITY V3.0 (EN)
echo   (Original: WillyLutin ^| Mod: boywithasickle ^& Gemini)
echo ==========================================================
echo.
echo  [1]  BACKUP   : Create a System Restore Point
echo.
echo  --- CLEANING ---
echo  [2]  BASIC    : Temp Files, Prefetch, Recycle Bin
echo  [3]  DEEP     : Windows Update, Logs, Cleanmgr
echo  [4]  STORE    : Reset Microsoft Store (wsreset)
echo.
echo  --- REPAIR ^& SYSTEM ---
echo  [5]  REPAIR   : SFC + DISM (Windows Image Repair)
echo  [6]  DISK     : CheckDisk (Scan on next reboot)
echo  [7]  OPTIMIZE : Trim SSD / Defrag HDD
echo.
echo  --- NETWORK ^& APPS ---
echo  [8]  NETWORK  : Flush DNS + Reset Winsock
echo  [9]  SOFTWARE : Update ALL Installed Apps (Winget)
echo  [10] ANALYSIS : List All Files (Dir /s)
echo  [11] BATTERY  : Health Report (For Laptops)
echo.
echo  [0]  EXIT
echo.
echo ==========================================================
set /p choice=Select an option (0-11): 

if "%choice%"=="1" goto restore
if "%choice%"=="2" goto clean_basic
if "%choice%"=="3" goto clean_deep
if "%choice%"=="4" goto store
if "%choice%"=="5" goto repair
if "%choice%"=="6" goto chkdsk
if "%choice%"=="7" goto optimize
if "%choice%"=="8" goto network
if "%choice%"=="9" goto winget
if "%choice%"=="10" goto dirscan
if "%choice%"=="11" goto battery
if "%choice%"=="0" exit
goto menu

:: --- COMMAND SECTIONS ---

:restore
cls
echo [Action] Creating a System Restore Point...
powershell.exe -Command "Checkpoint-Computer -Description 'Auto_Maintenance' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo Done. A backup point has been created.
pause
goto menu

:clean_basic
cls
echo [Action] Cleaning temporary files...
del /S /F /Q %temp%\*.*
del /S /F /Q %Windir%\Temp\*.*
del /S /F /Q C:\WINDOWS\Prefetch\*.*
echo Emptying Recycle Bin...
rd /s /q %systemdrive%\$Recycle.Bin
echo.
echo Basic cleaning completed.
pause
goto menu

:clean_deep
cls
echo [Action] Deep Cleaning (Updates, Logs, Manager)...
net stop wuauserv >nul 2>&1
rd /s /q %windir%\SoftwareDistribution
net start wuauserv >nul 2>&1
echo Clearing System Event Logs...
for /f "tokens=*" %%G in ('wevtutil.exe el') do (wevtutil.exe cl "%%G")
cleanmgr /sagerun:65535
echo.
echo Deep cleaning completed.
pause
goto menu

:store
cls
echo [Action] Resetting Microsoft Store...
wsreset
echo.
echo If the Store window opened, you can close it now.
pause
goto menu

:repair
cls
echo [Action] System Repair (SFC + DISM)...
echo 1. Running SFC Scan...
sfc /scannow
echo.
echo 2. Running DISM (Image Repair)...
dism /online /cleanup-image /restorehealth
echo.
echo Repair process completed.
pause
goto menu

:chkdsk
cls
echo [Action] Scheduling Disk Analysis...
chkdsk /F
echo.
echo Press 'Y' if Windows asks to schedule the scan on next reboot.
pause
goto menu

:optimize
cls
echo [Action] Optimizing Drives...
defrag /C /O
echo.
echo Optimization complete (Trim command sent to SSDs).
pause
goto menu

:network
cls
echo [Action] Resetting Network Stack...
ipconfig /flushdns
netsh winsock reset
echo.
echo Network reset. A reboot is recommended.
pause
goto menu

:winget
cls
echo [Action] Updating all installed software via Winget...
winget upgrade --all
echo.
echo All applications are now up to date.
pause
goto menu

:dirscan
cls
echo [Action] Analyzing and listing files...
dir /s
echo.
echo Scan complete.
pause
goto menu

:battery
cls
echo [Action] Generating Battery Report...
powercfg /batteryreport /output "%USERPROFILE%\Desktop\Battery_Report.html"
echo.
echo The file "Battery_Report.html" has been saved to your Desktop.
pause
goto menu