# AWS CLI

## Prepare
    # 特権ユーザに昇格
    sudo su -
    
    # pipをインストール
    curl -LRs "https://bootstrap.pypa.io/get-pip.py" | python
    
    # 【参考】jqをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq; chmod 755 /usr/bin/jq


## Setup AWS CLI
    pip install awscli
    aws configure


## Setup ProjectPrefix
    v_pre=dev

## Setup VPC ([参考](http://www.simpline.co.jp/tech/?p=267))

    # 変数を設定
    v_vpc_name=${v_pre}-vpc
    v_vpc_cidr=10.0.0.0/16
    v_vpc_region=ap-northeast-1
    
    # vpcのnameタグと同名のディレクトリを`$HOME`配下に作成 && 移動
    cd $HOME ; mkdir ${v_vpc_name} ; cd ${v_vpc_name} ; pwd
    
    # VPCを作成
    v_vpc_create_json="$(aws ec2 create-vpc --region ${v_vpc_region} --cidr-block ${v_vpc_cidr} | tee /dev/stderr)"
    
    # VPCのid情報を、変数に格納
    v_vpc_id="$(echo "${v_vpc_create_json}" | sed -r -e /VpcId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # VPCにNameタグを設定
    aws ec2 create-tags --resources ${v_vpc_id} --tags Key=Name,Value=${v_vpc_name}
    
    # VPCの情報をファイルに保存
    aws ec2 describe-vpcs --vpc-id ${v_vpc_id} | tee ${v_vpc_name}.json
    
    # 【参考】VPC作成時の情報をファイルに保存
    echo "${v_vpc_create_json}" | tee ${v_vpc_name}.json.create
    
    # VPCの設定を変更(VPC内の名前解決をサポート)
    aws ec2 modify-vpc-attribute --vpc-id ${v_vpc_id} --enable-dns-support
    
    # 設定確認
    aws ec2 describe-vpc-attribute --vpc-id ${v_vpc_id} --attribute enableDnsSupport
    
    # VPCの設定を変更(VPC内のGIPを持つ仮想マシンにPublicDNS名を付与)
    aws ec2 modify-vpc-attribute --vpc-id ${v_vpc_id} --enable-dns-hostnames
    
    # 設定確認
    aws ec2 describe-vpc-attribute --vpc-id ${v_vpc_id} --attribute enableDnsHostnames


## Setup IGW ([参考](http://www.simpline.co.jp/tech/?p=267))

    # IGW用変数を設定
    v_igw_name=${v_pre}-igw
    
    # IGWを作成
    v_igw_create_json="$(aws ec2 create-internet-gateway | tee /dev/stderr)"
    
    # IGWのid情報を、変数に格納
    v_igw_id="$(echo "${v_igw_create_json}" | sed -r -e /InternetGatewayId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # VPCにIGWをアタッチ
    aws ec2 attach-internet-gateway --internet-gateway-id ${v_igw_id} --vpc-id ${v_vpc_id}
    
    # IGWにNameタグを設定
    aws ec2 create-tags --resources ${v_igw_id} --tags Key=Name,Value=${v_igw_name}
    
    # IGWの情報をファイルに保存
    aws ec2 describe-internet-gateways --filters "Name=internet-gateway-id,Values=${v_igw_id}" | tee ${v_igw_name}.json
    
    # 【参考】IGW作成時の情報をファイルに保存
    echo "${v_igw_create_json}" | tee ${v_igw_name}.json.create


## Setup SUBNET ([参考](http://www.simpline.co.jp/tech/?p=267))

    # SUBNET用変数を設定
    v_seq=001
    v_subnet_name=${v_pre}-${v_seq}-subnet
    v_subnet_cidr=10.0.$(seq ${v_seq}).0/24
    v_subnet_az=${v_vpc_region}a
    #v_subnet_az=${v_vpc_region}c
    
    # 確認
    echo -e "${v_subnet_name}\n${v_subnet_cidr}\n${v_subnet_az}"
    
    # SUBNETを作成
    v_subnet_create_json="$(aws ec2 create-subnet --vpc-id ${v_vpc_id} --cidr-block ${v_subnet_cidr} --availability-zone ${v_subnet_az} | tee /dev/stderr)"
    
    # SUBNETのid情報を、変数に格納
    v_subnet_id="$(echo "${v_subnet_create_json}" | sed -r -e /SubnetId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # Auto Assign Public IPを設定
    aws ec2 modify-subnet-attribute --subnet-id ${v_subnet_id} --map-public-ip-on-launch
    
    # SUBNETにNameタグを設定
    aws ec2 create-tags --resources ${v_subnet_id} --tags Key=Name,Value=${v_subnet_name}
    
    # SUBNETの情報をファイルに保存
    aws ec2 describe-subnets --subnet-ids ${v_subnet_id} | tee ${v_subnet_name}.json
    
    # 【参考】SUBNET作成時の情報をファイルに保存
    echo "${v_subnet_create_json}" | tee ${v_subnet_name}.json.create












###### EOF
