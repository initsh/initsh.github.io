#!/bin/bash

# Edit 20170306

if ! egrep --quiet "Cent.* 7|Red.* 7" /etc/*release
then
	echo "This program supports only CentOS 7 or RedHat Enterprise Linux 7." >/dev/stderr
	exit 1
fi

#EOF
