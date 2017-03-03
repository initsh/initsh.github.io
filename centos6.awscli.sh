#!/bin/bash

# functions
. <(curl -LRs initsh.github.io/functions.sh)

# pip
if [ "$(pip --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo 'python get-pip.py' | StdoutLog
	python <(curl -Ls "https://bootstrap.pypa.io/get-pip.py") | StdoutLog
fi

# awscli
if [ "$(aws --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo 'pip install awscli' | StdoutLog
	pip install awscli | StdoutLog
fi

#EOF
