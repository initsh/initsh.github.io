@echo off

rem ### sshTeraTerm.ps1 インストール＆実行バッチ

set "SSH_POWERSHELL_URL=https://raw.githubusercontent.com/initsh/initsh.github.io/master/ps1/sshTeraTerm.ps1"
set "SSH_POWERSHELL_DIR=%USERPROFILE%\GoogleDrive\ps1"
set "SSH_POWERSHELL=%USERPROFILE%\GoogleDrive\ps1\sshTeraTerm.ps1"

if not exist "%SSH_POWERSHELL_DIR%" mkdir "%SSH_POWERSHELL_DIR%" 1>nul
if not exist "%SSH_POWERSHELL%" bitsadmin.exe /TRANSFER get_sshTeraTerm "%SSH_POWERSHELL_URL%" "%SSH_POWERSHELL%"

start powershell.exe "%SSH_POWERSHELL%" %*

move "%~dp0%~nx0" "%USERPROFILE%" 1>nul

rem # EOF
