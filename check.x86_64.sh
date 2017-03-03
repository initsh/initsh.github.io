#!/bin/bash

# check x64
if [ "$(uname -m)" != 'x86_64' ]
then
	echo "This program supports only x86_64"
	exit 1
fi

#EOF
