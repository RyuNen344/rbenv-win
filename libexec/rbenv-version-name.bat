@echo off
setlocal

if "%1" == "--help" (
echo Usage: rbenv version-name
echo.
echo Shows the currently selected Ruby version
EXIT /B
)

rem Implementation of this command is in the rbenv.vbs file .


