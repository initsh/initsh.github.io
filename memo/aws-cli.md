# AWS CLI

## Prepare
    sudo su -
    
    python <(curl -LRs "https://bootstrap.pypa.io/get-pip.py")
    
    # 【参考】jqコマンドをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq ; chmod 755 /tmp/jq ; \mv -f /tmp/jq /usr/bin/jq ; ls -dl /usr/bin/jq*


## Setup AWS CLI
    pip install awscli
    aws configure


## Setup VPC ([参考](http://www.simpline.co.jp/tech/?p=267))

#### 変数を設定

    VPC_CIDR=10.0.0.0/16
    VPC_NAME=dev-vpc
    REGION=ap-northeast-1


##### VPCを作成 / jsonからVPCのidを出力し、変数に格納 / 確認

    VPC_CREATE_JSON="$(aws ec2 create-vpc --region $REGION --cidr-block $VPC_CIDR | tee /dev/stderr)"
    VPC_ID="$(echo "$VPC_CREATE_JSON" | sed -r -e /VpcId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"


#### vpcのidと同名のディレクトリを`$HOME`配下に作成 && 移動

    cd $HOME ; mkdir $VPC_ID ; cd $VPC_ID ; pwd


#### VPCにNameタグを設定 / 設定をファイルに保存

    aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME
    aws ec2 describe-vpcs --vpc-id $VPC_ID | tee vpc.json
    
    # 【参考】VPC作成時の情報をファイルに保存
    echo "$VPC_CREATE_JSON" | tee vpc.json.create
    

#### VPCの設定を変更(VPC内の名前解決をサポート) / 設定確認

    aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
    aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsSupport


#### VPCの設定を変更(VPC内のGIPを持つ仮想マシンにPublicDNS名を付与) / 設定確認

    aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
    aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsHostnames


## Setup IGW ([参考](http://www.simpline.co.jp/tech/?p=267))

#### IGW用変数を設定

    IGW_NAME=dev-igw


##### VPCを作成 / jsonからVPCのidを出力し、変数に格納 / 確認

    IGW_CREATE_JSON="$(aws ec2 create-internet-gateway | tee /dev/stderr)"
    IGW_ID="$(echo "$IGW_CREATE_JSON" | sed -r -e /InternetGatewayId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"


#### VPCにIGWをアタッチ
    aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID


#### VPCにNameタグを設定 / 設定をファイルに保存

    aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$IGW_NAME
    aws ec2 describe-internet-gateways --filters "Name=internet-gateway-id,Values=$IGW_ID" | tee igw.json
    
    # 【参考】VPC作成時の情報をファイルに保存
    echo "$IGW_CREATE_JSON" | tee igw.json.create









###### EOF
