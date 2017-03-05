#!/bin/bash

# Edit 20170306
v_script_name="centos6.awscli.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."

	v_url_getpip="https://bootstrap.pypa.io/get-pip.py"

	# pip
	if [ "$(pip --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		LogInfo "Run \"get-pip.py\"."
		python <(curl -LRs "${v_url_getpip}")
		if [ "$(pip --help >/dev/null 2>&1; echo $?)" -eq 127 ]
		then
			LogError "Failed to install \"pip\"."
			exit 1
		fi
	fi

	# awscli
	if [ "$(aws --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		LogInfo "bash# pip install awscli"
		pip install awscli
		if [ "$(aws --help >/dev/null 2>&1; echo $?)" -eq 127 ]
		then
			LogError "Failed to install \"awscli\"."
			exit 1
		fi
	fi

	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
