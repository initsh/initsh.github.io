# Windows Subsystem for Linux


1. **<kbd>Windows</kbd> + <kbd>R</kbd> => `OptionalFeatures`**

1. **Check `Windows Subsystem for Linux`**

1. **<kbd>Windows</kbd> + <kbd>U</kbd> => `developer`** (OR **<kbd>Windows</kbd> + <kbd>R</kbd> => `powershell -Command "Start-Process -Verb runas powershell Show-WindowsDeveloperLicenseRegistration"`**)

1. **Check `Developer mode`**



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


###### EOF
