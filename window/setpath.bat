@REM ***********************************************************************************
@REM ** This script add path to the user path permanently
@REM ** This method does not require admin permission, since it is setting user path
@REM ** The variable %PATH% returns all System PATH + User PATH, thus can not use it
@REM ** Thus, need to get the User PATH from registry and set to variable
@REM ** Then use setx to set the PATH permanently
@REM ** 
@echo off
setlocal
if "%1"=="" goto Blank
set APPEND_DIR=%1

goto AppendPath

:Blank
echo Usage: %0 path-to-append
goto TheEnd

:AppendPath
@REM ********************************
@REM Get User Path from registry
@REM REG QUERY HKEY_CURRENT_USER\Environment /v PATH
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\Environment" /v PATH`) DO (
    set USER_PATH=%%A
    )
ECHO USER_PATH=%USER_PATH%
@REM reg add "HKEY_CURRENT_USER\Environment" /v PATH /t REG_SZ /d "%USER_PATH%;%APPEND_DIR%"
echo setting user path to %APPEND_DIR%;%USER_PATH%
setx PATH "%APPEND_DIR%;%USER_PATH%"

:TheEnd
endlocal