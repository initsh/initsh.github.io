

```PowerShell
(Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1)

https://msdn.microsoft.com/ja-jp/library/aa383644(v=vs.85).aspx
```

