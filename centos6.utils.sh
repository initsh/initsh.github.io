#!/bin/bash

. <(curl -LRs initsh.github.io/check.x86_64.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)

yum -y install yum-utils	| StdoutLog
yum -y install expect		| StdoutLog
yum -y install net-tools	| StdoutLog
yum -y install bind-utils	| StdoutLog
yum -y install traceroute	| StdoutLog
yum -y install nmap		| StdoutLog
yum -y install nc		| StdoutLog
yum -y install tcpdump		| StdoutLog
yum -y install mailx		| StdoutLog
yum -y install lsof		| StdoutLog
yum -y install parted		| StdoutLog
yum -y install openssh-clients	| StdoutLog
yum -y install telnet		| StdoutLog
yum -y install wget		| StdoutLog
yum -y install zip		| StdoutLog
yum -y install unzip		| StdoutLog
yum -y install vim-enhanced	| StdoutLog

# if not installed (return 127), download jq
if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo '# curl $url -o /usr/bin/jq' | StdoutLog
	curl -LRs https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq | StdoutLog
	{ chmod 755 /tmp/jq; \mv -f /tmp/jq /usr/bin; ls -dl /usr/bin/jq*; } | StdoutLog
	if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
	then
		echo '[ERROR] failed to install /usr/bin/jq' | StdoutLog
		echo '[ERROR] failed to install /usr/bin/jq'
		exit 1
	fi
fi

#EOF
