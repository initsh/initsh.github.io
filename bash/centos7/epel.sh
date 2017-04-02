#!/bin/bash

# Edit 20170403
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/epel.sh"

# functions
curl -LRs "${v_github_dir}/functions.sh" | . /dev/stdin

{
    LogInfo "Start \"${v_script_name}\"."
    
    # checks
    curl -LRs "${v_github_dir}/check/centos7.sh" | . /dev/stdin
    curl -LRs "${v_github_dir}/check/root.sh"    | . /dev/stdin
    
    # variable
    v_epel_url="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
    
    # install yum-utils
    if ! rpm --quiet -q yum-utils
    then
        LogInfo "bash# yum -y install yum-utils"
        yum -y install yum-utils 2>&1
    fi
    
    # install epel-release
    if ! rpm --quiet -q epel-release
    then
        LogInfo "bash# yum -y install ${v_epel_url}"
        yum -y install "${v_epel_url}" 2>&1
        LogInfo "bash# yum-config-manager --disable epel*"
        yum-config-manager --disable epel* 2>&1
    fi
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
