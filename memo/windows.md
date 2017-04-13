## Path
### Add `%PATH%`
```PowerShell
$Env:Path += ";%USERPROFILE%\AppData\Roaming\Python\Python35\Scripts;"
```


## System Files

### `regedit`
```
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
```

### `hosts`
```PowerShell
%SYSTEMROOT%\system32\drivers\etc
```

## Commands
### `mstsc`
```PowerShell
mstsc /v:127.0.0.1:33389
```
### `cmd`
```bat
cmd /k ipconfig
cmd /k route -p add 192.168.0.0 mask 255.255.0.0 192.168.254.254 metric 10
```
### `shutdown`
```
shutdown /r /t 0
```
### `shell:startup`
```PowerShell
shell:startup
```

## Shortcuts
### `admin`
```PowerShell
%SYSTEMROOT%\System32\rundll32.exe shell32.dll,#61
```
### `GODMODE`
```PowerShell
GODMODE.{ED7BA470-8E54-465E-825C-99712043E01C}
```



### system
```
OptionalFeatures
eventvwr
msconfig
taskmgr
regedit
compmgmt.msc
services.msc
perfmon.msc
devmgmt.msc
```

### controlpanel
```
control
sysdm.cpl
ncpa.cpl
inetcpl.cpl
appwiz.cpl
firewall.cpl
desk.cpl
powercfg.cpl
```

### taskbar?
```
ms-availablenetworks:
ms-settings-displays-topology:projection
```

### office
```
winword
excel
powerpnt
outlook
```

### tools
```
mspaint
calc
notepad
```



### env
```
%HOMEDRIVE%
%WINDIR%
%SYSTEMROOT%
%HOMEPATH%
%USERPROFILE%
```


### icon
```
%WINDIR%\system32\imageres.dll
```

### 仮想ドライブ
- エクスプローラ: [PC]右クリック -> 管理
- コンピュータの管理: 記憶域 -> ディスクの管理
- diskmgmt.msc







###### EOF
