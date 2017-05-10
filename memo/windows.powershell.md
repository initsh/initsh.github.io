## [SetAllowTSConnections method of the Win32_TerminalServiceSetting class (Windows)](https://msdn.microsoft.com/ja-jp/library/aa383644(v=vs.85).aspx)

```PowerShell
(Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1)

```

## [BasicAuth](http://winscript.jp/powershell/?s=-credential%83p%83%89%83%81%81%5B%83%5E)
```PowerShell
$cred = Get-Credential $userName
Invoke-RestMethod https://basic.auth/ -Credential $cred
```

### プロダクトキー確認
```PowerShell
(Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey
```
<!--
(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
-->

### DCOMの無効/有効 ([参考](http://www.geekpage.jp/practical/winxp-tips/dcomcnfg.php))
```cmd
dcomcnfg.exe
```

