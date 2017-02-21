#!/bin/bash
if ! egrep --quiet "CentOS.*7|Red.*7" /etc/system-release
then
	echo "This program supports only CentOS 7 or RedHat Enterprise Linux 7."
	exit 1
fi
