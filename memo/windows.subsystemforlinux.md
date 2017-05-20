# Windows Subsystem for Linux

## インストール手順

1. <kbd>Windows</kbd>+<kbd>R</kbd> => ```powershell.exe -Command "Start-Process -Verb RUNAS powershell.exe"```
1. 以下一連のコマンドを実行。
```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

lxrun

lxrun /install /y
```
#### 以上。







## `lxrun`コマンドについて

```
C:\> lxrun
Performs administrative operations on the LX subsystem

Usage:
    /install - Installs the subsystem
        Optional arguments:
            /y - Do not prompt user to accept
    /uninstall - Uninstalls the subsystem
        Optional arguments:
            /full - Perform a full uninstall
            /y - Do not prompt user to accept
    /update - Updates the subsystem
        Optional arguments:
            /critical - Perform critical update. This option will close all running LX processes when the update completes.

C:\> lxrun /install /y

C:\> lxrun /setdefaultuser root

C:\> lxrun /uninstall /y

```



<!--





## 以下、旧手順。

1. **<kbd>Windows</kbd> + <kbd>R</kbd> => `OptionalFeatures`**

1. **Check `Windows Subsystem for Linux`**

1. **<kbd>Windows</kbd> + <kbd>U</kbd> => `developer`** (OR **<kbd>Windows</kbd> + <kbd>R</kbd> => `powershell -Command "Start-Process -Verb runas powershell Show-WindowsDeveloperLicenseRegistration"`**)

1. **Check `Developer mode`**

```
if (-not((Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq 'Microsoft-Windows-Subsystem-Linux' }).State -eq 'Enabled'))
{
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
   reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
}

lxrun

lxrun /install /y
```

-->

###### EOF
