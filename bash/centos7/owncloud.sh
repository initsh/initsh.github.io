#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/owncloud.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
    LogInfo "Start \"${v_script_name}\"."
    
    
    . <(curl -LRs "${v_github_dir}/centos7/selinux.sh")
    . <(curl -LRs "${v_github_dir}/centos7/timezone.sh")
    . <(curl -LRs "${v_github_dir}/centos7/utils.sh")
    
    LogInfo "bash# yum -y install epel-release"
    . <(curl -LRs "${v_github_dir}/centos7/epel.sh")
    
    LogInfo "bash# yum -y install owncloud --enablerepo=epel"
    yum -y install owncloud --enablerepo=epel
    
    LogInfo "bash# ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf"
    ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
