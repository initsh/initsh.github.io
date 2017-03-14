#!/bin/bash

# Edit 20170308
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos6/munin.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs "${v_github_dir}/check/centos6.sh")
	. <(curl -LRs "${v_github_dir}/check/root.sh")
	
	# epel
	. <(curl -LRs "${v_github_dir}/centos6/epel.sh")
	
	# variable
	v_munin_user=admin
	v_munin_password=munin
	
	# install munin
	yum -y --enablerepo=epel munin
	
	# gen passwd
	echo -e "${v_munin_password}" | htpasswd -i /etc/munin/munin-htpasswd ${v_munin_user}
	
	# load /etc/httpd/conf.d/munin.conf
	service httpd restart
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
