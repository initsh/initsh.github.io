#### workdir
    v_aws_dir="${HOME:?}/$(date +'aws_%Y%m%d_%H%M%S')"
    mkdir ${v_aws_dir:?} && cd ${v_aws_dir:?}
    ls -ld ${HOME:?}/aws_*


#### VPC作成
    aws ec2 create-vpc --region ap-northeast-1 --cidr-block 10.0.0.0/16 >>"${v_aws_dir:?}/vpc.json"
    jq . ${v_aws_dir:?}/vpc.json








###### EOF
