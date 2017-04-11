#
# - Name
#     sshTeraTerm.ps1
# 
# - Contents
#     Simplify SSH Connect by Tera Term.
#     <Windows> + <R> => ssh user@remotehost
# 
# - Revision
#     2016-12-28 created.
#     yyyy-MM-dd modified.
# 

# Date
[System.String] $yyyy = Get-Date -Format yyyy
[System.String] $mm = Get-Date -Format MM
[System.String] $dd = Get-Date -Format dd
[System.String] $hh = Get-Date -Format HH
[System.String] $mi = Get-Date -Format mm
[System.String] $ss = Get-Date -Format ss
[System.String] $tz = Get-Date -Format zzz

# Directory
[System.String] $base_dir = $Env:Userprofile + "\GoogleDrive" # 作業ディレクトリ
[System.String] $ssh_dir = $base_dir + "\ssh" # 作業ディレクトリ
[System.String] $log_dir = $ssh_dir + "\log" # teratermログ出力ディレクトリ
[System.String] $key_dir = $ssh_dir + "\key" # 秘密鍵設置ディレクトリ

[System.String] $ps1_dir = $base_dir + "\ps1" # powershell格納ディレクトリ
# sshTeraTerm.csv
# |#Hostname,Port,Username,AuthType,Value,Alias
# |localhost,22,root,publickey,id_rsa,user@remotehost
# |localhost,22,root,password,pasuwa-do,user@remotehost
[System.String] $csv_file = $ps1_dir + "\sshTeraTerm.csv" # 任意の場所にログイン情報を記載したCSVを設置

# Get full path (ttermpro.exe)
[System.String] $ssh_client = Get-ChildItem -recurse "C:\Program Files*\teraterm" | Where-Object { $_.Name -match "ttermpro" } | ForEach-Object { $_.FullName } # teratemrインストールディレクトリからttermpro.exeを検索
if ( $ssh_client -notlike "*ttermpro.exe" ) {
    Write-Output "[ERROR]: ttermpro.exe not found in `"C:\Program Files*`"."
    Start-Sleep 5
    exit 1
}


if ( $args )
{
    # スクリプトの引数[1]には<username>@<hostname>形式を想定
    [System.String] $ssh_alias = $args[0]
    [System.Array] $ssh_args = $args[0] -split "@"
    [System.String] $ssh_log = $log_dir + "\" + $ssh_args[1] + "_" + $ssh_args[0] + "_" + $yyyy + $mm + $dd + "_" + $hh + $mi + $ss + ".log"
    
    # Import-Csv
    [System.Array] $csv_data = Import-Csv $csv_file | Where-Object { $_.Alias -eq $ssh_alias }
    
    if ( $csv_data )
    {
        # Compose Options
        [System.String] $opt_host = "ssh2://" + $csv_data[0].Hostname + ":" + $csv_data[0].Port
        [System.String] $opt_user = "/user=" + $csv_data[0].Username
        [System.String] $opt_auth = "/auth=" + $csv_data[0].AuthType
        if ( $csv_data[0].AuthType -eq "password" )
        {
            [System.String] $opt_value = "/passwd=" + $csv_data[0].Value
        }
        elseif ( $csv_data[0].AuthType  -eq "publickey" )
        {
            [System.String] $opt_value = "/keyfile=" + $key_dir + "\" + $csv_data[0].Value
        }
        [System.String] $opt_dir = "/FD=" + $ssh_dir
        [System.String] $opt_log = "/L=" + $ssh_log

        [System.String] $opt_array = @($opt_host,$opt_user,$opt_auth,$opt_value,$opt_dir,$opt_log,"/ssh-v","/LA=J")

        # Execute $ssh_client
        #Start-Process -FilePath $ssh_client -ArgumentList $opt_array
        $ssh_process = Start-Process -FilePath $ssh_client -ArgumentList $opt_array -Wait -PassThru
        Set-ItemProperty -Path $ssh_log -Name Attributes -Value Readonly # ログファイルを読み込み専用にする
        if ((Test-Path -Path $ssh_log) -And ($ssh_process.ExitCode -ne 0)) # logファイルが存在 かつ TeraTermが異常終了 => 既に確立済みのsshセッションが、ネットワーク切断等により強制終了した場合
        {
            Start-Process -FilePath notepad -ArgumentList $ssh_log # ログファイルをメモ帳で開く
        }
    }
    else # CSV内のAliasの値と、渡された引数とで、一致するものが存在しない場合
    {
        Import-Csv $csv_file | Select-Object Alias,Hostname,Username | Write-Host
        [Console]::ReadKey() | Out-Null
    }
}
else
{
    # Execute $ssh_client
    Start-Process -FilePath $ssh_client
}
