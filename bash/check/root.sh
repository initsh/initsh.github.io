#!/bin/bash

# Edit 20170306

if [ "$(whoami)" != "root" ]
then
	echo "$(date -Is) [ERROR]: You need to be root to perform this program." | tee /dev/stderr
	exit 1
fi

# EOF
