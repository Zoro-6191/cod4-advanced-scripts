@echo off
set COMPILEDIR=%CD%
set XASSETVALUES=+set r_xassetnum material=2560 xmodel=1200
set DEV="developer 2"
set PORT=28960
set FULLSCREEN=1
set RESOLUTION="1280x720"
set MAP="mp_crash"

title "Mod Compiler @ Zoro-6191"

for %%* in (.) do set modname=%%~n*

goto :MAKEOPTIONS

:MAKEOPTIONS
cls
:MAKEOPTIONS
echo ________________________________________________________________________
echo.
echo  Please select an option:
echo    1. Build Fast File (.ff)
echo    2. Build IWD File (.iwd)
echo    3. Dedicated Server and Start Game (WAR)
echo    4. Dedicated Server and Start Game (SD)
echo    5. Dedicated Server
echo    6. Start Game and connect to localhost
echo    7. Start Game and devmap
echo.
echo ________________________________________________________________________
echo.
echo    Mod: %modname%
echo.   Port: %PORT%
echo ________________________________________________________________________
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto build_ff
if "%make_option%"=="1" goto build_iwd
if "%make_option%"=="2" goto war
if "%make_option%"=="3" goto sd
if "%make_option%"=="5" goto dedicated
if "%make_option%"=="6" goto STARTGAMELOCAL
if "%make_option%"=="7" goto STARTGAMEDEVMAP

set SETPORT="+set sv_port %PORT%"
set WINDOWSETTINGS="+set r_fullscreen %FULLSCREEN% +set r_mode %RESOLUTION%"

:build_ff
cls
cd
echo ------------------------------------------------------------------------------------------------------------------------
echo  Building mod.ff:
echo    Deleting old mod.ff file...
del mod.ff
echo    Copying rawfiles...
xcopy fx ..\..\raw\fx /SY
xcopy images ..\..\raw\images /SY
xcopy materials ..\..\raw\materials /SY
xcopy material_properties ..\..\raw\material_properties /SY
xcopy mp ..\..\raw\mp /SY
xcopy promod ..\..\raw\promod /SY
xcopy shock ..\..\raw\shock /SY
xcopy sound ..\..\raw\sound /SY
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy statemaps ..\..\raw\statemaps /SY
xcopy techniques ..\..\raw\techniques /SY
xcopy techsets ..\..\raw\techsets /SY
xcopy weapons\mp ..\..\raw\weapons\mp /SY
xcopy xanim ..\..\raw\xanim /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy xmodelparts ..\..\raw\xmodelparts /SY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SY
xcopy ui ..\..\raw\ui /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy english ..\..\raw\english /SY
xcopy vision ..\..\raw\vision /SY
xcopy animtrees ..\..\raw\animtrees /SYI > NUL
echo    Copying source code...
xcopy maps ..\..\raw\maps /SY
xcopy promod_ruleset ..\..\raw\promod_ruleset /SY
echo    Copying MOD.CSV...
xcopy mod.csv ..\..\zone_source /SY
echo    Compiling mod...
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd %COMPILEDIR%
copy ..\..\zone\english\mod.ff
echo  New mod.ff file successfully built ;D
echo Completed: %time%
echo ------------------------------------------------------------------------------------------------------------------------
pause
goto :MAKEOPTIONS

:dedicated
echo %date% - %time% Dedicated Mode
cd ..\..\ 
START cod4x18_dedrun.exe %DEV% %SETPORT% %XASSETVALUES% +set dedicated 2 +exec server.cfg +set gametype sr +set fs_game mods/%modname% +map %MAP%
cd %COMPILEDIR%
goto :MAKEOPTIONS

:STARTGAMELOCAL
cls
echo %date% - %time% Play Game
cd ..\..\
START iw3mp.exe allowdupe +g_gametype dm %WINDOWSETTINGS% +set fs_game mods/%modname% +connect 127.0.0.1:%PORT%
cd %COMPILEDIR%
goto :MAKEOPTIONS

:STARTGAMEDEVMAP
cls
echo %date% - %time% Play Game
cd ..\..\
START iw3mp.exe allowdupe +g_gametype dm +set r_fullscreen 0 +set r_mode 1280x720 +set fs_game mods/%modname% +set g_gametype sd +set promod_mode custom_public +devmap %MAP%
cd %COMPILEDIR%
goto :MAKEOPTIONS

:war
cls
echo Dedicated Server and Start Game (WAR)
cd ..\..\
echo Dedicated Server Started Successfully.
START cod4x18_dedrun.exe %DEV% %SETPORT% %XASSETVALUES% +set dedicated 2 +exec server.cfg +set gametype sr +set logsync 2 +set fs_game mods/%modname% +map %MAP%
cd %COMPILEDIR%
cd ..\..\
START iw3mp.exe allowdupe +g_gametype dm +set r_fullscreen 0 +set r_mode 1280x720 +set fs_game mods/%modname% +connect 127.0.0.1:%PORT%
cd %COMPILEDIR%
echo Started Game with Mod Lunch.
goto :MAKEOPTIONS

:sd
cls
echo Dedicated Server and Start Game (SD)
cd ..\..\
echo Dedicated Server Started Successfully.
START cod4x18_dedrun.exe %DEV% %SETPORT% %XASSETVALUES% +set dedicated 2 +exec server.cfg +g_gametype sd +set logsync 2 +set fs_game mods/%modname% +map %MAP%
cd %COMPILEDIR%
cd ..\..\
START iw3mp.exe allowdupe +g_gametype dm +set r_fullscreen 0 +set r_mode 1280x720 +set fs_game mods/%modname% +connect 127.0.0.1:%PORT%
cd %COMPILEDIR%
echo Started Game with Mod Launch.
goto :MAKEOPTIONS

:build_iwd
cls
cd
echo ________________________________________________________________________
echo.
echo  Building %IWDNAME%:
if exist %IWDNAME% del %IWDNAME%

7za a -r -tzip %IWDNAME% images > NUL
7za a -r -tzip %IWDNAME2% weapons > NUL
7za a -r -tzip %IWDNAME2% sun > NUL
7za a -r -tzip %IWDNAME2% sound > NUL

echo.
echo %date% - %time% %IWDNAME% Completed
echo.
echo ________________________________________________________________________
echo.
pause
goto :MAKEOPTIONS

:FINAL