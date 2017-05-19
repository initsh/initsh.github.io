@echo off
rem # 
rem # - Name
rem #     Edit-Hosts.bat
rem # 
rem # - Contents
rem #     C:\Windows\System32\runas.exe notepad C:\Windows\System32\drivers\etc\hosts
rem # 
rem # - Install
rem #     PS C:\> Invoke-WebRequest -Uri "https://initsh.github.io/ps1/Edit-Hosts.bat" -OutFile "$env:USERPROFILE\Edit-Hosts.bat"
rem #
rem # - Revision
rem #     2017-05-10 created.
rem #     yyyy-MM-dd modified.
rem # 

start powershell.exe -Command "Start-Process -Verb RUNAS notepad C:\Windows\System32\drivers\etc\hosts"
