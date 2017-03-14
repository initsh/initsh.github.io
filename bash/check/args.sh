#!/bin/bash

# Edit 20170306

if [ ! $# -ge 1 ]
then
	echo "$(date -Is) [ERROR]: This script must have at least 1 argument." | tee /dev/stderr
	exit 1
fi

# EOF
