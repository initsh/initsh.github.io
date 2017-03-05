#!/bin/bash

# Edit 20170306

# variables
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"
v_log_file="${HOME}/initsh.log"

# functions
function StdoutLog()
{
	cat - | awk '{print "'$(date -Is)' "$0}' >>${HOME}/initsh.log
}

function LogInfo()
{
	echo "$1" | awk '{print "'"$(date -Is)"' [INFO]: "$0}' | tee /dev/stderr
}

# EOF
