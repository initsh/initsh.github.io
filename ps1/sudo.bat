@echo off
rem # 
rem # - Name
rem #     sudo.bat
rem # 
rem # - Contents
rem #     RUNAS rundll32.exe shell32.dll,#61
rem # 
rem # - Revision
rem #     2017-05-10 created.
rem #     yyyy-MM-dd modified.
rem # 

start powershell.exe -Command "Start-Process -Verb RUNAS rundll32.exe shell32.dll,`#61"
