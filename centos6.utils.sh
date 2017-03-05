#!/bin/bash

# Edit 20170306
v_script_name="centos6.utils.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs initsh.github.io/check.root.sh)
	. <(curl -LRs initsh.github.io/check.x86_64.sh)
	
	if ! rpm -q yum-utils
	then
		yum -y install yum-utils
	fi
	
	if ! rpm -q expect
	then
		yum -y install expect
	fi
	
	if ! rpm -q net-tools
	then
		yum -y install net-tools
	fi
	
	if ! rpm -q bind-utils
	then
		yum -y install bind-utils
	fi
	
	if ! rpm -q traceroute
	then
		yum -y install traceroute
	fi
	
	if ! rpm -q nmap
	then
		yum -y install nmap
	fi
	
	if ! rpm -q nmap-ncat
	then
		yum -y install nmap-ncat
	fi
	
	if ! rpm -q tcpdump
	then
		yum -y install tcpdump
	fi
	
	if ! rpm -q mailx
	then
		yum -y install mailx
	fi
	
	if ! rpm -q lsof
	then
		yum -y install lsof
	fi
	
	if ! rpm -q parted
	then
		yum -y install parted
	fi
	
	if ! rpm -q openssh-clients
	then
		yum -y install openssh-clients
	fi
	
	if ! rpm -q telnet
	then
		yum -y install telnet
	fi
	
	if ! rpm -q wget
	then
		yum -y install wget
	fi
	
	if ! rpm -q zip
	then
		yum -y install zip
	fi
	
	if ! rpm -q unzip
	then
		yum -y install unzip
	fi
	
	if ! rpm -q vim-enhanced
	then
		yum -y install vim-enhanced
	fi
	
	# if not installed (return 127), download jq
	if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		echo '# curl $url -o /usr/bin/jq'
		curl -LRs https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq
		chmod 755 /tmp/jq
		\mv -f /tmp/jq /usr/bin
		ls -dl /usr/bin/jq*
		if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
		then
			echo "$(date -Is) [ERROR]: Failed to install /usr/bin/jq" | tee /dev/stderr
			exit 1
		fi
	fi
	
	LogInfo "End \"${v_script_name}\"."
} >"${v_log_file}"


# EOF
