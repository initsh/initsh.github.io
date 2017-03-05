#!/bin/bash

# Edit 20170306

# variables
v_github_user='initsh'
v_github_pages='initsh.github.io'
v_git_dir="github.com/${v_github_user}/${v_github_pages}"

v_initsh_list="$(
	curl -LRs "${v_git_dir}" \
	| egrep '<a href="/[^/]+/[^/]+/blob/master/.+\..+" ' \
	| sed -r -e 's/^.*<a href="\/[^\/]+\/[^\/]+\/blob\/master\/([^"]*)" .*$/<(curl -LRs '"${v_github_pages}"'\/\1)/g'
)"

# ls
echo "[bash]"
echo "${v_initsh_list}" | awk '{print "    "$0}'
echo

# alias
echo "[alias]"
echo "alias initsh-ls='curl -LRs ${v_github_pages}/ls | bash'" | awk '{print "    "$0}'
echo


#EOF
