#!/bin/bash

# Edit 20170331
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos6/sudoers.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh")

{
    LogInfo "Start \"${v_script_name}\"."

    # checks
    curl -LRs "${v_github_dir}/check/root.sh" | . /dev/stdin
    curl -LRs "${v_github_dir}/check/args.sh" | . /dev/stdin

    # check args
    if [ -z "$(grep "^$1:" /etc/passwd)" ]
    then
        LogError "\$1 needs Linux local user."
        exit 1
    fi
    
    USERNAME="$1"

    usermod -G wheel "${USERNAME}"
    LogNotice "Modify \"${USERNAME}\" group \"wheel\"."
    
    v_sudoers_d="/etc/sudoers.d/${USERNAME}"
    echo -e "# $(date +%Y%m%d) #\n${USERNAME} ALL=(ALL) NOPASSWD: ALL" >"${v_sudoers_d}"
    LogNotice "Generate sudoers.d file(${v_sudoers_d})."

    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
