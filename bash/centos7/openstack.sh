#!/bin/bash

# Edit 20170329
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/httpd.vhost.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh")

{
    LogInfo "Start \"${v_script_name}\"."

    # checks
    . <(curl -LRs "${v_github_dir}/check/centos7.sh")
    . <(curl -LRs "${v_github_dir}/check/root.sh")
    . <(curl -LRs "${v_github_dir}/check/args.sh")
    
    # check $1 fqdn
    if [ ! -d "$1" -o -z "$(echo "$1" | egrep "^[0-9a-zA-Z\-]+\.[a-z]+")" ]
    then
        LogError "\$1 expect fqdn."
        exit 1
    fi
    
    v_fqdn="$1"
    
    hostnamectl set-hostname "${v_fqdn}"
    sed -r -e 's/(127\.0\.0\.1[ ]+)/\1'"${v_fqdn}"' /g' /etc/hosts -i
    
    # https://www.rdoproject.org/install/quickstart/
    systemctl disable firewalld
    systemctl stop firewalld
    systemctl disable NetworkManager
    systemctl stop NetworkManager
    systemctl enable network
    systemctl start network
    yum install -y centos-release-openstack-ocata
    yum update -y
    yum install -y openstack-packstack
    
    LogNotice "Reference: https://www.rdoproject.org/install/quickstart/"
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
