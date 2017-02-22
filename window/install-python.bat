@REM ***********************************************************************************
@REM ** This file install Python27 on computer for class that I am going to teach kids.
@REM ** This installation method does not require admin permission.
@REM ** The file requires a mc-py-class directory at the same level and 
@REM ** a Python27 directory under it. 
@REM ** The Python27 directory should be an existing (current user) installation of Python27
@REM ** with the python27.dll with the python.exe
setlocal

@REM Copy Python27
set CLASS_DIR=.\mc-py-class
set PY=Python27
set PY_DIR=C:\%PY%
echo Installing Python...
IF NOT EXIST %PY_DIR% mkdir %PY_DIR%
xcopy /S /E /Y %CLASS_DIR%\%PY% %PY_DIR%

@REM Create shortcut on the desktop to Python and IDLE
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\Python.lnk');$s.TargetPath='%PY_DIR%\python.exe';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\IDLE.lnk');$s.TargetPath='%PY_DIR%\Lib\idlelib\idle.bat';$s.WorkingDirectory='C:\MyAdventures';$s.IconLocation='%PY_DIR%\pythonw.exe';$s.Save()"

@REM **************************************************
@REM Get User Path from registry, set to variable
@REM REG QUERY HKEY_CURRENT_USER\Environment /v PATH
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Environment" /v PATH`) DO (
    set USER_PATH=%%A
    )
ECHO USER_PATH=%USER_PATH%
@REM reg add "HKEY_CURRENT_USER\Environment" /v PATH /t REG_SZ /d "%PY_DIR%;%USER_PATH%"
echo setting user path to %PY_DIR%;%USER_PATH%
@REM Setting the path to the user path (not system path)
setx PATH "%PY_DIR%;%USER_PATH%"

echo Installation completed
pause
endlocal