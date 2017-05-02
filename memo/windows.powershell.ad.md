# Setup Active Directory on CLI

## Active Directory のインストール

### 前提条件
- OS が Windows Server 2012 R2 であること
- ビルトイン Administrator ユーザでログインできること
- サーバに静的IPアドレスが割り振られていること
- 新規に構築されるフォレストであること

### 確認
```
# 作業対象サーバを確認する。
hostname

# ビルトイン Administrator ユーザでログインしていることを確認する。
whoami
```

### 作業
```
# ServerManager モジュールをインポートする。
Import-Module ServerManager

# Active Directory Domain Services をインストールする。
Install-WindowsFeature -IncludeManagementTools -Restart AD-Domain-Services
```

```
# ADDSDeployment モジュールをインポートする。
Import-Module ADDSDeployment


# 後述のコマンドに渡すパラメータを設定する。

# ADで使用するドメイン
$addsDomainName           = "report.local"

# ADで使用するドメインのNetBIOS名
$addsDomainNetbiosName    = "REPORT"

# 作成するフォレストの機能レベル
$addsForestMode           = "Win2012R2"

# 作成するドメインの機能レベル
$addsDomainMode           = "Win2012R2"

# セーフモード起動時のAdministratorユーザのパスワード
$addsAdminPassword        = "P@ssw0rd"

# ADのデータベース格納パス
$addsDatabasePath         = "C:\Windows\NTDS"

# ADのトランザクションログ格納パス
$addsLogPath              = "C:\Windows\NTDS"

# システムボリュームのパス
$addsSysvolPath           = "C:\Windows\SYSVOL"

# DNSをインストールする
$addsInstallDns           = $True

# DNS委任を作成しない
$addsCreateDnsDelegation  = $false

# 完了後にコンピュータを再起動させる
$addsNoRebootOnCompletion = $false

# 
$addsForce                = $True





```



