@REM ***********************************************************************************
@REM ** This file install Minecraft on computer for class that I am going to teach kids.
@REM ** The file requires a mc-py-class directory at the same level and 
@REM ** a Minecraft directory under it. 
@REM ** The Minecraft directory should an existing installation of the new Minecraft Launcher.
@REM ** It should also has the embedded Java runtime (1.8.0_25).
@REM ** 
@REM ** This installation essentially copy an existing Minecraft installation into the 
@REM ** C:\Minecraft directory
@REM ** The existing Minecraft installation should also contained a profile directory
@REM ** Then, it copied the .minecraft directory to the user %appdata% directory
@REM ** Any mod installed would be there copied as well.
@REM ** In case user want to install Minecraft Forge, it will run the Forge using
@REM ** the embedded java runtime.
@REM **
@echo off
setlocal
cls
@REM ***********************************************************************************
@REM setting batch script arguments
IF "%1"=="forge" (
   ECHO Parameter passed in %1
   set INSTALLFORGE=true
)

@REM ***********************************************************************************
@REM Install Minecraft by copying from mc-py-class directory
@REM Copy the class project directory and Minecraft-Python library to MyAdventures
@REM ***********************************************************************************
set CLASS_DIR=.\mc-py-class
set MC=Minecraft
set MC_DIR=C:\%MC%
echo Installing Minecraft...
IF NOT EXIST %MC_DIR% mkdir %MC_DIR%
xcopy /S /E /Y %CLASS_DIR%\%MC% %MC_DIR%
set MY=MyAdventures
set MY_DIR=C:\%MY%
IF NOT EXIST %MY_DIR% mkdir %MY_DIR%
xcopy /S /E /Y %CLASS_DIR%\%MY% %MY_DIR%

@REM Check if .minecraft directory exist
echo creating .minecraft directory
   mkdir %APPDATA%\.minecraft
)

xcopy /S /E /Y %CLASS_DIR%\.minecraft %APPDATA%\.minecraft

IF "%INSTALLFORGE%"=="true" (
   echo Installing Minecraft Forge
   cd %CLASS_DIR%
   %MC_DIR%\runtime\jre-x64\1.8.0_25\bin\java -jar forge-1.9-12.16.1.1887-installer.jar
   echo Minecraft Forge installation Completed
   cd ..
)
echo Installation completed for Minecraft Python class
pause
endlocal

