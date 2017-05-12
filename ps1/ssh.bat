@setlocal enableextensions enabledelayedexpansion & set "PATH0=%~f0" & PowerShell.exe -Command "& (Invoke-Expression -Command ('{#' + ((Get-Content '!PATH0:'=''!') -join \"`n\") + '}'))" %* & exit /b !errorlevel!
# 
# - Name
#     ssh.bat
# 
# - Contents
#     Simplify SSH Connect by Tera Term.
#     <Windows> + <R> => ssh root@192.168.1.100
#
# - Reference
#     http://pf-j.sakura.ne.jp/program/tips/ps1bat2.htm
# 
# - Revision
#     2016-12-28 created.
#     2017-04-14 modified.
#     yyyy-MM-dd modified.
# 

# constant
### 作業ディレクトリ
#[System.String] $base_dir = "$Env:Userprofile"             # ベースディレクトリ
[System.String] $base_dir = "$Env:Userprofile\GoogleDrive" # ベースディレクトリ
[System.String] $ssh_dir  = "$base_dir\ssh"                # teraterm起動ディレクトリ
[System.String] $log_dir  = "$ssh_dir\log"                 # teratermログ出力ディレクトリ
[System.String] $key_dir  = "$ssh_dir\key"                 # 秘密鍵設置ディレクトリ
[System.String] $csv_file = "$ssh_dir\hosts.csv"           # ログイン情報CSVファイル
### ログイン情報CSVファイル/記載内容について
###  +-----------------------------------------------------------------
###  |#Hostname,Port,Username,AuthType,Value,Alias
###  |192.168.1.100,22,root,publickey,id_rsa,root@192.168.1.100
###  |www.contoso.com,10022,admin,password,P@ssw0rd,admin@www.contoso.com
###  +-----------------------------------------------------------------
[System.String] $tt_install_uri = "https://ja.osdn.net/frs/redir.php?m=ymu&f=%2Fttssh2%2F67179%2Fteraterm-4.94.exe"
[System.String] $tt_install_exe = "$env:USERPROFILE\Downloads\teraterm-4.94.exe"

# variable
[System.String] $date = Get-Date -Format yyyyMMdd
[System.String] $time = Get-Date -Format HHmmss


# main
### teratemrインストールディレクトリからttermpro.exeを検索し、ttermpro.exeのフルパスを取得する
[System.String] $ssh_client = Get-ChildItem -recurse "C:\Program Files*\teraterm" | Where-Object { $_.Name -match "ttermpro" } | ForEach-Object { $_.FullName }
### 
if (-Not $? -Or -Not(Test-Path -Path $ssh_client))
{
    Invoke-WebRequest -Uri $tt_install_uri -OutFile $tt_install_exe
    Start-Process -FilePath $tt_install_exe -PassThru -Wait
    [System.String] $ssh_client = Get-ChildItem -recurse "C:\Program Files*\teraterm" | Where-Object { $_.Name -match "ttermpro" } | ForEach-Object { $_.FullName }
    if (-Not $? -Or -Not(Test-Path -Path $ssh_client))
    {
        Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [ERROR]: ttermpro.exe not found in `"C:\Program Files*`"."
        [Console]::ReadKey() | Out-Null
        exit 1
    }
}

if ($args)
{
    ### $args[0]には<username>@<hostname>形式を想定
    [System.String] $ssh_alias = $args[0]
    [System.Array] $ssh_args = $args[0] -split "@"
    [System.String] $ssh_log = "$log_dir\" + $ssh_args[1] + "_" + $ssh_args[0] + "_" + $date + "_" + $time + ".log"
    
    ### $args[0]の値と、CSV内のAliasの値で、一致するものを取得する
    [System.Array] $csv_data = Import-Csv $csv_file | Where-Object { $_.Alias -eq $ssh_alias }
    
    ### $args[0]の値と、CSV内のAliasの値で、一致するものが存在する場合
    if ($csv_data)
    {
        ### TeraTermに渡す引数を作成
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
    ### $args[0]の値と、CSV内のAliasの値で、一致するものが存在しない場合
    else
    {
        ### CSVの内容を表示
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

### teratermを実行
$ssh_process = Start-Process -FilePath $ssh_client -ArgumentList $opt_array -PassThru -Wait
### teratermログファイルの属性を読み込み専用に変更
Set-ItemProperty -Path $ssh_log -Name Attributes -Value Readonly
### teratermログファイルの内容を表示(個人的な趣味)
Get-Content -Path $ssh_log
### teratermログファイルの情報を画面に出力
Write-Output "$(Get-Date -Format yyyy-MM-ddThh:mm:sszzz) [INFO]: Log file: $ssh_log"
### TeraTermが異常終了 => 既に確立済みのsshセッションが、ネットワーク切断等により強制終了した場合
if ($ssh_process.ExitCode -ne 0)
{
    Write-Output "$(Get-Date -Format yyyy-MM-ddThh:mm:sszzz) [ERROR]: ttermpro.exe exit code NOT equal 0."
}
[Console]::ReadKey() | Out-Null
exit 0
