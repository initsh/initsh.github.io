#!/bin/bash

# Edit 20170308
SCRIPT_NAME="centos6.munin.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${SCRIPT_NAME}\"."
	
	# checks
	. <(curl -LRs initsh.github.io/check.centos6.sh)
	. <(curl -LRs initsh.github.io/check.root.sh)
	
	# epel
	. <(curl -LRs initsh.github.io/centos6.epel.sh)
	
	# variable
	MUNIN_USER=admin
	MUNIN_PASSWORD=munin
	
	# install munin
	yum -y --enablerepo=epel munin
	
	# gen passwd
	echo -e "${MUNIN_PASSWORD}" | htpasswd -i /etc/munin/munin-htpasswd ${MUNIN_USER}
	
	# load /etc/httpd/conf.d/munin.conf
	service httpd restart
	
	LogInfo "End \"${SCRIPT_NAME}\"."
} >>"${v_log_file}"


# EOF
