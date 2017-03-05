#!/bin/bash

# Edit 20170306

if ! egrep --quiet "Cent.* 6|Red.* 6" /etc/*release
then
	echo "$(date -Is) [ERROR]: This program supports only CentOS 6 or RedHat Enterprise Linux 6." | tee >/dev/stderr
	exit 1
fi

#EOF
