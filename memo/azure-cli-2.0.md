# Azure CLI

## Prepare

    # 特権ユーザに昇格する。
    sudo su -
    
    # 依存関係をインストールする。
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】Azure CLI 2.0 (az) azコマンド実行ユーザを作成する。
    USER_NAME=az
    GROUP_NAME=az
    GROUP_ID=12600
    USER_ID=12600
    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
    su - ${USER_NAME}


## Setup Azure CLI ([参考](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli))

    # Azure CLI 2.0 (az) をインストールする。
    curl -L https://aka.ms/InstallAzureCli | bash
    
    # シェルを再実行し、環境変数などを反映させる。
    exec -l ${SHELL}
    
    # azureへログインする。 (出力をファイル"az.login.json"として保存する)
    # 実行後に表示されるURLにアクセスし、コードを入力する。
    az login | tee ./az.login.json
    
    





###### EOF
