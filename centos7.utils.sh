#!/bin/bash

# Edit 20170306
v_script_name="centos7.utils.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	LogInfo "Redirect."
} >"${v_log_file}"

curl -LRs "initsh.github.io/centos6.utils.sh" | bash

# EOF
