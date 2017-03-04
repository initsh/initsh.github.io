#!/bin/bash

. <(curl -LRs initsh.github.io/check.x86_64.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)
echo "[INFO]: Start centos6.utils.sh" | StdoutLog

if ! rpm -q yum-utils | StdoutLog
then
	yum -y install yum-utils | StdoutLog
fi

if ! rpm -q expect | StdoutLog
then
	yum -y install expect | StdoutLog
fi

if ! rpm -q net-tools | StdoutLog
then
	yum -y install net-tools | StdoutLog
fi

if ! rpm -q bind-utils | StdoutLog
then
	yum -y install bind-utils | StdoutLog
fi

if ! rpm -q traceroute | StdoutLog
then
	yum -y install traceroute | StdoutLog
fi

if ! rpm -q nmap | StdoutLog
then
	yum -y install nmap | StdoutLog
fi

if ! rpm -q nc | StdoutLog
then
	yum -y install nc | StdoutLog
fi

if ! rpm -q tcpdump | StdoutLog
then
	yum -y install tcpdump | StdoutLog
fi

if ! rpm -q mailx | StdoutLog
then
	yum -y install mailx | StdoutLog
fi

if ! rpm -q lsof | StdoutLog
then
	yum -y install lsof | StdoutLog
fi

if ! rpm -q parted | StdoutLog
then
	yum -y install parted | StdoutLog
fi

if ! rpm -q openssh-clients | StdoutLog
then
	yum -y install openssh-clients | StdoutLog
fi

if ! rpm -q telnet | StdoutLog
then
	yum -y install telnet | StdoutLog
fi

if ! rpm -q wget | StdoutLog
then
	yum -y install wget | StdoutLog
fi

if ! rpm -q zip | StdoutLog
then
	yum -y install zip | StdoutLog
fi

if ! rpm -q unzip | StdoutLog
then
	yum -y install unzip | StdoutLog
fi

if ! rpm -q vim-enhanced | StdoutLog
then
	yum -y install vim-enhanced | StdoutLog
fi

# if not installed (return 127), download jq
if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo '# curl $url -o /usr/bin/jq' | StdoutLog
	curl -LRs https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq
	chmod 755 /tmp/jq
	\mv -f /tmp/jq /usr/bin
	ls -dl /usr/bin/jq* | StdoutLog
	if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		echo '[ERROR] failed to install /usr/bin/jq' | StdoutLog
		echo '[ERROR] failed to install /usr/bin/jq' 1>/dev/stderr
		exit 1
	fi
fi

#EOF
