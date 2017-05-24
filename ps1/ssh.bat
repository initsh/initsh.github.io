@setlocal enableextensions enabledelayedexpansion & set "PATH0=%~f0" & PowerShell.exe -Command "& (Invoke-Expression -Command ('{#' + ((Get-Content '!PATH0:'=''!') -join \"`n\") + '}'))" %* & exit /b !errorlevel!
# 
# - Name
#     Install-Vim.bat
# 
# - Contents
#     Install Vim.
#
# - Reference
#     PowerShell on *.bat - http://pf-j.sakura.ne.jp/program/tips/ps1bat2.htm
#     Vim - KaoriYa - https://www.kaoriya.net/software/vim/
# 
# - Revision
#     2016-05-24 created.
#     yyyy-MM-dd modified.
# 


################
# constant
################
$psDir = "$env:USERPROFILE\Documents\WindowsPowerShell"; if (-Not(Test-Path -Path $psDir)) { mkdir $psDir 1>$null 2>$null }
$psProfile = "$psDir\Microsoft.PowerShell_profile.ps1"
$vimZip = "$env:USERPROFILE\Documents\vim.zip"
$vimUri = 'https://github.com/koron/vim-kaoriya/releases/download/v8.0.0596-20170502/vim80-kaoriya-win64-8.0.0596-20170502.zip'


################
# main
################
# Get vim.zip.
if (-Not(Test-Path -Path $vimZip)) { Invoke-RestMethod -Uri $vimUri -OutFile $vimZip -UseBasicParsing }

# Unzip vim.zip.
if (Test-Path -Path $vimZip)
{
    if (-Not(Test-Path -Path "$env:USERPROFILE\Documents\vim*\vim.exe"))
    {
        $shApp = New-Object -Com shell.application
        $unzip = $shApp.NameSpace($vimZip)
        foreach ($item in $unzip.items()) { $shApp.Namespace("$env:USERPROFILE\Documents").copyhere($item, 0x8); }
    }
}
else
{
    Write-Output "[ERROR]: Failed to download from Uri($vimUri)."
    exit 1
}

# Get the full path of the vim.exe.
if (Test-Path -Path "$env:USERPROFILE\Documents\vim*\vim.exe")
{
    $vimExe = (Get-Item "$env:USERPROFILE\Documents\vim*\vim.exe").FullName
}
else
{
    Write-Output "[ERROR]: Failed to unzip file($vimZip)."
    exit 1
}

# If there is no description about Vim in Profile,
if (-Not((Get-Content $psProfile 2>$null | Select-String '# vim').Matches.Success))
{
    # Add a description about Vim.
    Write-Output "# vim`r`nNew-Alias vi $vimExe`r`nNew-Alias vim $vimExe`r`nfunction view() { $vimExe -R `$args }`r`n" >> $psProfile
}

# Display Profile information.
Get-Item $psProfile
Write-Output "`r`n"
Write-Output "================================"
Get-Content $psProfile
Write-Output "================================"
[Console]::ReadKey() | Out-Null

