#!/bin/bash

# if not installed (return 127), download jq
if [ "$(jq --help >/dev/null 2>&1; echo $?)" -eq 127 ]
then
	curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /tmp/jq
	chmod 755 /tmp/jq
	\mv -f /tmp/jq /usr/bin
	ls -dl /usr/bin/jq*
fi

#EOF
