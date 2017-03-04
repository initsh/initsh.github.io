#!/bin/bash

. <(curl -LRs initsh.github.io/check.centos6.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)
echo "[INFO]: Start centos6.epel.sh" | StdoutLog

# variable
v_epel_url='https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm'

# install yum-utils
if ! rpm -q yum-utils | StdoutLog
then
	echo '[INFO]: yum -y install yum-utils' | StdoutLog
	yum -y install yum-utils | StdoutLog
fi

# install epel-release
if ! rpm -q epel-release | StdoutLog
then
	echo "[INFO]:  yum -y install ${v_epel_url}" | StdoutLog
	yum -y install "${v_epel_url}" 2>/dev/stdout | StdoutLog
	echo '[INFO]:  yum-config-manager --disable epel*' | StdoutLog
	yum-config-manager --disable epel* | StdoutLog
fi

#EOF
