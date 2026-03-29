@echo off
setlocal enabledelayedexpansion

:: --- VÉRIFICATION DES DROITS ADMINISTRATEUR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo ==========================================================
    echo [ERREUR] VOUS DEVEZ LANCER CE SCRIPT EN TANT QU'ADMIN.
    echo Faites clic-droit -^> "Executer en tant qu'administrateur"
    echo ==========================================================
    pause
    exit
)

:menu
cls
color 0B
echo ==========================================================
echo       UTILITAIRE DE MAINTENANCE WINDOWS V3.0
echo   (WillyLutin ^| Trad: boywithasickle ^| Gemini Mod)
echo ==========================================================
echo.
echo  [1]  SAUVEGARDE : Creer un Point de Restauration
echo.
echo  --- NETTOYAGE ---
echo  [2]  BASIQUE : Temp, Prefetch, Corbeille
echo  [3]  AVANCE  : Windows Update, Logs, Cleanmgr
echo  [4]  STORE   : Reinitialiser le Microsoft Store
echo.
echo  --- REPARATION ^& SYSTEME ---
echo  [5]  REPARATION : SFC + DISM (Image Windows)
echo  [6]  DISQUE     : CheckDisk (Scan au redemarrage)
echo  [7]  OPTIMISER  : Trim SSD / Defrag HDD
echo.
echo  --- RESEAU ^& APPS ---
echo  [8]  RESEAU     : Flush DNS + Reset Winsock
echo  [9]  LOGICIELS   : Mettre a jour TOUTES les Apps (Winget)
echo  [10] ANALYSE     : Lister tous les fichiers (Dir /s)
echo  [11] BATTERIE    : Rapport d'etat (PC Portable)
echo.
echo  [0]  QUITTER
echo.
echo ==========================================================
set /p choix=Selectionnez une option (0-11) : 

if "%choix%"=="1" goto restore
if "%choix%"=="2" goto clean_basic
if "%choix%"=="3" goto clean_deep
if "%choix%"=="4" goto store
if "%choix%"=="5" goto repair
if "%choix%"=="6" goto chkdsk
if "%choix%"=="7" goto optimize
if "%choix%"=="8" goto network
if "%choix%"=="9" goto winget
if "%choix%"=="10" goto dirscan
if "%choix%"=="11" goto battery
if "%choix%"=="0" exit
goto menu

:: --- SECTIONS DE COMMANDES ---

:restore
cls
echo [Action] Creation d'un point de restauration...
powershell.exe -Command "Checkpoint-Computer -Description 'Maintenance_Auto' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo Termine. Un point de sauvegarde a ete cree.
pause
goto menu

:clean_basic
cls
echo [Action] Nettoyage des fichiers temporaires...
del /S /F /Q %temp%\*.*
del /S /F /Q %Windir%\Temp\*.*
del /S /F /Q C:\WINDOWS\Prefetch\*.*
echo Vider la Corbeille...
rd /s /q %systemdrive%\$Recycle.Bin
echo.
echo Nettoyage de base termine.
pause
goto menu

:clean_deep
cls
echo [Action] Nettoyage profond (Update, Logs, Manager)...
net stop wuauserv >nul 2>&1
rd /s /q %windir%\SoftwareDistribution
net start wuauserv >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil.exe el') do (wevtutil.exe cl "%%G")
cleanmgr /sagerun:65535
echo.
echo Nettoyage profond termine.
pause
goto menu

:store
cls
echo [Action] Reinitialisation du Microsoft Store...
wsreset
echo.
echo Si le Store s'est ouvert, vous pouvez le fermer.
pause
goto menu

:repair
cls
echo [Action] Reparation systeme (SFC + DISM)...
echo 1. Analyse SFC en cours...
sfc /scannow
echo.
echo 2. Analyse DISM en cours (Reparation de l'image)...
dism /online /cleanup-image /restorehealth
echo.
echo Reparation terminee.
pause
goto menu

:chkdsk
cls
echo [Action] Planification d'une analyse disque...
chkdsk /F
echo.
echo Tapez 'O' si Windows vous demande de planifier au redemarrage.
pause
goto menu

:optimize
cls
echo [Action] Optimisation des lecteurs...
defrag /C /O
echo.
echo Optimisation terminee (Trim envoye pour les SSD).
pause
goto menu

:network
cls
echo [Action] Reinitialisation reseau...
ipconfig /flushdns
netsh winsock reset
echo.
echo Reseau reinitialise. Un redemarrage peut etre necessaire.
pause
goto menu

:winget
cls
echo [Action] Mise a jour de tous les logiciels installes...
winget upgrade --all
echo.
echo Mises a jour terminees.
pause
goto menu

:dirscan
cls
echo [Action] Analyse et liste des fichiers...
dir /s
echo.
echo Analyse terminee.
pause
goto menu

:battery
cls
echo [Action] Generation du rapport batterie...
powercfg /batteryreport /output "%USERPROFILE%\Desktop\Rapport_Batterie.html"
echo.
echo Le fichier "Rapport_Batterie.html" est sur votre Bureau.
pause
goto menu