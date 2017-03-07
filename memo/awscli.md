#### workdir
    v_aws_workdir=${HOME:?}/$(date +'aws_%Y%m%d_%H%M%S')
    mkdir ${v_aws_workdir:?} && cd $v_aws_workdir
    ls -ld $HOME/aws_*
    pwd


#### VPC
    # 変数を設定
    v_aws_vpc_cidr=10.0.0.0/16
    v_aws_vpc_name=dev-vpc
    
    # create
    aws ec2 create-vpc --region ap-northeast-1 --cidr-block $v_aws_vpc_cidr >>vpc.json
    
    # get vpc-id
    v_aws_vpc_id=$(sed -r -e '/VpcId/!d' -e 's/.*"VpcId": "([^"]+)".*/\1/g' vpc.json)
    
    # modify properties
    aws ec2 create-tags --resources $v_aws_vpc_id --tags Key=Name,Value=$v_aws_vpc_name
    aws ec2 modify-vpc-attribute --vpc-id $v_aws_vpc_id --enable-dns-support
    aws ec2 modify-vpc-attribute --vpc-id $v_aws_vpc_id --enable-dns-hostnames
    
    # check properties
    aws ec2 describe-vpcs --vpc-id $v_aws_vpc_id
    aws ec2 describe-vpc-attribute --vpc-id $v_aws_vpc_id --attribute enableDnsSupport
    aws ec2 describe-vpc-attribute --vpc-id $v_aws_vpc_id --attribute enableDnsHostnames
    
    
    
    
    /




###### EOF
