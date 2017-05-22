@setlocal enableextensions enabledelayedexpansion & set "PATH0=%~f0" & PowerShell.exe -Command "& (Invoke-Expression -Command ('{#' + ((Get-Content '!PATH0:'=''!') -join \"`n\") + '}'))" %* & exit /b !errorlevel!
# 
# - Name
#     ssh.bat
# 
# - Contents
#     Simplify SSH Connect by Tera Term.
#     <Windows> + <R> => ssh root@192.168.1.100
#
# - Install
#     powershell.exe -Command "Invoke-RestMethod -Uri "https://initsh.github.io/ps1/ssh.bat" -OutFile "$env:USERPROFILE\ssh.bat""
#
# - Reference
#     http://pf-j.sakura.ne.jp/program/tips/ps1bat2.htm
# 
# - Revision
#     2016-12-28 created.
#     2017-04-14 modified.
#     2017-05-22 modified.
#     yyyy-MM-dd modified.
# 

################
# constant
################
#[System.String] $base_dir = "$env:Userprofile"
[System.String] $base_dir = "$env:Userprofile\GoogleDrive"
[System.String] $ssh_dir  = "$base_dir\ssh"
[System.String] $log_dir  = "$ssh_dir\log"
[System.String] $key_dir  = "$ssh_dir\key"
[System.String] $csv_file = "$ssh_dir\hosts.csv"
[System.String] $tt_install_uri = "https://ja.osdn.net/frs/redir.php?m=ymu&f=%2Fttssh2%2F67179%2Fteraterm-4.94.exe"
[System.String] $tt_install_exe = "$env:USERPROFILE\Downloads\teraterm-4.94.exe"

################
# variable
################
[System.String] $date = Get-Date -Format yyyyMMdd
[System.String] $time = Get-Date -Format HHmmss

################
# main
################
### Create directorys.
if ((Get-Item $ssh_dir).Mode | Select-String -NotMatch '^d') { mkdir $ssh_dir; }
if ((Get-Item $log_dir).Mode | Select-String -NotMatch '^d') { mkdir $log_dir; }
if ((Get-Item $key_dir).Mode | Select-String -NotMatch '^d') { mkdir $ssh_dir; }
if (-Not (Test-Path $csv_file))
{
    Write-Output @'
Hostname,Port,Username,AuthType,Value,Alias
# In the first line, Header information is written. Please do not edit!

# Please refer to the following and set it like the description example.
# Hostname,PortNumber,Username,AuthenticationType[password|publickey],Value[Passphrase|NameOfSecretKey],Set an alias character string as an argument of ssh command. UPN notation is recommended.

# description example:
www.example.com,22,admin,publickey,id_rsa,admin@www.example.com
192.168.1.100,22,root,password,P@ssw0rd,root@192.168.1.100
'@ > $csv_file
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [NOTICE]: Check the file( $csv_file ) and set it as shown in the description example."
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [NOTICE]: Edit the file( $csv_file ) and try again."
    notepad $csv_file
    [Console]::ReadKey() | Out-Null
    exit 1
}

### Search for ttermpro.exe from the directory where teraterm was installed and get the full path of ttermpro.exe.
[System.String] $ssh_client = Get-ChildItem -recurse "C:\Program Files*\teraterm" | Where-Object { $_.Name -match "ttermpro" } | ForEach-Object { $_.FullName }
### 
if (-Not ($?) -Or -Not (Test-Path -Path $ssh_client))
{
    Invoke-WebRequest -Uri $tt_install_uri -OutFile $tt_install_exe
    Start-Process -FilePath $tt_install_exe -PassThru -Wait
    [System.String] $ssh_client = Get-ChildItem -recurse "C:\Program Files*\teraterm" | Where-Object { $_.Name -match "ttermpro" } | ForEach-Object { $_.FullName }
    if (-Not ($?) -Or -Not (Test-Path -Path $ssh_client))
    {
        Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [ERROR]: ttermpro.exe not found in `"C:\Program Files*`"."
        [Console]::ReadKey() | Out-Null
        exit 1
    }
}

if ($args[0])
{
    ### $args[0] = Alias. UPN notation is recommended.
    [System.String] $ssh_alias = $args[0]
    [System.Array] $ssh_args = $args[0] -split "@"
    [System.String] $ssh_log = "$log_dir\" + $ssh_args[1] + "_" + $ssh_args[0] + "_" + $date + "_" + $time + ".log"
    
    ### Get a match with the value of $args[0] and the value of Alias in CSV.
    [System.Array] $csv_data = Import-Csv $csv_file | Where-Object { $_.Alias -eq $ssh_alias }
    
    ### If there is a match between the value of $args[0] and the value of Alias in CSV,
    if ($csv_data)
    {
        ### Create arguments to pass to ttermpro.exe.
        [System.String] $opt_host = "ssh2://" + $csv_data[0].Hostname + ":" + $csv_data[0].Port
        [System.String] $opt_user = "/user=" + $csv_data[0].Username
        [System.String] $opt_auth = "/auth=" + $csv_data[0].AuthType
        if ($csv_data[0].AuthType -eq "password")
        {
            [System.String] $opt_value = "/passwd=" + $csv_data[0].Value
        }
        elseif ($csv_data[0].AuthType -eq "publickey")
        {
            [System.String] $opt_value = "/keyfile=$key_dir\" + $csv_data[0].Value
        }
        [System.String] $opt_dir = "/FD=$ssh_dir"
        [System.String] $opt_log = "/L=$ssh_log"

        [System.Array] $opt_array = @($opt_host,$opt_user,$opt_auth,$opt_value,$opt_dir,$opt_log,"/ssh-v","/LA=J")

    }
    ### If there is no matching match between the value of $args[0] and the value of Alias in CSV,
    else
    {
        ### Show contents of CSV.
        Get-Item $csv_file
        Import-Csv $csv_file | Where-Object { ($_.Alias) } | Select-Object Username,Hostname,Alias | Format-Table -AutoSize
        [Console]::ReadKey() | Out-Null
        exit 0
    }
}
else
{
    [System.String] $ssh_log = "$log_dir\undefined_undefined_" + $date + "_" + $time + ".log"
    [System.String] $opt_dir = "/FD=" + $ssh_dir
    [System.String] $opt_log = "/L=$ssh_log"
    [System.Array] $opt_array = @($opt_dir,$opt_log,"/ssh-v","/LA=J")
}

### Run teraterm.
$ssh_process = Start-Process -FilePath $ssh_client -ArgumentList $opt_array -PassThru -Wait
### Change attribute of teraterm log file to read only.
Set-ItemProperty -Path $ssh_log -Name Attributes -Value Readonly
### Display the contents of teraterm log file (personal preference...).
Get-Content -Path $ssh_log
### Output contents of teraterm log file to screen.
Write-Output "$(Get-Date -Format yyyy-MM-ddThh:mm:sszzz) [INFO]: Log file: $ssh_log"
### TeraTerm abnormal termination: A case where an already established ssh session is forcibly terminated due to network disconnection or the like.
if ($ssh_process.ExitCode -ne 0)
{
    Write-Output "$(Get-Date -Format yyyy-MM-ddThh:mm:sszzz) [ERROR]: ttermpro.exe exit code NOT equal 0."
}
[Console]::ReadKey() | Out-Null
exit 0
