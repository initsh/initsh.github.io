#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/utils.sh"

# functions
source <(curl -LRs "${v_github_dir}/functions.sh")

{
	LogInfo "Start \"${v_script_name}\"."
	
	LogInfo "Redirect."
	bash <(curl -LRs "${v_github_dir}/centos6/utils.sh")
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
