#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos6/utils.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs "${v_github_dir}/check/root.sh")
	. <(curl -LRs "${v_github_dir}/check/x86_64.sh")
	
	if ! rpm --quiet -q yum-utils
	then
		yum -y install yum-utils 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q expect
	then
		yum -y install expect 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q net-tools
	then
		yum -y install net-tools 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q bind-utils
	then
		yum -y install bind-utils 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q traceroute
	then
		yum -y install traceroute 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q nmap
	then
		yum -y install nmap 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q nmap-ncat
	then
		yum -y install nmap-ncat 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q tcpdump
	then
		yum -y install tcpdump 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q mailx
	then
		yum -y install mailx 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q lsof
	then
		yum -y install lsof 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q parted
	then
		yum -y install parted 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q openssh-clients
	then
		yum -y install openssh-clients 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q telnet
	then
		yum -y install telnet 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q wget
	then
		yum -y install wget 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q zip
	then
		yum -y install zip 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q unzip
	then
		yum -y install unzip 2>/dev/stdout
	fi
	
	if ! rpm --quiet -q vim-enhanced
	then
		yum -y install vim-enhanced 2>/dev/stdout
	fi
	
	# if not installed (return 127), download jq
	if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		echo '# curl $url -o /usr/bin/jq'
		curl -LRs https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq && chmod 755 /usr/bin/jq 
		ls -dl /usr/bin/jq*
		if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
		then
			LogError "Failed to install /usr/bin/jq"
			exit 1
		fi
	fi
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
