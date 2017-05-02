# 
# - Name
#     setupOS.ps1
# 
# - Contents
#     Setup OS.
#     To run this script, follow the command below.
#       C:\> Invoke-RestMethod https://initsh.github.io/ps1/setupOS.ps1 | powershell.exe -Command -
# 
# - Precondition
#     - Windows Server 2012 R2
# 
# - Revision
#     2017-05-01 created.
#     yyyy-MM-dd modified.
#     yyyy-MM-dd modified.
# 


################
# Settings
################
# Settings OS
$addsAllowTsConnections   = $True
$addsHostname             = "win2012r2-01"


################
# Initialize
################
# Initialize Variables for script
$scriptBasename  = "setupOS"
$logDir          = "C:"
$logTranscript   = "$logDir\$scriptBasename" + ".transcript.log"
$logFile         = "$logDir\$scriptBasename" + ".log"
$currentHostname = [Net.Dns]::GetHostName()


################
# Start script
################
# Output console log
Start-Transcript -Append $logTranscript
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Start script: $scriptBasename" | Tee-Object -Append $logFile


################
# Setup OS
################
# if Deny RDP and $addsAllowTsConnections (above Settings OS) equal $True
if (((Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).AllowTsConnections -eq 0) -And $addsAllowTsConnections)
{
    # Allow Remote Desktop
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Allow Remote Desktop." | Tee-Object -Append $logFile
    (Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
}

# if $currentHostname (above "Initialize Variables") not equal $addsHostname (above "Settings OS")
if (-Not($currentHostname -eq $addsHostname))
{
    # Change Hostname $currentHostname to $addsHostname and Reboot
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Change Hostname $currentHostname to $addsHostname." | Tee-Object -Append $logFile
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Reboot." | Tee-Object -Append $logFile
    Rename-Computer -NewName $addsHostname -Force -Restart
    Stop-Transcript
}


################
# End script
################
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: End script: $scriptBasename" | Tee-Object -Append $logFile
Stop-Transcript


# EOF
