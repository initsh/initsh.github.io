#!/bin/bash

# Edit 20170306
v_script_name="centos6.selinux.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."

	v_selinux_conf="/etc/selinux/config"

	[ "$(getenforce | grep "^Disabled")" ] || setenforce 0
	\cp -p "${v_selinux_conf}" "${v_selinux_conf}${v_backup_suffix:?}"
	sed -r -e 's/^[ \t]*(SELINUX=[^d].+)/#\1\n# '"${v_comment}"'\nSELINUX=disabled/g' "${v_selinux_conf}" -i
	[ "$(diff "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}")" ] || \mv -f "${v_selinux_conf}${v_backup_suffix}" "${v_selinux_conf}"
	ls -dl "${v_selinux_conf}"*

	LogInfo "End \"${v_script_name}\"."
} >"${v_log_file}"

# EOF
