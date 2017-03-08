# Azure CLI

## 準備

    # 特権ユーザに昇格
    sudo su -
    
    # 依存関係をインストール
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】jqをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq; chmod 755 /usr/bin/jq
    
    # 【参考】Azure CLI 2.0 (az) azコマンド実行ユーザを作成
    v_user_name=az
    v_group_name=az
    v_group_id=12600
    v_user_id=12600
    groupadd -g ${v_group_id:?} ${v_group_name:?}
    useradd -u ${v_user_id:?} -g ${v_group_id:?} ${v_user_name:?}
    su - ${v_user_name:?}
    
    
## Azure CLI 2.0 のセットアップ ([参考](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli))

    # Azure CLI 2.0 (az) をインストール
    curl -L https://aka.ms/InstallAzureCli | bash
    
    # シェルを再実行し、環境変数などを反映させる
    exec -l $SHELL
    
    # azureへログイン (実行後に表示されるURLにアクセスし、コードを入力の後、ログイン情報を入力)
    az login
    
    # アカウント情報を表示
    az account show
    
    # 【参考】imageリストをファイルに保存
    az vm image list --all -o table >./az.vm.image.list.all.txt &
    
    
## 全リソースのプレフィックスを設定

    v_pre=Dev
    
    
## リソースグループ (ResourceGroup) 

    # var
    v_rg_name=${v_pre:?}RG
    v_rg_location=japaneast
    
    # リソースグループの作成
    az group create -l ${v_rg_location:?} -n ${v_rg_name:?}
    
    
## 仮想ネットワーク (VirtualNetwork)

    # var
    v_seq=001
    v_vnet_name=${v_pre:?}VNet${v_seq:?}
    v_vnet_cidr=192.168.0.0/16
    
    # 仮想ネットワークの作成
    az network vnet create -l ${v_rg_location:?} -g ${v_rg_name:?} -n ${v_vnet_name:?} --address-prefix ${v_vnet_cidr:?}
    
    
## サブネット

    # var
    v_seq=001
    v_subnet_name=${v_pre:?}Subnet${v_seq:?}
    v_subnet_cidr=192.168.$(seq ${v_seq:?}).0/24
    
    # サブネットの作成
    az network vnet subnet create -g ${v_rg_name:?} --vnet-name ${v_vnet_name:?} -n ${v_subnet_name:?} --address-prefix ${v_subnet_cidr:?}
    
    
## パブリックIP

    # var
    v_seq=001
    v_pip_name=${v_pre:?}PIP${v_seq:?}
    
    az network public-ip create -g ${v_rg_name:?} -l ${v_rg_location:?} -n ${v_pip_name:?} --allocation-method static
    
    #v_global_hostname=devazvm001
    #az network public-ip create -g ${v_rg_name:?} -l ${v_rg_location:?} -n ${v_pip_name:?} --dns-name ${v_global_hostname} --allocation-method static
    
    
    
    
    
    
    
    
    
    https://docs.microsoft.com/ja-jp/azure/virtual-machines/virtual-machines-linux-create-cli-complete
    
    
    
    
    
    
    
    
    
    
    
    
    
## 仮想マシン (VirtualMachine) ([参考](https://docs.microsoft.com/ja-jp/azure/virtual-machines/virtual-machines-linux-create-cli-complete))

    # var
    v_seq=001
    v_vm_name=${v_pre:?}VM${v_seq:?}
    v_vm_image="OpenLogic:CentOS:6.8:6.8.20170105"
    v_vm_user_name=azure-user
    v_vm_os_type=linux
    
    # create VM
    az vm create -n ${v_vm_name:?} -g ${v_rg_name:?} --image ${v_vm_image:?} --admin-username ${v_vm_user_name:?}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
## Regions
| Azure CLI 2.0 Regions | 和名 |
|:----------------------|:-----|
| centralus             ||
| eastasia              ||
| southeastasia         ||
| eastus                ||
| eastus2               ||
| westus                ||
| westus2               ||
| northcentralus        ||
| southcentralus        ||
| westcentralus         ||
| northeurope           ||
| westeurope            ||
| japaneast             |東日本|
| japanwest             |西日本|
| brazilsouth           ||
| australiasoutheast    ||
| australiaeast         ||
| westindia             ||
| southindia            ||
| centralindia          ||
| canadacentral         ||
| canadaeast            ||
| uksouth               ||
| ukwest                ||
| koreacentral          ||
| koreasouth            ||


###### EOF
