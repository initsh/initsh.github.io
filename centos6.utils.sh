#!/bin/bash

. <(curl -LRs initsh.github.io/check.x86_64.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)

if ! rpm -q yum-utils
then
	yum -y install yum-utils | StdoutLog
fi

if ! rpm -q expect
then
	yum -y install expect | StdoutLog
fi

if ! rpm -q net-tools
then
	yum -y install net-tools | StdoutLog
fi

if ! rpm -q bind-utils
then
	yum -y install bind-utils | StdoutLog
fi

if ! rpm -q traceroute
then
	yum -y install traceroute | StdoutLog
fi

if ! rpm -q nmap
then
	yum -y install nmap | StdoutLog
fi

if ! rpm -q nc
then
	yum -y install nc | StdoutLog
fi

if ! rpm -q tcpdump
then
	yum -y install tcpdump | StdoutLog
fi

if ! rpm -q mailx
then
	yum -y install mailx | StdoutLog
fi

if ! rpm -q lsof
then
	yum -y install lsof | StdoutLog
fi

if ! rpm -q parted
then
	yum -y install parted | StdoutLog
fi

if ! rpm -q openssh-clients
then
	yum -y install openssh-clients | StdoutLog
fi

if ! rpm -q telnet
then
	yum -y install telnet | StdoutLog
fi

if ! rpm -q wget
then
	yum -y install wget | StdoutLog
fi

if ! rpm -q zip
then
	yum -y install zip | StdoutLog
fi

if ! rpm -q unzip
then
	yum -y install unzip | StdoutLog
fi

if ! rpm -q vim-enhanced
then
	yum -y install vim-enhanced | StdoutLog
fi

# if not installed (return 127), download jq
if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo '# curl $url -o /usr/bin/jq' | StdoutLog
	curl -LRs https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq | StdoutLog
	chmod 755 /tmp/jq; | StdoutLog
	\mv -f /tmp/jq /usr/bin; | StdoutLog
	ls -dl /usr/bin/jq*; | StdoutLog
	ls -dl /usr/bin/jq*;
	if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		echo '[ERROR] failed to install /usr/bin/jq' | StdoutLog
		echo '[ERROR] failed to install /usr/bin/jq'
		exit 1
	fi
fi

#EOF
