#!/bin/bash

# Edit 20170306

if [ "$(whoami)" != "root" ]
then
	echo "$(date -Is) [ERROR]: This program needs to be executed by root user." | tee /dev/stderr
	exit 1
fi

# EOF
