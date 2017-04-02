#!/bin/bash

# Edit 20170324
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/init.sh"

# functions
source <(curl -LRs "${v_github_dir}/functions.sh")

{
    LogInfo "Start \"${v_script_name}\"."
    
    # checks
    curl -LRs "${v_github_dir}/check/centos7.sh" | . /dev/stdin
    curl -LRs "${v_github_dir}/check/root.sh"    | . /dev/stdin
    
    # initialize
    curl -LRs "${v_github_dir}/centos7/selinux.sh"  | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/tz.tokyo.sh" | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/utils.sh"    | bash /dev/stdin
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


