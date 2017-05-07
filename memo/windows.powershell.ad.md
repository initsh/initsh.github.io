Setup Active Directory on CLI
=============================

# 目次
- 手順：新規フォレスト・ドメイン・ドメインコントローラーの構築
- 手順：既存のドメインにドメインコントローラーを追加
- 手順：FSMOの転送
- Reference

# 手順：新規フォレスト・ドメイン・ドメインコントローラーの構築

### 前提条件
- サーバのOS が Windows Server 2012 R2 であること
- サーバに静的IPアドレスが設定済みであること
- サーバに Administrator ユーザでログインできること
- サーバにホスト名が設定済みであること
  -  右記コマンドにて変更可能: `Rename-Computer -NewName $Hostname -Force -Restart`

#### 以下、作業はすべてPowerShell上で行うものとします。

### 確認作業

```PowerShell
# 作業対象サーバを確認します。
hostname

# Administrator ユーザでログインしていることを確認します。
whoami
```

### 作業

#### Active Directory Domain Services をインストールします。

```PowerShell
# ADが既にインストールされていないことを確認します。
Get-WindowsFeature | Where-Object { $_.Name -eq 'AD-Domain-Services' }

# ServerManager モジュールをインポートします。
Import-Module ServerManager

# Active Directory Domain Services をインストールします。
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services

# ADがインストールされたことを確認します。
Get-WindowsFeature | Where-Object { $_.Name -eq 'AD-Domain-Services' }
```

#### 新規フォレスト・ドメイン・ドメインコントローラーの構築します。(※サーバが再起動されます)

```PowerShell
# ADDSDeployment モジュールをインポートします。
Import-Module ADDSDeployment

# 設定値(後段で使用)：ADで使用するドメイン
$addsDomainName = "report.local"

# 設定値(後段で使用)：ADで使用するドメインのNetBIOS名
$addsDomainNetbiosName = "REPORT"

# 設定値(後段で使用)：作成するフォレストの機能レベル
$addsForestMode = "Win2012R2"

# 設定値(後段で使用)：作成するドメインの機能レベル
$addsDomainMode = "Win2012R2"

# 設定値(後段で使用)：セーフモード起動時のAdministratorユーザのパスワード
$addsSafeModePassword = "P@ssw0rd"

# 設定値(後段で使用)：ADのデータベース格納パス
$addsDatabasePath = "$env:SystemRoot\NTDS"

# 設定値(後段で使用)：ADのトランザクションログ格納パス
$addsLogPath = "$env:SystemRoot\NTDS"

# 設定値(後段で使用)：システムボリュームのパス
$addsSysvolPath = "$env:SystemRoot\SYSVOL"

# 設定値(後段で使用)：DNSをインストールする
$addsInstallDns = $True

# 設定値(後段で使用)：DNS委任を作成しない
$addsCreateDnsDelegation = $false

# 設定値(後段で使用)：完了後にコンピュータを再起動させる
$addsNoRebootOnCompletion = $false

# 設定値(後段で使用)：すべての操作に対して [Y] はい(Y) を選択する
$addsForce = $True

# 新規フォレスト・ドメイン・ドメインコントローラーの構築します。
Install-ADDSForest -DomainName $addsDomainName -DomainNetbiosName $addsDomainNetbiosName -ForestMode $addsForestMode -DomainMode $addsDomainMode -DatabasePath $addsDatabasePath -LogPath $addsLogPath -SysvolPath $addsSysvolPath -SafeModeAdministratorPassword (ConvertTo-SecureString $addsSafeModePassword -AsPlainText -Force) -InstallDns:$addsInstallDns -CreateDnsDelegation:$addsCreateDnsDelegation -NoRebootOnCompletion:$addsNoRebootOnCompletion -Force:$addsForce

# 再起動後、ドメイン・DC・フォレストの情報を確認します。
Import-Module ActiveDirectory
Get-ADDomain
Get-ADDomainController
Get-ADForest
```

#### 以上で「手順：新規フォレスト・ドメイン・ドメインコントローラーの構築」は完了となります。



# 手順：既存のドメインにドメインコントローラーを追加

### 前提条件
- サーバのOS が Windows Server 2012 R2 であること
- サーバに静的IPアドレスが設定済みであること
- サーバに Administrator ユーザでログインできること
- サーバにホスト名が設定済みであること
  -  右記コマンドにて変更可能: `Rename-Computer -NewName $Hostname -Force -Restart`

