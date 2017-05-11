# 
# - Name
#     New-Shortcut.ps1
# 
# - Contents
#     Generate shortcut.
#     C:\> New-Shortcut.ps1 "C:\Users\j.doe\Documents\foobar.docx"
# 
# - Revision
#     2016-05-11 created.
#     yyyy-MM-dd modified.
# 

# Check $args
if(-Not("$($args[0])"))
{
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [ERROR]: `$args[0] is null."
    [Console]::ReadKey() | Out-Null
    exit 1
}

# Check source file path of shortcut(*.lnk).
if (-Not(Resolve-Path "$($args[0])" 2>$null))
{
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [ERROR]: Incorrect path: `"$($args[0])`""
    [Console]::ReadKey() | Out-Null
    exit 1
}

# variables(1)
[System.String] $lnkSrcPath = Resolve-Path $args[0]
[System.String] $lnkWorkingDir = Split-Path $lnkSrcPath -Parent
[System.String] $lnkDstDir = $env:USERPROFILE + "\Desktop"
[System.String] $lnkDstFile = (Split-Path $lnkSrcPath -Leaf) + "(shortcut).lnk"
[System.String] $lnkDstPath = "$lnkDstDir\$lnkDstFile"

# Instantiate "Windows Script Host"
$wsh = New-Object -comObject WScript.Shell

# Run instance method "Create Shortcut"
$lnk = $wsh.CreateShortcut($lnkDstPath)

# Initialize TargetPath of shortcut(*.lnk).
$lnk.TargetPath = $lnkSrcPath

# Initialize WorkingDirectory of shortcut(*.lnk).
$lnk.WorkingDirectory = $lnkWorkingDir

# Save shortcut(*.lnk)
$lnk.Save()

# Check generated shortcut(*.lnk)
if (-Not(Test-Path -Path $lnkDstPath))
{
    Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [ERROR]: Fail to generate shortcut: `"$lnkDstPath`""
    [Console]::ReadKey() | Out-Null
    exit 1
}

# exit 0
Write-Output "$(Get-Date -Format yyyy-MM-ddTHH:mm:sszzz) [INFO]: Generate shortcut: `"$lnkDstPath`""
[Console]::ReadKey() | Out-Null
exit 0
