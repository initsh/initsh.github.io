#!/bin/bash

v_git_dir='github.com/initsh/initsh.github.io'

curl -Ls "${v_git_dir}" \
| egrep '<a href="/[^/]+/[^/]+/blob/master/.*.sh" ' \
| sed -r -e 's/^.*<a href="\/[^\/]+\/[^\/]+\/blob\/master\/([^"]*)" .*$/\1/g'

#EOF
