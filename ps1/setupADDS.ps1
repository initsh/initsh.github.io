# 
# - Name
#     setupADDS.ps1
# 
# - Contents
#     Setup Active Directory Domain Services and Domain Controller.
#     To run this script, follow the command below.
#       C:\> Invoke-RestMethod https://initsh.github.io/ps1/setupADDS.ps1 | powershell.exe -Command -
# 
# - Precondition
#     - Windows Server 2012 R2
#     - Completed:
#         Setting Static IP Address
#         Setting Hostname ( I mean "$env:COMPUTERNAME" )
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
$addsAllowTsConnections     = $True
# Settings Active Directory Domain Services
# Initialize Variables for Build-Parameter of Active Directory Domain Services Server
$addsDomainName             = "report.local"
$addsDomainNetbiosName      = "REPORT"
$addsForestMode             = "Win2012R2"
$addsDomainMode             = "Win2012R2"
$addsSafeModePassword       = "P@ssw0rd"
$addsDatabasePath           = "C:\Windows\NTDS"
$addsLogPath                = "C:\Windows\NTDS"
$addsSysvolPath             = "C:\Windows\SYSVOL"
$addsInstallDns             = $True
$addsCreateDnsDelegation    = $false
$addsNoRebootOnCompletion   = $false
$addsForce                  = $True


################
# Initialize
################
# Initialize Variables for script
$scriptBasename             = "setupADDS"
$logDir                     = "C:"
$logTranscript              = "$logDir\$scriptBasename" + ".transcript.log"
$logFile                    = "$logDir\$scriptBasename" + ".log"
$currentHostname            = [Net.Dns]::GetHostName()
$addsSafeModePasswordSecure = ConvertTo-SecureString $addsSafeModePassword -AsPlainText -Force


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


################
# Install Active Directory Domain Services
################
Import-Module ServerManager
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Install AD-Domain-Services." | Tee-Object -Append $logFile
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services 2>&1 | Tee-Object -Append $logFile


################
# Setup Active Directory Forest and Domain Controller
################
Import-Module ADDSDeployment
# Setup net Forest and Domain Controller
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Setup New Forest and Domain Controller." | Tee-Object -Append $logFile
Install-ADDSForest `
    -DomainName $addsDomainName `
    -DomainNetbiosName $addsDomainNetbiosName `
    -ForestMode $addsForestMode `
    -DomainMode $addsDomainMode `
    -DatabasePath $addsDatabasePath `
    -LogPath $addsLogPath `
    -SysvolPath $addsSysvolPath `
    -SafeModeAdministratorPassword $addsSafeModePasswordSecure `
    -InstallDns:$addsInstallDns `
    -CreateDnsDelegation:$addsCreateDnsDelegation `
    -NoRebootOnCompletion:$addsNoRebootOnCompletion `
    -Force:$addsForce `
    2>&1 | Tee-Object -Append $logFile


################
# End script
################
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: End script: $scriptBasename" | Tee-Object -Append $logFile
Stop-Transcript


# EOF