#### 以下、作業はすべてPowerShell上で行うものとします。

### 確認作業

```PowerShell
# 作業対象サーバを確認します。
hostname

# Administrator ユーザでログインしていることを確認します。
whoami
```

### 作業

#### Active Directory Domain Services をインストールします。

```PowerShell
# ADが既にインストールされていないことを確認します。
Get-WindowsFeature | Where-Object { $_.Name -eq 'AD-Domain-Services' }

# ServerManager モジュールをインポートします。
Import-Module ServerManager

# Active Directory Domain Services をインストールします。
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services

# ADがインストールされたことを確認します。
Get-WindowsFeature | Where-Object { $_.Name -eq 'AD-Domain-Services' }
```

#### 既存のドメインにドメインコントローラーを追加します。(※サーバが再起動されます)

```PowerShell
# ADDSDeployment モジュールをインポートします。
Import-Module ADDSDeployment

# 設定値(後段で使用)：ADで使用するドメイン
$addsDomainName = "report.local"

# 設定値(後段で使用)：ドメインの Administrator ユーザ
$cred = Get-Credential Administrator

# 設定値(後段で使用)：ADのデータベース格納パス
$addsDatabasePath = "$env:SystemRoot\NTDS"

# 設定値(後段で使用)：ADのトランザクションログ格納パス
$addsLogPath = "$env:SystemRoot\NTDS"

# 設定値(後段で使用)：システムボリュームのパス
$addsSysvolPath = "$env:SystemRoot\SYSVOL"

# 設定値(後段で使用)：DCをグローバルカタログサーバとしてインストールする
$addsNoGlobalCatalog = $false

# 設定値(後段で使用)：DNSをインストールする
$addsInstallDns = $True

# 設定値(後段で使用)：DNS委任を作成しない
$addsCreateDnsDelegation = $false

# 設定値(後段で使用)：完了後にコンピュータを再起動させる
$addsNoRebootOnCompletion = $false

# 設定値(後段で使用)：すべての操作に対して [Y] はい(Y) を選択する
$addsForce = $True

# 既存のドメインにドメインコントローラーを追加します。
Install-ADDSDomainController -DomainName $addsDomainName -Credential $cred -DatabasePath $addsDatabasePath -LogPath $addsLogPath -SysVolPath $addsSysvolPath -NoGlobalCatalog:$addsNoGlobalCatalog -InstallDNS:$addsInstallDns -CreateDNSDelegation:$addsCreateDnsDelegation -NoRebootOnCompletion:$addsNoRebootOnCompletion -Force:$addsForce

# 再起動後、ドメイン・DC・フォレストの情報を確認します。
Import-Module ActiveDirectory
Get-ADDomain
Get-ADDomainController
Get-ADForest
```

#### 以上で「手順：既存のドメインにドメインコントローラーを追加」は完了となります。



# 手順：FSMOの転送

### 前提条件
- FSMO転送先DCが構築済みであり、ドメインにDCとして参加済みであること
- ドメインの Administrator ユーザでログインできること

#### 以下、作業はすべてPowerShell上で行うものとします。

### 確認作業

```PowerShell
# 作業対象サーバを確認します。
hostname

# Administrator ユーザでログインしていることを確認します。
whoami
```

### 作業

#### 転送元DCから、転送先DCへ、FSMOを転送します。

```PowerShell
# 必要となるモジュールをインポートします。
Import-Module ActiveDirectory

# 設定値(後段で使用)：FSMO転送先DCのホスト名
$addsFsmoHostname = "adds-02"

# FSMOを転送します。引数 -OperationMasterRole にて、下記を指定します。
#   - InfraStructureMaster
#   - RIDMaster
#   - PDCEmulator
#   - DomainNamingMaster
#   - SchemaMaster
Move-ADDirectoryServerOperationMasterRole -Identity $addsFsmoHostname -OperationMasterRole InfraStructureMaster,RIDMaster,PDCEmulator,DomainNamingMaster,SchemaMaster -Force:$True
```

#### 以上で「手順：FSMOの転送」は完了となります。



# Reference
- [Windows PowerShell を使用して AD DS をインストールする - MSDN](https://msdn.microsoft.com/ja-jp/library/hh472162.aspx#BKMK_PS)
- [Active Directory Cmdlets Move-ADDirectoryServerOperationMasterRole](https://technet.microsoft.com/en-us/library/ee617229.aspx)
