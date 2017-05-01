# 
# - Name
#     setupADDS.ps1
# 
# - Contents
#     Setup Active Directory Domain Services and Domain Controller.
#     C:\> Invoke-RestMethod https://initsh.github.io/ps1/setupADDS.ps1 | powershell.exe -Command -
# 
# - Revision
#     2017-05-01 created.
#     yyyy-MM-dd modified.
#     yyyy-MM-dd modified.
# 


################
# 設定
################
# OS設定
$addsAllowTsConnections   = $True
$addsHostname             = "adds-01"
# ADDS設定
# ADDSサーバ構築用の設定を変数として初期化
$addsDomainName           = "report.local"
$addsDomainNetbiosName    = "REPORT"
$addsForestMode           = "Win2012R2"
$addsDomainMode           = "Win2012R2"
$addsAdminPassword        = "P@ssw0rd"
$addsDatabasePath         = "C:\Windows\NTDS"
$addsLogPath              = "C:\Windows\NTDS"
$addsSysvolPath           = "C:\Windows\SYSVOL"
$addsInstallDns           = $True
$addsCreateDnsDelegation  = $false
$addsNoRebootOnCompletion = $false
$addsForce                = $True


################
# 初期化
################
# スクリプトで利用する変数を初期化
$scriptBasename = "setupADDS"
$logDir         = "C:"
$logTranscript  = "$logDir\$scriptBasename" + ".transcript.log"
$logFile        = "$logDir\$scriptBasename" + ".log"
# 一部設定に用いる変数を初期化
$currentHostname          = [Net.Dns]::GetHostName()
$addsAdminPasswordSecure  = ConvertTo-SecureString $addsAdminPassword -AsPlainText -Force


################
# スクリプト開始
################
# コンソール内容をログ出力
Start-Transcript -Append $logTranscript
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Start script: $scriptBasename" | Tee-Object -Append $logFile


################
# OSのセットアップ
################
# RDP許可が未設定かつ、上記 OS設定 にて $addsAllowTsConnections が $True の場合
if (((Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).AllowTsConnections -eq 0) -And $addsAllowTsConnections)
{
    # リモートデスクトップを許可
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Allow Remote Desktop." | Tee-Object -Append $logFile
    (Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
}

# 現在のホスト名が上記 設定 記載のものと異なる場合
if (-Not($currentHostname -eq $addsHostname))
{
    # ホスト名を変更し、再起動する
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Change Hostname $currentHostname to $addsHostname." | Tee-Object -Append $logFile
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Reboot." | Tee-Object -Append $logFile
    Rename-Computer -NewName $addsHostname -Force -Restart
    Stop-Transcript
}


################
# Active Directory ドメインサービス をインストール
################
Import-Module ServerManager
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Install AD-Domain-Services." | Tee-Object -Append $logFile
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services 2>&1 | Tee-Object -Append $logFile


################
# Active Directory の構成
################
Import-Module ADDSDeployment
# 新しいフォレスト及びドメインコントローラーをセットアップ
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Setup New Forest and Domain Controller." | Tee-Object -Append $logFile
Install-ADDSForest `
    -DomainName $addsDomainName `
    -DomainNetbiosName $addsDomainNetbiosName `
    -ForestMode $addsForestMode `
    -DomainMode $addsDomainMode `
    -DatabasePath $addsDatabasePath `
    -LogPath $addsLogPath `
    -SysvolPath $addsSysvolPath `
    -SafeModeAdministratorPassword $addsAdminPasswordSecure `
    -InstallDns:$addsInstallDns `
    -CreateDnsDelegation:$addsCreateDnsDelegation `
    -NoRebootOnCompletion:$addsNoRebootOnCompletion `
    -Force:$addsForce `
    2>&1 | Tee-Object -Append $logFile


################
# スクリプト終了
################
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: End script: $scriptBasename" | Tee-Object -Append $logFile
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Reboot." | Tee-Object -Append $logFile
Stop-Transcript


# EOF
