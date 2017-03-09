# Azure CLI

## 前提

以下を参考に、サブスクリプションやリソースの制限について確認すること。<br>
[Azure サブスクリプションとサービスの制限、クォータ、制約](https://docs.microsoft.com/ja-jp/azure/azure-subscription-service-limits)

    
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
    
    
## 全リソースのプレフィックスを設定 (プロジェクトコード・環境など)

    v_pre=OkWDev
    
    
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
    v_vnet_cidr=10.1.0.0/16
    
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
    v_global_hostname="$(echo ${v_pip_name:?} | tr "[:upper:]" "[:lower:]")"
    
    #az network public-ip create -g ${v_rg_name:?} -l ${v_rg_location:?} -n ${v_pip_name:?} --allocation-method static
    az network public-ip create -g ${v_rg_name:?} -l ${v_rg_location:?} -n ${v_pip_name:?} --allocation-method static --dns-name ${v_global_hostname}
    
    
## ロードバランサ ([参考](https://docs.microsoft.com/ja-jp/azure/virtual-machines/virtual-machines-linux-create-cli-complete))

    # var
    v_seq=001
    v_lb_name=${v_pre:?}LB${v_seq:?}
    v_lb_frontend_ip_name=${v_pre:?}LBFront${v_seq:?}
    v_lb_backend_pool_name=${v_pre:?}LBBack${v_seq:?}
    
    # ロードバランサ作成＆フロントエンドPIP付与
    az network lb create -g ${v_rg_name:?} -l ${v_rg_location:?} -n ${v_lb_name:?} --public-ip-address ${v_pip_name:?} --frontend-ip-name ${v_lb_frontend_ip_name:?}
    
    # ロードバランサバックエンドLocalIPプール作成
    az network lb address-pool create -g ${v_rg_name:?} --lb-name ${v_lb_name:?} -n ${v_lb_backend_pool_name:?}
    
## ロードバランサのNATルール (今回は不要か？)

    #
    ## var
    #v_seq=001
    #v_lb_nat=${v_pre:?}LBInNat${v_seq:?}
    #v_lb_protocol=tcp
    #v_lb_front_port=80
    #v_lb_back_port=80
    #
    ## nat rule
    #az network lb inbound-nat-rule create -g ${v_rg_name:?} --lb-name ${v_lb_name:?} -n ${v_lb_nat:?} --protocol ${v_lb_protocol:?} --frontend-port ${v_lb_front_port:?} --backend-port ${v_lb_back_port:?} --frontend-ip-name ${v_lb_frontend_ip_name:?}
    #
    ## var
    #v_seq=002
    #v_lb_nat=${v_pre:?}LBNat${v_seq:?}
    #v_lb_protocol=tcp
    #v_lb_front_port=443
    #v_lb_back_port=443
    #
    ## nat rule
    #az network lb inbound-nat-rule create -g ${v_rg_name:?} --lb-name ${v_lb_name:?} -n ${v_lb_nat:?} --protocol ${v_lb_protocol:?} --frontend-port ${v_lb_front_port:?} --backend-port ${v_lb_back_port:?} --frontend-ip-name ${v_lb_frontend_ip_name:?}
    #

    
## LB正常性プローブ (ヘルスチェック)

    # var
    v_seq=001
    v_lb_protocol=tcp
    v_lb_front_port=80
    v_lb_back_port=80
    v_lb_probe_name=${v_pre:?}LBProbe${v_seq:?}
    v_lb_probe_interval=5 #sec
    v_lb_probe_threshold=2

    az network lb probe create -g ${v_rg_name:?} --lb-name ${v_lb_name:?} -n ${v_lb_probe_name:?} --protocol ${v_lb_rule_protocol:?} --port ${v_lb_rule_front_port:?} --interval ${v_lb_probe_interval:?} --threshold ${v_lb_probe_threshold:?}
    

## ロードバランシングルール
    
    # var
    v_seq=001
    v_lb_rule_name=${v_pre:?}LBRule${v_seq:?}

    az network lb rule create -g ${v_rg_name:?} --lb-name ${v_lb_name:?} -n ${v_lb_rule_name:?} --protocol ${v_lb_protocol:?} --frontend-port ${v_lb_front_port:?} --backend-port ${v_lb_back_port:?} --frontend-ip-name ${v_lb_frontend_ip_name:?} --backend-pool-name ${v_lb_backend_pool_name:?} --probe-name ${v_lb_probe_name:?}

    # 確認
    az network lb show -g ${v_rg_name:?} -n ${v_lb_name:?}

    
    
    
## 仮想マシン (VirtualMachine) ([参考](https://docs.microsoft.com/ja-jp/azure/virtual-machines/virtual-machines-linux-create-cli-complete))

    # var
    v_seq=001
    v_vm_name=${v_pre:?}VM${v_seq:?}
    v_vm_image="OpenLogic:CentOS:6.8:6.8.20170105"
    v_vm_user_name=az-user
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
