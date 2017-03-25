#!/bin/bash

# Edit 20170324
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/init.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
    LogInfo "Start \"${v_script_name}\"."
    
    # checks
    . <(curl -LRs "${v_github_dir}/check/centos7.sh")
    . <(curl -LRs "${v_github_dir}/check/root.sh")
    
    # initialize
    bash <(curl -LRs "${v_github_dir}/centos7/selinux.sh")
    bash <(curl -LRs "${v_github_dir}/centos7/tz.tokyo.sh")
    bash <(curl -LRs "${v_github_dir}/centos7/utils.sh")
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


