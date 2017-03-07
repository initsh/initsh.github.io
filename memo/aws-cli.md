# VPC

#### 変数を設定

    v_aws_vpc_cidr=10.0.0.0/16
    v_aws_vpc_name=dev-vpc


##### VPCを作成 / jsonからVPCのidを出力し、変数に格納

    v_aws_vpc_create_json="$(aws ec2 create-vpc --region ap-northeast-1 --cidr-block $v_aws_vpc_cidr | tee /dev/stderr)"
    v_aws_vpc_id=$(echo "$v_aws_vpc_create_json" | sed -r -e '/VpcId/!d' -e 's/.*"VpcId": "([^"]+)".*/\1/g')
    

#### vpcのidと同名のディレクトリを`$HOME`配下に作成 && 移動

    cd $HOME && mkdir $v_aws_vpc_id && cd $v_aws_vpc_id && pwd
    

#### VPCにNameタグを設定 / 設定確認

    aws ec2 create-tags --resources $v_aws_vpc_id --tags Key=Name,Value=$v_aws_vpc_name
    aws ec2 describe-vpcs --vpc-id $v_aws_vpc_id | tee vpc.json
    

#### VPCの設定を変更(VPC内の名前解決をサポート) / 設定確認

    aws ec2 modify-vpc-attribute --vpc-id $v_aws_vpc_id --enable-dns-support
    aws ec2 describe-vpc-attribute --vpc-id $v_aws_vpc_id --attribute enableDnsSupport


#### VPCの設定を変更(VPC内のGIPを持つ仮想マシンにPublicDNS名を付与) / 設定確認

    aws ec2 modify-vpc-attribute --vpc-id $v_aws_vpc_id --enable-dns-hostnames
    aws ec2 describe-vpc-attribute --vpc-id $v_aws_vpc_id --attribute enableDnsHostnames





###### EOF
