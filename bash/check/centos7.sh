#!/bin/bash

# Edit 20170306

if ! egrep --quiet "Cent.* 7|Red.* 7" /etc/*release
then
	echo "$(date -Is) [ERROR]: This program supports only CentOS 7 or RedHat Enterprise Linux 7." | tee /dev/stderr
	exit 1
fi

# EOF
