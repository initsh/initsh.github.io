#!/bin/bash

# Edit 20170303

# ls

v_git_user='initsh'
v_repo_name='initsh.github.io'
v_git_dir="github.com/${v_git_user}/${v_repo_name}"

v_initsh_list="$(
	curl -LRs "${v_git_dir}" \
	| egrep '<a href="/[^/]+/[^/]+/blob/master/.+\..+" ' \
	| sed -r -e 's/^.*<a href="\/[^\/]+\/[^\/]+\/blob\/master\/([^"]*)" .*$/<( curl -LRs https:\/\/raw.githubusercontent.com\/'"${v_git_user}"'\/'"${v_repo_name}"'\/master\/\1 )/g'
)"

# ls
echo "${v_initsh_list}"

# alias
echo "alias initsh-ls='curl -LRs https://raw.githubusercontent.com/${v_git_user}/${v_repo_name}/master/ls | bash'"

#EOF
