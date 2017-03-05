#!/bin/bash

# Edit 20170306

if [ "$(whoami)" != "root" ]
then
	echo "This program needs to be executed by root user." >/dev/stderr
	exit 1
fi

#EOF
