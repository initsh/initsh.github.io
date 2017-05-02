# Setup Active Directory on CLI

## 手順：新規フォレスト及びドメインコントローラーの構築

### 前提条件
- サーバのOS が Windows Server 2012 R2 であること
- サーバにビルトイン Administrator ユーザでログインできること
- サーバに静的IPアドレスが設定済みであること
- サーバにホスト名が設定済みであること

#### 以下、作業はすべてPowerShell上で行うものとします。

### 確認作業

```PowerShell
# 作業対象サーバを確認します。
hostname

# ビルトイン Administrator ユーザでログインしていることを確認します。
whoami
```

### 作業

#### Active Directory Domain Services をインストールします。

```PowerShell
# ServerManager モジュールをインポートします。
Import-Module ServerManager

# Active Directory Domain Services をインストールします。
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services
```

#### 新規フォレスト及びドメインコントローラーを構築します。

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
$addsAdminPassword = "P@ssw0rd"

# 設定値(後段で使用)：ADのデータベース格納パス
$addsDatabasePath = "C:\Windows\NTDS"

# 設定値(後段で使用)：ADのトランザクションログ格納パス
$addsLogPath = "C:\Windows\NTDS"

# 設定値(後段で使用)：システムボリュームのパス
$addsSysvolPath = "C:\Windows\SYSVOL"

# 設定値(後段で使用)：DNSをインストールする
$addsInstallDns = $True

# 設定値(後段で使用)：DNS委任を作成しない
$addsCreateDnsDelegation = $false

# 設定値(後段で使用)：完了後にコンピュータを再起動させる
$addsNoRebootOnCompletion = $false

# 新規フォレスト及びドメインコントローラーを構築します。
Install-ADDSForest `
    -DomainName $addsDomainName `
    -DomainNetbiosName $addsDomainNetbiosName `
    -ForestMode $addsForestMode `
    -DomainMode $addsDomainMode `
    -DatabasePath $addsDatabasePath `
    -LogPath $addsLogPath `
    -SysvolPath $addsSysvolPath `
    -SafeModeAdministratorPassword (ConvertTo-SecureString $addsSafeModePassword -AsPlainText -Force) `
    -InstallDns:$addsInstallDns `
    -CreateDnsDelegation:$addsCreateDnsDelegation `
    -NoRebootOnCompletion:$addsNoRebootOnCompletion

```

## 手順：既存のフォレストにドメインコントローラーを追加

### 前提条件
- サーバのOS が Windows Server 2012 R2 であること
- サーバにビルトイン Administrator ユーザでログインできること
- サーバに静的IPアドレスが設定済みであること
- サーバにホスト名が設定済みであること

#### 以下、作業はすべてPowerShell上で行うものとします。


