@echo off

rem ### sshTeraTerm.ps1 インストール＆実行バッチ
rem ### 前提条件: teratermがインストールされていること

set "SSH_POWERSHELL_URL=https://raw.githubusercontent.com/initsh/initsh.github.io/master/ps1/sshTeraTerm.ps1"
set "BASE_DIR=%USERPROFILE%\GoogleDrive"
set "PATH_DIR=%BASE_DIR%\path"
set "PS1_DIR=%BASE_DIR%\ps1"
set "SSH_POWERSHELL=%PS1_DIR%\sshTeraTerm.ps1"

if not exist "%PATH_DIR%" mkdir "%PATH_DIR%" 1>nul
if not exist "%PS1_DIR%" mkdir "%PS1_DIR%" 1>nul
if not exist "%SSH_POWERSHELL%" bitsadmin.exe /TRANSFER get_sshTeraTerm "%SSH_POWERSHELL_URL%" "%SSH_POWERSHELL%"

start powershell.exe "%SSH_POWERSHELL%" %*

move "%~dp0%~nx0" "%USERPROFILE%" 1>nul

rem # EOF
