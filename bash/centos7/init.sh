#!/bin/bash

# Edit 20170324
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/init.sh"

. <(curl -LRs "${v_github_dir}/centos7/selinux.sh")
. <(curl -LRs "${v_github_dir}/centos7/tz.tokyo.sh")
. <(curl -LRs "${v_github_dir}/centos7/utils.sh")
