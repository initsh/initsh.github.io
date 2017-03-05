#!/bin/bash

# Edit 20170306
v_script_name="centos7.epel.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs initsh.github.io/check.centos7.sh)
	. <(curl -LRs initsh.github.io/check.root.sh)
	
	# variable
	v_epel_url="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
	
	# install yum-utils
	if ! rpm -q yum-utils
	then
		LogInfo "bash# yum -y install yum-utils"
		yum -y install yum-utils
	fi
	
	# install epel-release
	if ! rpm -q epel-release
	then
		LogInfo "bash# yum -y install ${v_epel_url}"
		yum -y install "${v_epel_url}"
		LogInfo "bash# yum-config-manager --disable epel*"
		yum-config-manager --disable epel*
	fi
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
