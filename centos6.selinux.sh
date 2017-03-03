#!/bin/bash

# functions
. <(curl -LRs initsh.github.io/functions.sh)

v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"
v_selinux_conf="/etc/selinux/config"

echo ': disable selinux' | StdoutLog
setenforce 0 2>/dev/stdout | StdoutLog
\cp -p "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix:?}" | StdoutLog
sed -r -e 's/^[ \t]*(SELINUX=[^d].+)/#\1\n# '"$(date +'Edit %Y%m%d')"'\nSELINUX=disabled/g' "${v_selinux_conf}" -i | StdoutLog
[ "$(diff "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix}")" ] || \mv -f "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}" | StdoutLog
ls -dl "${v_selinux_conf}"* | StdoutLog

#EOF
