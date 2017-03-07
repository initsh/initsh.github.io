# Azure CLI

## Prepare

    sudo su -
    
    yum update -y
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    $v_username=azure
    $v_gid=36500
    $v_uid=36500
    groupadd -g $v_gid
    useradd -u $v_uid -g $v_gid $v_username
    
    su -l $v_username
    

## Setup Azure CLI ([参考](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli))
    curl -L https://aka.ms/InstallAzureCli | bash





###### EOF
