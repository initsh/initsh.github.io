## nslookup
```
nslookup -q=mx mail.initsh.com
```

## ログ確認
```PowerShell
# ログの種類一覧の表示
Get-EventLog -List

# システムログの確認
Get-EventLog -LogName System
```


## [リモートデスクトップ接続の有効＋穴あけ(3389/tcp)](https://msdn.microsoft.com/ja-jp/library/aa383644(v=vs.85).aspx)

```PowerShell
(Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1)

```

## [Basic認証](http://winscript.jp/powershell/?s=-credential%83p%83%89%83%81%81%5B%83%5E)
```PowerShell
$cred = Get-Credential $userName
Invoke-RestMethod -Uri https://basic.auth/ -Credential $cred
```

## プロダクトキー確認
```PowerShell
(Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey
```
<!--
(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
-->

## DCOMの無効/有効 ([参考](http://www.geekpage.jp/practical/winxp-tips/dcomcnfg.php))
```cmd
dcomcnfg.exe
```

## `cmd.exe`で言うところの`pause`
```PowerShell
[Console]::ReadKey() | Out-Null
```

## Windowsの機能の有効化（Windows10用）
```PowerShell
# Windowsの機能のステータスの確認
Get-WindowsOptionalFeature -Online

# Windowsの機能の有効化(例はHyper-V)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

```

## ファイル名取得(`basename $file`),フルパス取得(`readlink -f $file`), 拡張子取得
```PowerShell
(Get-Item $file).BaseName

(Get-Item $file).FullName

(Get-Item $file).Extension
```

