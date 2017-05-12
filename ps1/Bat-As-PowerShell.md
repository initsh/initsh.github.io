
batファイルの行頭に以下を記載する。
```bat
@setlocal enableextensions enabledelayedexpansion & set "PATH0=%~f0" & PowerShell.exe -Command "& (Invoke-Expression -Command ('{#' + ((Get-Content '!PATH0:'=''!') -join \"`n\") + '}'))" %* & exit /b !errorlevel!
```

2行目以降はPowerShellを記載。
