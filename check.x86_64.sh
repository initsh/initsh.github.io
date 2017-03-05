#!/bin/bash

# Edit 20170306

if [ "$(uname -m)" != 'x86_64' ]
then
	echo "This program supports only x86_64." | tee /dev/stderr
	exit 1
fi

# EOF
