@echo off
for /F "tokens=*" %%i in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set "profile=%%i"
    call :getpassword
)
pause
exit

:getpassword
set profile=%profile:All User Profile     =%
echo Profile: %profile%
netsh wlan show profile name="%profile%" key=clear | findstr "Key Content"
echo.
goto :eof
