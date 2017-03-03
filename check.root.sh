#!/bin/bash
if [ "$(whoami)" != "root" ]
then
	echo "This program needs to be executed by root user."
	exit 1
fi

#EOF
