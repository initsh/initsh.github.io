#!/bin/bash

# pip
if [ "$(pip --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	python <(curl -Ls "https://bootstrap.pypa.io/get-pip.py")
fi

# awscli
if [ "$(aws --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	pip install awscli
fi

#EOF
