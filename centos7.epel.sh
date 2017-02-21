#!/bin/bash

# variable
v_epel_url='https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'

# install yum-utils
echo '--InstallYumUtils---------------'
if ! rpm -q yum-utils
then
	yum -y install yum-utils
fi

# install epel-release
echo '--InstallEpelRepo---------------'
if ! rpm -q epel-release
then
	yum -y install "${v_epel_url}"
fi

# disable default-enable
echo '--DisableAsDefault--------------'
yum-config-manager --disable epel* >/dev/null 2>&1
ls -ld /etc/yum.repos.d/epel*

#EOF
