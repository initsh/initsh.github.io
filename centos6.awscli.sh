#!/bin/bash

# pip
if [ "$(pip --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo 'python get-pip.py' | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
	python <(curl -Ls "https://bootstrap.pypa.io/get-pip.py") | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
fi

# awscli
if [ "$(aws --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	echo 'pip install awscli' | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
	pip install awscli | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
fi

#EOF
