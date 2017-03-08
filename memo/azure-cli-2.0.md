# Azure CLI

## Prepare

    # 特権ユーザに昇格
    sudo su -
    
    # 依存関係をインストール
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】Azure CLI 2.0 (az) 実行ユーザの作成
    USERNAME=az
    GROUP_ID=36500
    USER_ID=36500
    groupadd -g $GROUP_ID
    useradd -u $USER_ID -g $GROUP_ID $v_username
    su - $USERNAME


## Setup Azure CLI ([参考](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli))

    # Azure CLI 2.0 (az) をインストール
    curl -L https://aka.ms/InstallAzureCli | bash
    
    # シェルを再実行し、環境変数などを反映させる
    exec -l $SHELL
    
    # azureへログイン
    az login | tee ./az.login.json

    





###### EOF
