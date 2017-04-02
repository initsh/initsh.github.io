#!/bin/bash

# Edit 20170403
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/awscli.sh"

# functions
source <(curl -LRs "${v_github_dir}/functions.sh")

{
	LogInfo "Start \"${v_script_name}\"."
	
	LogInfo "Redirect."
	curl -LRs "${v_github_dir}/centos6/awscli.sh" | bash /dev/stdin
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
