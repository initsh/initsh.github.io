# Azure CLI

## Prepare

    # 特権ユーザに昇格
    sudo su -
    
    # 依存関係をインストール
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】Azure CLI 2.0 (az) 実行ユーザの作成
    USER_NAME=az
    GROUP_NAME=az
    GROUP_ID=12600
    USER_ID=12600
    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
    su - ${USER_NAME}


## Setup Azure CLI ([参考](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli))

    # Azure CLI 2.0 (az) をインストール
    curl -L https://aka.ms/InstallAzureCli | bash | tee ./az.install.log
    
    # シェルを再実行し、環境変数などを反映させる
    exec -l ${SHELL}
    
    # azureへログイン
    az login | tee ./az.login.json

    





###### EOF
