#!/bin/bash

# Edit 20170402
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/openstack.sh"

# functions
curl -LRs "${v_github_dir}/functions.sh" | . /dev/stdin

{
    LogInfo "Start \"${v_script_name}\"."

    # checks
    curl -LRs "${v_github_dir}/check/centos7.sh" | . /dev/stdin
    curl -LRs "${v_github_dir}/check/root.sh"    | . /dev/stdin
    curl -LRs "${v_github_dir}/check/args.sh"    | . /dev/stdin
    
    # check $1 fqdn
    if [ -z "$(echo "$1" | egrep "^[0-9a-zA-Z\-\.]*[0-9a-zA-Z\-]+\.[a-z]+")" ]
    then
        LogError "\$1 expect fqdn."
        exit 1
    fi
    
    # variables
    v_fqdn="$1"
    
    # requirement
    curl -LRs "${v_github_dir}/centos7/selinux.sh"  | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/tz.tokyo.sh" | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/utils.sh"    | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/epel.sh"     | bash /dev/stdin
    
    # hostname
    sed -r -e 's/(127\.0\.0\.1[ ]+)/\1'"${v_fqdn}"' /g' /etc/hosts -i
    hostnamectl set-hostname "${v_fqdn}"
    
    # locale
    localectl set-locale LANG=en_US.utf8
    echo -e "# $(date +%Y%m%d) #\nLANG=en_US.utf-8\nLC_ALL=en_US.utf-8" >/etc/environment
    
    # rdp - packstack
    # https://www.rdoproject.org/install/quickstart/
    systemctl disable firewalld                     2>&1
    systemctl stop firewalld                        2>&1
    systemctl disable NetworkManager                2>&1
    systemctl stop NetworkManager                   2>&1
    systemctl enable network                        2>&1
    systemctl start network                         2>&1
    yum install -y centos-release-openstack-ocata   2>&1
    yum update -y                                   2>&1
    yum install -y openstack-packstack              2>&1
    
    LogNotice "Ref: Packstack quickstart - RDO"
    LogNotice "Url: https://www.rdoproject.org/install/quickstart/"
    
    LogNotice "Please reboot for save settings."
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
