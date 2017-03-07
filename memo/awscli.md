#### workdir
    v_aws_workdir="${HOME:?}/$(date +'aws_%Y%m%d_%H%M%S')"
    mkdir ${v_aws_workdir:?} && cd ${v_aws_workdir:?}
    ls -ld ${HOME:?}/aws_*
    pwd


#### VPC作成
    v_aws_vpc_cidr=10.0.0.0/16
    v_aws_vpc_name=dev-vpc
    aws ec2 create-vpc --region ap-northeast-1 --cidr-block 10.0.0.0/16 >>vpc.json
    v_aws_vpc_id=$(sed -r -e '/VpcId/!d' -e 's/.*"VpcId": "([^"]+)".*/\1/g' vpc.json)








###### EOF
