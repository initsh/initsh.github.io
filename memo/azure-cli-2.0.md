# Azure CLI

## Prepare

    # 特権ユーザに昇格
    sudo su -
    
    # 依存関係をインストール
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】jqをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq; chmod 755 /usr/bin/jq
    
    # 【参考】Azure CLI 2.0 (az) azコマンド実行ユーザを作成
    USER_NAME=az
    GROUP_NAME=az
    GROUP_ID=12600
    USER_ID=12600
    groupadd -g ${GROUP_ID} ${GROUP_NAME}
    useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
    su - ${USER_NAME}


## Setup Azure CLI ([参考](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli))

    # Azure CLI 2.0 (az) をインストール
    curl -L https://aka.ms/InstallAzureCli | bash
    
    # シェルを再実行し、環境変数などを反映させる
    exec -l ${SHELL}
    
    # azureへログイン (出力をファイル"az.login.json"として保存)
    # 実行後に表示されるURLにアクセスし、コードを入力の後、ログイン情報を入力
    az login | tee ./az.login.json
    
    # アカウント情報を表示
    az account show
    
    
## Setup ResourceGroup
    
    # 
    RG_NAME=DevResourceGroup
    RG_LOCATION=japaneast
    
    # 
    RG_CREATE_JSON="$(az group create -n ${RG_NAME} -l ${RG_LOCATION} | tee /dev/stderr)"
    
    
## Setup VirtualMachine
    
    # 
    SEQ=001
    VM_NAME=DevVM${SEQ}
    
    # 
    az vm create -n ${VM_NAME} -g ${RG_NAME} --image UbuntuLTS --generate-ssh-keys
    
    
    
    
    
    
    
    
    
## Regions
|Azure CLI 2.0 Regions|和名|
|:--|:--|
|centralus||
|eastasia||
|southeastasia||
|eastus||
|eastus2||
|westus||
|westus2||
|northcentralus||
|southcentralus||
|westcentralus||
|northeurope||
|westeurope||
|japaneast|東日本|
|japanwest|西日本|
|brazilsouth||
|australiasoutheast||
|australiaeast||
|westindia||
|southindia||
|centralindia||
|canadacentral||
|canadaeast||
|uksouth||
|ukwest||
|koreacentral||
|koreasouth||


###### EOF
