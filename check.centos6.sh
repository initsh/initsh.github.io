#!/bin/bash
if ! egrep --quiet "Cent.* 6|Red.* 6" /etc/*release
then
	echo "This program supports only CentOS 6 or RedHat Enterprise Linux 6."
	exit 1
fi

#EOF
