#!/bin/bash
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"
v_selinux_conf="/etc/selinux/config"

# setenforce
setenforce 0

\cp -p "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix:?}"
sed -r -e 's/^[ \t]*(SELINUX=[^d].+)/#\1\n# '"$(date +'Edit %Y%m%d')"'\nSELINUX=disabled/g' "${v_selinux_conf}" -i
[ "$(diff "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix}")" ] || \mv -f "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}"
echo '--Selinux-----------------------'
ls -dl "${v_selinux_conf}"*

#EOF
