#!/bin/bash

# Edit 20170330
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos6/selinux.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh")

{
    LogInfo "Start \"${v_script_name}\"."
    
    v_selinux_conf="/etc/selinux/config"
    
    if [ -z "$(getenforce | grep "^Disabled")" ]; then setenforce 0; fi
    \cp -p "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix:?}"
    sed -r -e 's/^[ \t]*(SELINUX=[^d].+)/#\1\n# '"$(date +'Edit %Y%m%d')"'\nSELINUX=disabled/g' "${v_selinux_conf}" -i
    if [ -z "$(diff "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}")" ]; then \mv -f "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}"; fi
    LogInfo "$(ls -dl "${v_selinux_conf}"*)"
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"

# EOF
