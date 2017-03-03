#!/bin/bash

. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)

# variable
v_epel_url='https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'

# install yum-utils
echo '# yum -y install yum-utils' | StdoutLog
yum -y install yum-utils | StdoutLog

# install epel-release
echo "# yum -y install ${v_epel_url}" | StdoutLog
yum -y install "${v_epel_url}" | StdoutLog

# disable default-enable
echo '# yum-config-manager --disable epel*' | StdoutLog
yum-config-manager --disable epel* | StdoutLog

#EOF
