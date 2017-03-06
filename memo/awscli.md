#### VPC作成
    aws ec2 create-vpc --region ap-northeast-1 --cidr-block 10.0.0.0/16 | tee -a "$HOME"/"aws-vpc-$(date +'%Y%m%d-%H%M%S').json" | jq .

###### EOF
